;;;functions
(in-package MC)



(defun check-max-in-seq-old (rytmseq timeline max-deviation 
                                 max-ornaments max-skips)
  (let ((nr-ornaments 0)
        (nr-skips 0))
    (loop while (and rytmseq (>= max-ornaments nr-ornaments) (>= max-skips nr-skips))
          do (if (<= (- (car rytmseq) max-deviation) (car timeline))
               (if (>= (+ (car rytmseq) max-deviation) (car timeline))
                 (progn (pop rytmseq) (pop timeline) (setf nr-ornaments 0) (setf nr-skips 0))
                 (progn (pop rytmseq) (incf nr-ornaments)))
               (progn (incf nr-skips) (pop timeline))))
    (and (>= max-ornaments nr-ornaments) (>= max-skips nr-skips))))


(defun check-max-in-seq (rytmseq timeline max-deviation rhythm-end
                                 max-ornaments max-skips)
  (let ((nr-ornaments 0)
        (nr-skips 0))
    (loop while (and rytmseq timeline (>= max-ornaments nr-ornaments) (>= max-skips nr-skips))
          do (if (<= (- (car rytmseq) max-deviation) (car timeline))
               (if (>= (+ (car rytmseq) max-deviation) (car timeline))
                 (progn (pop rytmseq) (pop timeline) (setf nr-ornaments 0) (setf nr-skips 0))
                 (progn (pop rytmseq) (incf nr-ornaments)))
               (progn (incf nr-skips) (pop timeline))))
    
    (loop while (and timeline (>= max-skips nr-skips) (> (- rhythm-end max-deviation) (car timeline)))
          do (progn (incf nr-skips) (pop timeline)))
    
    (and (>= max-ornaments nr-ornaments) (>= max-skips nr-skips))))




(defun check-max-in-seq-and-total (rytmseq timeline max-deviation rhythm-end
                                           max-ornaments max-skips max-tot-ornaments max-tot-skips)
  (let ((nr-ornaments 0)
        (tot-nr-ornaments 0)     
        (nr-skips 0)   
        (tot-nr-skips 0))
    (loop while (and rytmseq timeline (>= max-ornaments nr-ornaments) (>= max-skips nr-skips) 
                     (>= max-tot-ornaments tot-nr-ornaments) (>= max-tot-skips tot-nr-skips))
          do (if (<= (- (car rytmseq) max-deviation) (car timeline))
               (if (>= (+ (car rytmseq) max-deviation) (car timeline))
                 (let ((x)) (pop rytmseq) (pop timeline) (setf nr-ornaments 0) (setf nr-skips 0))
                 (let ((x)) (pop rytmseq) (incf nr-ornaments) (incf tot-nr-ornaments)))
               (let ((x)) (incf nr-skips) (incf tot-nr-skips) (pop timeline))))
    
    (loop while (and timeline (>= max-skips nr-skips) (>= max-tot-skips tot-nr-skips) 
                     (> (- rhythm-end max-deviation) (car timeline)))
          do (progn (incf nr-skips) (pop timeline)))
    
    (and (>= max-ornaments nr-ornaments) (>= max-skips nr-skips) 
         (>= max-tot-ornaments tot-nr-ornaments) (>= max-tot-skips tot-nr-skips))))

