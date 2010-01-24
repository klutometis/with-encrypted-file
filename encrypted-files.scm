(module
 encrypted-files
 (read-password
  with-input-from-encrypted-file
  with-input-from-encrypted-file/password
  with-output-to-encrypted-file
  with-output-to-encrypted-file/password)
 (import scheme chicken)
 (use ports posix utils extras stty)
 (include "openssl.scm"))
