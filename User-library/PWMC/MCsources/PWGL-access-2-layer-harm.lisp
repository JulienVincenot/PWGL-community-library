(in-package MC)


(system::PWGLDef access-2part-harmony ((testfunction nil)(layernr1 0)(layernr2 1)(selection?  10 (ccl::mk-menu-subview :menu-list '(":always" ":duration-on-beat" ":onset-on-beat" ":homophony" ":1st-voice")))(gracenotes?  10 (ccl::mk-menu-subview :menu-list '(":grace" ":no-grace")))(heur?  10 (ccl::mk-menu-subview :menu-list '(":rule" ":heuristic-rule"))) &optional (beat-subdiv 1))
    "This function lets a rule access simultaneous pitches in 2 layers.

The rule (an abstractionm in the lambda state) can have any number of
inputs/variables. Two or more inputs represent consecutive harmonies (see 
the selection? setting below). The test function is only called when both 
pitches exist. If a pause appears, the test is ignored.

The selection? setting:

always: The rule is checked when a new pitch starts in any of the two voice.

homophony: The rule is only checked for pitches that exist at homophonic 
rhythms (i.e. they must have simultaneous onsets). Consecutive harmonies are 
here harmonies that exist on consecutive homophonic events.

onset-on-beat: The rule is only checked for pitches that starts at metric 
beats (= the onset in any of the voices has to occur at a beat). Consecutive 
harmonies are here harmonies that exist on consecutive beats. The optional 
beat-subdiv input determines if the rule should be checked on subdivisions 
of beats as well (for example 2 = every beat is divided into two equal
parts, and each onset that coincides with any of these time points is 
checked).

duration-on-beat: The rule is checked for pitches that exist at metric beats 
(i.e. regardless of where the onsets are). The optional beat-subdiv setting 
works as above.

1-st-voice: The rule is checked at the time points where the onsets for the 
first voice are.  

"
    (:groupings '(3 3)  :x-proportions '((0.3 0.3 0.3)(0.5 0.25 0.25)))
  (if (equal gracenotes? :grace)
      (if (equal heur? :heuristic-rule)
          (cond ((equal selection? :always )
                 (format-2-layer-harm-heuristic-rule-include-gracenotes testfunction layernr1 layernr2))
                ((equal selection? :homophony )
                 (homophony-harm-include-gracenotes-heuristic-rule layernr1 layernr2 testfunction))
                ((equal selection? :onset-on-beat )
                 (harm-onset-on-beat-include-gracenotes-heuristic-rule layernr1 layernr2 beat-subdiv testfunction))
                ((equal selection? :duration-on-beat)
                 (harm-on-beat-include-gracenotes-heuristic-rule layernr1 layernr2 beat-subdiv testfunction))
                ((equal selection? :1st-voice)
                 (1st-voice-onsets-harm-include-gracenotes-heuristic-rule layernr1 layernr2 testfunction))
                (t t))

        (cond ((equal selection? :always )
               (format-2-layer-harm-rule-include-gracenotes testfunction layernr1 layernr2))
              ((equal selection? :homophony )
               (homophony-harm-include-gracenotes-rule layernr1 layernr2 testfunction))
              ((equal selection? :onset-on-beat )
               (harm-onset-on-beat-include-gracenotes-rule layernr1 layernr2 beat-subdiv testfunction))
              ((equal selection? :duration-on-beat)
               (harm-on-beat-include-gracenotes-rule layernr1 layernr2 beat-subdiv testfunction))
              ((equal selection? :1st-voice)
               (1st-voice-onsets-harm-include-gracenotes-rule layernr1 layernr2 testfunction))
              (t t)))


    (if (equal heur? :heuristic-rule)
        (cond ((equal selection? :always )
               (format-2-layer-harm-heuristic-rule testfunction layernr1 layernr2))
              ((equal selection? :homophony )
               (homophony-harm-heuristic-rule layernr1 layernr2 testfunction))
              ((equal selection? :onset-on-beat )
               (harm-onset-on-beat-heuristic-rule layernr1 layernr2 beat-subdiv testfunction))
              ((equal selection? :duration-on-beat)
               (harm-on-beat-heuristic-rule layernr1 layernr2 beat-subdiv testfunction))
              ((equal selection? :1st-voice)
               (1st-voice-onsets-harm-heuristic-rule layernr1 layernr2 testfunction))
              (t t))

      (cond ((equal selection? :always )
             (format-2-layer-harm-rule testfunction layernr1 layernr2))
            ((equal selection? :homophony )
             (homophony-harm-rule layernr1 layernr2 testfunction))
            ((equal selection? :onset-on-beat )
             (harm-onset-on-beat-rule layernr1 layernr2 beat-subdiv testfunction))
            ((equal selection? :duration-on-beat)
             (harm-on-beat-rule layernr1 layernr2 beat-subdiv testfunction))
            ((equal selection? :1st-voice)
             (1st-voice-onsets-harm-rule layernr1 layernr2 testfunction))
            (t t)))))



;;;
