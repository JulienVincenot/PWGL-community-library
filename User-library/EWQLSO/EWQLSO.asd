(in-package :ASDF)

(defsystem "EWQLSO"

  :description "EWQLSO player"
  :long-description "EWQLSO player"
  :version "1.1"
  :author "Mika Kuuskankare"
  :licence ""
  :maintainer "Mika Kuuskankare"

  ;; :serial t means that each component is only compiled, when the
  ;; predecessors are already loaded
  :serial t
  :components
  ((:FILE "EWQLSO")
   (:FILE "EWQLSO-orchestra")))
   