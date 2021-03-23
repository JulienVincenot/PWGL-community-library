(in-package :ASDF)

(defsystem "OSC"
  :depends-on (:cl-osc)
  :default-component-class ccl::pwgl-source-file
  :description "OSC player"
  :long-description ""
  :version "1.0"
  :author "Mika Kuuskankare"
  :maintainer ""

  ;; :serial t means that each component is only compiled, when the
  ;; predecessors are already loaded
  :serial t
  :components
  (
   (:FILE "OSC")))