(in-package MC)

(system::PWGLDef access-metric-structure ((testfunction nil)(layernr 0)
                                          (variable-type?  10 (ccl::mk-menu-subview :menu-list '(":dur_offset" ":dur_offs_sign")))
                                          (selection?  10 (ccl::mk-menu-subview :menu-list '(":at-1st-beat" ":at-all-beats")))
                                          (mode?  10 (ccl::mk-menu-subview :menu-list '(":easy-mode")))
                                          (type?  10 (ccl::mk-menu-subview :menu-list '(":rule" ":heuristic-rule"))))
    "This function lets a rule access durations inside a metric structure.

Layernr can be a list of layernrs - in that case the rule will apply to all 
layers in the list.

The selection? menu setting:

The at-1st-beat selection will access all durations that start (or exist) at 
the first beat in each measure. Any duration that does not exist at the 
first beat will be ignored.

The at-all-beats selection will access all durations that start (or exist) 
at every beat in each measure. Any duration that does not exist at a beat will 
be ignored.


The variable-type? menu setting:

The dur_offset will pass durations and their offsets from either the 
beginning of a beat or the first beat in each measure. The format is 
'(durtion offset) - for example '(1/4 -1/8) is a quarter note duration 
starting an eighth note before a beat.

The dur_offs_sign will pass durations, their offsets and the time signature. 
The format is '(durtion offset timesignature) - for example 
'(1/4 -1/8 (4 4)) is a quarter note duration starting an eighth note before 
a beat inside a 4//4 bar.

Offset is the distance (in note value) the event has to the beat. 0 means at 
the beat. -1/8 means an eightnote before the beat. Offsets are always 
indicated at or BEFORE the beat. The event checked will thus always exist on 
the beat.

The rule can have any number of inputs/pairs.
"
    (:groupings '(2 2 2)  :x-proportions '((1.5 1.5)(1.5 1.5)(1.5 1.5)))


  (cond ((equal selection? :at-1st-beat)
         (cond ((equal variable-type? :dur_offset)
                (if (equal type? :rule)
                    (at-measure-metric-rule testfunction layernr)
                  (at-measure-metric-heuristic-rule testfunction layernr)))
               ((equal variable-type? :dur_offs_sign)
                (if (equal type? :rule)
                    (at-measure-with-sign-metric-rule testfunction layernr)
                  (at-measure-with-sign-metric-heuristic-rule testfunction layernr)))
               ))

        ((equal selection? :at-all-beats)
         (cond ((equal variable-type? :dur_offset)
                (if (equal type? :rule)
                    (at-beat-metric-rule testfunction layernr)
                  (at-beat-metric-heuristic-rule testfunction layernr)))
               ((equal variable-type? :dur_offs_sign)
                (if (equal type? :rule)
                    (at-beat-with-sign-metric-rule testfunction layernr)
                  (at-beat-with-sign-metric-heuristic-rule testfunction layernr)))
               )))
  )