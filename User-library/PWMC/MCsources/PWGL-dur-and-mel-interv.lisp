(in-package MC)


(system::PWGLDef mel-interval->dur-rule ((layernr 0)(match-dur?  10 (ccl::mk-menu-subview :menu-list '(":=" ":member" ":longer-than" ":shorter-than")))(durations 1/4)(match-interval?  10 (ccl::mk-menu-subview :menu-list '(":=" ":member" ":smaller-than" ":larger-than")))(intervals 0) &optional (break :wrap-gracenotes (ccl::mk-menu-subview :menu-list '(":wrap-gracenotes" ":break-at-gracenotes"))))
    "Restricts what melodic intervals are allowed from an event with a specific duration.

If the duration the melodic interval start at is
   =:            identical to a value
   member:       member of a list of values
   longer-than:  longer than a value
   shorter-than: shorter than a value

then the melodic interval has to be
=:            equal to an interval
member:       member of a list of intervals
smaller-than: smaller than an interval
larger-than:  larger than an interval
"
    (:groupings '(3 2)  :x-proportions '((0.4 (:fix 0.35) 0.6) ((:fix 0.35) 1.0)))
 
  (let ((testfunctioninterval #'(lambda (x xx) nil))
        (testfunctionduration #'(lambda (x xx) t)))

    (if (equal match-interval? :=) (if (and (listp intervals)(listp (first intervals)))
                                       (progn (ccl::PWGL-print "WARNING: List of intervals do not match the condition in the rule. Error in mel-interval->dur-rule")
                                         (setf testfunctioninterval #'(lambda (x xx) nil)))
                                     (setf testfunctioninterval 'testfunction-equal)) 
      (if (equal match-interval? :member) (if (listp intervals) (setf testfunctioninterval 'testfunction-member)
                                            (progn (ccl::PWGL-print "WARNING: the member option needs a list of possible pintervals to chose from. Error in mel-interval->dur-rule")
                                              (setf testfunctioninterval #'(lambda (x xx) nil)))) ;This dummy rule will kill all candidates! No answer will be true.

        (if (equal match-interval? :smaller-than) (if (listp intervals) (progn (ccl::PWGL-print "WARNING: A list can not be given as a treshold. Error in mel-interval->dur-rule")
                                                                          (setf testfunctioninterval #'(lambda (x xx) nil))) ;This dummy rule will kill all candidates! No answer will be true.
                                                    (setf testfunctioninterval 'testfunction-lowregister))
          (if (equal match-interval? :larger-than) (if (listp intervals) (progn (ccl::PWGL-print "WARNING: A list can not be given as a treshold. Error in mel-interval->dur-rule")
                                                                           (setf testfunctioninterval #'(lambda (x xx) nil))) ;This dummy rule will kill all candidates! No answer will be true.
                                                     (setf testfunctioninterval 'testfunction-highregister))
            nil
            ))))
    (if (equal match-dur? :=) (if (listp durations) (progn (ccl::PWGL-print "WARNING: A rhythm value can not be matched to a list. Error in mel-interval->dur-rule")
                                                      (setf testfunctioninterval #'(lambda (x xx) nil)))  ;This dummy rule will kill all candidates (has to be on pitch)! No answer will be true
                                (setf testfunctionduration 'testfunction-r=))
      (if (equal match-dur? :member) (if (listp durations) (setf testfunctionduration 'testfunction-rmember)
                                       (progn (ccl::PWGL-print "WARNING: the member option needs a list of possible rhythm values to chose from. Error in mel-interval->dur-rule")
                                         (setf testfunctioninterval #'(lambda (x xx) nil)))  ;This dummy rule will kill all candidates (has to be on pitch)! No answer will be true
                                       )
        (if (equal match-dur? :longer-than) (if (listp durations) (progn (ccl::PWGL-print "WARNING: A list can not be a treshold. Error in mel-interval->dur-rule")
                                                                    (setf testfunctioninterval #'(lambda (x xx) nil)))
                                              (setf testfunctionduration 'testfunction-longdurations))
          (if (equal match-dur? :shorter-than) (if (listp durations) (progn (ccl::PWGL-print "WARNING: A list can not be a treshold. Error in mel-interval->dur-rule")
                                                                       (setf testfunctioninterval #'(lambda (x xx) nil)))
                                                 (setf testfunctionduration 'testfunction-shortdurations))
            nil))))
    
    (if (equal break :wrap-gracenotes)
        (if (listp durations)
            (if (member 0 durations) (rule-melodic-interval-for-gracenotes testfunctionduration testfunctioninterval durations intervals layernr)
              (rule-melodic-interval-for-duration testfunctionduration testfunctioninterval durations intervals layernr))
          (if (= 0 durations) (rule-melodic-interval-for-gracenotes testfunctionduration testfunctioninterval durations intervals layernr)
            (rule-melodic-interval-for-duration testfunctionduration testfunctioninterval durations intervals layernr)))
      (if (listp durations)
          (if (member 0 durations) (append (rule-melodic-interval-for-gracenotes testfunctionduration testfunctioninterval '(0) intervals layernr)
                                           (rule-melodic-interval-for-dur-break-at-gracenotes testfunctionduration testfunctioninterval (remove 0 durations) intervals layernr))
            (rule-melodic-interval-for-dur-break-at-gracenotes testfunctionduration testfunctioninterval durations intervals layernr))
        (if (= 0 durations) (rule-melodic-interval-for-gracenotes testfunctionduration testfunctioninterval durations intervals layernr)
          (rule-melodic-interval-for-dur-break-at-gracenotes testfunctionduration testfunctioninterval durations intervals layernr))))
    ))