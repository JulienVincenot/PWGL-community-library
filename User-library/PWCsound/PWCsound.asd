(in-package :ASDF)

(defsystem "PWCsound"

  :description "PWCsound"
  :long-description "PWCsound is a tool for software synthesis control implemented in Pwgl, provides a graphical interface to Csound6 programming"
  :version "1.0"
  :author "Giorgio Zucco"
  :licence ""
  :maintainer ""

  ;; :serial t means that each component is only compiled, when the
  ;; predecessors are already loaded
  :serial t
  :components
  (
   (:FILE "package")
   (:file "opcode/boxes")
   (:file "opcode/synthesis")
(:file "opcode/sampling")
(:file "opcode/outputs")
(:file "opcode/spat")
(:file "opcode/filters")
(:file "opcode/spectral")
(:file "opcode/resonators")
(:file "opcode/lfo")
(:file "opcode/rndnumbers")
(:file "opcode/envelopes")
(:file "opcode/amplitudemod")
(:file "opcode/operators")
(:file "opcode/fx")
(:file "opcode/gen")



   (:file "menus")

    
   (:FILE "PWCsound")))
