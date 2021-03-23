(in-package studioflat)

;; needs patch-work::x->dx and patch-work::dx->x
(defvar *default-nothead-no-pitch* '(62 :note-head :x))
(defconstant *extra-measure-color* 10000050)



(defun make-proportional-cell (dur-list)
  (mapcar #'(lambda (dur) (* dur (apply 'lcm (mapcar 'denominator dur-list))))
          dur-list))

;offset from 1 always!!! Because otherwise the first pause ( -0!) will dissapear.
(defun x-dx-pause-ok (x-list)   ;grace notes ok
  (mapcar '*
          (mapcar #'(lambda (absdur) (if (or (plusp absdur) (= 0 absdur)) 1 -1)) x-list)
          (patch-work::x->dx (mapcar 'abs x-list))))

(defun dx-x-pause-ok (starttime x-list)   ;grace notes ok
  (mapcar '*
          (append (mapcar #'(lambda (absdur) (if (>= absdur 0) 1 -1)) x-list) '(1))
          (patch-work::dx->x starttime (mapcar 'abs x-list))))

(defun simplify-proportions (proportion-list)
  (mapcar #'(lambda (value) (/ value (apply 'gcd proportion-list))) proportion-list))

(defun build-local-times (global-onsets global-start)
       (mapcar #'(lambda (onset) (if (plusp onset)
                                   (- onset (1- global-start))
                                   (+ onset (1- global-start))))
               global-onsets))

;;append-pitch is a simpler and earlier version of append-pitch3. 
(defun append-pitch (proportion-list pitches)
  "Use append-pitch2 for subtrees"
  (mapcar #'(lambda (proportion) (if (plusp proportion)
                                     (if (numberp (car pitches))
                                         (list proportion ':notes (pop pitches))
                                       (list proportion ':notes (list (list 62 :note-head :x))))
                                   (progn (pop pitches) proportion)))
          proportion-list))




(defun append-pitch3 (proportion-list pitches)
  "append-pitch2 can handle subtrees (one level)"
  
  (mapcar #'(lambda (proportion) (if (listp proportion) ;subtree exist
                                     (list (car proportion) 
                                           (mapcar #'(lambda (subproportion)
                                                       (if (or (plusp subproportion) (= 0 subproportion))
                                                           (if (car pitches)
                                                               (if (plusp subproportion)
                                                                   (list subproportion ':notes (pop pitches)) 
                                                                 (list 1 (list (list 1 ':notes (pop pitches))) ':class ':grace-beat))
                                                             (if (plusp subproportion)
                                                                 (list subproportion ':notes (list *default-nothead-no-pitch*))
                                                               (list 1 (list (list 1 ':notes (list *default-nothead-no-pitch*))) ':class ':grace-beat)))
                                                         (progn (pop pitches) subproportion))) ;pause in subtree
                                                   (cadr proportion)))

                                   (if (or (plusp proportion) (= 0 proportion))
                                       (if (car pitches)
                                           (if (plusp proportion)
                                               (list proportion ':notes (pop pitches))
                                             (list 1 (list (list 1 ':notes (pop pitches))) ':class ':grace-beat))
                                         (if (plusp proportion) 
                                             (list proportion ':notes (list *default-nothead-no-pitch*))
                                           (list 1 (list (list 1 ':notes (list *default-nothead-no-pitch*))) ':class ':grace-beat)))
                                     (progn (pop pitches) proportion)))) ;pause
          proportion-list))



(defun create-beat-with-pitches (global-onset global-start beat-length pitches)

  (loop while (and (> (length global-onset) 1) (= (abs (car (last global-onset))) (+ global-start beat-length)))  ;;;; this is for gracenotes
        do (setf global-onset (butlast global-onset)))

  (let ((local-onset (build-local-times global-onset global-start))
        sub-tree)
    
    (if (not local-onset) (setf local-onset (list (1+ beat-length)))) ;empty = syncopation

    (if (<= (car (last local-onset)) (- -1 beat-length))               
        (setf local-onset (append (butlast local-onset) (list (1+ beat-length))))) ;pause starts on (or after) beat ending

    (if (/= (car (last local-onset)) (1+ beat-length))
        (setf local-onset (append local-onset (list (1+ beat-length))))) ;beat ending needed as an event for calculation

    (setf sub-tree (make-sub-tree local-onset))
    (setf sub-tree (better-predefined-subdiv? sub-tree))
    (list (car sub-tree) (append-pitch3 (cadr sub-tree) pitches))
    ))



(defun make-sub-tree (local-onset)
  (list 1
        ;(fuse-pauses
         (cond ((and (or (= (car local-onset) 1) (= (car local-onset) -1))) ; not a syncopation
                (make-proportional-cell (x-dx-pause-ok local-onset)))
               (t
                (let ((proportional-list
                       (make-proportional-cell (x-dx-pause-ok (cons 1 local-onset)))))
                  (cons (float (first proportional-list))
                        (cdr proportional-list))))
               )))





;;; below 3 functions to simplify notation
(defun remove-pitch-on-single-note (subtree)
  "if the subtree contains only one note - filter out pitch information"
  (if (= (length (cadr subtree)) 1)
      (if (listp (caadr subtree))
          (list (car subtree) (list (caaadr subtree)))
        (list (car subtree) (list (caadr subtree))))
    nil))

(defun get-notation-on-single-note (subtree)
    "if the subtree contains only one note - get notation information"
  (if (= (length (cadr subtree)) 1)
      (if (listp (caadr subtree))
          (cdaadr subtree)
        nil)
    nil))

(defun fuse-pauses-and-tied-notes-between-beats (measure-tree no-of-beats)
  (let ((beat-nr 0))
    
    (loop until (>=  beat-nr no-of-beats)
          collect (cond ((equal (nth beat-nr measure-tree) '(1 (-1)))  ;fuse tied pause

                         (let ((value (first (nth beat-nr measure-tree))))
                           (incf beat-nr)
                           (loop until (or (not (equal (nth beat-nr measure-tree) '(1 (-1))))
                                           (>=  beat-nr no-of-beats)
                                           )
                                 do (progn (incf value)
                                           (incf beat-nr)))
                           (list value '(-1))))

                        ((and (equal (remove-pitch-on-single-note (nth beat-nr measure-tree)) '(1 (1))))   ;fuse notes
                         (let ((value (first (remove-pitch-on-single-note (nth beat-nr measure-tree)))))
                           (incf beat-nr)
                           (loop until (not (equal (remove-pitch-on-single-note (nth beat-nr measure-tree)) '(1 (1.0))))
                                 do (progn (incf value)
                                           (incf beat-nr)))
                           (list value (list (append '(1) (get-notation-on-single-note (nth (1- beat-nr) measure-tree)))))))

                        ((and (equal (remove-pitch-on-single-note (nth beat-nr measure-tree)) '(1 (1.0))))   ;fuse notes
                         (let ((value (first (remove-pitch-on-single-note (nth beat-nr measure-tree)))))
                           (incf beat-nr)
                           (loop until (not (equal (remove-pitch-on-single-note (nth beat-nr measure-tree)) '(1 (1.0))))
                                 do (progn (incf value)
                                           (incf beat-nr)))
                           (list value (list (append '(1.0) (get-notation-on-single-note (nth (1- beat-nr) measure-tree)))))))

                        (t (incf beat-nr)  ;all other cases
                           (nth (1- beat-nr) measure-tree))))
    ))



(defun filter-events-with-pitches-between (start stop onsettimes-with-pitches)
  (let ((no-low-values (member start onsettimes-with-pitches :test #'(lambda (item value) (<= item (abs (car value)))))))
    (reverse (member stop (reverse no-low-values) :test #'(lambda (item value) (>= item (abs (car value))))))))

(defun get-onsettime-with-pitch-before (timepoint abs-rhythm-with-pitch)
  (car (member timepoint (reverse abs-rhythm-with-pitch) :test #'(lambda (item value) (> item (abs (car value)))))))

;local-onset-with-pitches ((1 60)(-2)(3 61))
(defun build-one-measure-with-pitches (local-onset-with-pitches no-of-beats beat-length colorflag tempo)
  (let ((beatlist (patch-work::dx->x 1 (make-list no-of-beats :initial-element beat-length)))
        tree)
    
    (setf tree
          (fuse-pauses-and-tied-notes-between-beats
           (loop for beat-nr from 0 to (1- no-of-beats)
                 collect (let ((these-events (filter-events-with-pitches-between (nth beat-nr beatlist)
                                                                                 (nth (1+ beat-nr) beatlist)
                                                                                 local-onset-with-pitches)))

                           ;check if pause before beat goes in to the current beat  - if yes: give startpoint as pause
                           (if (and these-events
                                    (/= (abs (car (first these-events))) (nth beat-nr beatlist))
                                    (get-onsettime-with-pitch-before (nth beat-nr beatlist) local-onset-with-pitches)
                                    (minusp (car (get-onsettime-with-pitch-before (nth beat-nr beatlist) local-onset-with-pitches))))
                               (setf these-events (append (list (list (- 0 (nth beat-nr beatlist)) nil))
                                                          these-events))) 


                           ;check if pause before beat goes into the current beat AND remains throughout 
                           ;the current beat - if yes: give startpoint as pause

                           (if (and (not these-events)
                                    (get-onsettime-with-pitch-before (nth beat-nr beatlist) local-onset-with-pitches)
                                    (minusp (car (get-onsettime-with-pitch-before (nth beat-nr beatlist) local-onset-with-pitches))))
                               (setf these-events (list (list (- 0 (nth beat-nr beatlist)) nil))))

                           (if (or (and these-events
                                        (/= (abs (car (first these-events))) (nth beat-nr beatlist)));start is syncopation - get pitch for first event
                                   (not these-events));no event in beat - start is syncopation (since pause is ruled out above)
                               (progn (setf syncopated-pitch 
                                            (cdr (get-onsettime-with-pitch-before (nth beat-nr beatlist) local-onset-with-pitches)))

                                 (create-beat-with-pitches (mapcar 'car these-events) 
                                                           (nth beat-nr beatlist) 
                                                           beat-length 
                                                           (append syncopated-pitch (mapcar 'cadr these-events))))
                             (create-beat-with-pitches (mapcar 'car these-events) 
                                                       (nth beat-nr beatlist) 
                                                       beat-length 
                                                       (mapcar 'cadr these-events)))))
           no-of-beats)
          )
    (if colorflag
        (append (list ':low (/ 1 beat-length) ':metronome-value tempo) tree (list :color *extra-measure-color*))
      (append (list ':low (/ 1 beat-length) ':metronome-value tempo) tree))))




(defun pair-rhythm-and-pitch (rhythms pitches)
  (mapcar #'(lambda (rhythm) (if (plusp rhythm)
                                 (list rhythm (pop pitches))
                               (list rhythm nil)))
          rhythms))

(defun build-local-times-with-pitches (global-onsets-with-pitches global-start)
       (mapcar #'(lambda (onset-pitch) (if (plusp (car onset-pitch))
                                           (list (- (car onset-pitch) (1- global-start)) (cadr onset-pitch))
                                         (list (+ (car onset-pitch) (1- global-start)) (cadr onset-pitch))))
               global-onsets-with-pitches))


(defun build-measure-seq (abs-rhythms pitches timesigns nr-colored-measures tempo)
  (let ((measure-start-points (patch-work::dx->x 1 (mapcar #'(lambda (timesign) (apply '/ timesign)) timesigns)))
        (abs-rhythm-with-pitches (pair-rhythm-and-pitch abs-rhythms pitches))
        (nr-black-measures (- (length timesigns) nr-colored-measures)))
    (loop for measure from 0 to (1- (length timesigns))
          collect (let ((this-seq (filter-events-with-pitches-between (nth measure measure-start-points)
                                                                      (nth (1+ measure) measure-start-points)
                                                                      abs-rhythm-with-pitches))
                        (this-timesign (nth measure timesigns))
                        local-onset)
                    
                    ;check if measure starts with tied pause
                    ;if yes, add extra pause on startpoint of measure
                    (if (and this-seq
                             (/= (abs (car (first this-seq))) (nth measure measure-start-points))
                             (minusp (car (get-onsettime-with-pitch-before (nth measure measure-start-points) abs-rhythm-with-pitches))))
                      (setf this-seq (append (list (list (- 0 (nth measure measure-start-points)) nil))
                                             this-seq)))

                    ;check if measure empty and starts with tied pause
                    ;if yes, add pause on startpoint of measure
                    (if (and (not this-seq) 
                             (minusp (car (get-onsettime-with-pitch-before (nth measure measure-start-points) abs-rhythm-with-pitches))))
                      (setf this-seq (list (list (- 0 (nth measure measure-start-points)) nil))))

                    ;;SYNCOPATION 
                    ;check if measure starts with tied note
                    ;if yes, input pitch before startpoint of measure
                    (if (and this-seq
                             (/= (abs (car (first this-seq))) (nth measure measure-start-points))
                             (plusp (car (get-onsettime-with-pitch-before (nth measure measure-start-points) abs-rhythm-with-pitches))))
                        (setf this-seq (append (list (list 
                                                      (- (nth measure measure-start-points) 1/2) ;trick function to input syncopated pitch
                                                      (cadr (get-onsettime-with-pitch-before 
                                                             (nth measure measure-start-points) 
                                                             abs-rhythm-with-pitches))))
                                               this-seq)))

                    ;check if measure is empty and starts with tied note
                    ;if yes, input pitch before startpoint of measure
                    (if (and (not this-seq) 
                             (plusp (car (get-onsettime-with-pitch-before (nth measure measure-start-points) abs-rhythm-with-pitches))))
                        (setf this-seq (list (list 
                                              (- (nth measure measure-start-points) 1/2) ;trick function to input syncopated pitch
                                              (cadr (get-onsettime-with-pitch-before 
                                                     (nth measure measure-start-points) 
                                                     abs-rhythm-with-pitches))))))
                    
                    (setf local-onset-with-pitches (build-local-times-with-pitches this-seq (nth measure measure-start-points)))

                    (if (<  measure nr-black-measures)
                        (build-one-measure-with-pitches local-onset-with-pitches 
                                                        (car this-timesign)
                                                        (/ 1 (cadr this-timesign))
                                                        nil
                                                        tempo)
                      (build-one-measure-with-pitches local-onset-with-pitches 
                                                      (car this-timesign)
                                                      (/ 1 (cadr this-timesign))
                                                      t
                                                      tempo))))))


(defun fuse-pauses-in-input (proportion-list)
  "Simplify input ratio list - pauses in imideate sequence are fused to one pause"
  (let ((result nil))
    (loop while proportion-list
          do (progn (if (and result
                             (minusp (first proportion-list))
                             (minusp (car (last result))))
                      (setf (car (last result)) (+ (car (last result)) (car proportion-list)))
                      (setf result (append result (list (car proportion-list)))))
                    (pop proportion-list)))
    result))

(dx-x-pause-ok 1 (fuse-pauses-in-input '(1/4 0 1/4 1/4 -100)))

(defun simple->tree (rhythmseq pitchseq timesignseq tempo)
  (let ((abs-rhythms (dx-x-pause-ok 1 (fuse-pauses-in-input (append rhythmseq '(-100))))))
  (list (list (fuse-gracenotes (list (list (build-measure-seq abs-rhythms pitchseq timesignseq 0 tempo))))))))

;(defun simple->tree-one-layer (rhythmseq pitchseq timesignseq nr-colored-measures tempo)
;  (let ((abs-rhythms (dx-x-pause-ok 1 (fuse-pauses-in-input (append rhythmseq '(-100))))))
;     (build-measure-seq abs-rhythms pitchseq timesignseq nr-colored-measures tempo)))
;;;;;;;;;;;;;;;;;;;;;;;;

(system::PWGLdef simplelayer->tree ((rhythmseq '(1/4 1/4 1/4 1/4)) (pitchseq nil) (timesignseq nil) &optional (velocity nil))
    "no doc"
    ()

  (let ((tempo 60))
    (if (typep (first timesignseq) 'integer)
        (let* ((tot-length-rhythmseq (apply '+ (mapcar 'abs rhythmseq)))
               (length-one-measure (apply '/ timesignseq))
               (no-of-measures (truncate (/ tot-length-rhythmseq length-one-measure))))
          (if (/= (- tot-length-rhythmseq (truncate (/ tot-length-rhythmseq length-one-measure))) 0)
              (incf no-of-measures))
          (setf timesignseq (make-list no-of-measures :initial-element timesignseq))))

    (if (not timesignseq)
        (let* ((tot-length-rhythmseq (apply '+ (mapcar 'abs rhythmseq)))
               (no-of-measures (truncate tot-length-rhythmseq)))
          (if (/= (- tot-length-rhythmseq (truncate tot-length-rhythmseq)) 0)
              (incf no-of-measures))
          (setf timesignseq (make-list no-of-measures :initial-element '(4 4)))))
      

    (if velocity 
        (simple->tree-velocities rhythmseq pitchseq velocity timesignseq tempo)
      (simple->tree rhythmseq pitchseq  timesignseq tempo))    
))



(system::PWGLdef simplelayer->score ((timesignseq '(4 4)) (tempo 60) (rhythmseq '(1/4 1/4 1/4 1/4)) (pitchseq nil)
                                     &optional (rhythmseq2 '()) (pitchseq2 nil) 
                                     (rhythmseq3 '()) (pitchseq3 nil) 
                                     (rhythmseq4 '()) (pitchseq4 nil))
    "This function coverts lists of duration ratios and midi note numbers to a score object.

The box can be expanded to upto 4 voices. All voices will have the same metric 
structure and tempo. If only oa single time signature is given, this will be
used for the whole sequence. If no pitches are given, x noteheads will be used."
    (:extension-pattern '(2 2) :x-proportions '((0.65 0.35)(0.5 0.5)))

  (ccl::make-score
   (let* ((tot-length-rhythmseq1 (apply '+ (mapcar 'abs rhythmseq)))
          (tot-length-rhythmseq2 (apply '+ (mapcar 'abs rhythmseq2)))
          (tot-length-rhythmseq3 (apply '+ (mapcar 'abs rhythmseq3)))
          (tot-length-rhythmseq4 (apply '+ (mapcar 'abs rhythmseq4)))
          (tot-length-rhythmseq (max tot-length-rhythmseq1 tot-length-rhythmseq2 tot-length-rhythmseq3 tot-length-rhythmseq4)))



     (if (typep (first timesignseq) 'integer)
         (let* ((length-one-measure (apply '/ timesignseq))
                (no-of-measures (truncate (/ tot-length-rhythmseq length-one-measure))))
           (if (/= (- tot-length-rhythmseq (truncate (/ tot-length-rhythmseq length-one-measure))) 0)
               (incf no-of-measures))
           (setf timesignseq (make-list no-of-measures :initial-element timesignseq))))

     (if (not timesignseq)
         (let* ((no-of-measures (truncate tot-length-rhythmseq)))
           (if (/= (- tot-length-rhythmseq (truncate tot-length-rhythmseq)) 0)
               (incf no-of-measures))
           (setf timesignseq (make-list no-of-measures :initial-element '(4 4)))))
      
     (append (if rhythmseq  (simple->tree rhythmseq pitchseq timesignseq tempo))
             (if rhythmseq2  (simple->tree rhythmseq2 pitchseq2 timesignseq tempo))
             (if rhythmseq3  (simple->tree rhythmseq3 pitchseq3 timesignseq tempo))
             (if rhythmseq4  (simple->tree rhythmseq4 pitchseq4 timesignseq tempo)))
     )))



;;;; improve grouping;;;
(defun better-predefined-subdiv? (sub-tree)
  (let* ((proportional-list (cadr sub-tree))
        (pauses (mapcar #'(lambda (value) (if (< value 0) -1 1)) proportional-list))
        (abs-proportional-list (mapcar 'abs proportional-list))
        abs-answer)
    (setf abs-answer
          (cond ((equal abs-proportional-list '(2 2 2 3 3))
                 (list (list 2 (list (first pauses)(second pauses)(third pauses)))(fourth pauses)(fifth pauses)))
                ((equal abs-proportional-list '(3 3 2 2 2))
                 (list (list 2 (list (first pauses)(second pauses))) (list 2 (list (third pauses)(fourth pauses)(fifth pauses)))))
                ((equal abs-proportional-list '(3 2 2 2 3))
                 (list (first pauses)(list 2 (list (second pauses)(third pauses)(fourth pauses)))(fifth pauses)))
                ((equal abs-proportional-list '(3.0 2 2 2 3))
                 (list (coerce (first pauses) 'float)(list 2 (list (second pauses)(third pauses)(fourth pauses)))(fifth pauses)))
                ((equal abs-proportional-list '(3 3 4 2))
                 (list (first pauses)(second pauses)(list 2 (list (* 2 (third pauses))(fourth pauses)))))
                ((equal abs-proportional-list '(4 2 3 3))
                 (list (list 2 (list (* 2 (first pauses))(second pauses)))(third pauses)(fourth pauses)))
                ((equal abs-proportional-list '(2 4 3 3))
                 (list (list 2 (list (first pauses)(* 2 (second pauses))))(third pauses)(fourth pauses)))
                ((equal abs-proportional-list '(3 3 2 4))
                 (list (first pauses)(second pauses)(list 2 (list (third pauses)(* 2 (fourth pauses))))))
                ((equal abs-proportional-list '(3 1 1 1))
                 (list (first pauses)(list 1 (list (second pauses)(third pauses)(fourth pauses)))))
                ((equal abs-proportional-list '(3.0 1 1 1))
                 (list (coerce (first pauses) 'float)(list 1 (list (second pauses)(third pauses)(fourth pauses)))))
                ((equal abs-proportional-list '(1 1 1 3))
                 (list (list 1 (list (first pauses)(second pauses)(third pauses)))(fourth pauses)))
                (t proportional-list)))
    (list 1 abs-answer)))




;;;;;; With veocity

(defun pair-rhythm-pitch-and-velocity (rhythms pitches velocities)
  (mapcar #'(lambda (rhythm) (if (plusp rhythm)
                                 (list rhythm (pop pitches) (pop velocities))
                               (list rhythm nil)))
          rhythms))


(defun build-local-times-with-pitches-and-velocities (global-onsets-with-pitches-and-vel global-start)
       (mapcar #'(lambda (onset-pitch) (if (plusp (car onset-pitch))
                                           (list (- (car onset-pitch) (1- global-start)) (cadr onset-pitch) (caddr onset-pitch))
                                         (list (+ (car onset-pitch) (1- global-start)) (cadr onset-pitch))))
               global-onsets-with-pitches-and-vel))


(defun build-measure-seq-vel (abs-rhythms pitches velocities timesigns nr-colored-measures tempo)
  (let ((measure-start-points (patch-work::dx->x 1 (mapcar #'(lambda (timesign) (apply '/ timesign)) timesigns)))
        (abs-rhythm-with-pitches-and-velocities (pair-rhythm-pitch-and-velocity abs-rhythms pitches velocities))
        (nr-black-measures (- (length timesigns) nr-colored-measures)))


    (loop for measure from 0 to (1- (length timesigns))
          collect (let ((this-seq (filter-events-with-pitches-between (nth measure measure-start-points)
                                                                      (nth (1+ measure) measure-start-points)
                                                                      abs-rhythm-with-pitches-and-velocities))
                        (this-timesign (nth measure timesigns))
                        local-onset)
                    

                    ;check if measure starts with tied pause
                    ;if yes, add extra pause on startpoint of measure
                    (if (and this-seq
                             (/= (abs (car (first this-seq))) (nth measure measure-start-points))
                             (minusp (car (get-onsettime-with-pitch-before (nth measure measure-start-points) abs-rhythm-with-pitches-and-velocities))))
                        (setf this-seq (append (list (list (- 0 (nth measure measure-start-points)) nil))
                                               this-seq)))

                    ;check if measure empty and starts with tied pause
                    ;if yes, add pause on startpoint of measure
                    (if (and (not this-seq) 
                             (minusp (car (get-onsettime-with-pitch-before (nth measure measure-start-points) abs-rhythm-with-pitches-and-velocities))))
                        (setf this-seq (list (list (- 0 (nth measure measure-start-points)) nil))))

                    ;;SYNCOPATION 
                    ;check if measure starts with tied note
                    ;if yes, input pitch before startpoint of measure
                    (if (and this-seq
                             (/= (abs (car (first this-seq))) (nth measure measure-start-points))
                             (plusp (car (get-onsettime-with-pitch-before (nth measure measure-start-points) abs-rhythm-with-pitches-and-velocities))))
                        (setf this-seq (append (list (list 
                                                      (- (nth measure measure-start-points) 1/2) ;trick function to input syncopated pitch
                                                      (cadr (get-onsettime-with-pitch-before 
                                                             (nth measure measure-start-points) 
                                                             abs-rhythm-with-pitches-and-velocities))))
                                               this-seq)))

                    ;check if measure is empty and starts with tied note
                    ;if yes, input pitch before startpoint of measure
                    (if (and (not this-seq) 
                             (plusp (car (get-onsettime-with-pitch-before (nth measure measure-start-points) abs-rhythm-with-pitches-and-velocities))))
                        (setf this-seq (list (list 
                                              (- (nth measure measure-start-points) 1/2) ;trick function to input syncopated pitch
                                              (cadr (get-onsettime-with-pitch-before 
                                                     (nth measure measure-start-points) 
                                                     abs-rhythm-with-pitches-and-velocities))))))
                    


                    (let ((local-onset-with-pitches-and-vel (build-local-times-with-pitches-and-velocities this-seq (nth measure measure-start-points))))
                    

                      (if (<  measure nr-black-measures)
                          (build-one-measure-with-pitches-and-vel local-onset-with-pitches-and-vel 
                                                                  (car this-timesign)
                                                                  (/ 1 (cadr this-timesign))
                                                                  nil
                                                                  tempo)
                        (build-one-measure-with-pitches-and-vel local-onset-with-pitches-and-vel
                                                                (car this-timesign)
                                                                (/ 1 (cadr this-timesign))
                                                                t
                                                                tempo)))))))


(defun simple->tree-velocities (rhythmseq pitchseq velocities timesignseq tempo)
  (let ((abs-rhythms (dx-x-pause-ok 1 (fuse-pauses-in-input (append rhythmseq '(-100))))))
     (list (list (fuse-gracenotes (list (list (build-measure-seq-vel abs-rhythms pitchseq velocities timesignseq 0 tempo))))))
))




(defun build-one-measure-with-pitches-and-vel (local-onset-with-pitches-and-vel no-of-beats beat-length colorflag tempo)
  (let ((beatlist (patch-work::dx->x 1 (make-list no-of-beats :initial-element beat-length)))
        tree)    
    (setf tree
          (fuse-pauses-and-tied-notes-between-beats
            (loop for beat-nr from 0 to (1- no-of-beats)
                 collect (let ((these-events (filter-events-with-pitches-between (nth beat-nr beatlist)
                                                                                 (nth (1+ beat-nr) beatlist)
                                                                                 local-onset-with-pitches-and-vel)))                           

                           ;check if pause before beat goes in to the current beat  - if yes: give startpoint as pause
                           (if (and these-events
                                    (/= (abs (car (first these-events))) (nth beat-nr beatlist))
                                    (get-onsettime-with-pitch-before (nth beat-nr beatlist) local-onset-with-pitches-and-vel)
                                    (minusp (car (get-onsettime-with-pitch-before (nth beat-nr beatlist) local-onset-with-pitches-and-vel))))
                               (setf these-events (append (list (list (- 0 (nth beat-nr beatlist)) nil))
                                                          these-events))) 

                           ;check if pause before beat goes into the current beat AND remains throughout 
                           ;the current beat - if yes: give startpoint as pause

                           

                           (if (and (not these-events)
                                    (get-onsettime-with-pitch-before (nth beat-nr beatlist) local-onset-with-pitches-and-vel)
                                    (minusp (car (get-onsettime-with-pitch-before (nth beat-nr beatlist) local-onset-with-pitches-and-vel))))
                               (setf these-events (list (list (- 0 (nth beat-nr beatlist)) nil))))
                           


                           (if (or (and these-events
                                        (/= (abs (car (first these-events))) (nth beat-nr beatlist)));start is syncopation - get pitch for first event
                                   (not these-events));no event in beat - start is syncopation (since pause is ruled out above)
                               (progn (setf syncopated-pitch 
                                            (list (second (get-onsettime-with-pitch-before (nth beat-nr beatlist) local-onset-with-pitches-and-vel))))
                                 (create-beat-with-pitches-and-vel (mapcar 'car these-events) 
                                                                   (nth beat-nr beatlist) 
                                                                   beat-length 
                                                                   (append syncopated-pitch (mapcar 'cadr these-events))
                                                                   (append '(nil) (mapcar 'caddr these-events))))
                                     
                         (create-beat-with-pitches-and-vel (mapcar 'car these-events)
                                                           (nth beat-nr beatlist) 
                                                           beat-length 
                                                           (mapcar 'cadr these-events) 
                                                           (mapcar 'caddr these-events)))))
           no-of-beats)
          )
    
    
    (if colorflag
        (append (list ':low (/ 1 beat-length) ':metronome-value tempo) tree (list :color *extra-measure-color*))
      (append (list ':low (/ 1 beat-length) ':metronome-value tempo) tree))))





(defun create-beat-with-pitches-and-vel (global-onset global-start beat-length pitches velocities)

  (loop while (and (> (length global-onset) 1) (= (abs (car (last global-onset))) (+ global-start beat-length)))  ;;;; this is for gracenotes
        do (setf global-onset (butlast global-onset)))


  (let ((local-onset (build-local-times global-onset global-start))
        sub-tree)
    
    (if (not local-onset) (setf local-onset (list (1+ beat-length)))) ;empty = syncopation

    (if (<= (car (last local-onset)) (- -1 beat-length))               
        (setf local-onset (append (butlast local-onset) (list (1+ beat-length))))) ;pause starts on (or after) beat ending

    (if (/= (car (last local-onset)) (1+ beat-length))
        (setf local-onset (append local-onset (list (1+ beat-length))))) ;beat ending needed as an event for calculation


    (setf sub-tree (make-sub-tree local-onset))
    (setf sub-tree (better-predefined-subdiv? sub-tree))
   ; (system::pwgl-print (list (car sub-tree) (append-pitch3-and-vel (cadr sub-tree) pitches velocities)))
    (list (car sub-tree) (append-pitch3-and-vel (cadr sub-tree) pitches velocities))
    ))



(defun append-pitch3-and-vel (proportion-list pitches velocities)
  "append-pitch2 can handle subtrees (one level)"
  (mapcar #'(lambda (proportion) (if (listp proportion) ;subtree exist
                                     (list (car proportion) 
                                           (mapcar #'(lambda (subproportion)
                                                       (if (or (plusp subproportion) (= 0 subproportion))
                                                           (if (car pitches)
                                                               (if (plusp subproportion)
                                                                   (list subproportion ':notes (list (list (pop pitches) ':vel (pop velocities)))) 
                                                                 (list 1 (list (list 1 ':notes (list (list (pop pitches) ':vel (pop velocities))))) ':class ':grace-beat))
                                                             (if (plusp subproportion)
                                                                 (list subproportion ':notes (list *default-nothead-no-pitch*))
                                                               (list 1 (list (list 1 ':notes (list *default-nothead-no-pitch*))) ':class ':grace-beat)))
                                                         (progn (pop pitches) subproportion))) ;pause in subtree
                                                   (cadr proportion)))

                                   (if (or (plusp proportion) (= 0 proportion))
                                       (if (and (car pitches) (car velocities))
                                           (if (plusp proportion)
                                               (list proportion ':notes (list (list (pop pitches) ':vel (pop velocities)))) 
                                             (list 1 (list (list 1 ':notes (list (list (pop pitches) ':vel (pop velocities))))) ':class ':grace-beat))
                                         (if (car pitches)
                                             (progn (pop velocities)
                                               (if (plusp proportion)
                                                   (list proportion ':notes (pop pitches))
                                                 (list 1 (list (list 1 ':notes (pop pitches))) ':class ':grace-beat)))
                                           (if (plusp proportion) 
                                               (list proportion ':notes (list *default-nothead-no-pitch*))
                                             (list 1 (list (list 1 ':notes (list *default-nothead-no-pitch*))) ':class ':grace-beat))))
                                     (progn (pop pitches) (pop velocities) proportion)))) ;pause
          proportion-list))


;;;;; improve gracenote notation (gracenote in immediate sequence will notate correctly;;;

(defun fuse-gracenotes (tree)
  (re-combine-tree
   (mapcar 'measureinfo (caar tree))
   (mapcar 'beats-lengths (caar tree))
   (mapcar 'fuse-grace-notes-1measure (caar tree)))
  )

;;

(defun measureinfo (measure)
  (subseq measure 0 4))

(defun beats-sublists (measure)
  (cddddr measure))

;;

(defun beats-lengths (measure)
  (mapcar 'car (beats-sublists measure)))

(defun beats-content (measure)
  (mapcar 'cadr (beats-sublists measure)))

;;

(defun test-gracenote (events)
  (mapcar #'(lambda (event)
              (if (listp event)
                  (equal (last event) '(:grace-beat))
                nil))
          events))

(defun fuse-grace-notes-1measure (measure)
  (mapcar 'fuse-grace-notes-1beat (beats-content measure)))

(defun fuse-grace-notes-1beat (beat)
  (let ((result-beat nil)
        (last-event nil)
        (last-event-gracenote? nil))
    (dolist (event beat)
       (if (listp event)
           (if (equal (last event) '(:grace-beat))
               (progn (if last-event-gracenote?
                          (setf (first (last result-beat))
                                (fuse-two-gracenotes (first (last result-beat)) event))
                        (setf result-beat (append result-beat (list event))))
                 (setf last-event-gracenote? t) t)
             (progn (setf last-event-gracenote? nil)
               (setf result-beat (append result-beat (list event)))))
         (progn (setf last-event-gracenote? nil)
           (setf result-beat (append result-beat (list event)))))
      (setf last-event event))
    result-beat))
    

(defun fuse-two-gracenotes (firstgracenote secondgracenote)
  (setf firstgracenote (second firstgracenote))
  (setf secondgracenote (second secondgracenote))
  (list 1 (append firstgracenote secondgracenote) ':class ':grace-beat))


(defun re-combine-tree (measureinfos beatlengths sublists)
  (loop for measureinfo in measureinfos
        for measure-beat-lengths in beatlengths
        for measure-beats in sublists
        
        collect (append measureinfo (mapcar 'list measure-beat-lengths measure-beats))))
    
