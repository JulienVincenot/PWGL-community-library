(in-package MC)

(system::PWGLDef access-poly-rhythm ((testfunction nil)(layernr1 0)(layernr2 1)
                                     (range?  10 (ccl::mk-menu-subview :menu-list '(":all-rhythms" ":window")))
                                     (windowsize 1/2)
                                     (mode?  10 (ccl::mk-menu-subview :menu-list '(":easy-mode")))
                                     (type?  10 (ccl::mk-menu-subview :menu-list '(":rule" ":heuristic-rule"))))
    "This function lets a rule access simultaneous durations in two layers. 

The rule (an abstraction in the lambda state) must have only one input.
The range? setting will determine what data the function accesses.

The range? setting:

If range? is set to all-rhythms, the rule will get a list with to sub-lists, 
each sub-list containing all durations in each layer.

If range? is set to window, the rule will check slices (windows) of the rhythm
sequences. The width of the window is determined by the windowsize 
input. The window will also step forward with the windowsize. The rule
will get access to a list of two sub-list (one for each voice), each 
sub-list being formated '((duration-seq) offset-from-windowstart).

Ex (window):
'(((1/4 1/4 1/16 1/16) -1/8) ((1/4 1/8) 0))
The first voice start the window with a quarter note, starting 1/8 before 
the window (i.e. syncopation). Offsets can only be 0 or negative ratios.
"
    (:groupings '(3 2 2)  :x-proportions '((1.0 1.0 1.0)(1.5 0.5)(1.0 1.0)))

  (cond ((equal range? :all-rhythms)
         (if (equal type? :rule)
             (access-poly-all-rhythm testfunction layernr1 layernr2)
           (access-heuristic-poly-all-rhythm testfunction layernr1 layernr2)))
        ((equal range? :window)
         (if (equal type? :rule)
             (access-poly-window-rhythm testfunction layernr1 layernr2 windowsize)
           (access-heuristic-poly-window-rhythm testfunction layernr1 layernr2 windowsize))))
  )