(in-package MC)

(system::PWGLdef decode-pmc ((solution nil) (tempo 96)
                             (extra-pitch? 10 (ccl::mk-menu-subview :menu-list '(":include_all_pitches" ":only_pitch_with_rhythm")))
                             (extra-rhythm? 10 (ccl::mk-menu-subview :menu-list '(":include_all_rhythms" ":only_rhythm_with_pitch")))
                             (supply-measures? 10 (ccl::mk-menu-subview :menu-list '(":supply_extra_measures" ":only_measures_from_pmc"))))
    "decode-pmc"
    (:groupings '(2 1 1 1) :w 0.65)
  (let ((solutionlist (pmc-solutionlists-from-vectors solution)))
    (if solutionlist
        (progn
          (setf supply-measures? (if (equal supply-measures? :supply_extra_measures) t nil))
          (if (or (equal extra-pitch? :only_pitch_with_rhythm)
                  (equal extra-rhythm? :only_rhythm_with_pitch))

              (solutionlists-to-PWGLtree 
               (append (list (pop solutionlist))
                       (loop while solutionlist
                             collect (let* ((this-solutionlist (pop solutionlist))
                                            (rhythm-seq (car this-solutionlist))
                                            (pitch-seq (cadr this-solutionlist)))
   
                                       (if (and (equal extra-pitch? :only_pitch_with_rhythm)
                                                (collect-overflow-pitch rhythm-seq pitch-seq))
                                           (progn (print "Pitchevents without corresponding rhythmevent truncated: ")
                                             (print (collect-overflow-pitch rhythm-seq pitch-seq))
                                             (setf pitch-seq (remove-overflow-pitch rhythm-seq pitch-seq)))
                                   )
                                       (if (and (equal extra-rhythm? :only_rhythm_with_pitch)
                                                (collect-overflow-rhythm rhythm-seq pitch-seq))
                                           (progn (print "Rhythmevents without corresponding pitch truncated: ")
                                             (collect-overflow-rhythm rhythm-seq pitch-seq)
                                             (setf rhythm-seq (remove-overflow-rhythm rhythm-seq pitch-seq))
                                             ))
                                       (list rhythm-seq pitch-seq))))
               supply-measures? tempo)

            (solutionlists-to-PWGLtree solutionlist supply-measures? tempo))
          ))))

(system::PWGLdef partial-solution ((tempo 96)
                                   (extra-pitch? 10 (ccl::mk-menu-subview :menu-list '(":include_all_pitches" ":only_pitch_with_rhythm")))
                                   (extra-rhythm? 10 (ccl::mk-menu-subview :menu-list '(":include_all_rhythms" ":only_rhythm_with_pitch")))
                                   (supply-measures? 10 (ccl::mk-menu-subview :menu-list '(":supply_extra_measures" ":only_measures_from_pmc"))))
    "Get partial solution from last run of PMC."
    (:groupings '(1 1 1 1) :w 0.4)
  (let ((solutionlist (partial-solutionlists-from-vectors)))
    (if solutionlist
        (progn
          (setf supply-measures? (if (equal supply-measures? :supply_extra_measures) t nil))
          (if (or (equal extra-pitch? :only_pitch_with_rhythm)
                  (equal extra-rhythm? :only_rhythm_with_pitch))

              (solutionlists-to-PWGLtree 
               (append (list (pop solutionlist))
                       (loop while solutionlist
                             collect (let* ((this-solutionlist (pop solutionlist))
                                            (rhythm-seq (car this-solutionlist))
                                            (pitch-seq (cadr this-solutionlist)))
   
                                       (if (and (equal extra-pitch? :only_pitch_with_rhythm)
                                                (collect-overflow-pitch rhythm-seq pitch-seq))
                                           (progn (print "Pitchevents without corresponding rhythmevent truncated: ")
                                             (print (collect-overflow-pitch rhythm-seq pitch-seq))
                                             (setf pitch-seq (remove-overflow-pitch rhythm-seq pitch-seq)))
                                   )
                                       (if (and (equal extra-rhythm? :only_rhythm_with_pitch)
                                                (collect-overflow-rhythm rhythm-seq pitch-seq))
                                           (progn (print "Rhythmevents without corresponding pitch truncated: ")
                                             (collect-overflow-rhythm rhythm-seq pitch-seq)
                                             (setf rhythm-seq (remove-overflow-rhythm rhythm-seq pitch-seq))
                                             ))
                                       (list rhythm-seq pitch-seq))))
               supply-measures? tempo)

            (solutionlists-to-PWGLtree solutionlist supply-measures? tempo))
          ))))



(system::PWGLdef debugger ((list nil))
    "Put between rules and pmc to activate debugger. View in MCdebug"
    ()
  (let ((rules (cadr (caddr list))))
    (clear-all-debug-vector)
    (list (read-from-string "*")
          (read-from-string "MC::?1")
          (list (read-from-string "?IF")
                (append rules
                        (read-from-string "((mc::debugger-put-last-candidate (1- (CUR-INDEX)) (SECOND RL)))"))))))


;;;;;;;





(system::PWGLDef simple-melodic-rule-interface ((testfunction nil)(layernr 0)(mode?  10 (ccl::mk-menu-subview :menu-list '(":easy-mode" ":include-nonexisting-pitches"))) (type?  10 (ccl::mk-menu-subview :menu-list '(":rule" ":heuristic-rule"))))
        "The include-nonexisting-pitches mode will give nil for all variables before the beginning of the sequence. these might have to be filtered out in the rule.
Easy mode will give true until all variables are filled with pitchvalues.

The rule (an abstractionm in the lambda state) can have any number of inputs/variables.

Layernr can be a list of layernrs - in that case the rule will apply to all layers."
        (:groupings '(3 1)  :x-proportions '((0.2 0.2 (:fix 0.35))(1.0)))
  (if (equal type? :heuristic-rule)
      (cond ((equal mode? :easy-mode )
             (format-heuristic-pitch-rule testfunction layernr))
            ((equal mode? :include-nonexisting-pitches )
             (format-heuristic-pitch-rule-include-nil testfunction layernr))
            (t t))
    (cond ((equal mode? :easy-mode )
           (format-pitch-rule testfunction layernr))
          ((equal mode? :include-nonexisting-pitches )
           (format-pitch-rule-include-nil testfunction layernr))
          (t t))))





(system::PWGLDef simple-harmonic-rule-interface ((testfunction nil)(layernr1 0)(layernr2 1)(rule  10 (ccl::mk-menu-subview :menu-list '(":always" ":homophony" ":onset-on-beat" ":duration-on-beat")))(heur?  10 (ccl::mk-menu-subview :menu-list '(":rule" ":heuristic-rule"))) &optional (beat-subdiv 1))
        "
The rule (an abstractionm in the lambda state) must have two inputs/variables. The first is the first layer's pitch, the second is the second layer's simultaneous pitch.  The test function is only called when both pitches exist. If a pause appears, the test is ignored.

The rule menu determies how the testfunction is checked:

Always - The testfunction is checked for each separate pitch.
Homophony - The testunction is checked for pitches that exist in homophonic rhythm (onsets).
Onset-on-beat - The testfunction is checked for pitches that starts at metric beats (= onset exist at metric beat). The optional beat-subdiv input determines if the testfunction should be checked on subdivisions of beats as well (2 = every beat is divided into two equal divisions, and each onsets that occur on any division is checked).
Duration-on-beat - The testfunction is checked for pitches that exist at metric beats (= metric beats occurs within the duration of the pitch). "
        (:groupings '(3 2)  :x-proportions '((0.3 0.3 0.3)(0.5 0.5)))
  (if (equal heur? :heuristic-rule)
      (cond ((equal rule :always )
             (format-heuristic-chord-rule testfunction layernr1 layernr2))
            ((equal rule :homophony )
             (pitch-at-homophony-heuristicrule layernr1 layernr2 testfunction))
            ((equal rule :onset-on-beat )
             (pitch-on-beat-heuristicrule3 layernr1 layernr2 beat-subdiv testfunction))
            ((equal rule :duration-on-beat )
             (pitch-on-beat-heuristicrule4 layernr1 layernr2 beat-subdiv testfunction))
            (t t))
    (cond ((equal rule :always )
           (format-chord-rule testfunction layernr1 layernr2))
          ((equal rule :homophony )
           (pitch-at-homophony-rule layernr1 layernr2 testfunction))
          ((equal rule :onset-on-beat )
           (pitch-on-beat-rule3 layernr1 layernr2 beat-subdiv testfunction))
          ((equal rule :duration-on-beat )
           (pitch-on-beat-rule4 layernr1 layernr2 beat-subdiv testfunction))
          (t t)))
  )



(system::PWGLDef simple-rhythm-rule-interface ((testfunction nil)(layernr 0)(mode?  10 (ccl::mk-menu-subview :menu-list '(":easy-mode" ":include-nonexisting-rhythms" ":rhythmcell-easy-mode")))(type?  10 (ccl::mk-menu-subview :menu-list '(":rule" ":heuristic-rule"))))
        "The :include-nonexisting-rhythms mode will give nil for all variables before the beginning of the sequence. 
These might have to be filtered out in the rule.
Easy mode will give true until all variables are filled with durations.
Rhythmcell-easy-mode gives whole rhythmcells (as lists) instead of single durations for each variable. The rule will be true until all variables are filled with rhythmcells.

The rule (an abstractionm in the lambda state) can have any number of inputs/variables."
        (:groupings '(3 1)  :x-proportions '((0.2 0.2 (:fix 0.55))(1.0)))
  (if (equal type? :heuristic-rule)
      (cond ((equal mode? :easy-mode )
             (format-heuristic-rhythm-rule testfunction layernr))
            ((equal mode? :include-nonexisting-rhythms )
             (format-heuristic-rhythm-rule-include-nil testfunction layernr))
            ((equal mode? :rhythmcell-easy-mode )
             (format-heuristic-rhythmcell-rule testfunction layernr))
            (t t))
    (cond ((equal mode? :easy-mode )
           (format-rhythm-rule testfunction layernr))
          ((equal mode? :include-nonexisting-rhythms )
           (format-rhythm-rule-include-nil testfunction layernr))
          ((equal mode? :rhythmcell-easy-mode )
           (format-rhythmcell-rule testfunction layernr))
          (t t))))


;;;Below very old function
(system::PWGLDef simple-chord-rule-interface ((testfunction nil)(layernr1 0)(layernr2 1)(type?  10 (ccl::mk-menu-subview :menu-list '(":rule" ":heuristic-rule"))))
        "
The rule (an abstractionm in the lambda state) must have two inputs/variables. The first is the first layer's pitch, the second is the second layer's simultaneous pitch. The testfunction is checkd for each separte pitch. The test function is only called when both pitches exist. If a pause appears, the test function is not called."
        (:groupings '(3 1)  :x-proportions '((0.3 0.3 0.3)(1.0)))
  (if (equal type? :heuristic-rule)
      (format-heuristic-chord-rule testfunction layernr1 layernr2)
    (format-chord-rule testfunction layernr1 layernr2)))