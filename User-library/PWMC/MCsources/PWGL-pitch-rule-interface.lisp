(in-package MC)

(system::PWGLDef access-melody ((testfunction nil)(layernr 0)(mode?  10 (ccl::mk-menu-subview :menu-list '(":easy-mode" ":include-nonexisting-pitches" ":list-all-pitches"))) (type?  10 (ccl::mk-menu-subview :menu-list '(":rule" ":heuristic-rule"))))
        "This function lets a rle access pitches in a layer.

Layernr can be a list of layernrs - in that case the rule will apply to all
layers in the list.

The mode? setting:

Easy-mode will give true until all variables are filled with pitches

The include-nonexisting-pitches mode will give nil for all variables before 
the beginning of the sequence. In this mode the testfunction has to be able 
to handle nil as a possible value. Normally this is not a desired option and 
should be seen as an expert setting.

List-all-pitches gives a list with all pitches that exist in a layer so far. 
If this setting is chosen the rule must only have one input.

If easy-mode or include-nonexisting-pitches is chosen, the rule (an 
abstraction in the lambda state) can have any number of inputs/variables. 
The inputs correspond to consecutive durations in a layer.
"
        (:groupings '(3 1)  :x-proportions '((0.2 0.2 (:fix 0.35))(1.0)))
  (setf testfunction (jbs-mc-pitch testfunction))
  (if (equal type? :heuristic-rule)
      (cond ((equal mode? :easy-mode )
             (format-heuristic-pitch-rule testfunction layernr))
            ((equal mode? :include-nonexisting-pitches )
             (format-heuristic-pitch-rule-include-nil testfunction layernr))
            ((equal mode? :list-all-pitches )
             (format-heuristic-pitch-rule-list-all-pitches testfunction layernr))
            (t t))
    (cond ((equal mode? :easy-mode )
           (format-pitch-rule testfunction layernr))
          ((equal mode? :include-nonexisting-pitches )
           (format-pitch-rule-include-nil testfunction layernr))
          ((equal mode? :list-all-pitches )
           (format-pitch-rule-list-all-pitches testfunction layernr))
          (t t))))

;format-pitch-rule-list-all-pitches (pitchfn layers)
;format-heuristic-pitch-rule-list-all-pitches




