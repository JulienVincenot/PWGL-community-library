(defpackage :link-distance
  (:use :cl :iterate :screamer :alexandria :myam)
  (:import-from :ccl #:PWGLdef)
  (:shadowing-import-from :screamer
                          #:defun #:multiple-value-bind #:y-or-n-p ;in analogy to screamer-user package
                          #:fail        ;due to using myam
                          ))
