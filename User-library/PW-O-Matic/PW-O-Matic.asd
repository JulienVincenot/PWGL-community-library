(in-package :ASDF)

(defsystem "PW-O-Matic"

  :description "A visual interface between Pwgl and SuperCollider."
  :long-description ""
  :version "0.1"
  :author "Giorgio Zucco"
  :licence ""
  :maintainer "Giorgio Zucco"

  ;; :serial t means that each component is only compiled, when the
  ;; predecessors are already loaded
  :serial t
  :components
  (
   (:FILE "package")
(:file "boxes")
(:file "gui")
(:file "operators")
(:file "buffer")
(:file "convolution")
(:file "delays")
(:file "generators")
(:file "inout")
(:file "envelope")
(:file "filters")
(:file "multichannel")
(:file "randomsc")
(:file "reverbs")
(:file "Triggers")
(:file "user-int")
(:file "patterns")
(:file "PhysicalModels")
(:file "menus")



   (:FILE "PW-O-Matic")))