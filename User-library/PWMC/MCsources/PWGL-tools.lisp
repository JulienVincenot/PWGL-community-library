(in-package MC)

(system::PWGLDef nr-of-events ()
    "Get number of events (i.e. number of pitches OR number of note values and pauses OR 
number of time signatures) including the one being examined."
    (:groupings '()  :x-proportions '())

  (get-nr-of-events-including-this))