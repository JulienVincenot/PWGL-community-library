(in-package MC)

(defun at-measure-with-sign-metric-rule (rulefn layers)
  (let* ((nr-of-variables-in-fn (length (system::arglist rulefn))))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer) (= (get-layer-nr x) *TIMESIGNLAYER*))
                                             (typecase x
                                               (timesign (let* ((starttime (get-total-duration-timesigns-at-index (1- indexx)))
                                                                (endtime (get-total-duration-timesigns-at-index indexx))
                                                                (this-timesign (get-timesign x))
                                                                (this-measure-pos (list starttime endtime))

                                                                (preceeding-measure-lengths (get-last-measure-lengths-simple-rule (1- indexx) (1- nr-of-variables-in-fn)))
                                                                (preceeding-onsets (ratios-to-onsets-to-endtime preceeding-measure-lengths starttime))
                                                                (measure-pos (append preceeding-onsets this-measure-pos))  
                                                                (tot-number-of-dur-this-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                (tot-duration-rhythm-and-pauses (get-total-duration-rhythms-at-index layer indexx))
                                                                (filtered-measure-pos (reverse (fast-lp-filter-w-pauses (- tot-duration-rhythm-and-pauses 1/100000) measure-pos)))) 

                                                           (if (and filtered-measure-pos (> tot-duration-rhythm-and-pauses 0))
                                                               (let* ((pointer-at-or-before-measures (mapcar #'(lambda (timepoint) (get-pointer-for-rhythm-at-or-before-timepoint layer timepoint tot-number-of-dur-this-layer))
                                                                                                             filtered-measure-pos))
                                                                      (onset-at-or-before-measures (mapcar #'(lambda (pointer) (1- (abs (aref part-sol-vector layer pointer *ONSETTIME*))))
                                                                                                           pointer-at-or-before-measures))
                                                                      (duration-at-or-before-meaures (mapcar #'(lambda (pointer) (car (get-durations-from-vector layer pointer (1+ pointer)))) pointer-at-or-before-measures))

                                                                      (timesigns-at-or-before-meaures (remove nil (mapcar #'(lambda (timepoint) (get-timesign-at-timepoint timepoint indexx)) filtered-measure-pos)))


                                                                      (offset-at-or-before-measures (mapcar #'(lambda (onset beat-pos) (- onset beat-pos)) onset-at-or-before-measures filtered-measure-pos))
                                                                      (dur-offset-time-triplets (mc-mattrans3 duration-at-or-before-meaures offset-at-or-before-measures timesigns-at-or-before-meaures)))

                                                                 (if (not timesigns-at-or-before-meaures)  ;to make the rule "simple"
                                                                     t
                                                                   (eval (append '(and)
                                                                                 (loop for n from 0 to (- (length timesigns-at-or-before-meaures) nr-of-variables-in-fn)
                                                                                       collect (if (apply rulefn (strip-selection dur-offset-time-triplets n (+ n (1- nr-of-variables-in-fn)))) t))))))
                                                             t)))
                                               

                                               (rhythmcell (let* ((start-time-this-cell (get-total-duration-rhythms-at-index layer (1- indexx)))
                                                                  (tot-number-of-dur-this-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                  (end-time-this-cell (get-total-duration-rhythms-at-index layer indexx))
                                                                  (all-measures (mapcar #'(lambda (time) (1- time)) (get-timepoints-at-measures-upto-index2 indexx))); 1- compensate for offset
                                                                  (filtered-measure-pos (reverse (fast-lp-filter-w-pauses (- end-time-this-cell 1/100000) all-measures)))
                                                                  (position-of-first-measure-within-cell (position start-time-this-cell filtered-measure-pos :test '<=))) ;the measure in all-measures that is the first inside the cell
                                                             
                                                             (if position-of-first-measure-within-cell
                                                                 (let ((position-first-measure (- position-of-first-measure-within-cell (1- nr-of-variables-in-fn))))
                                                                   (if (minusp position-first-measure) (setf position-first-measure 0)) ; simple rule
                                                                   (if (>= (- (length filtered-measure-pos) position-first-measure) 
                                                                           nr-of-variables-in-fn)
                                                                       (let* ((measure-positions (strip-selection filtered-measure-pos position-first-measure (1- (length filtered-measure-pos))))
                                                                              (pointer-at-or-before-measures (mapcar #'(lambda (timepoint) (get-pointer-for-rhythm-at-or-before-timepoint layer timepoint tot-number-of-dur-this-layer))
                                                                                                                     measure-positions))
                                                                              (onset-at-or-before-measures (mapcar #'(lambda (pointer) (1- (abs (aref part-sol-vector layer pointer *ONSETTIME*))))
                                                                                                                   pointer-at-or-before-measures))
                                                                              (offset-at-or-before-measures (mapcar #'(lambda (onset measure-pos) (- onset measure-pos)) onset-at-or-before-measures measure-positions))
                                                                              (duration-at-or-before-measures (mapcar #'(lambda (pointer) (car (get-durations-from-vector layer pointer (1+ pointer)))) pointer-at-or-before-measures))
                                                                              (timesigns-at-or-before-meaures (remove nil (mapcar #'(lambda (timepoint) (get-timesign-at-timepoint timepoint indexx)) measure-positions)))

                                                                              (dur-offset-time-triplets (mc-mattrans3 duration-at-or-before-measures offset-at-or-before-measures timesigns-at-or-before-meaures)))

                                                                         (if (not timesigns-at-or-before-meaures)  ;to make the rule "simple"
                                                                             t
                                                                           (eval (append '(and)
                                                                                         (loop for n from 0 to (- (length timesigns-at-or-before-meaures) nr-of-variables-in-fn)
                                                                                               collect (if (apply rulefn (strip-selection dur-offset-time-triplets n (+ n (1- nr-of-variables-in-fn)))) t))))))
                                                                     t))
                                                               t)))
                                               (t t))
                                           t)
                                           )))))


(defun at-measure-with-sign-metric-heuristic-rule (rulefn layers)
  (let* ((nr-of-variables-in-fn (length (system::arglist rulefn))))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer) (= (get-layer-nr x) *TIMESIGNLAYER*))
                                             (typecase x
                                               (timesign (let* ((starttime (get-total-duration-timesigns-at-index (1- indexx)))
                                                                (endtime (get-total-duration-timesigns-at-index indexx))
                                                                (this-timesign (get-timesign x))
                                                                (this-measure-pos (list starttime endtime))

                                                                (preceeding-measure-lengths (get-last-measure-lengths-simple-rule (1- indexx) (1- nr-of-variables-in-fn)))
                                                                (preceeding-onsets (ratios-to-onsets-to-endtime preceeding-measure-lengths starttime))
                                                                (measure-pos (append preceeding-onsets this-measure-pos))  
                                                                (tot-number-of-dur-this-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                (tot-duration-rhythm-and-pauses (get-total-duration-rhythms-at-index layer indexx))
                                                                (filtered-measure-pos (reverse (fast-lp-filter-w-pauses (- tot-duration-rhythm-and-pauses 1/100000) measure-pos)))) 

                                                           (if (and filtered-measure-pos (> tot-duration-rhythm-and-pauses 0))
                                                               (let* ((pointer-at-or-before-measures (mapcar #'(lambda (timepoint) (get-pointer-for-rhythm-at-or-before-timepoint layer timepoint tot-number-of-dur-this-layer))
                                                                                                             filtered-measure-pos))
                                                                      (onset-at-or-before-measures (mapcar #'(lambda (pointer) (1- (abs (aref part-sol-vector layer pointer *ONSETTIME*))))
                                                                                                           pointer-at-or-before-measures))
                                                                      (duration-at-or-before-meaures (mapcar #'(lambda (pointer) (car (get-durations-from-vector layer pointer (1+ pointer)))) pointer-at-or-before-measures))

                                                                      (timesigns-at-or-before-meaures (remove nil (mapcar #'(lambda (timepoint) (get-timesign-at-timepoint timepoint indexx)) filtered-measure-pos)))


                                                                      (offset-at-or-before-measures (mapcar #'(lambda (onset beat-pos) (- onset beat-pos)) onset-at-or-before-measures filtered-measure-pos))
                                                                      (dur-offset-time-triplets (mc-mattrans3 duration-at-or-before-meaures offset-at-or-before-measures timesigns-at-or-before-meaures)))

                                                                 (if (not timesigns-at-or-before-meaures)  ;to make the rule "simple"
                                                                     0
                                                                   (apply '+
                                                                          (loop for n from 0 to (- (length timesigns-at-or-before-meaures) nr-of-variables-in-fn)
                                                                                collect (apply rulefn (strip-selection dur-offset-time-triplets n (+ n (1- nr-of-variables-in-fn))))))))
                                                             0)))
                                               

                                               (rhythmcell (let* ((start-time-this-cell (get-total-duration-rhythms-at-index layer (1- indexx)))
                                                                  (tot-number-of-dur-this-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                  (end-time-this-cell (get-total-duration-rhythms-at-index layer indexx))
                                                                  (all-measures (mapcar #'(lambda (time) (1- time)) (get-timepoints-at-measures-upto-index2 indexx))); 1- compensate for offset
                                                                  (filtered-measure-pos (reverse (fast-lp-filter-w-pauses (- end-time-this-cell 1/100000) all-measures)))
                                                                  (position-of-first-measure-within-cell (position start-time-this-cell filtered-measure-pos :test '<=))) ;the measure in all-measures that is the first inside the cell
                                                             
                                                             (if position-of-first-measure-within-cell
                                                                 (let ((position-first-measure (- position-of-first-measure-within-cell (1- nr-of-variables-in-fn))))
                                                                   (if (minusp position-first-measure) (setf position-first-measure 0)) ; simple rule
                                                                   (if (>= (- (length filtered-measure-pos) position-first-measure) 
                                                                           nr-of-variables-in-fn)
                                                                       (let* ((measure-positions (strip-selection filtered-measure-pos position-first-measure (1- (length filtered-measure-pos))))
                                                                              (pointer-at-or-before-measures (mapcar #'(lambda (timepoint) (get-pointer-for-rhythm-at-or-before-timepoint layer timepoint tot-number-of-dur-this-layer))
                                                                                                                     measure-positions))
                                                                              (onset-at-or-before-measures (mapcar #'(lambda (pointer) (1- (abs (aref part-sol-vector layer pointer *ONSETTIME*))))
                                                                                                                   pointer-at-or-before-measures))
                                                                              (offset-at-or-before-measures (mapcar #'(lambda (onset measure-pos) (- onset measure-pos)) onset-at-or-before-measures measure-positions))
                                                                              (duration-at-or-before-measures (mapcar #'(lambda (pointer) (car (get-durations-from-vector layer pointer (1+ pointer)))) pointer-at-or-before-measures))
                                                                              (timesigns-at-or-before-meaures (remove nil (mapcar #'(lambda (timepoint) (get-timesign-at-timepoint timepoint indexx)) measure-positions)))

                                                                              (dur-offset-time-triplets (mc-mattrans3 duration-at-or-before-measures offset-at-or-before-measures timesigns-at-or-before-meaures)))

                                                                         (if (not timesigns-at-or-before-meaures)  ;to make the rule "simple"
                                                                             0
                                                                           (apply '+
                                                                                  (loop for n from 0 to (- (length timesigns-at-or-before-meaures) nr-of-variables-in-fn)
                                                                                        collect (apply rulefn (strip-selection dur-offset-time-triplets n (+ n (1- nr-of-variables-in-fn))))))))
                                                                     0))
                                                               0)))
                                               (t 0))
                                           0)
                        )))))



;;;;;;


(defun at-beat-with-sign-metric-rule (rulefn layers)
  (let* ((nr-of-variables-in-fn (length (system::arglist rulefn)))
         )
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer) (= (get-layer-nr x) *TIMESIGNLAYER*))
                                             (typecase x
                                               (timesign (let* ((starttime (get-total-duration-timesigns-at-index (1- indexx)))
                                                                (this-timesign (get-timesign x))
                                                                (this-measure-beat-lengths (make-list (car this-timesign) :initial-element (/ 1 (cadr this-timesign))))
                                                                (this-measure-beat-pos (ratios-to-onsets-with-offset starttime this-measure-beat-lengths))
                                                                (preceeding-beat-lengths (get-last-beats (1- indexx) (1- nr-of-variables-in-fn)))
                                                                (preceeding-onsets (ratios-to-onsets-to-endtime preceeding-beat-lengths starttime))
                                                                (measure-beat-pos (remove nil (append preceeding-onsets this-measure-beat-pos)))   ; remove nil = simple rule
                                                                (tot-number-of-dur-this-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                (tot-duration-rhythm-and-pauses (get-total-duration-rhythms-at-index layer indexx))
                                                                (filtered-beat-pos (reverse (fast-lp-filter-w-pauses (- tot-duration-rhythm-and-pauses 1/100000) measure-beat-pos)))) 

                                                           
                                                           (if (and filtered-beat-pos (> tot-duration-rhythm-and-pauses 0))
                                                               (let* ((pointer-at-or-before-beats (mapcar #'(lambda (timepoint) (get-pointer-for-rhythm-at-or-before-timepoint layer timepoint tot-number-of-dur-this-layer))
                                                                                                          filtered-beat-pos))
                                                                      (onset-at-or-before-beats (mapcar #'(lambda (pointer) (1- (abs (aref part-sol-vector layer pointer *ONSETTIME*))))
                                                                                                        pointer-at-or-before-beats))
                                                                      (duration-at-or-before-beats (mapcar #'(lambda (pointer) (car (get-durations-from-vector layer pointer (1+ pointer)))) pointer-at-or-before-beats))

                                                                      (timesigns-at-or-before-beats (remove nil (mapcar #'(lambda (timepoint) (get-timesign-at-timepoint timepoint indexx)) filtered-beat-pos)))

                                                                      (offset-at-or-before-beats (mapcar #'(lambda (onset beat-pos) (- onset beat-pos)) onset-at-or-before-beats filtered-beat-pos))
                                                                      (dur-offset-time-triplets (mc-mattrans3 duration-at-or-before-beats offset-at-or-before-beats timesigns-at-or-before-beats)))

                                                                 (if (not timesigns-at-or-before-beats)  ;to make the rule "simple"
                                                                     t
                                                                   (eval (append '(and)
                                                                                 (loop for n from 0 to (- (length timesigns-at-or-before-beats) nr-of-variables-in-fn)
                                                                                       collect (if (apply rulefn (strip-selection dur-offset-time-triplets n (+ n (1- nr-of-variables-in-fn)))) t))))))
                                                             t)))
                                               


                                               (rhythmcell (let* ((start-time-this-cell (get-total-duration-rhythms-at-index layer (1- indexx)))
                                                                  (tot-number-of-dur-this-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                  (end-time-this-cell (get-total-duration-rhythms-at-index layer indexx))
                                                                  (all-beats (mapcar #'(lambda (time) (1- time)) (get-timepoints-at-beats-upto-index2 indexx))); 1- compensate for offset
                                                                  (filtered-beat-pos (reverse (fast-lp-filter-w-pauses (- end-time-this-cell 1/100000) all-beats)))

                                                                  (position-of-first-beat-within-cell (position start-time-this-cell filtered-beat-pos :test '<=))) ;the beat in all-beats that is the first inside the cell
                                                             
                                                             (if position-of-first-beat-within-cell
                                                                 (let ((position-first-beat (- position-of-first-beat-within-cell (1- nr-of-variables-in-fn))))
                                                                   (if (minusp position-first-beat) (setf position-first-beat 0)) ; simple rule
                                                                   (if (>= (- (length filtered-beat-pos) position-first-beat) 
                                                                           nr-of-variables-in-fn)
                                                                       (let* ((beat-positions (strip-selection filtered-beat-pos position-first-beat (1- (length filtered-beat-pos))))
                                                                              (pointer-at-or-before-beats (mapcar #'(lambda (timepoint) (get-pointer-for-rhythm-at-or-before-timepoint layer timepoint tot-number-of-dur-this-layer))
                                                                                                                  beat-positions))
                                                                              (onset-at-or-before-beats (mapcar #'(lambda (pointer) (1- (abs (aref part-sol-vector layer pointer *ONSETTIME*))))
                                                                                                                pointer-at-or-before-beats))
                                                                              (offset-at-or-before-beats (mapcar #'(lambda (onset beat-pos) (- onset beat-pos)) onset-at-or-before-beats beat-positions))
                                                                              (duration-at-or-before-beats (mapcar #'(lambda (pointer) (car (get-durations-from-vector layer pointer (1+ pointer)))) pointer-at-or-before-beats))
                                                                              (timesigns-at-or-before-beats (remove nil (mapcar #'(lambda (timepoint) (get-timesign-at-timepoint timepoint indexx)) beat-positions)))

                                                                              (dur-offset-time-triplets (mc-mattrans3 duration-at-or-before-beats offset-at-or-before-beats timesigns-at-or-before-beats)))
                                                                         
                                                                 (if (not timesigns-at-or-before-beats)  ;to make the rule "simple"
                                                                     t
                                                                   (eval (append '(and)
                                                                                 (loop for n from 0 to (- (length pointer-at-or-before-beats) nr-of-variables-in-fn)
                                                                                       collect (if (apply rulefn (strip-selection dur-offset-time-triplets n (+ n (1- nr-of-variables-in-fn)))) t))))))
                                                                     t))
                                                               t)))
                                               (t t))
                                           t))))))


(defun at-beat-with-sign-metric-heuristic-rule (rulefn layers)
  (let* ((nr-of-variables-in-fn (length (system::arglist rulefn)))
         )
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer) (= (get-layer-nr x) *TIMESIGNLAYER*))
                                             (typecase x
                                               (timesign (let* ((starttime (get-total-duration-timesigns-at-index (1- indexx)))
                                                                (this-timesign (get-timesign x))
                                                                (this-measure-beat-lengths (make-list (car this-timesign) :initial-element (/ 1 (cadr this-timesign))))
                                                                (this-measure-beat-pos (ratios-to-onsets-with-offset starttime this-measure-beat-lengths))
                                                                (preceeding-beat-lengths (get-last-beats (1- indexx) (1- nr-of-variables-in-fn)))
                                                                (preceeding-onsets (ratios-to-onsets-to-endtime preceeding-beat-lengths starttime))
                                                                (measure-beat-pos (remove nil (append preceeding-onsets this-measure-beat-pos)))   ; remove nil = simple rule
                                                                (tot-number-of-dur-this-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                (tot-duration-rhythm-and-pauses (get-total-duration-rhythms-at-index layer indexx))
                                                                (filtered-beat-pos (reverse (fast-lp-filter-w-pauses (- tot-duration-rhythm-and-pauses 1/100000) measure-beat-pos)))) 

                                                           
                                                           (if (and filtered-beat-pos (> tot-duration-rhythm-and-pauses 0))
                                                               (let* ((pointer-at-or-before-beats (mapcar #'(lambda (timepoint) (get-pointer-for-rhythm-at-or-before-timepoint layer timepoint tot-number-of-dur-this-layer))
                                                                                                          filtered-beat-pos))
                                                                      (onset-at-or-before-beats (mapcar #'(lambda (pointer) (1- (abs (aref part-sol-vector layer pointer *ONSETTIME*))))
                                                                                                        pointer-at-or-before-beats))
                                                                      (duration-at-or-before-beats (mapcar #'(lambda (pointer) (car (get-durations-from-vector layer pointer (1+ pointer)))) pointer-at-or-before-beats))

                                                                      (timesigns-at-or-before-beats (remove nil (mapcar #'(lambda (timepoint) (get-timesign-at-timepoint timepoint indexx)) filtered-beat-pos)))

                                                                      (offset-at-or-before-beats (mapcar #'(lambda (onset beat-pos) (- onset beat-pos)) onset-at-or-before-beats filtered-beat-pos))
                                                                      (dur-offset-time-triplets (mc-mattrans3 duration-at-or-before-beats offset-at-or-before-beats timesigns-at-or-before-beats)))

                                                                 (if (not timesigns-at-or-before-beats)  ;to make the rule "simple"
                                                                     0
                                                                   (apply '+
                                                                          (loop for n from 0 to (- (length timesigns-at-or-before-beats) nr-of-variables-in-fn)
                                                                                collect (apply rulefn (strip-selection dur-offset-time-triplets n (+ n (1- nr-of-variables-in-fn))))))))
                                                             0)))
                                               


                                               (rhythmcell (let* ((start-time-this-cell (get-total-duration-rhythms-at-index layer (1- indexx)))
                                                                  (tot-number-of-dur-this-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                  (end-time-this-cell (get-total-duration-rhythms-at-index layer indexx))
                                                                  (all-beats (mapcar #'(lambda (time) (1- time)) (get-timepoints-at-beats-upto-index2 indexx))); 1- compensate for offset
                                                                  (filtered-beat-pos (reverse (fast-lp-filter-w-pauses (- end-time-this-cell 1/100000) all-beats)))

                                                                  (position-of-first-beat-within-cell (position start-time-this-cell filtered-beat-pos :test '<=))) ;the beat in all-beats that is the first inside the cell
                                                             
                                                             (if position-of-first-beat-within-cell
                                                                 (let ((position-first-beat (- position-of-first-beat-within-cell (1- nr-of-variables-in-fn))))
                                                                   (if (minusp position-first-beat) (setf position-first-beat 0)) ; simple rule
                                                                   (if (>= (- (length filtered-beat-pos) position-first-beat) 
                                                                           nr-of-variables-in-fn)
                                                                       (let* ((beat-positions (strip-selection filtered-beat-pos position-first-beat (1- (length filtered-beat-pos))))
                                                                              (pointer-at-or-before-beats (mapcar #'(lambda (timepoint) (get-pointer-for-rhythm-at-or-before-timepoint layer timepoint tot-number-of-dur-this-layer))
                                                                                                                  beat-positions))
                                                                              (onset-at-or-before-beats (mapcar #'(lambda (pointer) (1- (abs (aref part-sol-vector layer pointer *ONSETTIME*))))
                                                                                                                pointer-at-or-before-beats))
                                                                              (offset-at-or-before-beats (mapcar #'(lambda (onset beat-pos) (- onset beat-pos)) onset-at-or-before-beats beat-positions))
                                                                              (duration-at-or-before-beats (mapcar #'(lambda (pointer) (car (get-durations-from-vector layer pointer (1+ pointer)))) pointer-at-or-before-beats))
                                                                              (timesigns-at-or-before-beats (remove nil (mapcar #'(lambda (timepoint) (get-timesign-at-timepoint timepoint indexx)) beat-positions)))

                                                                              (dur-offset-time-triplets (mc-mattrans3 duration-at-or-before-beats offset-at-or-before-beats timesigns-at-or-before-beats)))
                                                                         
                                                                         (if (not timesigns-at-or-before-beats)  ;to make the rule "simple"
                                                                             0
                                                                           (apply '+
                                                                                  (loop for n from 0 to (- (length pointer-at-or-before-beats) nr-of-variables-in-fn)
                                                                                        collect (apply rulefn (strip-selection dur-offset-time-triplets n (+ n (1- nr-of-variables-in-fn))))))))
                                                                     0))
                                                               0)))
                                               (t 0))
                                           0))))))