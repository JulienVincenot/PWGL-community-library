;;;; Silly emacs, this is -*- Lisp -*-

(in-package :asdf)

(defsystem :fs-pixel
  :name "fs-pixel"
  :description "fs-pixel"
  :author "Filippo Saya"
  :version "1.0"
  :serial t
  :components
  ((:static-file "fs-pixel.asd")
   ;; (:static-file "load.lisp")
    
   (:file "package")
   (:file "box-classes")
   (:file "generic-functions")
   (:file "crossfades")
   (:file "reverbs")
   ;(:file "useful-devices")
   
   )
  :depends-on (:morphologie :jbs-constraints :iterate))