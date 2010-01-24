(use encrypted-files files test)

(let ((password "wunderbar")
      (plaintext "harro")
      (ciphertext (create-temporary-file))
      (tty #f))
  (with-input-from-string
      password
    (lambda ()
      (with-output-to-encrypted-file
          ciphertext
        (lambda ()
          (display plaintext))
        tty)))

  (with-input-from-string
      password
    (lambda ()
      (with-input-from-encrypted-file
          ciphertext
        (lambda ()
          (test
           "retrieve cipher from encrypted file"
           plaintext
           (read-all)))
        tty))))
