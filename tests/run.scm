(use encrypted-files files test)

(let ((password "wunderbar")
      (plaintext "harro")
      (ciphertext (create-temporary-file))
      (tty #f))
  (with-output-to-encrypted-file/password
   ciphertext
   (lambda ()
     (display plaintext))
   password)

  (with-input-from-encrypted-file/password
   ciphertext
   (lambda ()
     (test
      "retrieve cipher from encrypted file"
      plaintext
      (read-all)))
   password))
