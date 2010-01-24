(define (read-password prompt)
  (display prompt)
  (with-stty '(not echo) read-line))

(define with-output-to-encrypted-file
  (case-lambda
   ((file thunk)
    (with-output-to-encrypted-file file thunk #t))
   ((file thunk tty)
    (let ((sometime-output-port (current-output-port)))
      (dynamic-wind
          (lambda ()
            (let*-values (((password) (if tty
                                          ;; seems to have problems on
                                          ;; non-ttys
                                          (read-password "Password: ")
                                          (read-line)))
                          ((in out id)
                           (process "openssl"
                                    `("enc"
                                      "-aes-256-cbc"
                                      "-a"
                                      "-salt"
                                      "-in"
                                      "/dev/stdin"
                                      "-out"
                                      ,file
                                      "-pass"
                                      ,(format "pass:~A" password)))))
              (close-input-port in)
              (current-output-port out)))
          thunk
          (lambda ()
            (close-output-port (current-output-port))
            (current-output-port sometime-output-port)))))))

(define with-input-from-encrypted-file
  (case-lambda
   ((file thunk)
    (with-input-from-encrypted-file file thunk #t))
   ((file thunk tty)
    (let ((sometime-input-port (current-input-port)))
      (dynamic-wind
          (lambda ()
            (let*-values (((password) (if tty
                                          (read-password "Password: ")
                                          (read-line)))
                          ((in out id)
                           (process "openssl"
                                    `("enc"
                                      "-d"
                                      "-aes-256-cbc"
                                      "-a"
                                      "-in"
                                      ,file
                                      "-pass"
                                      ,(format "pass:~A" password)))))
              (close-output-port out)
              (current-input-port in)))
          thunk
          (lambda ()
            (close-input-port (current-input-port))
            (current-input-port sometime-input-port)))))))
