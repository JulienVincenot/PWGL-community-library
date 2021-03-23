(in-package :ASDF)

(defsystem "TEMP_TUTORIAL_STUFF"

  :description "temporary box tutorial scheme"
  :long-description ""
  :version "1.0"
  :author "CHARLIE BROWN"
  :licence ""
  :maintainer ""

  ;; :serial t means that each component is only compiled, when the
  ;; predecessors are already loaded
  :serial t
  :components
  ((:FILE "TEMP_TUTORIAL_STUFF")
   (:FILE "make-num-fun")))