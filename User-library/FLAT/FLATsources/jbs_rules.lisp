(in-package studioflat)

(defun distribution-factor (tot-length temp-length factor)
  (expt (/ temp-length tot-length) factor))

;(distribution-factor 10 5 .5)

(defun distributed-pattern-rule (element nr-of-repeats distributionfactor tot-length)
  "Ruke for approximation of an energy profile. A reference sequence is used as a model.
deviation% is deviation compared to max energy in the energy profile of the reference profile."
    (list '* (list (read-from-string "?if") (list 'and (list '<= (list 'min (list 'round (list '* nr-of-repeats (list 'distribution-factor tot-length (read-from-string "len") distributionfactor)))
                                                                       (read-from-string "len"))
                                                             (list 'count element (read-from-string "l")))
                                                  (list '>= nr-of-repeats (list 'count element (read-from-string "l")))))))


(defun pattern-rule (element nr-of-repeats tot-length)
  "Ruke for approximation of an energy profile. A reference sequence is used as a model.
deviation% is deviation compared to max energy in the energy profile of the reference profile."
    (list '* (list (read-from-string "?if") (list 'and (list 'if (list '<= (list '- tot-length (read-from-string "len")) nr-of-repeats)
                                                             (list '<= (list '- nr-of-repeats (list 'count element (read-from-string "l"))) (list '- tot-length (read-from-string "len")))
                                                             't)
                                                  (list '>= nr-of-repeats (list 'count element (read-from-string "l"))))
                   )))
                                                

(defun pattern-rule2 (element nr-of-repeats section-length)
  "Ruke for approximation of an energy profile. A reference sequence is used as a model.
deviation% is deviation compared to max energy in the energy profile of the reference profile."
    (list '* (list (read-from-string "?if") (list 'let (list (list 'section (list 'last (read-from-string "l") section-length)))
                                                  (list 'and (list 'if (list '<= (list '- section-length (list 'length 'section)) nr-of-repeats)
                                                                   (list '<= (list '- nr-of-repeats (list 'count element 'section)) (list '- section-length (list 'length 'section)))
                                                                   't)
                                                        (list '>= nr-of-repeats (list 'count element 'section)))
                                                  ))))


(defun distributed-pattern-rule2 (element nr-of-repeats distributionfactor section-length)
  "Ruke for approximation of an energy profile. A reference sequence is used as a model.
deviation% is deviation compared to max energy in the energy profile of the reference profile."
    (list '* (list (read-from-string "?if") (list 'let (list (list 'section (list 'last (read-from-string "l") section-length)))
                                                  (list 'and (list '<= (list 'min (list 'round (list '* nr-of-repeats (list 'distribution-factor section-length (list 'length 'section) distributionfactor)))
                                                                             (list 'length 'section))
                                                                   (list 'count element 'section))
                                                        (list '>= nr-of-repeats (list 'count element 'section)))))))




(defun pattern-rule3 (element nr-of-repeats section-length)
  "Ruke for approximation of an energy profile. A reference sequence is used as a model.
deviation% is deviation compared to max energy in the energy profile of the reference profile."
    (list '* (list (read-from-string "?if") (list 'let (list (list 'section (list 'car (list 'last (list 'system:GROUP-LST (read-from-string "l") section-length)))))
                                                  (list 'and (list 'if (list '<= (list '- section-length (list 'length 'section)) nr-of-repeats)
                                                                   (list '<= (list '- nr-of-repeats (list 'count element 'section)) (list '- section-length (list 'length 'section)))
                                                                   't)
                                                        (list '>= nr-of-repeats (list 'count element 'section)))
                                                  ))))

(defun distributed-pattern-rule3 (element nr-of-repeats distributionfactor section-length)
  "Ruke for approximation of an energy profile. A reference sequence is used as a model.
deviation% is deviation compared to max energy in the energy profile of the reference profile."
    (list '* (list (read-from-string "?if") (list 'let (list (list 'section (list 'car (list 'last (list 'system:GROUP-LST (read-from-string "l") section-length)))))
                                                  (list 'and (list '<= (list 'min (list 'round (list '* nr-of-repeats (list 'distribution-factor section-length (list 'length 'section) distributionfactor)))
                                                                             (list 'length 'section))
                                                                   (list 'count element 'section))
                                                        (list '>= nr-of-repeats (list 'count element 'section)))))))


(defun jbs-pattern-rule3 (element nr-of-repeats section-length)
  "Ruke for approximation of an energy profile. A reference sequence is used as a model.
deviation% is deviation compared to max energy in the energy profile of the reference profile."
  (let ((element (if (listp element) (list 'quote element) element)))
    (list (read-from-string ":TRUE/FALSE") '* (list (read-from-string "?if") (list 'let (list (list 'section (list 'car (list 'last (list 'system:GROUP-LST (read-from-string "l") section-length)))))
                                                  (list 'and (list 'if (list '<= (list '- section-length (list 'length 'section)) nr-of-repeats)
                                                                   (list '<= (list '- nr-of-repeats (list 'count element 'section  (read-from-string ":test") (read-from-string "'equalp"))) (list '- section-length (list 'length 'section)))
                                                                   't)
                                                        (list '>= nr-of-repeats (list 'count element 'section (read-from-string ":test") (read-from-string "'equalp"))))
                                                  )))))

(defun jbs-distributed-pattern-rule3 (element nr-of-repeats distributionfactor section-length)
  "Ruke for approximation of an energy profile. A reference sequence is used as a model.
deviation% is deviation compared to max energy in the energy profile of the reference profile."
  (let ((element (if (listp element) (list 'quote element) element)))
    (list (read-from-string ":TRUE/FALSE") '* (list (read-from-string "?if") (list 'let (list (list 'section (list 'car (list 'last (list 'system:GROUP-LST (read-from-string "l") section-length)))))
                                                  (list 'and (list '<= (list 'min (list 'round (list '* nr-of-repeats (list 'distribution-factor section-length (list 'length 'section) distributionfactor)))
                                                                             (list 'length 'section))
                                                                   (list 'count element 'section  (read-from-string ":test") (read-from-string "'equalp")))
                                                        (list '>= nr-of-repeats (list 'count element 'section  (read-from-string ":test") (read-from-string "'equalp")))))))))


(system::PWGLDef pmc-patternrules ((repeated-element nil)(nr-of-repeats 4)(section-length 12)(distributionfactor 1.0)
                                            (order?  10 (ccl::mk-menu-subview :menu-list '(":simple" ":distributed"))))
    "Sorry, no doc :) "
    (:groupings '(2 2 1) :x-proportions '((0.5 0.5)(0.5 0.5)(1.0)))

      (cond ((equal order? :simple)
             (pattern-rule3 repeated-element nr-of-repeats section-length))
            ((equal order? :distributed)
             (distributed-pattern-rule3 repeated-element nr-of-repeats distributionfactor section-length))))


(system::PWGLDef jbs-patternrule ((repeated-element nil)(nr-of-repeats 4)(section-length 12)(distributionfactor 1.0)
                                            (order?  10 (ccl::mk-menu-subview :menu-list '(":simple" ":distributed"))))
    "Sorry, no doc :) "
    (:groupings '(2 2 1) :x-proportions '((0.5 0.5)(0.5 0.5)(1.0)))

      (cond ((equal order? :simple)
             (jbs-pattern-rule3 repeated-element nr-of-repeats section-length))
            ((equal order? :distributed)
             (jbs-distributed-pattern-rule3 repeated-element nr-of-repeats distributionfactor section-length))))