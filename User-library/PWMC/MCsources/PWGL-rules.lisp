(in-package MC)


;*********************
;testfunction-not-equal

(system::PWGLDef dur->pitch-rule ((layernr 0)(match-chord?  10 (ccl::mk-menu-subview :menu-list '(":=" ":/=" ":member" ":lower-than" ":higher-than")))(chord 60)(match-dur?  10 (ccl::mk-menu-subview :menu-list '(":=" ":/=" ":member" ":long-duration" ":short-duration")))(durations 1/4))
    "Restricts what duration lengths are allowed at certain pitches.

If the pitch (or chord) at an event is

=:           equal to a value
member:      member of a list of values
lower-than:  lower than a value
higher-than: higher than a value
exist:       contain a value (i.e. a chord has to contain a value)


then the duration at the same event has to be
   =:            identical to a value
   member:       member of a list of values
   longer-than:  longer than a value
   shorter-than: shorter than a value
"
    (:groupings '(3 2)  :x-proportions '((0.2 (:fix 0.35) 0.8) ((:fix 0.35) 1.0)))
  (let ((testfunctiondur #'(lambda (x xx) nil))
        (testfunctionchord #'(lambda (x xx) t)))
    (if (equal match-dur? :=) (if (listp durations)  (error "PWMC: Error in dur->pitch-rule: A rhythm value can not be matched to a list.")
                                (setf testfunctiondur 'testfunction-r=))
      (if (equal match-dur? :/=) (if (listp durations)  (error "PWMC: Error in dur->pitch-rule: A rhythm value can not be matched to a list.")
                                   (setf testfunctiondur 'testfunction-r-not=))
        (if (equal match-dur? :member) (if (listp durations) (setf testfunctiondur 'testfunction-rmember)
                                         (error "PWMC: Error in dur->pitch-rule: the member option needs a list of possible rhythm values to chose from."))
          (if (equal match-dur? :long-duration) (if (listp durations) (error "PWMC: Error in dur->pitch-rule:  A list can not be a treshold. ")
                                                  (setf testfunctiondur 'testfunction-longdurations))
            (if (equal match-dur? :short-duration) (if (listp durations) (error "PWMC: Error in dur->pitch-rule: A list can not be a treshold. ")
                                                     (setf testfunctiondur 'testfunction-shortdurations))
              nil)))))
    (if (equal match-chord? :=) (if (listp chord) (error "PWMC: Error in dur->pitch-rule: A pitch value can not be matched to a list. ")
                                  (setf testfunctionchord 'testfunction-equal))
      (if (equal match-chord? :/=) (if (listp chord) (error "PWMC: Error in dur->pitch-rule: A pitch value can not be matched to a list. ")
                                     (setf testfunctionchord 'testfunction-not-equal))
        (if (equal match-chord? :member) (if (listp chord) (setf testfunctionchord 'testfunction-member)
                                           (error "PWMC: Error in dur->pitch-rule: The member option needs a list of possible pitches/chords to chose from. ")) 
          (if (equal match-chord? :lower-than) (if (listp chord) (error "PWMC: Error in dur->pitch-rule: A list can not be given as a treshold for a register.")
                                                 (setf testfunctionchord 'testfunction-lowregister))    
            (if (equal match-chord? :higher-than) (if (listp chord) (error "PWMC: Error in dur->pitch-rule: A list can not be given as a treshold for a register.")
                                                    (setf testfunctionchord 'testfunction-highregister))
              nil)))))
    (dur-at-pitch-rule layernr durations chord testfunctiondur testfunctionchord)
    ))

 

;;;*****
(system::PWGLDef pitch->dur-rule ((layernr 0)(match-dur?  10 (ccl::mk-menu-subview :menu-list '(":=" ":member" ":longer-than" ":shorter-than")))(duration 1/4)(match-chord?  10 (ccl::mk-menu-subview :menu-list '(":=" ":member" ":lower-than" ":higher-than" ":exist")))(chords 60))
        "Restricts what pitches are allowed at certain duration lengths.

If the duration at an event is
   =:            identical to a value
   member:       member of a list of values
   longer-than:  longer than a value
   shorter-than: shorter than a value



then the pitch (or chord) at the same event has to be
=:           equal to a value
member:      member of a list of values
lower-than:  lower than a value
higher-than: higher than a value
exist:       contain a value (i.e. a chord has to contain a value)
"
        (:groupings '(3 2)  :x-proportions '((0.2 (:fix 0.35) 0.8) ((:fix 0.35) 1.0)))
  (let ((testfunctionpitch #'(lambda (x xx) nil))
        (testfunctionduration #'(lambda (x xx) t)))

    (if (equal match-chord? :=) (if (and (listp chords)(listp (first chords)))
                              (progn (ccl::PWGL-print "WARNING: List of chords do not match the condition in the rule. Error in pitch->dur-rule.")
                                (setf testfunctionpitch #'(lambda (x xx) nil)))
                            (setf testfunctionpitch 'testfunction-equal)) 
      (if (equal match-chord? :member) (if (listp chords) (setf testfunctionpitch 'testfunction-member)
                                   (progn (ccl::PWGL-print "WARNING: the member option needs a list of possible pitches/chords to chose from. Error in pitch->dur-rule.")
                                     (setf testfunctionpitch #'(lambda (x xx) nil)))) ;This dummy rule will kill all candidates! No answer will be true.

        (if (equal match-chord? :lower-than) (if (listp chords) (progn (ccl::PWGL-print "WARNING: A list can not be given as a treshold for a register. Error in pitch->dur-rule.")
                                                           (setf testfunctionpitch #'(lambda (x xx) nil))) ;This dummy rule will kill all candidates! No answer will be true.
                                         (setf testfunctionpitch 'testfunction-lowregister))
          (if (equal match-chord? :higher-than) (if (listp chords) (progn (ccl::PWGL-print "WARNING: A list can not be given as a treshold for a register. Error in pitch->dur-rule.")
                                                               (setf testfunctionpitch #'(lambda (x xx) nil))) ;This dummy rule will kill all candidates! No answer will be true.
                                            (setf testfunctionpitch 'testfunction-highregister))
            (if (equal match-chord? :exist) (if (listp chords) (progn (ccl::PWGL-print "WARNING: A list can not exist in a chord. Error in pitch->dur-rule.")
                                                           (setf testfunctionpitch #'(lambda (x xx) nil))) ;This dummy rule will kill all candidates! No answer will be true.
                                        (setf testfunctionpitch 'testfunction-exist))
            nil
            )))))
    (if (equal match-dur? :=) (if (listp duration) (progn (ccl::PWGL-print "WARNING: A rhythm value can not be matched to a list.. Error in pitch->dur-rule.")
                                                     (setf testfunctionpitch #'(lambda (x xx) nil)))  ;This dummy rule will kill all candidates (has to be on pitch)! No answer will be true
                                (setf testfunctionduration 'testfunction-r=))
      (if (equal match-dur? :member) (if (listp duration) (setf testfunctionduration 'testfunction-rmember)
                                       (progn (ccl::PWGL-print "WARNING: the member option needs a list of possible rhythm values to chose from. Error in pitch->dur-rule.")
                                                     (setf testfunctionpitch #'(lambda (x xx) nil)))  ;This dummy rule will kill all candidates (has to be on pitch)! No answer will be true
                                )
        (if (equal match-dur? :longer-than) (if (listp duration) (progn (ccl::PWGL-print "WARNING: A list can not be a treshold. Error in pitch->dur-rule.")
                                                                   (setf testfunctionpitch #'(lambda (x xx) nil)))
                                                (setf testfunctionduration 'testfunction-longdurations))
          (if (equal match-dur? :shorter-than) (if (listp duration) (progn (ccl::PWGL-print "WARNING: A list can not be a treshold. Error in pitch->dur-rule.")
                                                                     (setf testfunctionpitch #'(lambda (x xx) nil)))
                                                (setf testfunctionduration 'testfunction-shortdurations))
      nil))))
    
    (pitch-at-dur-rule layernr chords duration testfunctionpitch testfunctionduration)
    ))
