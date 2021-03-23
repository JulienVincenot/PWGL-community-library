;;;; Silly emacs, this is -*- Lisp -*-

(in-package :asdf)

(defsystem :gp-density
  :name "gp-density"
  :description "gp-density"
  :author "Giacomo Platini"
  :version "1.0"
  :serial t
  :components
  ((:static-file "gp-density.asd")
   ;; (:static-file "load.lisp")
    
   (:file "package")
   (:file "box-classes")
   (:file "generic-functions")
   (:file "density")
   ;(:file "generate")
   )
   
  
  :depends-on (:iterate :jbs-cmi))