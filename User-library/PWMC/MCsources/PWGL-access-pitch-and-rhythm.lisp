(in-package MC)

(system::PWGLDef access-pitch-and-rhythm ((testfunction nil)(layernr 0)
                                          (measure-info?  10 (ccl::mk-menu-subview :menu-list '(":exclude-time-info" ":include-measure-offset"":include-beat-offset")))
                                          (pauses?  10 (ccl::mk-menu-subview :menu-list '(":include-pauses" ":exclude-pauses")))
                                          (mode?  10 (ccl::mk-menu-subview :menu-list '(":easy-mode" ":include-nonexisting-events")))
                                          (type?  10 (ccl::mk-menu-subview :menu-list '(":rule" ":heuristic-rule"))))
    "This function lets a rule access pairs of pitches and durations in the
format: '(pitch duration)

Layernr can be a list of layernrs - in that case the rule will apply to all 
layers in the list.

The rule is a testfunction (an abstraction in the lambda state). Each input 
to the abstraction will access one pitch-duration-pair; two inputs will 
access two consecutive events (pitch-duration pairs) in the sequence, etc. 
Any number of inputs is possible.

If an event is a pause, the pitch will be 0 (for example '(0 -1/4)). By 
filtering out pauses (set the pauses?-menu to exclude_pauses) these event 
will be skipped.

The mode? menu setting:

Easy mode will give true until all variables are filled with events.

The include-nonexisting-pitches mode will give nil for all variables before 
the beginning of the sequence. The testfunction has to handle nil-values if 
this is chosen. Normally this is not a desired option and should be seen as 
an expert setting.
"
    (:groupings '(2 2 2)  :x-proportions '((0.5 0.5)(0.6 0.4)(0.6 0.4)))
  (let (filter
        metric-div-fn)
    (cond ((equal pauses? :include-pauses)
           (setf filter 'filter-keep-all))
          ((equal pauses? :exclude-pauses)
           (setf filter 'filter-remove-pauses)))
    (cond ((equal measure-info? :include-beat-offset)
           (setf metric-div-fn 'get-timepoints-at-beats-upto-index2))
          ((equal measure-info? :include-measure-offset)
           (setf metric-div-fn 'get-timepoints-at-measures-upto-index2)))
    (cond ((equal measure-info? :exclude-time-info)
           (if (equal type? :heuristic-rule)
               (cond ((equal mode? :easy-mode )
                      (pitch-and-rhythm-heuristic-rule testfunction layernr filter))
                     ((equal mode? :include-nonexisting-events )
                      (pitch-and-rhythm-include-not-assigned-heuristic-rule testfunction layernr filter))
                     (t 0))
             (cond ((equal mode? :easy-mode )
                    (pitch-and-rhythm-rule testfunction layernr filter))
                   ((equal mode? :include-nonexisting-events )
                    (pitch-and-rhythm-include-not-assigned-rule testfunction layernr filter))
                   (t t))))
          (t
           (if (equal type? :heuristic-rule)
               (cond ((equal mode? :easy-mode )
                      (if (equal pauses? :include-pauses)
                          (pitch-rhythm-and-beat-heuristic-rule testfunction layernr metric-div-fn)
                        (pitch-rhythm-and-beat-no-pauses-heuristic-rule testfunction layernr metric-div-fn))
                      )
                     ((equal mode? :include-nonexisting-events )
                      (if (equal pauses? :include-pauses)
                          (pitch-rhythm-and-beat-include-not-assigned-heuristic-rule testfunction layernr metric-div-fn)
                        (pitch-rhythm-and-beat-no-pauses-include-not-assigned-heuristic-rule testfunction layernr metric-div-fn))
                      )
                     (t 0))
             (cond ((equal mode? :easy-mode )
                    (if (equal pauses? :include-pauses)
                        (pitch-rhythm-and-beat-rule testfunction layernr metric-div-fn)
                      (pitch-rhythm-and-beat-no-pauses-rule testfunction layernr metric-div-fn))
                    )
                   ((equal mode? :include-nonexisting-events )
                    (if (equal pauses? :include-pauses)
                        (pitch-rhythm-and-beat-include-not-assigned-rule testfunction layernr metric-div-fn)
                      (pitch-rhythm-and-beat-no-pauses-include-not-assigned-rule testfunction layernr metric-div-fn))
                    )
                   (t t))))
          )))


