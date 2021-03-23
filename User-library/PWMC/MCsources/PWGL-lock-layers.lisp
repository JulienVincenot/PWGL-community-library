(in-package MC)

(system::PWGLDef lock-rhythms ((rhythmseq '(1/4 1/4 1/4 1/4)))
    "Lock the rhythm sequence in one layer to a predefined sequence of durations."
    (:groupings '(1)  :x-proportions '((1.0)))
  (put-and-lock-this-layers-durations rhythmseq))

(system::PWGLDef lock-pitches ((pitchseq '(60 62 64 65)))
    "Lock the pitch sequence in one layer to a predefined sequence of pitches."
    (:groupings '(1)  :x-proportions '((1.0)))
  (put-and-lock-this-layers-pitches pitchseq))



;;;below functions behave strange
(system::PWGLDef plug-rhythms ()
    "Lock rhythms in one layer to last solution."
    (:groupings '()  :x-proportions '())
  (plug-this-rlayer))

(system::PWGLDef plug-pitches ()
    "Lock pitches in one layer to last solution."
    (:groupings '()  :x-proportions '())
  (plug-this-player))
