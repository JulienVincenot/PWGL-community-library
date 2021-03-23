(in-package MC)

(defun get-time-for-rhythm (indexx x)
  (let ((layer (get-layer-nr x)))
  (get-total-duration-rhythms-at-index layer (1- indexx))))



(defun get-time-at-nthpitch (layer index nth)
  (let* ((local-pointer (get-localpointer-at-nthrhythm layer (1- index) nth));1- for index since the rhythm must have existed before
         (time+1 (if local-pointer
                     (aref part-sol-vector layer local-pointer *ONSETTIME*))))
    (if time+1 (1- time+1))))

(defun get-time-for-pitch (indexx x)
  (let* ((layer (get-layer-nr x))
         (pitchnr (get-number-of-pitches-at-index layer (1- indexx))));gives nth pitch for the first in the new cell
    (get-time-at-nthpitch layer indexx pitchnr)))



(defun get-endtime-at-nthpitch (layer index nth)
  (let* ((local-pointer (get-localpointer-at-nthrhythm layer (1- index) nth));1- for index since the rhythm must have existed before
         (time+1 (if local-pointer
                     (abs (aref part-sol-vector layer (1+ local-pointer) *ONSETTIME*)))))
    (if time+1 (1- time+1))))

(defun get-endtime-for-pitch (indexx x)
  (let* ((layer (get-layer-nr x))
         (pitchnr (get-number-of-pitches-at-index layer indexx)));gives (1+ nth) pitch for the last pitch in tis cell
    (get-endtime-at-nthpitch layer indexx (1- pitchnr))))


;(number-of-rhythms (get-number-of-rhythms-at-index layer index))
(defun get-endtime-or-last-at-nthpitch (layer index endnth startnth)
"If endtim does not exist, the last existing time before startnth is returned"
  (let* ((local-pointer (get-localpointer-at-nthrhythm layer (1- index) endnth));1- for index since the rhythm must have existed before
         (time+1 (if local-pointer
                     (abs (aref part-sol-vector layer (1+ local-pointer) *ONSETTIME*)))))
    (if time+1 (1- time+1)
      (let ((number-of-rhythms (get-number-of-rhythms-at-index layer (1- index))))
        (if (> number-of-rhythms (1+ startnth))
            (get-endtime-at-nthpitch layer index (1- number-of-rhythms)))))))

(defun get-endtime-or-last-for-pitch (indexx x)
"If endtim does not exist, the last existing time in pitchcell is returned"
  (let* ((layer (get-layer-nr x))
         (endpitchnr (get-number-of-pitches-at-index layer indexx));gives (1+ nth) pitch for the last pitch in tis cell
         (startpitchnr (get-number-of-pitches-at-index layer (1- indexx))));gives nth pitch for the first pitch in tis cell
    (get-endtime-or-last-at-nthpitch layer indexx (1- endpitchnr) startpitchnr)))

;(get-number-of-rhythms-at-index 0 0)
;(get-number-of-pitches-at-index 1 10)
;(get-endtime-or-last-at-nthpitch 1 10 6 0)
;(get-localpointer-at-nthrhythm 1 24 11)
;(defun get-time-for-barline (indexx x)
;  (get-total-duration-timesigns-at-index (1- indexx)))


