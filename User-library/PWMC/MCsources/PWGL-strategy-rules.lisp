(in-package MC)

(system::PWGLDef strategy-rule-1layer ((layernr 0)(strategy  10 (ccl::mk-menu-subview :menu-list '(":eq-pitch-rhy" ":eq-mea-rhy" ":pitch-before-rhy" ":rhy-before-pitch" ":mea-before-rhy" ":rhy-before-mea"))) &optional (offset 0))
       " Strategy rule within a layer. Layernr can be a list of layers - the rule 
will then be applied on all layers in the list.

The strategy rule controls what should be assigned first (for example pitch 
or duration). A good strategy will speed up a search. You need to think 
about if it makes sense to for example put pitches on existing rhythms or 
vice versa.

The equal length settings will not prefere any to be assigned first, but 
will force the search to assign what is missing (i.e. if durations exist 
without pitch, then find pitches).

The before-setting will first assign what you have chosen to be first, 
but then immediately fill in the missing parameters (unless an offset 
is used).
 
IMPORTANT ABOUT OFFSETS:
pitch-before-rhythm and rhythm-before-pitch: offset (optional) is in 
number of notes.

mea-before-rhy and rhy-before-mea: offset is in duration (note value)
"
        (:groupings '(2)  :x-proportions '((1.0 (:fix 0.4))))
  (if (equal strategy :eq-pitch-rhy) (pitch-rhythm-eq-length-rule layernr) 
    (if (equal strategy :eq-mea-rhy) (measures-rhythm-eq-length-rule layernr) 
      (if (equal strategy :pitch-before-rhy) (pitch-before-rhythm-eq-length-rule layernr offset)
        (if (equal strategy :rhy-before-pitch) (rhythm-before-pitch-eq-length-rule layernr offset)
          (if (equal strategy :mea-before-rhy) (measures-before-rhythm-eq-length-rule layernr offset)
            (if (equal strategy :rhy-before-mea) (rhythm-before-measures-eq-length-rule layernr offset)
    nil)))))))


(system::PWGLDef strategy-rule-2layers ((layernr1 0)(layernr2 1)(strategy  10 (ccl::mk-menu-subview :menu-list '(":eq-rhy-rhy" ":eq-pitch-pitch" ":rhy-before-rhy" ":pitch-before-pitch"))) &optional (offset 0))
        "Strategy rule between layers.

The strategy rule controls what should be assigned first (for example pitch 
in layer 1 before pitch in layer 2). A good strategy will speed up a search. 
You need to think about if it makes sense to for example searh for pitches
in layer 2 when pitches in layer 1 exist or vice versa.

The equal length settings will not prefere any to be assigned first, but 
will force the search to assign what is missing (i.e. if 5 pitches in 
layer 1 exist, then find 5 pitches in layer 2).

The before-setting will first assign what you have chosen to be first, 
but then immediately fill in the missing items (unless an offset 
is used).

IMPORTANT ABOUT OFFSETS:
pitch-before-pitch: offset (optional) is in number of pitches
rhythm-before-rhythm: offset is in duration (note value)"
        (:groupings '(3)  :x-proportions '((0.1 0.1 (:fix 0.5))))
  (if (equal strategy :eq-rhy-rhy) (rhythm-rhythm-eq-length-rule layernr1 layernr2) 
    (if (equal strategy :eq-pitch-pitch) (pitch-pitch-eq-length-rule layernr1 layernr2) 
      (if (equal strategy :rhy-before-rhy) (rhythm-before-rhythm-eq-length-rule layernr1 layernr2 offset)
        (if (equal strategy :pitch-before-pitch) (pitch-before-pitch-eq-length-rule layernr1 layernr2 offset)
    nil)))))


(system::PWGLDef rules->pmc   (&rest (rules  nil))
        "Collects all rules and formats them to be readable by the multi-pmc.

The box is expandable and accepts any number of rules. Rules can also
be input as list of rules (the function will make any list flat).

This box needs to be connected to the multi-pmc to make the PWMC
system work (even if no rule is attached to it, you need to have 
it attached)!"  
        ()
 (rules-to-pmc  (patch-work::flat (remove nil rules))))


(system::PWGLDef strategy-only-motifs   ((layernr 0))
        "The result of this strategy rule is that the first pitches will 
be a from single pitch-cell with fixed pitches from the domain, and all 
following pitches will be determined from transposable pitch cells."  
        ()
 (rule-only-motifs layernr))

