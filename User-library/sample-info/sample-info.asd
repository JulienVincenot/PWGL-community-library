(in-package :ASDF)

(defsystem "sample-info"

  :description "soundfilequery"
  :long-description "returns number of channels, samplerate etc."
  :version "0.9"
  :author "putsomethingthere"
  :licence ""
  :maintainer ""

  ;; :serial t means that each component is only compiled, when the
  ;; predecessors are already loaded
  :serial t
  :components
  (
   (:FILE "sample-info")
   (:FILE "menu")))