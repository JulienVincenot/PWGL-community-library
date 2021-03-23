(in-package MC)

(system::PWGLDef pitch-canon-rule ((layernr1 0)(layernr2 1) &optional (transpose-layer2 0))
        "Forces hte piches in one layer to imitate the pitches in another layer 
in a strict canon. If a traditional canon will be perceived depends on
the durations.

Optional the second layer can be transposed by the interval defined in the
transpose-layer2 setting.
"
        (:groupings '(2)  :x-proportions '((0.5 0.5)))

        (the-pitch-canon-rule layernr1 layernr2 transpose-layer2))




(system::PWGLDef startpitch-rule ((layernrs '(0))(pitches '(64)))
        "Forces the first pitch in a layer to be fixed to a given value.

layernrs: This is a list of the layernrs for the layers
pitches: This is a list of the first pitch for each layer in layernrs.

The lists in layernrs and pitches have to be of the same lengths."
        (:groupings '(2)  :x-proportions '((0.5 0.5)))

        (the-start-pitches-rule layernrs pitches))