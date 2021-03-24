(in-package :ASDF)

(defsystem "M2T"

  :description "melody to tone"
  :long-description ""
  :version "1.0"
  :author "Yann Ics"
  :licence ""
  :maintainer "Yann Ics"

  ;; :serial t means that each component is only compiled, when the
  ;; predecessors are already loaded
  :serial t
  :components
  (
   (:FILE "package")
   (:FILE "M2T"))
  :depends-on (:morphologie)
  )