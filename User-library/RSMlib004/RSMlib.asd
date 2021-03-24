(in-package :ASDF)

(defsystem "RSMlib"

  :description "Rhythmic Similarity Measures"
  :long-description "Rhythmic analysis and generation based on Rhythmic Similarity Measures"
  :version "0.04"
  :author "Josue Moreno"
  :licence "GPL2"
  :maintainer "Josue Moreno"

  ;; :serial t means that each component is only compiled, when the
  ;; predecessors are already loaded
  :serial t
  :components
  (
   (:FILE "package")
   (:FILE "RSMlib")
(:FILE "rsmlib-menus")
   ))