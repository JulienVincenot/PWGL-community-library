;;;; Silly emacs, this is -*- Lisp -*-

(in-package :asdf)

(defsystem :jbs-cmi
  :name "JBS-Cmi"
  :description "jbs-cmi"
  :author "Jacopo Baboni Schilingi"
  :version "1.0"
  :serial t
  :components
  ((:static-file "jbs-cmi.asd")
   ;; (:static-file "load.lisp")
    
   (:file "package")
   (:file "box-classes")
   (:file "generic-functions")
   (:file "write-entities")
   (:file "pitch-boxes")
   (:file "matrix-boxes") 
   (:file "special-combinations-boxes")
   (:file "segmentations")
   (:file "useful-devices")
   ;(:file "tools-boxes")
   )
  :depends-on (:morphologie :jbs-profile :iterate))

;:useful-devices
;:iterate
;:ompw