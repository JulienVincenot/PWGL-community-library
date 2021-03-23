(in-package :asdf)

;; This is a hack to read latin-1 instead of utf-8
#+sbcl (setq sb-impl::*default-external-format* :latin-1)

(defsystem :morphologie
  :version "3.0.3"
  :components
  ((:static-file "morphologie.asd")
   (:static-file "load.lisp")
   (:module :src
	    :serial t
	    :components
	    ((:file "package")
	     (:file "utils")
	     (:file "morphologie"))))
  :depends-on (:ompw :ompw-utils))