;(check-max-in-seq-and-total-w.rests (fuse-pauses-in-input '(0 1 9/4 5/2 7/2 -5 -6 7)) '(0 1 2.4 2.43 3.5 -5.1 7.0) 1/4 7 0 0 0 0)

(defun check-max-in-seq-and-total-w.rests (rytmseq timeline max-deviation rhythm-end
                                                   max-ornaments max-skips max-tot-ornaments max-tot-skips)
  (let ((nr-ornaments 0)
        (tot-nr-ornaments 0)     
        (nr-skips 0)   
        (tot-nr-skips 0))

    (loop while (and rytmseq timeline (>= max-ornaments nr-ornaments) (>= max-skips nr-skips) 
                     (>= max-tot-ornaments tot-nr-ornaments) (>= max-tot-skips tot-nr-skips))
          do (if (and (<= (- (abs (car rytmseq)) max-deviation) (abs (car timeline)))       ;if rytmseq length = 2 and rythm = rest and next dur < next timepoint
                      (if (> (length rytmseq) 1) (equal (minusp (car rytmseq)) (minusp (car timeline))) t)) ;don't check sign for endpoint
                 (if (>= (+ (abs (car rytmseq)) max-deviation) (abs (car timeline)))
                     (progn (if (and (= 2 (length rytmseq)) (minusp (car rytmseq)) (cadr timeline) (< (cadr rytmseq) (abs (cadr timeline))))
                                (pop rytmseq))
                       (pop rytmseq) (pop timeline) (setf nr-ornaments 0) (setf nr-skips 0))
                   (progn (pop rytmseq) (incf nr-ornaments) (incf tot-nr-ornaments)))
               (progn (incf nr-skips) (incf tot-nr-skips) (pop timeline))))

    (loop while (and timeline (>= max-skips nr-skips) (>= max-tot-skips tot-nr-skips) 
                     (> (- rhythm-end max-deviation) (abs (car timeline))))
          do (progn (incf nr-skips) (pop timeline)))
    
    (and (>= max-ornaments nr-ornaments) (>= max-skips nr-skips) 
         (>= max-tot-ornaments tot-nr-ornaments) (>= max-tot-skips tot-nr-skips))))


(defun fuse-pauses-in-timeline (seq)
  (let ((flag nil))
    (remove nil (loop for n from 0 to (1- (length seq))
          collect (let ((x (nth n seq)))
                    (if (and flag (minusp x))
                        (progn (setf flag t) nil)
                      (if (minusp x) (progn (setf flag t) x)
                        (progn (setf flag nil) x))))))))
                     

;(fuse-pauses-in-timeline '(0 1 -2 -3 4 -5 -6))
(defun quant-max-in-seq-and-total-w.rests-rule (layer-nr timeline tempo max-deviation 
                                                         max-ornaments max-skips
                                                         max-tot-ornaments max-tot-skips)
  (let ((max-deviation-sec (/ (* 240 max-deviation) tempo)))
    (list
     #'(lambda (indexx x)

         (if (and (= layer-nr (get-layer-nr x)) (typep x 'rhythmcell))
                     
             (let* ((start-this-cell (get-total-duration-rhythms-at-index layer-nr (1- indexx)))
                  ;(start-this-cell (1+ (get-stop-time this-voice-nr layer-nr (1- indexx))))

                    (stop-this-cell (+ start-this-cell (get-variabledur x)))
                  ;(stop-this-cell (1- (+ start-this-cell (get-variabledur x))))
                  ;(this-glogal-cell (system::g* (system::g+ start-this-cell (get-local-onset-without-pauses x))
                   ;                          (append (get-pauses x) '(1))))
                  ;(this-glogal-cell (system::g* (system::g+ start-this-cell (get-local-onset x))
                  ;                           (append (get-pauses x) '(1))))
                    (onsets-in-rhythm-with-pauses (fuse-pauses-in-timeline (get-one-rhythmlayer-at-index layer-nr indexx))) ;fuse-pauses from PWGLsimple-to-tree
                  ;(onsets-in-rhythm (remove nil (mapcar #'(lambda (x) (if (minusp x) nil x)) onsets-in-rhythm-with-pauses)))
                  ;as in hierarchy-rule - see Rules.lisp
                    (onsets-sec-in-rhythm  (system::g*  (system::g/ (system::g* 240 (system::g- (system::g-abs onsets-in-rhythm-with-pauses) 1)) tempo) 
                                                       (mapcar #'(lambda (x) (if (minusp x) -1 1)) onsets-in-rhythm-with-pauses)))  
                    
                    (stop-time (/ (* 240 stop-this-cell) tempo)))
             
               (and (check-max-in-seq-and-total-w.rests onsets-sec-in-rhythm timeline max-deviation-sec stop-time
                                                        max-ornaments max-skips max-tot-ornaments max-tot-skips)
                    (not (minusp (first onsets-in-rhythm-with-pauses)))))
           t)))
    ))


(defun quant-max-in-seq-and-total-rule (layer-nr timeline tempo max-deviation 
                                                 max-ornaments max-skips
                                                 max-tot-ornaments max-tot-skips)
  
  (let ((max-deviation-sec (/ (* 240 max-deviation) tempo)))
    (list
     #'(lambda (indexx x)

         (if (and (= layer-nr (get-layer-nr x)) (typep x 'rhythmcell))
                     
           (let* ((start-this-cell (get-total-duration-rhythms-at-index layer-nr (1- indexx)))
                  ;(start-this-cell (1+ (get-stop-time this-voice-nr layer-nr (1- indexx))))

                  (stop-this-cell (+ start-this-cell (get-variabledur x)))
                  ;(stop-this-cell (1- (+ start-this-cell (get-variabledur x))))
                  ;(this-glogal-cell (system::g* (system::g+ start-this-cell (get-local-onset-without-pauses x))
                   ;                          (append (get-pauses x) '(1))))
                  ;(this-glogal-cell (system::g* (system::g+ start-this-cell (get-local-onset x))
                  ;                           (append (get-pauses x) '(1))))
                  (onsets-in-rhythm-with-pauses (get-one-rhythmlayer-at-index layer-nr indexx))
                  (onsets-in-rhythm (remove nil (mapcar #'(lambda (x) (if (minusp x) nil x)) onsets-in-rhythm-with-pauses)))
                  ;as in hierarchy-rule - see Rules.lisp
                  (onsets-sec-in-rhythm  (system::g/ (system::g* 240 (system::g- onsets-in-rhythm 1)) tempo))                 
                  (stop-time (/ (* 240 stop-this-cell) tempo)))
             
             (check-max-in-seq-and-total onsets-sec-in-rhythm timeline max-deviation-sec stop-time
                                         max-ornaments max-skips max-tot-ornaments max-tot-skips))
           t)))
    ))

;(remove nil (mapcar #'(lambda (x) (if (minusp x) nil x)) truncated-onset-list))

(system::PWGLDef r-quant ((layer-nr 0)
                          (timeline nil)
                          (tempo 60)
                          (max-deviation 1/32)
                          (max-ornaments 0)
                          (max-skips 0)
                          (max-tot-ornaments 0)
                          (max-tot-skips 0))
   
    "Rule for quantifying a sequence of events (onsets) to 
proportional durations. The settings for ornaments and 
skips will allow the quantification to be more flexible.

Pauses are not 100% supported.

<layer-nr> is the layer number for the layer that contains the quantified 
           rhythm.
<timeline> is the sequence of events as a list of timevalues (seconds).
<tempo> is the tempo for the quantified rhythm (quarternotes per minute). 
<max-deviation> is the maximum allowed deviation from the timeline 
           (a notevalue as a ratio, for example 1/32).
<max-ornaments> is the maximum number of ornamental events in the 
           quantified rhythm between two events in the timeline.
           If set to 0 every event in the quantified rhythm must 
           correspond to an event in the timeline.
<max-skips> is the maximum number of events in immediate sequence
           in the timeline that can be ignored in the quantified rhythm.
           If set to 0 every event in the timeline must 
           correspond to an event in the quantified rhythm.
<max-tot-ornaments> is the maximum number of all ornamental events in the 
           whole answer.
<max-tot-skips> is the maximum number of events in the timeline that can 
           be ignored in the quantified rhythm.
"
    (:groupings '(2 2 4) :x-proportions '((1 1)(1 1)(1 1 1 1)))
   
  (quant-max-in-seq-and-total-w.rests-rule layer-nr (system::pwgl-print (fuse-pauses-in-timeline timeline)) tempo max-deviation 
                                           max-ornaments max-skips
                                           max-tot-ornaments max-tot-skips))






;;;;;;;;;
(defun heur-check-deviation (rytmseq timeline max-deviation rhythm-end)
  
  (let ((averagre-deviation 0))
    (loop while (and rytmseq timeline)
          do (if (<= (- (car rytmseq) max-deviation) (car timeline))
               (if (>= (+ (car rytmseq) max-deviation) (car timeline))
                 (progn (setf averagre-deviation 
                              (/ (+ (abs (- (car rytmseq) (car timeline)))
                                    averagre-deviation)
                                 2))
                        (pop rytmseq) (pop timeline))
                 (pop rytmseq))
               (pop timeline)))
    
    (/ 1 (1+ (* 10 averagre-deviation)))
    ))




;heur-check-deviation-w.rests
(defun heur-check-deviation-w.rests (rytmseq timeline max-deviation rhythm-end)
  (let ((averagre-deviation 0))
    (loop while (and rytmseq timeline)
          do (if (<= (- (abs (car rytmseq)) max-deviation) (abs (car timeline)))
                 (if (>= (+ (abs (car rytmseq)) max-deviation) (abs (car timeline)))
                      (progn (setf averagre-deviation  
                                   (/ (+ (abs (- (abs (car rytmseq)) (abs (car timeline))))
                                         averagre-deviation)
                                      2))
                        (pop rytmseq) (pop timeline))
                   (pop rytmseq))
               (pop timeline))
          )
    
    (/ 1 (1+ (* 10 averagre-deviation)))
    ))


(defun heur-min-deviation (layer-nr timeline tempo max-deviation factor)
  
  (let ((max-deviation-sec (/ (* 240 max-deviation) tempo)))
    (list
     #'(lambda (indexx x)
         (if (and (= layer-nr (get-layer-nr x)) (typep x 'rhythmcell))
           (let* ((start-this-cell (get-total-duration-rhythms-at-index layer-nr (1- indexx)))
                  (stop-this-cell (+ start-this-cell (get-variabledur x)))
                  (onsets-in-rhythm-with-pauses (get-one-rhythmlayer-at-index layer-nr indexx))
                  (onsets-in-rhythm (remove nil (mapcar #'(lambda (x) (if (minusp x) nil x)) onsets-in-rhythm-with-pauses)))
                  ;as in hierarchy-rule - see Rules.lisp
                  (onsets-sec-in-rhythm (system::g/ (system::g* 240 (system::g- onsets-in-rhythm 1)) tempo))
                  (stop-time (/ (* 240 stop-this-cell) tempo)))
             
              (* factor (heur-check-deviation onsets-sec-in-rhythm timeline max-deviation-sec stop-time)))
           0)))
    ))

;(get-one-rhythmlayer-at-index 0 15)
;(system::g/ (system::g* 240 (system::g- (get-one-rhythmlayer-at-index 0 15) 1)) 60)
(defun heur-min-deviation-w.rests (layer-nr timeline tempo max-deviation factor)
  
  (let ((max-deviation-sec (/ (* 240 max-deviation) tempo)))
    (list
     #'(lambda (indexx x)
         (if (and (= layer-nr (get-layer-nr x)) (typep x 'rhythmcell))
             (let* ((start-this-cell (get-total-duration-rhythms-at-index layer-nr (1- indexx)))
                    (stop-this-cell (+ start-this-cell (get-variabledur x)))
                    (onsets-in-rhythm-with-pauses  (fuse-pauses-in-timeline (get-one-rhythmlayer-at-index layer-nr indexx)))
               ;     (onsets-in-rhythm-with-pauses   (get-one-rhythmlayer-at-index layer-nr indexx))
                  ;(onsets-in-rhythm (remove nil (mapcar #'(lambda (x) (if (minusp x) nil x)) onsets-in-rhythm-with-pauses)))
                  ;as in hierarchy-rule - see Rules.lisp  
                    (onsets-sec-in-rhythm  (system::g*  (system::g/ (system::g* 240 (system::g- (system::g-abs onsets-in-rhythm-with-pauses) 1)) tempo) 
                                                        (mapcar #'(lambda (x) (if (minusp x) -1 1)) onsets-in-rhythm-with-pauses)))
                    (stop-time (/ (* 240 stop-this-cell) tempo)))
             
               (* factor (heur-check-deviation-w.rests onsets-sec-in-rhythm  timeline max-deviation-sec stop-time)))
           0)))
    ))


(system::PWGLDef hr-quant_dev ((layer-nr 0)
                               (timeline nil)
                               (tempo 60)
                               (max-deviation 1/32)
                               (factor 1))

"This heuristic rules should be used together with r-quant.

hr-quant_dev will try to minimize deviations from the timeline. 
OBS: this rule has to be connected to the heuristic-rules 
input (see the manual).

An exact match will give the weight 1.

Deviations will give the weight 1/(1 + deviation), where deviation 
is measured in 1/10 seconds.

<factor> will be multiplied to the weight to allow the output to
be balanced to other heuristic rule.

Example: 0.1 sec deviation will give the weight 0.5, 0.3 sec deviation will give the weight 0.25.
"
(:groupings '(2 2 1) :x-proportions '((1 1)(1 1)(1)))
  
  
  (if (not factor) (setf factor 1))
  (heur-min-deviation-w.rests layer-nr (fuse-pauses-in-timeline timeline) tempo max-deviation factor))