(defun get-starttime (indexx x)
  (cond ((typep x 'rhythmcell)
         (get-time-for-rhythm indexx x))
        ((typep x 'pitchcell)
         (get-time-for-pitch indexx x))
        ((typep x 'timesign)
         (get-total-duration-timesigns-at-index (1- indexx)))))

(defun get-stoptime (indexx x)
  (cond ((typep x 'rhythmcell)
         (get-time-for-rhythm (1+ indexx) x))
        ((typep x 'pitchcell)
         (get-endtime-for-pitch indexx x))
        ((typep x 'timesign)
         (get-total-duration-timesigns-at-index indexx))))

(defun get-stoptime2 (indexx x)
"If stoptime exist INSIDE pitchcell (not last pitch), last existing stoptime will be returned"
  (cond ((typep x 'rhythmcell)
         (get-time-for-rhythm (1+ indexx) x))
        ((typep x 'pitchcell)
         (get-endtime-or-last-for-pitch indexx x))
        ((typep x 'timesign)
         (get-total-duration-timesigns-at-index indexx))))

;(get-total-duration-timesigns-at-index 0)






(defun find-beat-onsets-between-timepoints2 (spanstart spanstop subdiv index)
  "Gives all beats (from measure) that the timespan covers. Beat starts from the beginning of
the first measure where the timespan starts, and ends at the last beat in the last measure.
In this way some extra beats might be included.

OBS: spanstart and spanstop counts from time 0, but beat onsets are returned from time 1."
  (let ((timesigns nil) (starttimes nil))
    (if (> (get-total-duration-timesigns-at-index index) spanstart) ;check if measure exist
        (let ((all-local-pointers (remove nil (remove-duplicates 
                                               (loop for this-index from 1 to index
                                                     collect (aref pointers-vector *TIMESIGNLAYER* this-index *ONSETTIME* *STARTPOINTER*))))))
          (if all-local-pointers
              (loop for n from 0 to (1- (length all-local-pointers))         ;loop until timesign is found
                    while (let* ((pointer (nth n all-local-pointers))
                                 (this-m-starttime (aref part-sol-timegridvector *GRIDPOINTS* pointer))
                                 (this-timesign (aref part-sol-timegridvector *TIMESIGN* pointer))
                                 (this-m-stoptime (+ this-m-starttime (apply '/ this-timesign))))
                            (if (and (> this-m-stoptime (1+ spanstart))(<= this-m-starttime (1+ spanstop)))
                                (progn (setf timesigns (append timesigns (list this-timesign)))
                                  (setf starttimes (append starttimes (list this-m-starttime)))))
                            (if (> this-m-starttime (1+ spanstop)) nil t)))
            )))
    (if timesigns 
        (butlast 
         (ratios-to-onsets-with-offset 
          (first starttimes)
          (apply 'append (loop for m in timesigns
                               collect (make-list (* subdiv (first m)) :initial-element (/ 1 (* subdiv (second m))))))))
         nil)))
                                                                  
                                                                         
                       



;;;;;

(defun pitch-on-beat-rule3 (highlayernr lowlayernr subdiv testfn) 
"Checks pitches which has their ONSETS on a beat (or subdiision of beat)."
   #'(lambda (indexx x)
       (let ((this-layer-nr (get-layer-nr x))
             (start-this-cell (get-starttime indexx x)) ;1+ to compensate for global offset 
             (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for global offset
             high-layer-onset-times
             low-layer-onset-times
             beat-onsets
             intersection)

         (cond ((or (and (or (= this-layer-nr highlayernr) 
                             (= this-layer-nr lowlayernr))
                         stop-this-cell)
                    (typep x 'timesign))  ;check that time for pitch event is assigned
                (setf beat-onsets (find-beat-onsets-between-timepoints2 start-this-cell stop-this-cell subdiv indexx))
                ;(setf high-layer-onset-times (butlast (get-one-rhythmlayer-at-index highlayernr indexx)))
                (setf low-layer-onset-times (butlast (get-one-rhythmlayer-at-index lowlayernr indexx)))
                ;not necessary to remove pauses (because of intersection), butlast to remove offset.
                (setf high-layer-onset-times (butlast (get-one-rhythmlayer-at-index highlayernr indexx)))

                          ;(get-nrs-for-rhythms-from-vector-between-timepoints 0 16/8 16/8 20) 
                ;(get-ordernr-for-onsets-from-vector-at-timepoints 0 '(17/8) 8)
                (setf intersection 
                      (reverse (fast-band-filter (1+ start-this-cell)
                                              (1+ (- stop-this-cell 1/1000))
                                              (sort (intersection beat-onsets (append low-layer-onset-times high-layer-onset-times))'<))))
                (if intersection
                    (let ((high-layer-evt-nrs (get-ordernr-for-onsets-from-vector-at-timepoints 
                                              highlayernr intersection (get-number-of-rhythms-and-pauses-at-index highlayernr indexx)))
                          (low-layer-evt-nrs (get-ordernr-for-onsets-from-vector-at-timepoints 
                                              lowlayernr intersection (get-number-of-rhythms-and-pauses-at-index lowlayernr indexx))))  
                      (eval (append '(and) 
                                    (loop for n from 0 to (1- (length intersection))
                                          collect (let ((low-layer-evt-nr (nth n low-layer-evt-nrs))
                                                        (high-layer-evt-nr (nth n high-layer-evt-nrs)))
                                                  (if (and high-layer-evt-nr low-layer-evt-nr)
                                                      (let ((high-layer-pitch (car (get-pitch-at-nthrhythm highlayernr indexx high-layer-evt-nr)))
                                                            (low-layer-pitch (car (get-pitch-at-nthrhythm lowlayernr indexx low-layer-evt-nr))))  
                                                        
                                                        (if (and high-layer-pitch low-layer-pitch)
                                                            (if (funcall testfn high-layer-pitch low-layer-pitch) t nil)
                                                          t))
                                                    t))))))
                  t))                               
               (t t)))))

;;;;

(defun pitch-on-beat-heuristicrule3 (highlayernr lowlayernr subdiv testfn) 

   #'(lambda (indexx x)
       (let ((this-layer-nr (get-layer-nr x))
             (start-this-cell (get-starttime indexx x)) ;1+ to compensate for global offset 
             (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for global offset
             high-layer-onset-times
             low-layer-onset-times
             beat-onsets
             intersection)

         (cond ((or (and (or (= this-layer-nr highlayernr) 
                             (= this-layer-nr lowlayernr))
                         stop-this-cell)
                    (typep x 'timesign))  ;check that time for pitch event is assigned
                (setf beat-onsets (find-beat-onsets-between-timepoints2 start-this-cell stop-this-cell subdiv indexx))
                ;(setf high-layer-onset-times (butlast (get-one-rhythmlayer-at-index highlayernr indexx)))
                (setf low-layer-onset-times (butlast (get-one-rhythmlayer-at-index lowlayernr indexx)))
                ;not necessary to remove pauses (because of intersection), butlast to remove offset.
                (setf high-layer-onset-times (butlast (get-one-rhythmlayer-at-index highlayernr indexx)))

                                              
                (setf intersection 
                      (reverse (fast-band-filter (1+ start-this-cell)
                                              (1+ (- stop-this-cell 1/1000))
                                              (sort (intersection beat-onsets (append low-layer-onset-times high-layer-onset-times)) '<))))
                (if intersection
                    (let ((high-layer-evt-nrs (get-ordernr-for-onsets-from-vector-at-timepoints 
                                              highlayernr intersection (get-number-of-rhythms-and-pauses-at-index highlayernr indexx)))
                          (low-layer-evt-nrs (get-ordernr-for-onsets-from-vector-at-timepoints 
                                              lowlayernr intersection (get-number-of-rhythms-and-pauses-at-index lowlayernr indexx))))  
                      (apply '+
                             (loop for n from 0 to (1- (length intersection))
                                   collect (let ((low-layer-evt-nr (nth n low-layer-evt-nrs))
                                                 (high-layer-evt-nr (nth n high-layer-evt-nrs)))
                                             (if (and high-layer-evt-nr low-layer-evt-nr)
                                                 (let ((high-layer-pitch (car (get-pitch-at-nthrhythm highlayernr indexx high-layer-evt-nr)))
                                                       (low-layer-pitch (car (get-pitch-at-nthrhythm lowlayernr indexx low-layer-evt-nr))))  
                                                   
                                                   (if (and high-layer-pitch low-layer-pitch)
                                                       (funcall testfn high-layer-pitch low-layer-pitch)
                                                     0))
                                               0)))))
                  0))                               
               (t 0)))))

;;;;;;;;
;This rule (below) does not consider metric structure

(defun pitch-at-homophony-rule (highlayernr lowlayernr testfn) 

   #'(lambda (indexx x)
       (let ((this-layer-nr (get-layer-nr x))
             (start-this-cell (get-starttime indexx x)) ;1+ to compensate for global offset 
             (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for global offset
             high-layer-onset-times
             low-layer-onset-times
             beat-onsets
             intersection)

         (cond ((and (or (= this-layer-nr highlayernr) 
                             (= this-layer-nr lowlayernr))
                         stop-this-cell)
                      ;check that time for pitch event is assigned
                ;(setf beat-onsets (find-beat-onsets-between-timepoints2 start-this-cell stop-this-cell subdiv indexx))
                (setf high-layer-onset-times (butlast (get-one-rhythmlayer-at-index highlayernr indexx)))
                (setf low-layer-onset-times (butlast (get-one-rhythmlayer-at-index lowlayernr indexx)))
             
                ;(get-one-rhythmlayer-at-index 2 78)

                ;(sort '(3 2 4) '<)                    
                (setf intersection 
                      (reverse (fast-band-filter (1+ start-this-cell)
                                              (1+ (- stop-this-cell 1/1000))
                                              (sort (intersection high-layer-onset-times low-layer-onset-times) '<))))
                (setf intersection (remove 0 intersection :test #'(lambda (x y) (> x y))))
                (if intersection
                    (let ((high-layer-evt-nrs (get-ordernr-for-onsets-from-vector-at-timepoints 
                                              highlayernr intersection (get-number-of-rhythms-and-pauses-at-index highlayernr indexx))))  
                      (eval (append '(and) 
                                    (loop for n from 0 to (1- (length intersection))
                                          collect (let ((low-layer-evt-nr (car (get-nrs-for-rhythms-from-vector-between-timepoints 
                                                                                lowlayernr (nth n intersection) (nth n intersection) indexx)))
                                                        (high-layer-evt-nr (nth n high-layer-evt-nrs)))
                                                  (if (and high-layer-evt-nr low-layer-evt-nr)
                                                      (let ((high-layer-pitch (car (get-pitch-at-nthrhythm highlayernr indexx high-layer-evt-nr)))
                                                            (low-layer-pitch (car (get-pitch-at-nthrhythm lowlayernr indexx (1- low-layer-evt-nr)))))  
                                                        
                                                        (if (and high-layer-pitch low-layer-pitch)
                                                            (if (funcall testfn high-layer-pitch low-layer-pitch) t nil)
                                                          t))
                                                    t))))))
                  t))                               
               (t t)))))


;;;
(defun pitch-at-homophony-heuristicrule (highlayernr lowlayernr testfn) 

   #'(lambda (indexx x)
       (let ((this-layer-nr (get-layer-nr x))
             (start-this-cell (get-starttime indexx x)) ;1+ to compensate for global offset 
             (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for global offset
             high-layer-onset-times
             low-layer-onset-times
             beat-onsets
             intersection)

         (cond ((and (or (= this-layer-nr highlayernr) 
                         (= this-layer-nr lowlayernr))
                     stop-this-cell)
                  ;check that time for pitch event is assigned
                ;(setf beat-onsets (find-beat-onsets-between-timepoints2 start-this-cell stop-this-cell subdiv indexx))
                (setf high-layer-onset-times (butlast (get-one-rhythmlayer-at-index highlayernr indexx)))
                (setf low-layer-onset-times (butlast (get-one-rhythmlayer-at-index lowlayernr indexx)))
                ;not necessary to remove pauses (because of intersection), butlast to remove offset.


                                              
                (setf intersection 
                      (reverse (fast-band-filter (1+ start-this-cell)
                                                 (1+ (- stop-this-cell 1/1000))
                                                 (sort (intersection high-layer-onset-times low-layer-onset-times) '<))))
                (setf intersection (remove 0 intersection :test #'(lambda (x y) (> x y))))
                (if intersection
                    (let ((high-layer-evt-nrs (get-ordernr-for-onsets-from-vector-at-timepoints 
                                              highlayernr intersection (get-number-of-rhythms-and-pauses-at-index highlayernr indexx))))  
                      (apply '+
                             (loop for n from 0 to (1- (length intersection))
                                   collect (let ((low-layer-evt-nr (car (get-nrs-for-rhythms-from-vector-between-timepoints 
                                                                         lowlayernr (nth n intersection) (nth n intersection) indexx)))
                                                 (high-layer-evt-nr (nth n high-layer-evt-nrs)))
                                             (if (and high-layer-evt-nr low-layer-evt-nr)
                                                 (let ((high-layer-pitch (car (get-pitch-at-nthrhythm highlayernr indexx high-layer-evt-nr)))
                                                       (low-layer-pitch (car (get-pitch-at-nthrhythm lowlayernr indexx (1- low-layer-evt-nr)))))  
                                                   
                                                   (if (and high-layer-pitch low-layer-pitch)
                                                       (funcall testfn high-layer-pitch low-layer-pitch)
                                                     0))
                                               0)))))
                  0))                               
               (t 0)))))


;;;;;;

(defun pitch-on-beat-rule4 (highlayernr lowlayernr subdiv testfn) 
  "Checks pitches that exist on beat (not only onsets) in two simultaneous layers."

   #'(lambda (indexx x)
       (let ((this-layer-nr (get-layer-nr x))
             (start-this-cell (get-starttime indexx x)) ;1+ to compensate for global offset 
             (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for global offset, further down: -1/10000 to stop BEFORE next beat
             high-layer-onset-times
             low-layer-onset-times
             beat-onsets
             )

         (cond ((or (and (or (= this-layer-nr highlayernr) 
                             (= this-layer-nr lowlayernr))
                         stop-this-cell)
                    (typep x 'timesign))  ;check that time for pitch event is assigned
                (setf beat-onsets (find-beat-onsets-between-timepoints2 start-this-cell (- stop-this-cell 1/10000) subdiv indexx))
                ;(setf high-layer-onset-times (butlast (get-one-rhythmlayer-at-index highlayernr indexx)))
                ;(setf low-layer-onset-times (butlast (get-one-rhythmlayer-at-index lowlayernr indexx)))
                ;not necessary to remove pauses (because of intersection), butlast to remove offset.


                (let ((high-layer-evt-nrs (get-ordernr-for-onsets-from-vector-at-timepoints 
                                           highlayernr beat-onsets (get-number-of-rhythms-and-pauses-at-index highlayernr indexx)))
                      (low-layer-evt-nrs (get-ordernr-for-onsets-from-vector-at-timepoints 
                                          lowlayernr beat-onsets (get-number-of-rhythms-and-pauses-at-index lowlayernr indexx))))  





                      (eval (append '(and) 
                                    (loop for n from 0 to (1- (length beat-onsets))
                                          collect (let ((low-layer-evt-nr (nth n low-layer-evt-nrs))
                                                        (high-layer-evt-nr (nth n high-layer-evt-nrs)))
                                                  (if (and high-layer-evt-nr low-layer-evt-nr)
                                                      (let ((high-layer-pitch (car (get-pitch-at-nthrhythm highlayernr indexx high-layer-evt-nr)))
                                                            (low-layer-pitch (car (get-pitch-at-nthrhythm lowlayernr indexx low-layer-evt-nr))))  
                                                        
                                                        (if (and high-layer-pitch low-layer-pitch)
                                                            (if (funcall testfn high-layer-pitch low-layer-pitch) t nil)
                                                          t))
                                                    t)))))))
                                                
               (t t)))))



(defun pitch-on-beat-heuristicrule4 (highlayernr lowlayernr subdiv testfn) 
  "Checks pitches that exist on beat (not only onsets) in two simultaneous layers."

   #'(lambda (indexx x)
       (let ((this-layer-nr (get-layer-nr x))
             (start-this-cell (get-starttime indexx x)) ;1+ to compensate for global offset 
             (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for global offset
             high-layer-onset-times
             low-layer-onset-times
             beat-onsets
             )

         (cond ((or (and (or (= this-layer-nr highlayernr) 
                             (= this-layer-nr lowlayernr))
                         stop-this-cell)
                    (typep x 'timesign))  ;check that time for pitch event is assigned
                (setf beat-onsets (find-beat-onsets-between-timepoints2 start-this-cell stop-this-cell subdiv indexx))
                ;(setf high-layer-onset-times (butlast (get-one-rhythmlayer-at-index highlayernr indexx)))
                ;(setf low-layer-onset-times (butlast (get-one-rhythmlayer-at-index lowlayernr indexx)))
                ;not necessary to remove pauses (because of intersection), butlast to remove offset.


                (let ((high-layer-evt-nrs (get-ordernr-for-onsets-from-vector-at-timepoints 
                                           highlayernr beat-onsets (get-number-of-rhythms-and-pauses-at-index highlayernr indexx)))
                      (low-layer-evt-nrs (get-ordernr-for-onsets-from-vector-at-timepoints 
                                          lowlayernr beat-onsets (get-number-of-rhythms-and-pauses-at-index lowlayernr indexx))))  





                      (apply '+
                             (loop for n from 0 to (1- (length beat-onsets))
                                   collect (let ((low-layer-evt-nr (nth n low-layer-evt-nrs))
                                                 (high-layer-evt-nr (nth n high-layer-evt-nrs)))
                                             (if (and high-layer-evt-nr low-layer-evt-nr)
                                                 (let ((high-layer-pitch (car (get-pitch-at-nthrhythm highlayernr indexx high-layer-evt-nr)))
                                                       (low-layer-pitch (car (get-pitch-at-nthrhythm lowlayernr indexx low-layer-evt-nr))))  
                                                   
                                                   (if (and high-layer-pitch low-layer-pitch)
                                                       (funcall testfn high-layer-pitch low-layer-pitch)
                                                     0))
                                               0))))))
               
               (t 0)))))