(in-package MC)

(system::PWGLDef access-rhythm ((testfunction nil)(layernr 0)(mode?  10 (ccl::mk-menu-subview :menu-list '(":easy-mode" ":include-nonexisting-rhythms" ":rhythmcell-easy-mode" ":list-all-rhythms")))(type?  10 (ccl::mk-menu-subview :menu-list '(":rule" ":heuristic-rule"))))
        "This function lets a rule access durations in a layer.

Layernr can be a list of layernrs - in that case the rule will apply to all 
layers in the list.

The mode? setting:

Easy mode will give true until all variables are filled with durations.

The include-nonexisting-rhythms mode will give nil for all variables before 
the beginning of the sequence. In this mode the testfunction has to be able 
to handle nil as a possible value. Normally this is not a desired option and 
should be seen as an expert setting.

Rhythmcell-easy-mode gives whole rhythmcells (as lists) instead of single
durations for each variable. The rule will be true until all variables are 
filled with rhythmcells.

The rule (an abstractionm in the lambda state) can have any number of 
inputs/variables. The inputs correspond to consecutive durations in a layer.
"
        (:groupings '(3 1)  :x-proportions '((0.2 0.2 (:fix 0.55))(1.0)))
  (setf testfunction (jbs-mc-rhythm testfunction))
  (if (equal type? :heuristic-rule)
      (cond ((equal mode? :easy-mode )
             (format-heuristic-rhythm-rule testfunction layernr))
            ((equal mode? :include-nonexisting-rhythms )
             (format-heuristic-rhythm-rule-include-nil testfunction layernr))
            ((equal mode? :rhythmcell-easy-mode )
             (format-heuristic-rhythmcell-rule testfunction layernr))
            ((equal mode? :list-all-rhythms )
             (format-heuristic-rhythm-rule-list-all-rhythms testfunction layernr))
            (t t))
    (cond ((equal mode? :easy-mode )
           (format-rhythm-rule testfunction layernr))
          ((equal mode? :include-nonexisting-rhythms )
           (format-rhythm-rule-include-nil testfunction layernr))
          ((equal mode? :rhythmcell-easy-mode )
           (format-rhythmcell-rule testfunction layernr))
          ((equal mode? :list-all-rhythms )
           (format-rhythm-rule-list-all-rhythms testfunction layernr))
          (t t))))


