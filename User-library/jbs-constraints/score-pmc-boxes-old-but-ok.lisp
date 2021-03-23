;;;==============================================================================================
;;;                                JBS - CONSTRAINTS    2007    
;;;==============================================================================================
;
;===================================     Package    =============================================
;
(in-package :jbs-constraints)
;
;===================================    SCORE PMC   =============================================
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;                 FOR      FRIENDS        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
(define-box s-pmc-forbid-harm-int-rule ((intervals (0))
                                        (mode? ":true/false")
                                        (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "The given intervals set in INTERVALS have be inside the solution."
  (case mode?    
    (:true/false `(:true/false * ?1 :harmony
                   (?if (let* ((harmony (m ?1 :complete? t))
                               (ints (pw::g-abs (pw::flat (jbs-constraints::find-all-intervals harmony))))
                               )
                          (if ints (every #'(lambda (x) (not (member x ',intervals))) ints)
                            t)))))
    (:heuristic `(:heuristic * ?1 :harmony 
                  (?if (if (let ((ints (m ?1 :data-access :harm-int)))
                             (if ints (every #'(lambda (x) (not (member x ints))) ',intervals)
                               t)) ,weight 0))))))



;
;=================================      MELODIC RULES      ======================================
;
;================================================================================================
;=================================  In melodic rules menu  ======================================
;================================================================================================
;
(define-menu melodic-rules :in score-pmc-rules)
(in-menu melodic-rules)
;=============================  In generic-poly-rules rules menu  ==============================
(define-menu generic-poly-rules :in melodic-rules)
(in-menu generic-poly-rules)
;
;;;==============================================================================================
;                                     INDEX RULE
;;;==============================================================================================
;
(define-box s-pmc-index-rule ((index 1)
                              (value 72)
                              (parts ":all")
                              (mode? ":true/false")
                              (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "Its an index rule for a give part...."
  (when (eql parts :all) (setq parts nil))
  (case mode?
    (:true/false `(:true/false * ,(jbs-constraints::make-i1 index) ,@(when parts `(:parts ,parts))
                   (?if (= (m ,(jbs-constraints::make-i1 index)) ,value))))
    (:heuristic `(:heuristic * ,(jbs-constraints::make-i1 index) ,@(when parts `(:parts ,parts))
                   (?if (if (= (m ,(jbs-constraints::make-i1 index)) ,value) ,weight 0))))))
;
;;;==============================================================================================
;                                     INDEX HIGHER RULE
;;;==============================================================================================
;
(define-box s-pmc-index-higher-rule ((index 1)
                                     (value 72)
                                     (parts ":all")
                                     (mode? ":true/false")
                                     (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "Its an index rule obliging an index to be higher than 72 (in this example) for a given part."
  (when (eql parts :all) (setq parts nil))
  (case mode?
    (:true/false `(:true/false * ,(jbs-constraints::make-i1 index) ,@(when parts `(:parts ,parts))
                   (?if (> (m ,(jbs-constraints::make-i1 index)) ,value))))
    (:heuristic `(:heuristic * ,(jbs-constraints::make-i1 index) ,@(when parts `(:parts ,parts))
                  (?if (if (> (m ,(jbs-constraints::make-i1 index)) ,value) ,weight 0))))))
;
;;;==============================================================================================
;                                     INDEX LOWER RULE
;;;==============================================================================================
;
(define-box s-pmc-index-lower-rule ((index 1)
                                    (value 72)
                                    (parts ":all")
                                    (mode? ":true/false")
                                    (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "Its an index rule obliging an index to be lower than 72 in this example for a given part."
  (when (eql parts :all) (setq parts nil))
  (case mode?
    (:true/false `(:true/false * ,(jbs-constraints::make-i1 index) ,@(when parts `(:parts ,parts))
                   (?if (< (m ,(jbs-constraints::make-i1 index)) ,value))))
    (:heuristic `(:heuristic * ,(jbs-constraints::make-i1 index) ,@(when parts `(:parts ,parts))
                  (?if (if (< (m ,(jbs-constraints::make-i1 index)) ,value) ,weight 0))))))
;
;;;==============================================================================================
;                                     NOT HIGHER RULE
;;;==============================================================================================
;
(define-box s-pmc-not-higher-rule ((limit 3)
                                   (parts ":all")
                                   (mode? ":true/false")
                                   (weight 1)
                                   &optional (expression ":slur"))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "The S-PMC-NOT-HIGHER-RULE is a rule obliging any value to be higher than a given number"
  (when (eql parts :all) (setq parts nil))
  (if (symbolp expression)
      (case mode?
        (:true/false `(:true/false * ?1
                       ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                       (?if (not (> (m ?1) ,limit)))))
        (:heuristic `(:heuristic * ?1
                      ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                      (?if (if (not (> (m ?1) ,limit)) ,weight 0)))))
    (case mode?
        (:true/false `(:true/false * ?1
                       ,@(when parts `(:parts ,parts)) 
                       (?if (not (> (m ?1) ,limit)))))
        (:heuristic `(:heuristic * ?1
                      ,@(when parts `(:parts ,parts)) 
                      (?if (if (not (> (m ?1) ,limit)) ,weight 0)))))))
;
;;;==============================================================================================
;                                     NOT HIGHER RULE
;;;==============================================================================================
;
(define-box s-pmc-not-lower-rule ((limit 3)
                                   (parts ":all")
                                   (mode? ":true/false")
                                   (weight 1)
                                   &optional (expression ":slur"))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "S-PMC-NOT-LOWER-RULE is a rule obliging any value to be lower than a given number"
  (when (eql parts :all) (setq parts nil))
  (if (symbolp expression)
      (case mode?
        (:true/false `(:true/false * ?1
                       ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                       (?if (not (< (m ?1) ,limit)))))
        (:heuristic `(:heuristic * ?1
                      ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                      (?if (if (not (< (m ?1) ,limit)) ,weight 0)))))
    (case mode?
        (:true/false `(:true/false * ?1
                       ,@(when parts `(:parts ,parts)) 
                       (?if (not (< (m ?1) ,limit)))))
        (:heuristic `(:heuristic * ?1
                      ,@(when parts `(:parts ,parts)) 
                      (?if (if (not (< (m ?1) ,limit)) ,weight 0)))))))
;
;;;==============================================================================================
;                                     NO LOCAL REPETITION RULE
;;;==============================================================================================
;
(define-box s-pmc-no-lcl-repetition-rule ((parts ":all")
                                          (mode? ":true/false")
                                          (weight 1)
                                          &optional (expression ":slur"))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "no local repetition in the given voice...."
  (when (eql parts :all) (setq parts nil))
  (if (symbolp expression)
      (case mode?
        (:true/false `(:true/false * ?1 ?2
                       ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                       (?if (not (= (m ?2) (m ?1))))))
        (:heuristic `(:heuristic * ?1 ?2
                      ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                      (?if (if (not (= (m ?2) (m ?1))) ,weight 0)))))
    (case mode?
      (:true/false `(:true/false * ?1 ?2
                     ,@(when parts `(:parts ,parts)) 
                     (?if (not (= (m ?2) (m ?1))))))
      (:heuristic `(:heuristic * ?1 ?2
                    ,@(when parts `(:parts ,parts)) 
                    (?if (if (not (= (m ?2) (m ?1))) ,weight 0)))))))
;
;;;==============================================================================================
;                                     NOT CONSECUTIVE ASCENDING RULE
;;;==============================================================================================
;
(define-box s-pmc-n-ascending-rule ((how-many 5)
                                    (parts ":all")
                                    (mode? ":true/false")
                                    (weight 1)
                                    &optional (expression ":slur"))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "no more than Xnote ascending...."
  (setq calcolo (pw::mat-trans (list (jbs-constraints::pr (list 'm) (pw::arithm-ser 1 1 how-many))
                                     (jbs-constraints::make-?1 (pw::arithm-ser 1 1 how-many)))))
  (when (eql parts :all) (setq parts nil))
  (if (symbolp expression)
      (case mode?
        (:true/false `(:true/false * ,@(jbs-constraints::make-?1 (pw::arithm-ser 1 1 how-many))
                       ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                       (?if (not (< ,@calcolo)))))
        (:heuristic `(:heuristic * ,@(jbs-constraints::make-?1 (pw::arithm-ser 1 1 how-many))
                      ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                      (?if (if (not (< ,@calcolo)) ,weight 0)))))  
    (case mode?
      (:true/false `(:true/false * ,@(jbs-constraints::make-?1 (pw::arithm-ser 1 1 how-many))
                     ,@(when parts `(:parts ,parts)) 
                     (?if (not (< ,@calcolo)))))
      (:heuristic `(:heuristic * ,@(jbs-constraints::make-?1 (pw::arithm-ser 1 1 how-many))
                    ,@(when parts `(:parts ,parts)) 
                    (?if (if (not (< ,@calcolo)) ,weight 0)))))))
;
;;;==============================================================================================
;                                     NOT CONSECUTIVE DESCENDING RULE
;;;==============================================================================================
;
(define-box s-pmc-n-descending-rule ((how-many 5)
                                     (parts ":all")
                                     (mode? ":true/false")
                                     (weight 1)
                                     &optional (expression ":slur"))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "no more than Xnote descending"
  (setq calcolo (pw::mat-trans (list (jbs-constraints::pr (list 'm) (pw::arithm-ser 1 1 how-many))
                                     (jbs-constraints::make-?1 (pw::arithm-ser 1 1 how-many)))))
  (when (eql parts :all) (setq parts nil))
  (if (symbolp expression)
      (case mode?      
        (:true/false `(:true/false * ,@(jbs-constraints::make-?1 (pw::arithm-ser 1 1 how-many))
                       ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                       (?if (not (> ,@calcolo)))))
        (:heuristic `(:heuristic * ,@(jbs-constraints::make-?1 (pw::arithm-ser 1 1 how-many))
                      ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                      (?if (if (not (> ,@calcolo)) ,weight 0)))))  
    (case mode?      
      (:true/false `(:true/false * ,@(jbs-constraints::make-?1 (pw::arithm-ser 1 1 how-many))
                     ,@(when parts `(:parts ,parts)) 
                     (?if (not (> ,@calcolo)))))
      (:heuristic `(:heuristic * ,@(jbs-constraints::make-?1 (pw::arithm-ser 1 1 how-many))
                    ,@(when parts `(:parts ,parts)) 
                    (?if (if (not (> ,@calcolo)) ,weight 0)))))))
