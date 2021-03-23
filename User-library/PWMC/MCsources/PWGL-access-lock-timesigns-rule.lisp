(in-package MC)


(system::PWGLDef lock-meter-rule ((timesigns '((4 4)(4 4))) &optional (nr-of-meaures nil))
        "This rule will lock the sequence of timesigns to be equal to a predefined 
sequence of timesigns. The rule will not affect measures after the length of the 
predefined sequence. "
        ()
  (if (not nr-of-meaures)
      (lock-timesign-rule timesigns)
    (list (lock-timesign-rule timesigns)
          (fix-nr-of-measures nr-of-meaures))))


(system::PWGLDef access-meter ((testfunction nil)
                               (mode?  10 (ccl::mk-menu-subview :menu-list '(":easy-mode")))
                               (type?  10 (ccl::mk-menu-subview :menu-list '(":rule" ":heuristic-rule"))))
    "This function lets a rule access time signatures. If the rule has more
than one input, time signatures in cosecutive measures will be checked.
"
    (:groupings '(2 1)  :x-proportions '((0.2 0.8)(1.0)))

  (if (equal type? :rule)
      (access-timesigns-rule testfunction)
    (access-timesigns-heuristic-rule testfunction)))