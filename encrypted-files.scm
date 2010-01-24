(module
 encrypted-files
 (with-input-from-encrypted-file
     with-output-to-encrypted-file)
 (import scheme chicken)
 (use posix utils extras stty)
 (include "openssl.scm"))