;
;
;=============================  In interval-poly-rules rules menu  ==============================
(define-menu interval-poly-rules :in melodic-rules)
(in-menu interval-poly-rules)
;
;
;
;;;==============================================================================================
;                                    ALLOWED INTERVAL RULE
;;;==============================================================================================
;
(define-box s-pmc-allowed-interval-rule ((intervals (1 5 7))
                                         (absolute? :absolute)
                                         (parts ":all")
                                         (mode? ":true/false")
                                         (weight 1)
                                         &optional (expression ":slur"))
  :menu (absolute? (:absolute "absolute") (:up/down "up/down"))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "This rule outputs a solution having only the interval entered in allowed-intervals. With the menu intervall-mod
you can chose if the intervals are in absolute value or not. In the menu mode? you can chose if the rule is true /faulse
or heuristic.
ATTENTION: in parts if :all it means that the rule is vfor all the parts. If you want  specific part to be constrained
you have to put: :parts1, or :parts2..."
  (when (eql parts :all) (setq parts nil))
  (let ((absolute? (case absolute?
                          (:absolute `(abs (- (m ?2) (m ?1))))
                          (:up/down `(- (m ?2) (m ?1))))))
    (if (symbolp expression) 
        (case mode?
          (:true/false `(:true/false * ?1 ?2 ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                         (?if (member ,absolute? ',intervals))))
          (:heuristic `(:heuristic * ?1 ?2 ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                        (?if (if (member ,absolute? ',intervals) ,weight 0)))))
      
      (case mode?
        (:true/false `(:true/false * ?1 ?2 ,@(when parts `(:parts ,parts))
                       (?if (member ,absolute? ',intervals))))
        (:heuristic `(:heuristic * ?1 ?2 ,@(when parts `(:parts ,parts))
                      (?if (if (member ,absolute? ',intervals) ,weight 0)))))
      )))
;
;;;==============================================================================================
;                                    NOT ALLOWED INTERVAL RULE
;;;==============================================================================================
;
(define-box s-pmc-not-allowed-interval-rule ((intervals (1 5 7))
                                             (absolute? :absolute)
                                             (parts ":all")
                                             (mode? ":true/false")
                                             (weight 1)
                                             &optional (expression ":slur"))
  :menu (absolute? (:absolute "absolute") (:up/down "up/down"))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "This rule outputs a solution having only the interval entered in allowed-intervals. With the menu intervall-mod
you can chose if the intervals are in absolute value or not. In the menu mode? you can chose if the rule is true /faulse
or heuristic.
ATTENTION: in parts if :all it means that the rule is vfor all the parts. If you want  specific part to be constrained
you have to put: :parts1, or :parts2..."
  (when (eql parts :all) (setq parts nil))
  (let ((absolute? (case absolute?
                     (:absolute `(abs (- (m ?2) (m ?1))))
                     (:up/down `(- (m ?2) (m ?1))))))
    (if (symbolp expression)
        (case mode?
          (:true/false `(:true/false * ?1 ?2 ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                         (?if (not (member ,absolute? ',intervals)))))
          (:heuristic `(:heuristic * ?1 ?2 ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                        (?if (if (not (member ,absolute? ',intervals)) ,weight 0)))))
        
      (case mode?
        (:true/false `(:true/false * ?1 ?2 ,@(when parts `(:parts ,parts))
                       (?if (not (member ,absolute? ',intervals)))))
        (:heuristic `(:heuristic * ?1 ?2 ,@(when parts `(:parts ,parts))
                      (?if (if (not (member ,absolute? ',intervals)) ,weight 0))))))))
;
;;;==============================================================================================
;                                     INTERVAL BIGGER THAN RULE
;;;==============================================================================================
;
(define-box s-pmc-interval-bigger-rule ((interval 9)
                                        (parts ":all")
                                        (mode? ":true/false")
                                        (weight 1)
                                        &optional (expression ":slur"))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "intervals have to be bigger than...."
  (when (eql parts :all) (setq parts nil))
  (if (symbolp expression)
      (case mode?
        (:true/false `(:true/false * ?1 ?2 
                       ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                       (?if (>= (abs (- (m ?2) (m ?1))) ,interval))))
        (:heuristic `(:heuristic *  ?1 ?2
                      ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                      (?if (if (>= (abs (- (m ?2) (m ?1))) ,interval) ,weight 0)))))
    (case mode?
      (:true/false `(:true/false * ?1 ?2 
                     ,@(when parts `(:parts ,parts)) 
                     (?if (>= (abs (- (m ?2) (m ?1))) ,interval))))
      (:heuristic `(:heuristic *  ?1 ?2
                    ,@(when parts `(:parts ,parts)) 
                    (?if (if (>= (abs (- (m ?2) (m ?1))) ,interval) ,weight 0)))))))
;
;;;==============================================================================================
;                                     INTERVAL SMALLER THAN RULE
;;;==============================================================================================
;
(define-box s-pmc-interval-smaller-rule ((interval 9)
                                         (parts ":all")
                                         (mode? ":true/false")
                                         (weight 1)
                                         &optional (expression ":slur"))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "intervals have to bi bigger than...."
  (when (eql parts :all) (setq parts nil))
  (if (symbolp expression)
      (case mode?
        (:true/false `(:true/false * ?1 ?2 
                       ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                       (?if (<= (abs (- (m ?2) (m ?1))) ,interval))))
        (:heuristic `(:heuristic *  ?1 ?2
                      ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                      (?if (if (<= (abs (- (m ?2) (m ?1))) ,interval) ,weight 0)))))
    (case mode?
      (:true/false `(:true/false * ?1 ?2 
                     ,@(when parts `(:parts ,parts)) 
                     (?if (<= (abs (- (m ?2) (m ?1))) ,interval))))
      (:heuristic `(:heuristic *  ?1 ?2
                    ,@(when parts `(:parts ,parts)) 
                    (?if (if (<= (abs (- (m ?2) (m ?1))) ,interval) ,weight 0)))))))
;
;;;==============================================================================================
;                                    NO REACHED INTERVAL RULE
;;;==============================================================================================
;
(define-box s-pmc-no-reached-intrv-rule ((how-many 3)
                                         (interval 11)
                                         (parts ":all")
                                         (mode? ":true/false")
                                         (weight 1)
                                          &optional (expression ":slur"))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "do not reach a given interval in three given notes..."
  (setq calcola (list (list 'm (jbs-constraints::make-?1 how-many))
                      (list 'm (jbs-constraints::make-?1 1))))
  (when (eql parts :all) (setq parts nil))
  (if (symbolp expression)
      (case mode?    
        (:true/false `(:true/false * ,@(jbs-constraints::make-?1 (pw::arithm-ser 1 1 how-many))
                       ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                       (?if (not (> (abs (- ,@calcola)) ,interval)))))
        (:heuristic `(:heuristic * ,@(jbs-constraints::make-?1 (pw::arithm-ser 1 1 how-many))
                      ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                      (?if (if (not (> (abs (- ,@calcola)) ,interval)) ,weight 0)))))
    (case mode?    
      (:true/false `(:true/false * ,@(jbs-constraints::make-?1 (pw::arithm-ser 1 1 how-many))
                     ,@(when parts `(:parts ,parts)) 
                     (?if (not (> (abs (- ,@calcola)) ,interval)))))
      (:heuristic `(:heuristic * ,@(jbs-constraints::make-?1 (pw::arithm-ser 1 1 how-many))
                    ,@(when parts `(:parts ,parts)) 
                    (?if (if (not (> (abs (- ,@calcola)) ,interval)) ,weight 0)))))))
;
;=============================  In pitch-poly-rules rules menu  ==============================
;
(define-menu pitch-poly-rules :in melodic-rules)
(in-menu pitch-poly-rules)
;
;;;==============================================================================================
;                                     ALLOWED PITCH RULE
;;;==============================================================================================
;
(define-box s-pmc-allowed-pitch-rule ((pitch (60 62 64))
                                      (parts ":all")
                                      (mode? ":true/false")
                                      (weight 1)
                                      &optional (expression ":slur"))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "This rule outputs a solution having only the pitch (in modulo 12) entered in pitch. In the menu mode? you can chose if the rule is true /faulse
or heuristic.
ATTENTION: in parts if :all it means that the rule is vfor all the parts. If you want  specific part to be constrained
you have to put: :parts1, or :parts2..."
  (when (eql parts :all) (setq parts nil))
  (let ((pitch (pw::g-mod pitch 12)))
    (if (symbolp expression)
        (case mode?
          (:true/false `(:true/false * ?1 ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                         (?if (member (mod (m ?1) 12) ',pitch))))
          (:heuristic `(:heuristic * ?1 ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                        (?if (if (member (mod (m ?1) 12) ',pitch) ,weight 0)))))
      (case mode?
        (:true/false `(:true/false * ?1 ,@(when parts `(:parts ,parts))
                       (?if (member (mod (m ?1) 12) ',pitch))))
        (:heuristic `(:heuristic * ?1 ,@(when parts `(:parts ,parts))
                      (?if (if (member (mod (m ?1) 12) ',pitch) ,weight 0))))))))

;
;;;==============================================================================================
;                                     ALLOWED EXACT PITCH RULE
;;;==============================================================================================
;


(define-box s-pmc-allowed-exact-pitch-rule ((pitch (60 62 64))
                                            (parts ":all")
                                            (mode? ":true/false")
                                            (weight 1)
                                            &optional (expression ":slur"))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "This rule outputs a solution having only the pitch (in modulo 12) entered in pitch. In the menu mode? you can chose if the rule is true /faulse
or heuristic.
ATTENTION: in parts if :all it means that the rule is vfor all the parts. If you want  specific part to be constrained
you have to put: :parts1, or :parts2..."
  (when (eql parts :all) (setq parts nil))
  (let ()
    (if (symbolp expression)
        (case mode?
          (:true/false `(:true/false * ?1 ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                         (?if (member (m ?1) ',pitch))))
          (:heuristic `(:heuristic * ?1 ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                        (?if (if (member (mod (m ?1) 12) ',pitch) ,weight 0)))))
      (case mode?
        (:true/false `(:true/false * ?1 ,@(when parts `(:parts ,parts))
                       (?if (member (mod (m ?1) 12) ',pitch))))
        (:heuristic `(:heuristic * ?1 ,@(when parts `(:parts ,parts))
                      (?if (if (member (mod (m ?1) 12) ',pitch) ,weight 0))))))))
;
;;;==============================================================================================
;                                     NOT ALLOWED PITCH RULE
;;;==============================================================================================
;
(define-box s-pmc-not-allowed-pitch-rule ((pitch (61 63 66 68 70))
                                          (parts ":all")
                                          (mode? ":true/false")
                                          (weight 1)
                                          &optional (expression ":slur"))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "This rule outputs a solution having only the pitch (in modulo 12) entered in pitch. In the menu mode? you can chose if the rule is true /faulse
or heuristic.
ATTENTION: in parts if :all it means that the rule is vfor all the parts. If you want  specific part to be constrained
you have to put: :parts1, or :parts2..."
  (when (eql parts :all) (setq parts nil))
  (let ((pitch (pw::g-mod pitch 12)))
    (if (symbolp expression)
        (case mode?
          (:true/false `(:true/false * ?1 ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                         (?if (not (member (mod (m ?1) 12) ',pitch)))))
          (:heuristic `(:heuristic * ?1 ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                        (?if (if (not (member (mod (m ?1) 12) ',pitch)) ,weight 0)))))
      (case mode?
        (:true/false `(:true/false * ?1 ,@(when parts `(:parts ,parts))
                       (?if (not (member (mod (m ?1) 12) ',pitch)))))
        (:heuristic `(:heuristic * ?1 ,@(when parts `(:parts ,parts))
                      (?if (if (not (member (mod (m ?1) 12) ',pitch)) ,weight 0))))))))
;
;;;==============================================================================================
;                                     ALLOWED-PITCH-CLASS-SUB-LIST-RUL
;;;==============================================================================================
;
(define-box s-pmc-allowed-pitch-class-sub-group-rule ((pitch (61 63 66))
                                                      (parts ":all")
                                                      (mode? ":true/false")
                                                      (weight 1)
                                                      &optional (expression ":slur"))

  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "This function outputs a solution where the class (for instance minor triad) indicated in 
'pitch' WILL be allowed in any octave including also other notes. That means that is I'm looking
for NOT HAVING a minor triad in a 5 notes chord.
ATTENTION IN HEURISTIC MODE NOT YET IMPLEMENTED CORRECTELY"
  (when (eql parts :all) (setq parts nil))
  (let* ((pattern (jbs-constraints::make-?1 (pw::arithm-ser 1 1 (length pitch))))
         (pattern-con-m (jbs-constraints::genero-m-for-?1 pattern)))
    (if (symbolp expression)
        (case mode?
          (:true/false `(:true/false * ,@pattern
                         ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                         (?if  (equalp
                                (ccl::sc-name ',pitch)
                                (ccl::sc-name (list ,@pattern-con-m))))))
          (:heuristic `(:heuristic * ,@pattern 
                        ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                        (?if (if  (equalp
                                   (ccl::sc-name ',pitch)
                                   (ccl::sc-name (list ,@pattern-con-m)))  ,weight 0)))))
          
      (case mode?    
        (:true/false `(:true/false * ,@pattern ,@(when parts `(:parts ,parts))
                       (?if (equalp
                             (ccl::sc-name ',pitch)
                             (ccl::sc-name (list ,@pattern-con-m))))))                       
        (:heuristic `(?if (if (equalp
                               (ccl::sc-name ',pitch)
                               (ccl::sc-name (list ,@pattern-con-m))) ,weight 0)))))))
;
;;;==============================================================================================
;                                     NOT-ALLOWED-PITCH-CLASS-SUB-LIST-RUL
;;;==============================================================================================
;
(define-box s-pmc-not-allowed-pitch-class-sub-group-rule ((pitch (61 63 66))
                                                          (parts ":all")
                                                          (mode? ":true/false")
                                                          (weight 1)
                                                          &optional (expression ":slur"))

  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "This function outputs a solution where the class (for instance minor triad) indicated in 
'pitch' will NOT be allowed in any octave including also other notes. That means that is I'm looking
for NOT HAVING a minor triad in a 5 notes chord.
ATTENTION IN HEURISTIC MODE NOT YET IMPLEMENTED CORRECTELY"
  (when (eql parts :all) (setq parts nil))
  (let* ((pattern (jbs-constraints::make-?1 (pw::arithm-ser 1 1 (length pitch))))
         (pattern-con-m (jbs-constraints::genero-m-for-?1 pattern)))
    (if (symbolp expression)
        (case mode?
          (:true/false `(:true/false * ,@pattern
                         ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                         (?if (not (equalp
                                    (ccl::sc-name ',pitch)
                                    (ccl::sc-name (list ,@pattern-con-m)))))))
          (:heuristic `(:heuristic * ,@pattern 
                        ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                        (?if (if (not (equalp
                                       (ccl::sc-name ',pitch)
                                       (ccl::sc-name (list ,@pattern-con-m))))  ,weight 0)))))
          
      (case mode?    
        (:true/false `(:true/false * ,@pattern ,@(when parts `(:parts ,parts))
                       (?if (not (equalp
                                  (ccl::sc-name ',pitch)
                                  (ccl::sc-name (list ,@pattern-con-m)))))))                             
        (:heuristic `(?if (if (not (equalp
                                    (ccl::sc-name ',pitch)
                                    (ccl::sc-name (list ,@pattern-con-m)))) ,weight 0)))))))
      
      
;
;
;
;=============================  In resolutions-poly-rules rules menu  ==============================
(define-menu resolutions-poly-rules :in melodic-rules)
(in-menu resolutions-poly-rules)
;
;;;==============================================================================================
;                                     TONE RESOLUTION RULE
;;;==============================================================================================
;
(define-box s-pmc-tone-resolution-rule ((sensibile 11)
                                        (resolution (0))
                                        (parts ":all")
                                        (mode? ":true/false")
                                        (weight 1)
                                        &optional (expression ":slur"))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "the sensibile (in mod 12) has to solve on resolution (in mod12)..."
  (when (eql parts :all) (setq parts nil))
  (if (symbolp expression)
      (case mode?    
        (:true/false `(:true/false * ?1 ?2
                       ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                       (?if (if (= (mod (m ?1) 12) ,sensibile)
                                (member (mod (m ?2) 12) (pw::g-mod ',resolution 12)) t))))
        (:heuristic `(:heuristic * ?1 ?2
                      ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                      (?if (if (if (= (mod (m ?1) 12) ,sensibile)
                                   (member (mod (m ?2) 12) (pw::g-mod ',resolution 12)) t) ,weight 0)))))
    (case mode?    
      (:true/false `(:true/false * ?1 ?2
                     ,@(when parts `(:parts ,parts)) 
                     (?if (if (= (mod (m ?1) 12) ,sensibile)
                              (member (mod (m ?2) 12) (pw::g-mod ',resolution 12)) t))))
      (:heuristic `(:heuristic * ?1 ?2
                    ,@(when parts `(:parts ,parts)) 
                    (?if (if (if (= (mod (m ?1) 12) ,sensibile)
                                 (member (mod (m ?2) 12) (pw::g-mod ',resolution 12)) t) ,weight 0)))))))
;
;;;==============================================================================================
;                                     NOT TONE RESOLUTION RULE
;;;==============================================================================================
;
(define-box s-pmc-not-tone-resolution-rule ((sensibile 11)
                                            (resolution (0))
                                            (parts ":all")
                                            (mode? ":true/false")
                                            (weight 1)
                                            &optional (expression ":slur"))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "the sensibile (in mod 12) has NOT to solve on resolution (in mod12)..."
  (when (eql parts :all) (setq parts nil))
  (if (symbolp expression)
      (case mode?    
        (:true/false `(:true/false * ?1 ?2
                       ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                       (?if (if (= (mod (m ?1) 12) ,sensibile)
                                (not (member (mod (m ?2) 12) (pw::g-mod ',resolution 12))) t))))
        (:heuristic `(:heuristic * ?1 ?2
                      ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                      (?if (if (if (= (mod (m ?1) 12) ,sensibile)
                                   (not (member (mod (m ?2) 12) (pw::g-mod ',resolution 12))) t) ,weight 0)))))
    (case mode?    
      (:true/false `(:true/false * ?1 ?2
                     ,@(when parts `(:parts ,parts)) 
                     (?if (if (= (mod (m ?1) 12) ,sensibile)
                              (not (member (mod (m ?2) 12) (pw::g-mod ',resolution 12))) t))))
      (:heuristic `(:heuristic * ?1 ?2
                    ,@(when parts `(:parts ,parts)) 
                    (?if (if (if (= (mod (m ?1) 12) ,sensibile)
                                 (not (member (mod (m ?2) 12) (pw::g-mod ',resolution 12))) t) ,weight 0)))))))
;
;;;==============================================================================================
;                                    JUMP RESOLUTION RULE
;;;==============================================================================================
;
(define-box s-pmc-jump-resolution-rule ((jump-size 6)
                                        (resolution 2)
                                        (parts ":all")
                                        (mode? ":true/false")
                                        (weight 1)
                                        &optional (expression ":slur"))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "The PMC-JUMP-RESOLUTION-RULE defines that if there is a jump bigger than the one set in jump-size, the next interval has to be smaller than the one set in resolution and in the opposite direction than previous."
  (when (eql parts :all) (setq parts nil))
  (if (symbolp expression)
      (case mode?    
        (:true/false `(:true/false * ,@(jbs-constraints::make-?1 (pw::arithm-ser 1 1 3))
                       ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                       (?if (let ((int1 (- (m ?2) (m ?1)))
                                  (int2 (- (m ?3) (m ?2))))
                              (if (< (abs int1) ,jump-size)
                                  t
                                (and (< (abs int2) ,resolution)
                                     (not (= (signum int1) (signum int2)))))))))
        (:heuristic `(:heuristic * ,@(jbs-constraints::make-?1 (pw::arithm-ser 1 1 3))
                      ,@(when parts `(:parts ,parts)) (e ?1 ,expression)
                      (?if (if (let ((int1 (- (m ?2) (m ?1)))
                                     (int2 (- (m ?3) (m ?2))))
                                 (if (< (abs int1) ,jump-size)
                                     t
                                   (and (< (abs int2) ,resolution)
                                        (not (= (signum int1) (signum int2)))))) ,weight 0)))))
    (case mode?    
      (:true/false `(:true/false * ,@(jbs-constraints::make-?1 (pw::arithm-ser 1 1 3))
                     ,@(when parts `(:parts ,parts)) 
                     (?if (let ((int1 (- (m ?2) (m ?1)))
                                (int2 (- (m ?3) (m ?2))))
                            (if (< (abs int1) ,jump-size)
                                t
                              (and (< (abs int2) ,resolution)
                                   (not (= (signum int1) (signum int2)))))))))
      (:heuristic `(:heuristic * ,@(jbs-constraints::make-?1 (pw::arithm-ser 1 1 3))
                    ,@(when parts `(:parts ,parts)) 
                    (?if (if (let ((int1 (- (m ?2) (m ?1)))
                                   (int2 (- (m ?3) (m ?2))))
                               (if (< (abs int1) ,jump-size)
                                   t
                                 (and (< (abs int2) ,resolution)
                                      (not (= (signum int1) (signum int2)))))) ,weight 0)))))))

;
;=============================  In shaping-poly-rules rules menu  ==============================
(define-menu shaping-poly-rules :in melodic-rules)
(in-menu shaping-poly-rules)
;
;;;==============================================================================================
;                                    GIVEN VOICE RULE
;;;==============================================================================================
;
(define-box s-pmc-given-voice-rule ((given-voice (48 53 55 48 57 53 52 55 48))
                                    (parts ":all")
                                    (mode? ":true/false")
                                    (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "given voice"
  (when (eql parts :all) (setq parts nil))
  (let ((pitches (if (atom (first given-voice))
                     (mapcar #'(lambda (x) (list x)) given-voice) given-voice)))
    (case mode?    
      (:true/false `(:true/false * ?1 :chord ,@(when parts `(:parts ,parts))
                     (?if (let ((fixed-midi (nth (1- (ccl::chordnum ?1)) ',pitches)))
                            (if fixed-midi (every #'= (ccl::sort< (M ?1)) fixed-midi) T)))))
      (:heuristic `(:heuristic * ?1 :chord ,@(when parts `(:parts ,parts))  
                    (?if (if (let ((fixed-midi (nth (1- (ccl::chordnum ?1)) ',pitches)))
                               (if fixed-midi (every #'= (ccl::sort< (M ?1)) fixed-midi) T)) ,weight 0)))))))
;
;;;==============================================================================================
;                                    MK FIX PROFILE RULE
;;;==============================================================================================
;
(define-box s-pmc-mk-profile-rule ((curve-min 60) (curve-max 72) (steps 10)
                                    (profile nil)
                                    (parts ":all")
                                    (mode? ":true/false")
                                    (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "It is the mk-fix-profile-rule but for the score-pmc"
  (when (eql parts :all) (setq parts nil))
  (let ((profile (pw::g-round (pw::g-scaling (ccl::pwgl-sample profile steps) curve-min curve-max))))
    (case mode?
      (:true/false `(:true/false * ?1 ,@(when parts `(:parts ,parts)) (<= 1 (ccl::notenum ?1) (length ',profile))
                     (?if (let ((fixed-midi (nth (1- (ccl::notenum ?1)) ',profile)))
                            (if fixed-midi (= (m ?1) fixed-midi) T)))))
      (:heuristic `(:heuristic * ?1 ,@(when parts `(:parts ,parts)) (<= 1 (ccl::notenum ?1) (length ',profile))
                    (?if (if (let ((fixed-midi (nth (1- (ccl::notenum ?1)) ',profile)))
                               (if fixed-midi (= (m ?1) fixed-midi) T)) ,weight 0)))))))
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;====================================   HARMONIC RULES   ========================================
;
;================================================================================================
;=================================  In melodic rules menu  ======================================
;================================================================================================
;
(define-menu harmonic-rules :in score-pmc-rules)
(in-menu harmonic-rules)
;
;
;;;==============================================================================================
;                                 INDEX ALLOWED HARMONY RULE
;;;==============================================================================================
;
(define-box s-pmc-index-allowed-harmony-rule ((harmony? (60 64 67))
                                              (index i1)
                                              (mode? ":true/false")
                                              (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "This rule allows a specific harmony set in harmony? on a given index."
  (case mode?    
    (:true/false `(:true/false * ,index :harmony 
                   (?if (let ((harm (sort (remove-duplicates (pw::g-mod (m ,index :complete? t) 12)) '<))
                              (harmony (sort (pw::g-mod ',harmony? 12) '<)))
                          (if harm (pw::included? harm harmony 'equalp) t)))
                   ))


                        
    (:heuristic `(:heuristic * ,index :harmony 
                  (?if (let ((harm (sort (remove-duplicates (pw::g-mod (m ,index :complete? t) 12)) '<))
                             (harmony (sort (pw::g-mod ',harmony? 12) '<))) 
                         (if (if harm (pw::included? harm harmony 'equalp) t),weight 0)))))))
;
;;;==============================================================================================
;                                 INDEX NOT ALLOWED HARMONY RULE
;;;==============================================================================================
;
(define-box s-pmc-index-not-allowed-harmony-rule ((harmony? (60 64 67))
                                                  (index i1)
                                                  (mode? ":true/false")
                                                  (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "This rule allows a specific harmony set in harmony? on a given index."
  (case mode?    
    (:true/false `(:true/false * ,index :harmony 
                   (?if (let ((harm (sort (remove-duplicates (pw::g-mod (m ,index :complete? t) 12)) '<))
                              (harmony (sort (pw::g-mod ',harmony? 12) '<)))
                          (if harm (not (pw::included? harm harmony 'equalp)) t)))
                   ))


                        
    (:heuristic `(:heuristic * ,index :harmony 
                  (?if (let ((harm (sort (remove-duplicates (pw::g-mod (m ,index :complete? t) 12)) '<))
                             (harmony (sort (pw::g-mod ',harmony? 12) '<))) 
                         (if (if harm (not (pw::included? harm harmony 'equalp)) t),weight 0)))))))


;
;;;==============================================================================================
;                                 ALLOWED HARMONY IN GIVEN MEASURES RULE
;;;==============================================================================================
;
(define-box s-pmc-allowed-harmony-in-given-measures-rule ((harmony? (60 64 67))
                                                          (measures (1))
                                                          (mode? ":true/false")
                                                          (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "This rule forces one or a series of measures to have a specific harmony set in harmony? (in modulo 12)"
  (case mode?    
    (:true/false `(:true/false * ?1 :measures ,measures 
                   (?if (member (pw::g-mod (m ?1) 12)
                                (pw::g-mod ',harmony? 12)))))
                        
    (:heuristic `(:heuristic * ?1 :measures ,measures 
                  (?if (if (member (pw::g-mod (m ?1) 12)
                                   (pw::g-mod ',harmony? 12)) ,weight 0))))))
;
;
;;;==============================================================================================
;                               NOT  ALLOWED HARMONY IN GIVEN MEASURES RULE
;;;==============================================================================================
;
(define-box s-pmc-not-allowed-harmony-in-given-measures-rule ((harmony? (60 64 67))
                                                              (measures (1))
                                                              (mode? ":true/false")
                                                              (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "This rule forces one or a series of measures NOT to have a specific harmony set in harmony? (in modulo 12)"
  (case mode?    
    (:true/false `(:true/false * ?1 :measures ,measures 
                   (?if (not (member (pw::g-mod (m ?1) 12)
                                     (pw::g-mod ',harmony? 12))))))
                        
    (:heuristic `(:heuristic * ?1 :measures ,measures 
                  (?if (if (not (member (pw::g-mod (m ?1) 12)
                                        (pw::g-mod ',harmony? 12))) ,weight 0))))))
;
;
;;;==============================================================================================
;                                 ALLOWED HARMONY ON BEAT RULE
;;;==============================================================================================
;
(define-box s-pmc-allowed-harmony-on-beat-rule ((harmony? (60 64 67))
                                                (beats? (3))
                                                (mode? ":true/false")
                                                (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "This rule forces one or a series of beats to have a specific harmony set in harmony? (in modulo 12)"
  (case mode?    
    (:true/false `(:true/false * ?1 :beats ,beats? 
                   (?if (member (pw::g-mod (m ?1 :complete? T) 12)
                                (pw::g-mod ',harmony? 12)))))
                        
    (:heuristic `(:heuristic * ?1 :beats ,beats? 
                  (?if (if (member (pw::g-mod (m ?1 :complete? T) 12)
                                (pw::g-mod ',harmony? 12)) ,weight 0))))))
;
;
;;;==============================================================================================
;                               NOT  ALLOWED HARMONY ON BEAT RULE
;;;==============================================================================================
;
(define-box s-pmc-not-allowed-harmony-on-beat-rule ((harmony? (60 64 67))
                                                    (beats? (3))
                                                    (mode? ":true/false")
                                                    (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "This rule forces one or a series of beats to NOT have a specific harmony set in harmony? (in modulo 12)"
  (case mode?    
    (:true/false `(:true/false * ?1 :beats ,beats? 
                   (?if (not (member (pw::g-mod (m ?1 :complete? T) 12)
                                     (pw::g-mod ',harmony? 12))))))
                        
    (:heuristic `(:heuristic * ?1 :beats ,beats? 
                  (?if (if (not (member (pw::g-mod (m ?1 :complete? T) 12)
                                        (pw::g-mod ',harmony? 12))) ,weight 0))))))

#|

;
;
;;;==============================================================================================
;                                 ALLOWED HARMONY ON EXPRESSION RULE
;;;==============================================================================================
;
(define-box s-pmc-allowed-harmony-on-expression-rule1 ((part1 1)
                                                      (part2 2)
                                                      (harmony? (60 64 67))
                                                      (expression ":slur")
                                                      (mode? ":true/false")
                                                      (weight 1)
                                                      &optional (expression ":slur"))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "This rule forces one or a series of expressions to have a specific harmony set in harmony? (in modulo 12)"
  (if (symbolp expression)
      (case mode?    
        (:true/false `(:true/false * ?1 :harmony ,@`(:parts ,part1) (e ?1 ,expression)
                       (?if (let ((pitch1 (m ?1 :parts ,part1  :complete? T)))
                              (member (pw::g-mod pitch1 12)
                                      (pw::g-mod ',harmony? 12))
                              ))))
                        
        (:heuristic `(:heuristic * ?1 :harmony ,@`(:parts ,part1) (e ?1 ,expression) 
                      (?if (if (let ((pitch1 (m ?1 :parts ,part1  :complete? T)))
                                 (member (pw::g-mod pitch1 12)
                                         (pw::g-mod ',harmony? 12))) ,weight 0)))))
    (case mode?    
      (:true/false `(:true/false * ?1 :harmony ,@`(:parts ,part1)
                     (?if (let ((pitch1 (m ?1 :parts ,part1  :complete? T)))
                            (member (pw::g-mod pitch1 12)
                                    (pw::g-mod ',harmony? 12))
                            ))))
                        
      (:heuristic `(:heuristic * ?1 :harmony ,@`(:parts ,part1) 
                    (?if (if (let ((pitch1 (m ?1 :parts ,part1  :complete? T)))
                               (member (pw::g-mod pitch1 12)
                                       (pw::g-mod ',harmony? 12))) ,weight 0)))))))

|#
;
;;;==============================================================================================
;                                    ALLOWED HARMONIC INTERVAL RULE
;;;==============================================================================================
; 
(define-box s-pmc-allowed-harm-int-rule ((intervals (0))
                                         (mode? ":true/false")
                                         (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "The given intervals set in INTERVALS have be inside the solution."
  (case mode?    
    (:true/false `(:true/false * ?1 :harmony
                   (?if (let* ((harmony (m ?1 :complete? t))
                               (ints (pw::g-abs (pw::flat (jbs-constraints::find-all-intervals harmony))))
                               )
                        (if ints (every #'(lambda (x) (member x ',intervals)) ints)
                          t)))))
    (:heuristic `(:heuristic * ?1 :harmony 
                  (?if (if (let ((ints (m ?1 :data-access :harm-int)))
                             (if ints (every #'(lambda (x) (member x ints)) ',intervals)
                               t)) ,weight 0))))))
;
;
;;;==============================================================================================
;                                    NOT ALLOWED HARMONIC INTERVAL RULE
;;;==============================================================================================
;
(define-box s-pmc-not-allowed-harm-int-rule ((intervals (0))
                                         (mode? ":true/false")
                                         (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "The given intervals set in INTERVALS have be inside the solution."
  (case mode?    
    (:true/false `(:true/false * ?1 :harmony
                   (?if (let* ((harmony (m ?1 :complete? t))
                               (ints (pw::g-abs (pw::flat (jbs-constraints::find-all-intervals harmony))))
                               )
                        (if ints (every #'(lambda (x) (not (member x ',intervals))) ints)
                          t)))))
    (:heuristic `(:heuristic * ?1 :harmony 
                  (?if (if (let ((ints (m ?1 :data-access :harm-int)))
                             (if ints (every #'(lambda (x) (not (member x ints))) ',intervals)
                               t)) ,weight 0))))))
#|


(define-box s-pmc-not-allowed-harm-int-rule ((intervals (0))
                                             (mode? ":true/false")
                                             (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "no given harmonic intervals."
  (case mode?    
    (:true/false `(:true/false * ?1 :harmony
                   (?if (let ((ints (m ?1 :data-access :harm-int)))
                          (if ints (every #'(lambda (x) (not (member x ints))) ',intervals)
                            t)))))
    (:heuristic `(:heuristic * ?1 :harmony 
                  (?if (if (let ((ints (m ?1 :data-access :harm-int)))
                          (if ints (every #'(lambda (x) (not (member x ints))) ',intervals)
                            t)) ,weight 0))))))
|#

;
;;;==============================================================================================
;                                    ALL NOTES INCLUDED RULE
;;;==============================================================================================
;
(define-box s-pmc-all-notes-included-rule ((all-notes 3)
                                           (mode? ":true/false")
                                           (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "all notes of a chord of three notes into 4 parts"
  (case mode?    
    (:true/false `(:true/false * ?1 :harmony 
                   (?if (let ((harm (remove-duplicates (pw::g-mod (m ?1 :complete? t) 12))))
                          (if harm
                              (= (length harm) ,all-notes)
                            t)))))
    (:heuristic `(:heuristic * ?1 :harmony 
                  (?if (if (let ((harm (remove-duplicates (pw::g-mod (m ?1 :complete? t) 12))))
                             (if harm
                                 (= (length harm) ,all-notes)
                               t)) ,weight 0))))))
;
;;;==============================================================================================
;                                   INDEX ALL NOTES INCLUDED RULE
;;;==============================================================================================
;
(define-box s-pmc-index-all-notes-included-rule ((index i1)
                                                 (all-notes 3)
                                                 (mode? ":true/false")
                                                 (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "This rule forces a solution to have the number of different notes set in 'all-notes' on a given index."
  (case mode?    
    (:true/false `(:true/false * ,index :harmony 
                   (?if (let ((harm (remove-duplicates (pw::g-mod (m ,index :complete? t) 12))))
                          (if harm
                              (= (length harm) ,all-notes)
                            t)))))
    (:heuristic `(:heuristic * ,index :harmony 
                  (?if (if (let ((harm (remove-duplicates (pw::g-mod (m ,index :complete? t) 12))))
                             (if harm
                                 (= (length harm) ,all-notes)
                               t)) ,weight 0))))))
;
;;;==============================================================================================
;                                    ALL NOTES INCLUDED ON BEAT RULE
;;;==============================================================================================
;
(define-box s-pmc-all-notes-included-on-beat-rule ((beat-number (3))
                                                   (all-notes 4)
                                                   (mode? ":true/false")
                                                   (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "all the notes set in all-notes have to be on a given beat in every measure"
  (case mode?    
    (:true/false `(:true/false * ?1 :harmony :beats ,beat-number 
                   (?if (let ((harm (remove-duplicates (pw::g-mod (m ?1 :complete? t) 12))))
                          (if harm
                              (= (length harm) ,all-notes)
                            t)))))
    (:heuristic `(:heuristic * ?1 :harmony :beats ,beat-number
                  (?if (if (let ((harm (remove-duplicates (pw::g-mod (m ?1 :complete? t) 12))))
                             (if harm
                                 (= (length harm) ,all-notes)
                               t)) ,weight 0))))))



;
;;;==============================================================================================
;                                    ALL NOTES INCLUDED ON GIVEN MEASURE RULE
;;;==============================================================================================
;
(define-box s-pmc-all-notes-included-on-given-measure-rule ((measures (1))
                                                            (all-notes 4)
                                                            (mode? ":true/false")
                                                            (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "all the notes set in all-notes have to be on a given beat in every measure"
  (case mode?    
    (:true/false `(:true/false * ?1 :harmony :measures ,measures 
                   (?if (let ((harm (remove-duplicates (pw::g-mod (m ?1 :complete? t) 12))))
                          (if harm
                              (= (length harm) ,all-notes)
                            t)))))
    (:heuristic `(:heuristic * ?1 :harmony :measures ,measures
                  (?if (if (let ((harm (remove-duplicates (pw::g-mod (m ?1 :complete? t) 12))))
                             (if harm
                                 (= (length harm) ,all-notes)
                               t)) ,weight 0))))))

;
;;;==============================================================================================
;                                   FORBIDDEN INVERSIONS RULE
;;;==============================================================================================
;
(define-box s-pmc-forbidden-inversions-rule ((database ())
                                             (mode? ":true/false")
                                             (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "forbidden inversions...no quarta e sesta"
  (case mode?    
    (:true/false `(:true/false * ?1 :harmony 
                   (?if (let ((harm (remove-duplicates 
                                           (pw::g-mod (sort (m ?1 :complete? t) '<) 12) :from-end t) ))
                          (if harm 
                              (not (member harm ',database :test 'equalp))
                            t)))))
    (:heuristic `(:heuristic * ?1 :harmony 
                  (?if (if (let ((harm (remove-duplicates 
                                           (pw::g-mod (sort (m ?1 :complete? t) '<) 12) :from-end t) ))
                             (if harm 
                                 (not (member harm ',database :test 'equalp))
                               t)) ,weight 0))))))
;
;;;==============================================================================================
;                                   PREFERRED DUPLICATES RULE
;;;==============================================================================================
;
(define-box s-pmc-preferred-duplicate-rule ((dups 0)
                                            (mode? ":true/false")
                                            (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "prefers a given duplicates in mod12"
  (case mode?    
    (:true/false `(:true/false * ?1 :harmony 
                   (?if (let* ((harm (m ?1 :complete? t)))
                          (if harm
                              (check-major/minor-dup harm ,dups)
                            t)))))
    (:heuristic `(:heuristic * ?1 :harmony 
                  (?if (if (let* ((harm (m ?1 :complete? t)))
                             (if harm
                                 (check-major/minor-dup harm ,dups)
                               t)) ,weight 0))))))
;
;;;==============================================================================================
;                                   ALLOWED HARMONY RULE
;;;==============================================================================================
;
(define-box s-pmc-allowed-harm-rule ((mainchords ())
                                     (chord-subsets ())
                                     (mode? ":true/false")
                                     (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "allowed harmony even incomplete"
  (case mode?    
    (:true/false `(:true/false * ?1 :harmony
                   (?if (let ((partial-harmony (m ?1))
                              (complete-harmony (m ?1 :complete? t)))
                          (if complete-harmony 
                              (member (ccl::sc-name complete-harmony) ',mainchords :test #'equalp)
                            (member (ccl::sc-name partial-harmony) ',chord-subsets :test #'equalp))))))
    (:heuristic `(:heuristic * ?1 :harmony
                   (?if (if (let ((partial-harmony (m ?1))
                              (complete-harmony (m ?1 :complete? t)))
                          (if complete-harmony 
                              (member (ccl::sc-name complete-harmony) ',mainchords :test #'equalp)
                            (member (ccl::sc-name partial-harmony) ',chord-subsets :test #'equalp))) ,weight 0))))))
;
;;;==============================================================================================
;                                   CHORDS SUCCESSION RULE
;;;==============================================================================================
;
(define-box s-pmc-chords-succession-rule ((database ())
                                          (mode? ":true/false")
                                          (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "data base oriented chords succession with pwgl value"
  (case mode?    
    (:true/false `(:true/false * ?1 ?2 :harmony 
                   (?if (let ((chord1 (m ?1 :complete? t))
                              (chord2 (m ?2 :complete? t)))
                          (if (and chord1 chord2)
                              (let* ((sc1 (ccl::sc+off chord1))
                                     (sc2 (ccl::sc+off chord2))
                                     (followers (second (first (member sc1 ',database :key #'first :test #'equalp)))))
                                (member sc2 followers :test #'equalp))
                            t)))))
    (:heuristic `(:heuristic * ?1 ?2 :harmony 
                  (?if (if (let ((chord1 (m ?1 :complete? t))
                                 (chord2 (m ?2 :complete? t)))
                             (if (and chord1 chord2)
                                 (let* ((sc1 (ccl::sc+off chord1))
                                        (sc2 (ccl::sc+off chord2))
                                        (followers (second (first (member sc1 ',database :key #'first :test #'equalp)))))
                                   (member sc2 followers :test #'equalp))
                               t)) ,weight 0))))))
;
;;;==============================================================================================
;                                   INTERVAL BETWEEN TWO PARTS RULE
;;;==============================================================================================
;
(define-box s-pmc-intv-between-2-parts-rule ((part1 2)
                                             (part2 3)
                                             (intervals (3 4))
                                             (mode? ":true/false")
                                             (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "allowd vertical intervals between contralto and tenor"
(case mode?    
  (:true/false `(:true/false * ?1 :harmony 
                 (?if (let ((pitch1 (m ?1 :parts ,part1))
                            (pitch2 (m ?1 :parts ,part2)))
                        (if (and pitch1 pitch2)
                            (member (abs (- pitch1 pitch2)) ',intervals)
                          t)))))
  (:heuristic `(:heuristic * ?1 :harmony
                (?if (if (let ((pitch1 (m ?1 :parts ,part1))
                               (pitch2 (m ?1 :parts ,part2)))
                           (if (and pitch1 pitch2)
                               (member (abs (- pitch1 pitch2)) ',intervals)
                             t)) ,weight 0))))))
;
;;;==============================================================================================
;                                   NOT INTERVAL BETWEEN TWO PARTS RULE
;;;==============================================================================================
;
(define-box s-pmc-not-intv-between-2-parts-rule ((part1 2)
                                                 (part2 3)
                                                 (intervals (3 4))
                                                 (mode? ":true/false")
                                                 (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "allowd vertical intervals between contralto and tenor"
  (case mode?    
    (:true/false `(:true/false * ?1 :harmony
                   (?if (let ((pitch1 (m ?1 :parts ,part1))
                              (pitch2 (m ?1 :parts ,part2)))
                          (if (and pitch1 pitch2)
                              (not (member (abs (- pitch1 pitch2)) ',intervals))
                            t)))))
    (:heuristic `(:heuristic * ?1 :harmony
                  (?if (if (let ((pitch1 (m ?1 :parts ,part1))
                                 (pitch2 (m ?1 :parts ,part2)))
                             (if (and pitch1 pitch2)
                                 (not (member (abs (- pitch1 pitch2)) ',intervals))
                               t)) ,weight 0))))))
;
;;;==============================================================================================
;                                   SMALLER INTERVAL BETWEEN TWO PARTS RULE
;;;==============================================================================================
;
(define-box s-pmc-smaller-int-between-2-parts-rule ((part1 2)
                                                    (part2 3)
                                                    (interval 12)
                                                    (mode? ":true/false")
                                                    (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "smaller vertical intervals between two parts"
  (case mode?    
    (:true/false `(:true/false * ?1 :harmony
                   (?if (let ((pitch1 (m ?1 :parts ,part1))
                              (pitch2 (m ?1 :parts ,part2)))
                          (if (and pitch1 pitch2)
                              (< (abs (- pitch2 pitch1)) ,interval)
                            t)))))
    (:heuristic `(:heuristic * ?1 :harmony
                  (?if (if (let ((pitch1 (m ?1 :parts ,part1))
                                 (pitch2 (m ?1 :parts ,part2)))
                             (if (and pitch1 pitch2)
                                 (< (abs (- pitch2 pitch1)) ,interval)
                               t)) ,weight 0))))))
;
;;;==============================================================================================
;                                   BIGGER INTERVAL BETWEEN TWO PARTS RULE
;;;==============================================================================================
;
(define-box s-pmc-bigger-int-between-2-parts-rule ((part1 2)
                                                   (part2 3)
                                                   (interval 12)
                                                   (mode? ":true/false")
                                                   (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "bigger vertical intervals between two parts"
  (case mode?    
    (:true/false `(:true/false * ?1 :harmony
                   (?if (let ((pitch1 (m ?1 :parts ,part1))
                              (pitch2 (m ?1 :parts ,part2)))
                          (if (and pitch1 pitch2)
                              (> (abs (- pitch2 pitch1)) ,interval)
                            t)))))
    (:heuristic `(:heuristic * ?1 :harmony
                  (?if (if (let ((pitch1 (m ?1 :parts ,part1))
                                 (pitch2 (m ?1 :parts ,part2)))
                             (if (and pitch1 pitch2)
                                 (> (abs (- pitch2 pitch1)) ,interval)
                               t)) ,weight 0))))))
;
;;;==============================================================================================
;                             FORBIDDEN INTERVAL RELATION BETWEEN TWO PARTS RULE
;;;==============================================================================================
;
(define-box s-pmc-forbidden-int-relation-between-2-parts-rule ((part1 2)
                                                               (part2 3)
                                                               (interval 12)
                                                               (mode? ":true/false")
                                                               (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "forbidden interval relation between two parts with a given interval (false relazioni do do#...do# do...)"
  (case mode?    
    (:true/false `(:true/false * ?1 ?2 :harmony (M ?2 :COMPLETE? T)
                   (?if (let ((pitch1-a (m ?1 :parts ,part1))
                              (pitch1-b (m ?2 :parts ,part1))
                              (pitch2-a (m ?1 :parts ,part2))
                              (pitch2-b (m ?2 :parts ,part2)))
                          (if (and pitch1-a pitch1-b pitch2-a pitch2-b)
                              (or (not (equal (mod pitch1-a 12) (mod pitch2-b 12)))
                                  (not (equal (mod pitch1-b 12) (mod pitch2-a 12)))
                                  (or (not (equal (abs (- pitch1-a pitch1-b)) ,interval))
                                      (not (equal (abs (- pitch2-a pitch2-b)) ,interval))))
                            t)))))
    (:heuristic `(:heuristic * ?1 ?2 :harmony (M ?2 :COMPLETE? T)
                  (?if (if (let ((pitch1-a (m ?1 :parts ,part1))
                                 (pitch1-b (m ?2 :parts ,part1))
                                 (pitch2-a (m ?1 :parts ,part2))
                                 (pitch2-b (m ?2 :parts ,part2)))
                             (if (and pitch1-a pitch1-b pitch2-a pitch2-b)
                                 (or (not (equal (mod pitch1-a 12) (mod pitch2-b 12)))
                                     (not (equal (mod pitch1-b 12) (mod pitch2-a 12)))
                                     (or (not (equal (abs (- pitch1-a pitch1-b)) ,interval))
                                         (not (equal (abs (- pitch2-a pitch2-b)) ,interval))))
                               t)) ,weight 0))))))
;
;;;==============================================================================================
;                        NOT N CONSECUTIVE INTERVAL REPETITIONS BETWEEN TWO PARTS RULE
;;;==============================================================================================
;
(define-box s-pmc-not-n-consecutive-harm-int-rule ((part1 1)
                                                   (part2 2)
                                                   (repetition 3)
                                                   (mode? ":true/false")
                                                   (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "in repetition you put how many equal intervals you do not allowed between two parts. The concerned parts are to be
specified in part1 and part2."
  (let* ((candidates (make-?1 (pw::arithm-ser 1 1 repetition)))
         (candidato-ultimo (make-?1 repetition))
         (ris nil)
         (harmint (genero-harm-int-for-rule (pw::arithm-ser 1 1 repetition)))
         (calcolo (dolist (y harmint (nreverse ris))
                    (push (pw::x-append 'first (list y)) ris))))
    (case mode?    
      (:true/false `(:true/false * ,@candidates :harmony (m ,candidato-ultimo :complete? t)
                     (?if 
                      (not (= ,@calcolo)))))
      (:heuristic `(:heuristic * ,@candidates :harmony (m ,candidato-ultimo :complete? t)
                     (?if 
                     (if (not (= ,@calcolo)) ,weight 0)))))))
;
;;;==============================================================================================
;                        NOT N SAME DIRECTIONS BETWEEN TWO PARTS RULE
;;;==============================================================================================
;
(define-box s-pmc-not-n-same-directions-rule ((part1 1)
                                              (part2 2)
                                              (repetition 3)
                                              (mode? ":true/false")
                                              (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "This rule does not admit more than n repetitions of the same directions between two voices. In part1 and part2 you 
define which are the intersted parts. In repetition you set how many same directions do you admit."
  (let* ((candidates (make-?1 (pw::arithm-ser 1 1 repetition)))
         (candidato-ultimo (make-?1 repetition))
         (calcolo-m-part1 (genero-m-for-?1-con-parts (pw::arithm-ser 1 1 repetition) part1))
         (calcolo-m-part2 (genero-m-for-?1-con-parts (pw::arithm-ser 1 1 repetition) part2))
         (interval-part1 (genero-signum2 (genero-segno-meno (mapcar 'reverse (scom calcolo-m-part1 2)))))
         (interval-part2 (genero-signum2 (genero-segno-meno (mapcar 'reverse (scom calcolo-m-part2 2)))))
         (matrice (pw::mat-trans (list interval-part1 interval-part2)))
         (ris nil)
         (aggiungo= (dolist (y matrice (nreverse ris))
                      (push (pw::x-append '= y) ris)))
         )
    (case mode?    
      (:true/false `(:true/false * ,@candidates :harmony (m ,candidato-ultimo :complete? t)
                     (?if 
                      (not (and ,@aggiungo=)))))
      (:heuristic `(:heuristic * ,@candidates :harmony (m ,candidato-ultimo :complete? t)
                    (?if 
                     (if (not (and ,@aggiungo=)) ,weight 0)))))))
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;=================================   VOICE LEADING RULES   ======================================
;
;================================================================================================
;=============================  In voice leading rules menu  ====================================
;================================================================================================
;
;
(define-menu voice-leading-rules :in score-pmc-rules)
(in-menu voice-leading-rules)
;
;
;
;;;==============================================================================================
;                                    NO CROSSING VOICE RULE
;;;==============================================================================================
;
(define-box s-pmc-no-crossing-voice-rule ((mode? ":true/false")
                                          (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "no part-crossings"
  (case mode?    
    (:true/false `(:true/false * ?1 :harmony
                   (?if 
                    (every #'(lambda (n) 
                               (cond ((> (ccl::partnum n) (ccl::partnum ccl::?csv)) (< (m n) (m ccl::?csv)))
                                     ((< (ccl::partnum n) (ccl::partnum ccl::?csv)) (> (m n) (m ccl::?csv)))
                                     (T T))) (m ?1 :object t)))))
    (:heuristic `(:heuristic * ?1 :harmony
                  (?if 
                   (if (every #'(lambda (n) 
                                  (cond ((> (ccl::partnum n) (ccl::partnum ccl::?csv)) (< (m n) (m ccl::?csv)))
                                        ((< (ccl::partnum n) (ccl::partnum ccl::?csv)) (> (m n) (m ccl::?csv)))
                                        (T T))) (m ?1 :object t)) ,weight 0))))))
;
;;;==============================================================================================
;                                    NO OPEN PARALLEL RULE
;;;==============================================================================================
;
(define-box s-pmc-no-open-parallel-rule ((intervals (0 7))
                                         (mode? ":true/false")
                                         (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "no open parallel..."
  (case mode?    
    (:true/false `(:true/false * ?1  :harmony  
                   (?if (let ((mat (ccl::MATRIX-ACCESS (m ?1 :vl-matrix T) :h)))
                          (if mat
                              (destructuring-bind (m11 m12) (first mat)
                                (if (/= m11 m12)
                                    (not (find-if #'(lambda (mel2)
                                                      (destructuring-bind (m21 m22) mel2
                                                        (let ((hint1 (ccl::mod12 (abs (- m11 m21)))) 
                                                              (hint2 (ccl::mod12 (abs (- m12 m22)))))
                                                          (and (/= m21 m22) (member hint1 ',intervals) (= hint1 hint2))))) 
                                                  (rest mat)))
                                  T))
                            T)))  ))
    (:heuristic `(:heuristic * ?1  :harmony  
                  (?if (if (let ((mat (ccl::MATRIX-ACCESS (m ?1 :vl-matrix T) :h)))
                             (if mat
                                 (destructuring-bind (m11 m12) (first mat)
                                   (if (/= m11 m12)
                                       (not (find-if #'(lambda (mel2)
                                                         (destructuring-bind (m21 m22) mel2
                                                           (let ((hint1 (ccl::mod12 (abs (- m11 m21)))) 
                                                                 (hint2 (ccl::mod12 (abs (- m12 m22)))))
                                                             (and (/= m21 m22) (member hint1 ',intervals) (= hint1 hint2))))) 
                                                     (rest mat)))
                                     T))
                               T)) ,weight 0))  ))))
;
;;;==============================================================================================
;                                    FORBIDDEN SUCCESSIONS RULE
;;;==============================================================================================
;
(define-box s-pmc-forbidden-succession-rule ((interval1 6)
                                             (interval2 7)
                                             (mode? ":true/false")
                                             (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "no triton followed by a fifth..."
  (case mode?    
    (:true/false `(:true/false * ?1  :harmony  
                   (?if (let ((mat (ccl::MATRIX-ACCESS (m ?1 :vl-matrix T) :h)))
                          (if mat
                              (destructuring-bind (m11 m12) (first mat)
                                (if (/= m11 m12)
                                    (not (find-if #'(lambda (mel2)
                                                      (destructuring-bind (m21 m22) mel2
                                                        (let ((hint1 (ccl::mod12 (abs (- m11 m21)))) 
                                                              (hint2 (ccl::mod12 (abs (- m12 m22)))))
                                                          (and (/= m21 m22) (= hint1 ,interval1) (= hint2 ,interval2))))) 
                                                  (rest mat)))
                                  T))
                            T))) ))
    (:heuristic `(:heuristic * ?1  :harmony  
                  (?if (if (let ((mat (ccl::MATRIX-ACCESS (m ?1 :vl-matrix T) :h)))
                             (if mat
                                 (destructuring-bind (m11 m12) (first mat)
                                   (if (/= m11 m12)
                                       (not (find-if #'(lambda (mel2)
                                                         (destructuring-bind (m21 m22) mel2
                                                           (let ((hint1 (ccl::mod12 (abs (- m11 m21)))) 
                                                                 (hint2 (ccl::mod12 (abs (- m12 m22)))))
                                                             (and (/= m21 m22) (= hint1 ,interval1) (= hint2 ,interval2))))) 
                                                     (rest mat)))
                                     T))
                               T)) ,weight 0)) ))))
;
;;;==============================================================================================
;                                    HIDDEN PARALLEL RULE
;;;==============================================================================================
;
(define-box s-pmc-hidden-parallel-rule ((intervals (0 7))
                                        (mode? ":true/false")
                                        (weight 1))
  :menu (mode? (:true/false "true/false") (:heuristic "heuristic"))
  :class score-pmc-box
  "hidden parallel fifths/octs with stepwise upper voice"
  (case mode?    
    (:true/false `(:true/false * ?1  :harmony  
                   (?if (let ((mat (ccl::MATRIX-ACCESS (m ?1 :vl-matrix T) :h)))
                          (if mat
                              (destructuring-bind (m11 m12) (first mat)
                                (if (/= m11 m12)
                                    (not (find-if #'(lambda (mel2)
                                                      (destructuring-bind (m21 m22) mel2
                                                        (let ((same-direction? (= (signum (- m11 m12)) (signum (- m21 m22)))) 
                                                              (hint2 (ccl::mod12 (abs (- m12 m22))))
                                                              (stepwise? (if (> m12 m22) 
                                                                             (<= (abs (- m11 m12)) 2)
                                                                           (<= (abs (- m21 m22)) 2))))
                                                          (and (not stepwise?) (/= m21 m22) same-direction? (member hint2 ',intervals))))) 
                                                  (rest mat)))
                                  T))
                            T)))))
    (:heuristic `(:heuristic * ?1  :harmony  
                  (?if (if (let ((mat (ccl::MATRIX-ACCESS (m ?1 :vl-matrix T) :h)))
                             (if mat
                                 (destructuring-bind (m11 m12) (first mat)
                                   (if (/= m11 m12)
                                       (not (find-if #'(lambda (mel2)
                                                         (destructuring-bind (m21 m22) mel2
                                                           (let ((same-direction? (= (signum (- m11 m12)) (signum (- m21 m22)))) 
                                                                 (hint2 (ccl::mod12 (abs (- m12 m22))))
                                                                 (stepwise? (if (> m12 m22) 
                                                                                (<= (abs (- m11 m12)) 2)
                                                                              (<= (abs (- m21 m22)) 2))))
                                                             (and (not stepwise?) (/= m21 m22) same-direction? (member hint2 ',intervals))))) 
                                                     (rest mat)))
                                     T))
                               T)) ,weight 0))))))
;
;
;
;to be done : 
;not-two-voices-more-than-X-same-direction
;if-expression : not-two-voices-more-than-X-same-direction
;
;
;
;
;
;
;
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;=============================   CREATE EXPRESSIONS TOOL   ======================================
;
;================================================================================================
;=========================  In create expression tool menu   ====================================
;================================================================================================
;
;
(define-menu create-expressions-tools :in score-pmc-rules)
(in-menu create-expressions-tools)
;
;
;
;;;==============================================================================================
;                                   CREATE INDIVIDUAL EXPRESSIONS 
;;;==============================================================================================
;
(define-box create-individual-expression ((index? (1 4))
                                          (expression ":slur")
                                          (parts ":all"))                                          
  :class score-pmc-box
  "In index? you put the indexes on which you want to put some expression.. 
In parts if you put :all, the rule will be applied on all parts. if you put 1 only in the first, second only in the second...
ATTENTION : index are in the cosntraints way: it means that 1 is for the first, 2 for the second... and not as in lisp... (O for the 
first, 1 for the second...)"
  (when (eql parts :all) (setq parts nil)) 
  `(* ?1 ,@(when parts `(:parts ,parts)) (?if (let ((ris (first (member (ccl::mindex ?1) ',index?))))
                                                (when ris
                                                  (ccl::add-expression ',(ccl::keyword-to-class expression) ?1)))) ))
;
;;;==============================================================================================
;                                   CREATE GROUP EXPRESSIONS 
;;;==============================================================================================
;
(define-box create-group-expression ((indexes? ((1 4) (7 10) (11 16)))
                                    (expression ":slur")
                                    (parts ":all"))                                          
 :class score-pmc-box
 "In indexes? you put a list of lists. The first value indicates from which index you want to start a group expression (like crescendo, or slur...), and the second indicates when you want the group to stop. In expression you pt the kind of expression you want.  In parts if you put :all, the rule will be applied on all parts. if you put 1 only in the first, second only in the second...
ATTENTION : index are in the cosntraints way: it means that 1 is for the first, 2 for the second... and not as in lisp... (O for the 
first, 1 for the second...)"
 (when (eql parts :all) (setq parts nil)) 
 `(* ?1 :chord ,@(when parts `(:parts ,parts)) 
     (?if (when (m ?1 :complete? T)
            (let ((ris (find-if #'(lambda(x) (= (second x) (ccl::chordnum ?1))) ',indexes?)))
              (when ris
                (ccl::add-expression ',(ccl::keyword-to-class expression) (m ?1 :l (1+ (- (second ris) (first ris))) :object :accessor))))))))
;
;;;==============================================================================================
;                                   CREATE EXPRESSIONS ON FACE VALUE
;;;==============================================================================================
;
(define-box create-face-value-expression ((face-values? (1/4 1/8))
                                          (expression ":staccato")
                                          (parts ":all"))                                          
  :class score-pmc-box
  "In face value you put the rhythmical values on whom you want to apply an expression.
In expression you put the kind of expression you want. In parts if you put :all, the rule will be applied on all parts. 
If you put 1 only in the first, second only in the second..."
  (when (eql parts :all) (setq parts nil)) 
  `(* ?1 ,@(when parts `(:parts ,parts)) :chord (m ?1 :complete? t)
      (?if (when (member (ccl::face-value ?1 :total-p nil) ',face-values?)
             (ccl::add-expression ',(ccl::keyword-to-class expression) ?1)))))
;
;;;==============================================================================================
;                                   CREATE EXPRESSIONS ON NOTE SEQUENCE
;;;==============================================================================================
;
(define-box create-expression-on-note-sequence ((expression ":slur")
                                                (parts ":all"))                                          
  :class score-pmc-box
  "This function adds expression on consecutive single notes.
In expression you pt the kind of expression you want. In parts if you put :all, the rule will be applied on all parts. if you put 1 only in the first, second only in the second..."
  (when (eql parts :all) (setq parts nil)) 
  `(* ?1 ,@(when parts `(:parts ,parts)) :chord (and (m ?1 :complete? t) (and (not (cdr (ccl::notes ?1)))
                                                                              (if (ccl::next-item ?1) (cdr (ccl::notes (ccl::next-item ?1))) T)))
      (?if (let ((chords (m ?1 :l t :object :accessor :l-filter #'(lambda(c) (or (not (cdr (ccl::notes c))) :exit)))))
             (when (cdr chords)
               (ccl::add-expression ',(ccl::keyword-to-class expression) chords))))))
;
;;;==============================================================================================
;                                   CREATE EXPRESSIONS ON CHORD SEQUENCE
;;;==============================================================================================
;
(define-box create-expression-on-chord-sequence ((expression ":slur")
                                                 (parts ":all"))                                          
  :class score-pmc-box
  "This function adds expression on consecutive chords.
In expression you pt the kind of expression you want. In parts if you put :all, the rule will be applied on all parts. 
If you put 1 only in the first, second only in the second..."
  (when (eql parts :all) (setq parts nil)) 
  `(* ?1 ,@(when parts `(:parts ,parts)) :chord (and (cdr (ccl::notes ?1))
                                                     (if (ccl::next-item ?1) (not (cdr (ccl::notes (ccl::next-item ?1)))) T))
      (?if (when (m ?1 :complete? T)
             (let ((chords (m ?1 :l t :object :accessor :l-filter #'(lambda(c) (or (cdr (ccl::notes c)) :exit)))))
               (when (cdr chords)
                 (ccl::add-expression ',(ccl::keyword-to-class expression) chords)))))))
;
;;;==============================================================================================
;                                   CREATE EXPRESSIONS ON GRACE NOTE SEQUENCE
;;;==============================================================================================
;
(define-box create-expression-on-grace-note-sequence ((expression ":slur")
                                                      (parts ":all"))                                          
  :class score-pmc-box
  "This function adds expression on consecutive grave-note sequence. In expression you pt the kind of expression you want. In parts if you put :all, the rule will be applied on all parts. If you put 1 only in the first, second only in the second..."

  (when (eql parts :all) (setq parts nil)) 
  `(* ?1 ,@(when parts `(:parts ,parts)) :chord (and (m ?1 :complete? t) (and (ccl::grace-note-p ?1)
                                                                              (if (ccl::next-item ?1)
                                                                                  (not (ccl::grace-note-p 
                                                                                        (ccl::next-item ?1)))
                                                                                T)))
      (?if (let ((chords (m ?1 :l t :object :accessor :l-filter #'(lambda(c) (or (ccl::grace-note-p c) :exit)))))
             (when (cdr chords)
               (ccl::add-expression ',(ccl::keyword-to-class expression) chords))))))
;
;;;==============================================================================================
;                                   CREATE EXPRESSIONS ON MAIN BEAT
;;;==============================================================================================
;
(define-box create-expression-on-main-beat ((expression ":accent")
                                            (parts ":all"))                                          
  :class score-pmc-box
  "This function adds expression on main beat value.
In expression you pt the kind of expression you want. In parts if you put :all, the rule will be applied on all parts. 
If you put 1 only in the first, second only in the second..."
  (when (eql parts :all) (setq parts nil))
  `(* ?1 ,@(when parts `(:parts ,parts)) 
      (?if (when (ccl::on-main-beat? ?1)
             (ccl::add-expression ',(ccl::keyword-to-class expression) ?1)))))
;
;;;==============================================================================================
;                                   CREATE EXPRESSIONS NOT ON MAIN BEAT
;;;==============================================================================================
;
(define-box create-expression-NOT-on-main-beat ((expression ":accent")
                                                (parts ":all"))                                          
  :class score-pmc-box
  "This function adds expression not on main beat.
In expression you pt the kind of expression you want. In parts if you put :all, the rule will be applied on all parts. 
If you put 1 only in the first, second only in the second..."
  (when (eql parts :all) (setq parts nil))
  `(* ?1 ,@(when parts `(:parts ,parts)) 
      (?if (when (not (ccl::on-main-beat? ?1))
             (ccl::add-expression ',(ccl::keyword-to-class expression) ?1)))))

;
;;;==============================================================================================
;                                   CREATE EXPRESSIONS FOR BEATS
;;;==============================================================================================
;
(define-box create-expression-for-beats ((beats-numbers (2 3))
                                         (expression ":accent")
                                         (parts ":all"))                                          
  :class score-pmc-box
  "This function adds expression not on main beat for the beats set in beats-numbers in any measure.
In expression you pt the kind of expression you want. In parts if you put :all, the rule will be applied on all parts. 
If you put 1 only in the first, second only in the second..."
  (when (eql parts :all) (setq parts nil))
  `(* ?1 ,@(when parts `(:parts ,parts)) 
      :beats ',beats-numbers (?if (ccl::add-expression ',(ccl::keyword-to-class expression) ?1))))
;
;;;==============================================================================================
;                                   CREATE EXPRESSIONS FOR MEASURES
;;;==============================================================================================
;
(define-box create-expression-for-measures ((measure-numbers (2 3))
                                            (expression ":accent")
                                            (parts ":all"))                                          
  :class score-pmc-box
  "This function adds expression for the entire measures set in measure-numbers.
In expression you pt the kind of expression you want. In parts if you put :all, the rule will be applied on all parts. 
If you put 1 only in the first, second only in the second..."
  (when (eql parts :all) (setq parts nil))
  `(* ?1 ,@(when parts `(:parts ,parts)) 
      :measures ',measure-numbers (?if (ccl::add-expression ',(ccl::keyword-to-class expression) ?1))))