(system::PWGLDef access-harmony ((testfunction nil)(layernr1 0)(layernr2 1)(rule  10 (ccl::mk-menu-subview :menu-list '(":always" ":homophony" ":onset-on-beat" ":duration-on-beat")))(heur?  10 (ccl::mk-menu-subview :menu-list '(":rule" ":heuristic-rule"))) &optional (beat-subdiv 1))
        "
The rule (an abstractionm in the lambda state) must have two inputs/variables. The first is the first layer's pitch, the second is the second layer's simultaneous pitch.  The test function is only called when both pitches exist. If a pause appears, the test is ignored.

The rule menu determies how the testfunction is checked:

Always - The testfunction is checked for each separate pitch.
Homophony - The testunction is checked for pitches that exist in homophonic rhythm (onsets).
Onset-on-beat - The testfunction is checked for pitches that starts at metric beats (= onset exist at metric beat). The optional beat-subdiv input determines if the testfunction should be checked on subdivisions of beats as well (2 = every beat is divided into two equal divisions, and each onsets that occur on any division is checked).
Duration-on-beat - The testfunction is checked for pitches that exist at metric beats (= metric beats occurs within the duration of the pitch). 

Layernr can be a list of layernrs - in that case the rule will apply to all layers."
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



;;;;

(system::PWGLDef access-3harmony ((testfunction nil)(layernr1 0)(layernr2 1)(layernr3 2)(rule  10 (ccl::mk-menu-subview :menu-list '(":always")))(heur?  10 (ccl::mk-menu-subview :menu-list '(":rule"))) &optional (beat-subdiv 1))
        "
The rule (an abstractionm in the lambda state) must have two inputs/variables. The first is the first layer's pitch, the second is the second layer's simultaneous pitch.  The test function is only called when both pitches exist. If a pause appears, the test is ignored.

The rule menu determies how the testfunction is checked:

Always - The testfunction is checked for each separate pitch.
Homophony - The testunction is checked for pitches that exist in homophonic rhythm (onsets).
Onset-on-beat - The testfunction is checked for pitches that starts at metric beats (= onset exist at metric beat). The optional beat-subdiv input determines if the testfunction should be checked on subdivisions of beats as well (2 = every beat is divided into two equal divisions, and each onsets that occur on any division is checked).
Duration-on-beat - The testfunction is checked for pitches that exist at metric beats (= metric beats occurs within the duration of the pitch). 

Layernr can be a list of layernrs - in that case the rule will apply to all layers."
        (:groupings '(4 2)  :x-proportions '((0.2 0.2 0.2 0.2)(0.5 0.5)) :w 0.5)
  (if (equal heur? :heuristic-rule)
      (cond ((equal rule :always )
             ())
            ((equal rule :homophony )
             ())
            ((equal rule :onset-on-beat )
             ())
            ((equal rule :duration-on-beat )
             ())
            (t t))
    (cond ((equal rule :always )
           (format-3layers-harm-rule testfunction layernr1 layernr2 layernr3))
          ((equal rule :homophony )
           ())
          ((equal rule :onset-on-beat )
           ())
          ((equal rule :duration-on-beat )
           ())
          (t t)))
  )


;format-3layers-chord-rule (testfn layer1 layer2 layer3)

(system::PWGLDef access-4harmony ((testfunction nil)(layernr1 0)(layernr2 1)(layernr3 2)(layernr4 3)(rule  10 (ccl::mk-menu-subview :menu-list '(":always" ":duration-on-beat")))(heur?  10 (ccl::mk-menu-subview :menu-list '(":rule"))) &optional (beat-subdiv 1))
        "
The rule (an abstractionm in the lambda state) must have two inputs/variables. The first is the first layer's pitch, the second is the second layer's simultaneous pitch.  The test function is only called when both pitches exist. If a pause appears, the test is ignored.

The rule menu determies how the testfunction is checked:

Always - The testfunction is checked for each separate pitch.
Homophony - The testunction is checked for pitches that exist in homophonic rhythm (onsets).
Onset-on-beat - The testfunction is checked for pitches that starts at metric beats (= onset exist at metric beat). The optional beat-subdiv input determines if the testfunction should be checked on subdivisions of beats as well (2 = every beat is divided into two equal divisions, and each onsets that occur on any division is checked).
Duration-on-beat - The testfunction is checked for pitches that exist at metric beats (= metric beats occurs within the duration of the pitch). 

Layernr can be a list of layernrs - in that case the rule will apply to all layers."
        (:groupings '(5 2)  :x-proportions '((0.2 0.2 0.2 0.2 0.2)(0.5 0.5)) :w 0.6)
  (if (equal heur? :heuristic-rule)
      (cond ((equal rule :always )
             ())
            ((equal rule :homophony )
             ())
            ((equal rule :onset-on-beat )
             ())
            ((equal rule :duration-on-beat )
             ())
            (t t))
    (cond ((equal rule :always )
           (format-4layers-harm-rule testfunction layernr1 layernr2 layernr3 layernr4))
          ((equal rule :homophony )
           ())
          ((equal rule :onset-on-beat )
           ())
          ((equal rule :duration-on-beat )
           (format-4layers-harm-on-beat-rule testfunction beat-subdiv layernr1 layernr2 layernr3 layernr4))
          (t t)))
  )


(system::PWGLDef rule-4-voice-chords ((chord-list '((3 7)(4 7)))(layernr1 0)(layernr2 1)(layernr3 2)(layernr4 3)(selections?  10 (ccl::mk-menu-subview :menu-list '(":always" ":duration-on-beat")))(heur?  10 (ccl::mk-menu-subview :menu-list '(":rule"))) &optional (beat-subdiv 1))
        "Makes sure that chord structures between up to 4 voices match a list of 
allowed chord structures. Only pitch classes for the pitches are checked 
(i.e. pitches can be in any octave).

chord-list: This is the list of allowed chord structures. Numbers indicate 
intervals from the lowest pitch in the definition. Chords are allowed in any 
tranposition and position. Ex. (4 7) is a major triad. The rule will allow 
(3 8) and (5 9) as well since they are also major triads built form the 
third respective fifth.

Layernrs determines the layers the pitches in the chord exist in. The 
pitches have to be single pitches (chords within a voice will not be 
understood). By setting two or more layernrs to the same number, the rule 
can also handle chords/intervals between 2 or 3 voices (unisons are always 
allowed).

The selection? setting:

always: The rule is checked when a new pitch starts in any of the voices.

duration-on-beat: The rule is only  checked for pitches that exist at metric 
beats (i.e. regardless of where the onsets are). The optional beat-subdiv
input determines if the rule shojuld be checkes on subdivisions of the 
beat as well (for example 2 = every beat is divided into two equal parts,
and the starting point of each sub-division is checked).
"
        (:groupings '(5 2)  :x-proportions '((0.5 0.12 0.12 0.12 0.12)(0.5 0.5)) :w 0.6)
  (if (equal heur? :heuristic-rule)
      (cond ((equal selections? :always )
             ())
            ((equal selections? :homophony )
             ())
            ((equal selections? :onset-on-beat )
             ())
            ((equal selections? :duration-on-beat )
             ())
            (t t))
    (cond ((equal selections? :always )
           (format-4layers-chord-rule chord-list layernr1 layernr2 layernr3 layernr4))
          ((equal selections? :homophony )
           ())
          ((equal selections? :onset-on-beat )
           ())
          ((equal selections? :duration-on-beat )
           (format-4layers-chord-at-beats-rule chord-list beat-subdiv layernr1 layernr2 layernr3 layernr4))
          (t t)))
  )