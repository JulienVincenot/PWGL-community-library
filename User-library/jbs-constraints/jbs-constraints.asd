;;;; Silly emacs, this is -*- Lisp -*-

(in-package :asdf)

(defsystem :jbs-constraints
  :name "jbs-constraints"
  :description "jbs-constraints"
  :author "Jacopo Baboni Schilingi"
  :version "0.1"
  :serial t
  :components
  ((:static-file "jbs-constraints.asd")
   ;; (:static-file "load.lisp")
    
   (:file "package")
   (:file "box-classes")
   (:file "jbs-generic-functions")
   (:file "pmc-boxes")
   (:file "score-pmc-boxes")
   (:file "utils")
   )
  :depends-on (:jbs-cmi :morphologie :jbs-profile))

