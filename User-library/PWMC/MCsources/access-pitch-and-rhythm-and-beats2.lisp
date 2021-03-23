(in-package MC)

;metric-div-fn set to  'get-timepoints-at-beats-upto-index2

(defun pitch-rhythm-and-beat-rule (rulefn layers metric-div-fn)
  (let* ((nr-of-variables-in-fn (length (system::arglist rulefn)))
         (filter-fn 'filter-keep-all))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer) (= (get-layer-nr x) *TIMESIGNLAYER*))
                                             (typecase x
                                               (pitchcell (let* ((number-of-events-in-cell (get-nr-of-events x))
                                                                 (number-of-pitches-in-layer (get-number-of-pitches-at-index layer indexx))
                                                                 (start-nth-pitch (1+ (- number-of-pitches-in-layer number-of-events-in-cell nr-of-variables-in-fn)));include events before this cell
                                                                 )
                                                            (if (minusp start-nth-pitch) (let ((nr-of-pauses+1 (get-localpointer-at-nthrhythm layer indexx 0)))
                                                                                           (if (and nr-of-pauses+1 (>= (1- nr-of-pauses+1) (abs start-nth-pitch)))  (setf start-nth-pitch 0))))
                                                            ;(system::pwgl-print 'pitch)
                                                            (if (>= start-nth-pitch 0)
                                                                (let* ((stop-nth-pitch (1- number-of-pitches-in-layer))
                                                                       (preceeding-pauses (check-if-pauses-before layer indexx start-nth-pitch))
                                                                       (following-pauses (check-if-pauses-after layer indexx stop-nth-pitch))
                                                                       (rhythms-and-pauses-this-cell (append preceeding-pauses
                                                                                                             (get-rhythm-for-pitches-include-nil layer indexx start-nth-pitch stop-nth-pitch)
                                                                                                             following-pauses))
                                                                       (pitches-this-cell-no-pause (get-pitches-between-nths-when-all-exist layer indexx 
                                                                                                                                            start-nth-pitch 
                                                                                                                                            stop-nth-pitch))
                                                                       (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                       

                                                                       (onsets (get-onsets-between-nth-pitches-include-preceeding&following-pauses layer indexx start-nth-pitch stop-nth-pitch))
                                                                       (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                       (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list (get-total-duration-timesigns-at-index indexx)))))
                                                                       (pitch-dur-offset-triplets (remove-not-assignd-and-remaining-triplets 
                                                                                                   (apply filter-fn (list
                                                                                                                     (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets))))))
                                                                  (eval (append '(and)
                                                                                (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                                      collect (if (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))) t)))))
                                                                  
                                                              t)))

                                               (rhythmcell (let* ((first-pitch-in-cell (get-number-of-rhythms-at-index layer (1- indexx)))
                                                                  (number-of-needed-pitches-in-layer (get-number-of-rhythms-at-index layer indexx))
                                                                  (first-rhythm-or-pause-in-cell (get-number-of-rhythms-and-pauses-at-index layer (1- indexx))) ;nth, first is 0
                                                                  (number-of-rhythm-and-pause (get-number-of-rhythms-and-pauses-at-index layer indexx))

                                                                  (start-nth-rhythm-or-pause (1+ (- first-rhythm-or-pause-in-cell nr-of-variables-in-fn))))
                                                               ;(system::pwgl-print 'rhythm)
                                                             (if (minusp start-nth-rhythm-or-pause) (setf start-nth-rhythm-or-pause 0))
                                                             (if (>= number-of-rhythm-and-pause nr-of-variables-in-fn)
                                                                 (let* ((start-pitch-pointer (1+ (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer start-nth-rhythm-or-pause))) ;nth+1
                                                                        (stop-pitch-pointer (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer number-of-rhythm-and-pause))     ;nth+1
                                                                        (pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer start-pitch-pointer stop-pitch-pointer indexx))
                                                                        (rhythms-and-pauses-this-cell (get-durations-from-vector layer (1+ start-nth-rhythm-or-pause) (1+ number-of-rhythm-and-pause)))
                                                                        (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                        (onsets (mapcar #'(lambda (onset) (1- (abs onset)))
                                                                                        (get-onsets-from-vector layer (1+ start-nth-rhythm-or-pause) number-of-rhythm-and-pause)))
                                                                        (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                        (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list (get-total-duration-timesigns-at-index indexx)))))
                                                                        ;get-total-duration-timesigns-at-index adds the end time for measures
 
                                                                        (pitch-dur-offset-triplets (remove-not-assignd-and-remaining-triplets 
                                                                                                    (apply filter-fn (list
                                                                                                                      (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets))))))
                                                                   (eval (append '(and)
                                                                                 (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                                       collect (if (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))) t)))))
                                                              
                                                               t)))
                                               (timesign (let* ((starttime (get-total-duration-timesigns-at-index (1- indexx)))
                                                                (endtime (get-total-duration-timesigns-at-index indexx))
                                                                (tot-length-rhythm-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                (first-pointer-in-this-measure (get-pointer-for-rhythm-at-or-after-timepoint layer starttime tot-length-rhythm-layer))
                                                                (start-nth-rhythm-or-pause (- first-pointer-in-this-measure nr-of-variables-in-fn)))
                                                           ;(system::pwgl-print 'time)
                                                           (if (minusp start-nth-rhythm-or-pause) (setf start-nth-rhythm-or-pause 0))
                                                           (if (>= tot-length-rhythm-layer nr-of-variables-in-fn)
                                                               (let* ((start-pitch-pointer (1+ (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer start-nth-rhythm-or-pause)))
                                                                      (stop-pitch-pointer (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer tot-length-rhythm-layer))
                                                                      (pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer start-pitch-pointer stop-pitch-pointer indexx))
                                                                      (rhythms-and-pauses-this-cell (get-durations-from-vector layer (1+ start-nth-rhythm-or-pause) (1+ tot-length-rhythm-layer)))
                                                                      (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                      (onsets (mapcar #'(lambda (onset) (1- (abs onset)))
                                                                                      (get-onsets-from-vector layer (1+ start-nth-rhythm-or-pause) tot-length-rhythm-layer)))
                                                                      (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                      (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list endtime))))
                                                                      (pitch-dur-offset-triplets (remove-not-assignd-and-remaining-triplets 
                                                                                                  (apply filter-fn (list
                                                                                                                    (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets))))))
                                                                 (eval (append '(and)
                                                                               (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                                     collect (if (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))) t)))))
                                                             t)))
                                               )
                                           t)
                        )))))




(defun pitch-rhythm-and-beat-no-pauses-rule (rulefn layers metric-div-fn)
  (let* ((nr-of-variables-in-fn (length (system::arglist rulefn)))
         (filter-fn 'filter-remove-pauses))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer) (= (get-layer-nr x) *TIMESIGNLAYER*))
                                             (typecase x
                                               (pitchcell (let* ((number-of-events-in-cell (get-nr-of-events x))
                                                                 (number-of-pitches-in-layer (get-number-of-pitches-at-index layer indexx))
                                                                 (start-nth-pitch (1+ (- number-of-pitches-in-layer number-of-events-in-cell nr-of-variables-in-fn)));include events before this cell
                                                                 )
                                                            ;(if (minusp start-nth-pitch) (let ((nr-of-pauses+1 (get-localpointer-at-nthrhythm layer indexx 0)))
                                                            ;                               (if (and nr-of-pauses+1 (>= (1- nr-of-pauses+1) (abs start-nth-pitch)))  (setf start-nth-pitch 0))))
                                                            (if (>= start-nth-pitch 0)
                                                                (let* ((stop-nth-pitch (1- number-of-pitches-in-layer))
                                                                       (preceeding-pauses (check-if-pauses-before layer indexx start-nth-pitch))
                                                                       (following-pauses (check-if-pauses-after layer indexx stop-nth-pitch))
                                                                       (rhythms-and-pauses-this-cell (append preceeding-pauses
                                                                                                             (get-rhythm-for-pitches-include-nil layer indexx start-nth-pitch stop-nth-pitch)
                                                                                                             following-pauses))
                                                                       (pitches-this-cell-no-pause (get-pitches-between-nths-when-all-exist layer indexx 
                                                                                                                                            start-nth-pitch 
                                                                                                                                            stop-nth-pitch))
                                                                       (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                       

                                                                       (onsets (get-onsets-between-nth-pitches-include-preceeding&following-pauses layer indexx start-nth-pitch stop-nth-pitch))
                                                                       (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                       (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list (get-total-duration-timesigns-at-index indexx)))))
                                                                       (pitch-dur-offset-triplets (remove-not-assignd-and-remaining-triplets 
                                                                                                   (apply filter-fn (list
                                                                                                                     (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets))))))
                                                                  
                                                                  (eval (append '(and)
                                                                                (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                                      collect (if (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))) t)))))
                                                                  
                                                              t)))



                                               (rhythmcell (let* ((first-rhythm-no-pauses-in-cell (get-number-of-rhythms-at-index layer (1- indexx)))   ;nth, first is 0
                                                                  (number-of-rhythms-no-pauses-in-layer (get-number-of-rhythms-at-index layer indexx))
                                                                  (start-nth-rhythm-no-pauses (1+ (- first-rhythm-no-pauses-in-cell nr-of-variables-in-fn))))
                                                               
                                                             (if (minusp start-nth-rhythm-no-pauses) (setf start-nth-rhythm-no-pauses 0))
                                                             (if (and (>= number-of-rhythms-no-pauses-in-layer nr-of-variables-in-fn) (/= number-of-rhythms-no-pauses-in-layer first-rhythm-no-pauses-in-cell))

                                                                 (let* ((pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer (1+ start-nth-rhythm-no-pauses) number-of-rhythms-no-pauses-in-layer indexx))
                                                                        (rhythms-and-pauses-this-cell (get-rhythm-for-pitches layer indexx start-nth-rhythm-no-pauses (1- number-of-rhythms-no-pauses-in-layer)))
                                                                        (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                        (start-pointer-rhythm-or-pause (get-localpointer-at-nthrhythm layer indexx start-nth-rhythm-no-pauses))
                                                                        (stop-pointer-rhythm-or-pause (get-localpointer-at-nthrhythm layer indexx (1- number-of-rhythms-no-pauses-in-layer)))
                                                                        (onsets (mapcar #'(lambda (onset) (1- (abs onset)))
                                                                                        (get-onsets-from-vector layer start-pointer-rhythm-or-pause stop-pointer-rhythm-or-pause)))
                                                                        (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                        (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list (get-total-duration-timesigns-at-index indexx)))))
                                                                        ;get-total-duration-timesigns-at-index adds the end time for measures
                                                                        
                                                                        (pitch-dur-offset-triplets (remove-not-assignd-and-remaining-triplets 
                                                                                                    (apply filter-fn (list
                                                                                                                      (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets))))))
                                                                   
                                                                   (eval (append '(and)
                                                                                 (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                                       collect (if (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))) t)))))
                                                                   
                                                              
                                                               t)))



                                               (timesign (let* ((starttime (get-total-duration-timesigns-at-index (1- indexx)))
                                                                (endtime (get-total-duration-timesigns-at-index indexx))
                                                                (tot-length-rhythm-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                (first-pointer-in-this-measure (get-pointer-for-rhythm-at-or-after-timepoint layer starttime tot-length-rhythm-layer))
                                                                ;(start-nth-rhythm-or-pause (- first-pointer-in-this-measure nr-of-variables-in-fn))
                                                                (start-nth-pitch (- (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer first-pointer-in-this-measure)
                                                                                    nr-of-variables-in-fn)))
                                                           (if (minusp start-nth-pitch) (setf start-nth-pitch 0))
                                                           (if (and (get-localpointer-at-nthrhythm layer indexx start-nth-pitch) (>= tot-length-rhythm-layer nr-of-variables-in-fn))
                                                               (let* ((start-nth-rhythm-or-pause (1- (get-localpointer-at-nthrhythm layer indexx start-nth-pitch)))
                                                                      (start-pitch-pointer (1+ (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer start-nth-rhythm-or-pause)))
                                                                      (stop-pitch-pointer (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer tot-length-rhythm-layer))
                                                                      (pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer start-pitch-pointer stop-pitch-pointer indexx))
                                                                      (rhythms-and-pauses-this-cell (get-durations-from-vector layer (1+ start-nth-rhythm-or-pause) (1+ tot-length-rhythm-layer)))
                                                                      (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                      (onsets (mapcar #'(lambda (onset) (1- (abs onset)))
                                                                                      (get-onsets-from-vector layer (1+ start-nth-rhythm-or-pause) tot-length-rhythm-layer)))
                                                                      (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                      (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list endtime))))
                                                                      (pitch-dur-offset-triplets (remove-not-assignd-and-remaining-triplets 
                                                                                                  (apply filter-fn (list
                                                                                                                    (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets))))))
                                                                 (eval (append '(and)
                                                                               (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                                     collect (if (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))) t)))))
                                                             t)))
                                               )
                                           t)
                        )))))



(defun pitch-rhythm-and-beat-include-not-assigned-rule (rulefn layers metric-div-fn)
  (let* ((nr-of-variables-in-fn (length (system::arglist rulefn)))
         (filter-fn 'filter-keep-all))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer) (= (get-layer-nr x) *TIMESIGNLAYER*))
                                             (typecase x
                                               (pitchcell (let* ((number-of-events-in-cell (get-nr-of-events x))
                                                                 (number-of-pitches-in-layer (get-number-of-pitches-at-index layer indexx))
                                                                 (start-nth-pitch (1+ (- number-of-pitches-in-layer number-of-events-in-cell nr-of-variables-in-fn)));include events before this cell
                                                                 preceeding-notassigned-nils)
                                                            (if (minusp start-nth-pitch) (progn 
                                                                                           (setf preceeding-notassigned-nils (make-list (abs start-nth-pitch) :initial-element '(nil nil nil)))
                                                                                           (setf start-nth-pitch 0)))
                                                            ;(system::pwgl-print 'pitch)
                                                            
                                                            (let* ((stop-nth-pitch (1- number-of-pitches-in-layer))
                                                                   (preceeding-pauses (check-if-pauses-before layer indexx start-nth-pitch))
                                                                   (following-pauses (check-if-pauses-after layer indexx stop-nth-pitch))
                                                                   (rhythms-and-pauses-this-cell (append preceeding-pauses
                                                                                                         (get-rhythm-for-pitches-include-nil layer indexx start-nth-pitch stop-nth-pitch)
                                                                                                         following-pauses))
                                                                   (pitches-this-cell-no-pause (get-pitches-between-nths-when-all-exist layer indexx 
                                                                                                                                        start-nth-pitch 
                                                                                                                                        stop-nth-pitch))
                                                                   (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                   (onsets (get-onsets-between-nth-pitches-include-preceeding&following-pauses layer indexx start-nth-pitch stop-nth-pitch))
                                                                   (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                   (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list (get-total-duration-timesigns-at-index indexx)))))
                                                                   (pitch-dur-offset-triplets (append preceeding-notassigned-nils
                                                                                                      (remove-not-assignd-and-remaining-triplets 
                                                                                                       (apply filter-fn (list
                                                                                                                         (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets)))))))
                                                                  
                                                              (eval (append '(and)
                                                                            (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                                  collect (if (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))) t)))))
                                                                  
                                                            ))

                                               (rhythmcell (let* ((first-pitch-in-cell (get-number-of-rhythms-at-index layer (1- indexx)))
                                                                  (number-of-needed-pitches-in-layer (get-number-of-rhythms-at-index layer indexx))
                                                                  (first-rhythm-or-pause-in-cell (get-number-of-rhythms-and-pauses-at-index layer (1- indexx))) ;nth, first is 0
                                                                  (number-of-rhythm-and-pause (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                  (start-nth-rhythm-or-pause (1+ (- first-rhythm-or-pause-in-cell nr-of-variables-in-fn)))
                                                                  preceeding-notassigned-nils)
                                                               ;(system::pwgl-print 'rhythm)
                                                             (if (minusp start-nth-rhythm-or-pause) (progn 
                                                                                                      (setf preceeding-notassigned-nils (make-list (abs start-nth-rhythm-or-pause) :initial-element '(nil nil nil)))
                                                                                                      (setf start-nth-rhythm-or-pause 0)))
                                                             (let* ((start-pitch-pointer (1+ (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer start-nth-rhythm-or-pause))) ;nth+1
                                                                    (stop-pitch-pointer (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer number-of-rhythm-and-pause))     ;nth+1
                                                                    (pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer start-pitch-pointer stop-pitch-pointer indexx))
                                                                    (rhythms-and-pauses-this-cell (get-durations-from-vector layer (1+ start-nth-rhythm-or-pause) (1+ number-of-rhythm-and-pause)))
                                                                    (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                    (onsets (mapcar #'(lambda (onset) (1- (abs onset)))
                                                                                    (get-onsets-from-vector layer (1+ start-nth-rhythm-or-pause) number-of-rhythm-and-pause)))
                                                                    (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                    (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list (get-total-duration-timesigns-at-index indexx)))))
                                                                        ;get-total-duration-timesigns-at-index adds the end time for measures
 
                                                                    (pitch-dur-offset-triplets (append preceeding-notassigned-nils
                                                                                                       (remove-not-assignd-and-remaining-triplets 
                                                                                                        (apply filter-fn (list
                                                                                                                          (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets)))))))
                                                                   
                                                               (eval (append '(and)
                                                                             (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                                   collect (if (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))) t)))))
                                                              
                                                             ))
                                               (timesign (let* ((starttime (get-total-duration-timesigns-at-index (1- indexx)))
                                                                (endtime (get-total-duration-timesigns-at-index indexx))
                                                                (tot-length-rhythm-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                (first-pointer-in-this-measure (get-pointer-for-rhythm-at-or-after-timepoint layer starttime tot-length-rhythm-layer))
                                                                (start-nth-rhythm-or-pause (- first-pointer-in-this-measure nr-of-variables-in-fn))
                                                                preceeding-notassigned-nils)
                                                           ;(system::pwgl-print 'time)
                                                           (if (minusp start-nth-rhythm-or-pause) (progn 
                                                                                                    (setf preceeding-notassigned-nils (make-list (abs start-nth-rhythm-or-pause) :initial-element '(nil nil nil)))
                                                                                                    (setf start-nth-rhythm-or-pause 0)))
                                                           (if (>= tot-length-rhythm-layer nr-of-variables-in-fn)
                                                               (let* ((start-pitch-pointer (1+ (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer start-nth-rhythm-or-pause)))
                                                                      (stop-pitch-pointer (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer tot-length-rhythm-layer))
                                                                      (pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer start-pitch-pointer stop-pitch-pointer indexx))
                                                                      (rhythms-and-pauses-this-cell (get-durations-from-vector layer (1+ start-nth-rhythm-or-pause) (1+ tot-length-rhythm-layer)))
                                                                      (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                      (onsets (mapcar #'(lambda (onset) (1- (abs onset)))
                                                                                      (get-onsets-from-vector layer (1+ start-nth-rhythm-or-pause) tot-length-rhythm-layer)))
                                                                      (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                      (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list endtime))))
                                                                      (pitch-dur-offset-triplets (append preceeding-notassigned-nils
                                                                                                         (remove-not-assignd-and-remaining-triplets 
                                                                                                          (apply filter-fn (list
                                                                                                                            (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets)))))))
                                                                 
                                                                 (eval (append '(and)
                                                                               (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                                     collect (if (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))) t)))))
                                                             t)))
                                               )
                                           t)
                        )))))


(defun pitch-rhythm-and-beat-no-pauses-include-not-assigned-rule (rulefn layers metric-div-fn)
  (let* ((nr-of-variables-in-fn (length (system::arglist rulefn)))
         (filter-fn 'filter-remove-pauses))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer) (= (get-layer-nr x) *TIMESIGNLAYER*))
                                             (typecase x
                                               (pitchcell (let* ((number-of-events-in-cell (get-nr-of-events x))
                                                                 (number-of-pitches-in-layer (get-number-of-pitches-at-index layer indexx))
                                                                 (start-nth-pitch (1+ (- number-of-pitches-in-layer number-of-events-in-cell nr-of-variables-in-fn)));include events before this cell
                                                                 preceeding-notassigned-nils)
                                                            
                                                            (if (minusp start-nth-pitch) (progn 
                                                                                           (setf preceeding-notassigned-nils (make-list (abs start-nth-pitch) :initial-element '(nil nil nil)))
                                                                                           (setf start-nth-pitch 0)))                                                           
                                                            (let* ((stop-nth-pitch (1- number-of-pitches-in-layer))
                                                                   (preceeding-pauses (check-if-pauses-before layer indexx start-nth-pitch))
                                                                   (following-pauses (check-if-pauses-after layer indexx stop-nth-pitch))
                                                                   (rhythms-and-pauses-this-cell (append preceeding-pauses
                                                                                                         (get-rhythm-for-pitches-include-nil layer indexx start-nth-pitch stop-nth-pitch)
                                                                                                         following-pauses))
                                                                   (pitches-this-cell-no-pause (get-pitches-between-nths-when-all-exist layer indexx 
                                                                                                                                        start-nth-pitch 
                                                                                                                                        stop-nth-pitch))
                                                                   (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                   (onsets (get-onsets-between-nth-pitches-include-preceeding&following-pauses layer indexx start-nth-pitch stop-nth-pitch))
                                                                   (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                   (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list (get-total-duration-timesigns-at-index indexx)))))
                                                                   (pitch-dur-offset-triplets (append preceeding-notassigned-nils
                                                                                                      (remove-not-assignd-and-remaining-triplets 
                                                                                                       (apply filter-fn (list
                                                                                                                         (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets)))))))
                                                                  
                                                              (eval (append '(and)
                                                                            (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                                  collect (if (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))) t)))))
                                                                  
                                                            ))



                                               (rhythmcell (let* ((first-rhythm-no-pauses-in-cell (get-number-of-rhythms-at-index layer (1- indexx)))   ;nth, first is 0
                                                                  (number-of-rhythms-no-pauses-in-layer (get-number-of-rhythms-at-index layer indexx))
                                                                  (start-nth-rhythm-no-pauses (1+ (- first-rhythm-no-pauses-in-cell nr-of-variables-in-fn)))
                                                                  preceeding-notassigned-nils)
                                                               
                                                             (if (minusp start-nth-rhythm-no-pauses) (progn 
                                                                                                       (setf preceeding-notassigned-nils (make-list (abs start-nth-rhythm-no-pauses) :initial-element '(nil nil nil)))
                                                                                                       (setf start-nth-rhythm-no-pauses 0)))
                                                             (if (> number-of-rhythms-no-pauses-in-layer 0)  ;special case - only pauses in layer
                                                                 (let* ((pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer (1+ start-nth-rhythm-no-pauses) number-of-rhythms-no-pauses-in-layer indexx))
                                                                        (rhythms-and-pauses-this-cell (get-rhythm-for-pitches layer indexx start-nth-rhythm-no-pauses (1- number-of-rhythms-no-pauses-in-layer)))
                                                                        (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                        (start-pointer-rhythm-or-pause (get-localpointer-at-nthrhythm layer indexx start-nth-rhythm-no-pauses))
                                                                        (stop-pointer-rhythm-or-pause (get-localpointer-at-nthrhythm layer indexx (1- number-of-rhythms-no-pauses-in-layer)))
                                                                        (onsets (mapcar #'(lambda (onset) (1- (abs onset)))
                                                                                        (get-onsets-from-vector layer start-pointer-rhythm-or-pause stop-pointer-rhythm-or-pause)))
                                                                        (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                        (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list (get-total-duration-timesigns-at-index indexx)))))
                                                                        ;get-total-duration-timesigns-at-index adds the end time for measures
                                                                        
                                                                        (pitch-dur-offset-triplets (append preceeding-notassigned-nils
                                                                                                           (remove-not-assignd-and-remaining-triplets 
                                                                                                            (apply filter-fn (list
                                                                                                                              (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets)))))))
                                                                   
                                                                   (eval (append '(and)
                                                                                 (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                                       collect (if (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))) t)))))
                                                               t)
                                                             ))



                                               (timesign (let* ((starttime (get-total-duration-timesigns-at-index (1- indexx)))
                                                                (endtime (get-total-duration-timesigns-at-index indexx))
                                                                (tot-length-rhythm-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                (first-pointer-in-this-measure (get-pointer-for-rhythm-at-or-after-timepoint layer starttime tot-length-rhythm-layer))
                                                                (start-nth-pitch (- (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer first-pointer-in-this-measure)
                                                                                    nr-of-variables-in-fn))
                                                                preceeding-notassigned-nils)

                                                           (if (minusp start-nth-pitch) (progn 
                                                                                          (setf preceeding-notassigned-nils (make-list (abs start-nth-pitch) :initial-element '(nil nil nil)))
                                                                                          (setf start-nth-pitch 0)))
                                                           (if (get-localpointer-at-nthrhythm layer indexx start-nth-pitch)
                                                               (let* ((start-nth-rhythm-or-pause (1- (get-localpointer-at-nthrhythm layer indexx start-nth-pitch))) ;BUG - måste kolla nil
                                                                      (start-pitch-pointer (1+ (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer start-nth-rhythm-or-pause)))
                                                                      (stop-pitch-pointer (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer tot-length-rhythm-layer))
                                                                      (pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer start-pitch-pointer stop-pitch-pointer indexx))
                                                                      (rhythms-and-pauses-this-cell (get-durations-from-vector layer (1+ start-nth-rhythm-or-pause) (1+ tot-length-rhythm-layer)))
                                                                      (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                      (onsets (mapcar #'(lambda (onset) (1- (abs onset)))
                                                                                      (get-onsets-from-vector layer (1+ start-nth-rhythm-or-pause) tot-length-rhythm-layer)))
                                                                      (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                      (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list endtime))))
                                                                      (pitch-dur-offset-triplets (remove-not-assignd-and-remaining-triplets 
                                                                                                  (apply filter-fn (list
                                                                                                                    (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets))))))
                                                                 (eval (append '(and)
                                                                               (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                                     collect (if (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))) t)))))
                                                             t)
                                                           ))
                                               )
                                           t)
                        )))))



;;;;;;;;HEURISTIC RULES


(defun pitch-rhythm-and-beat-heuristic-rule (rulefn layers metric-div-fn)
  (let* ((nr-of-variables-in-fn (length (system::arglist rulefn)))
         (filter-fn 'filter-keep-all))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer) (= (get-layer-nr x) *TIMESIGNLAYER*))
                                             (typecase x
                                               (pitchcell (let* ((number-of-events-in-cell (get-nr-of-events x))
                                                                 (number-of-pitches-in-layer (get-number-of-pitches-at-index layer indexx))
                                                                 (start-nth-pitch (1+ (- number-of-pitches-in-layer number-of-events-in-cell nr-of-variables-in-fn)));include events before this cell
                                                                 )
                                                            (if (minusp start-nth-pitch) (let ((nr-of-pauses+1 (get-localpointer-at-nthrhythm layer indexx 0)))
                                                                                           (if (and nr-of-pauses+1 (>= (1- nr-of-pauses+1) (abs start-nth-pitch)))  (setf start-nth-pitch 0))))
                                                            ;(system::pwgl-print 'pitch)
                                                            (if (>= start-nth-pitch 0)
                                                                (let* ((stop-nth-pitch (1- number-of-pitches-in-layer))
                                                                       (preceeding-pauses (check-if-pauses-before layer indexx start-nth-pitch))
                                                                       (following-pauses (check-if-pauses-after layer indexx stop-nth-pitch))
                                                                       (rhythms-and-pauses-this-cell (append preceeding-pauses
                                                                                                             (get-rhythm-for-pitches-include-nil layer indexx start-nth-pitch stop-nth-pitch)
                                                                                                             following-pauses))
                                                                       (pitches-this-cell-no-pause (get-pitches-between-nths-when-all-exist layer indexx 
                                                                                                                                            start-nth-pitch 
                                                                                                                                            stop-nth-pitch))
                                                                       (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                       

                                                                       (onsets (get-onsets-between-nth-pitches-include-preceeding&following-pauses layer indexx start-nth-pitch stop-nth-pitch))
                                                                       (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                       (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list (get-total-duration-timesigns-at-index indexx)))))
                                                                       (pitch-dur-offset-triplets (remove-not-assignd-and-remaining-triplets 
                                                                                                   (apply filter-fn (list
                                                                                                                     (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets))))))
                                                                  
                                                                  (apply '+
                                                                         (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                               collect (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))))))
                                                                  
                                                              0)))

                                               (rhythmcell (let* ((first-pitch-in-cell (get-number-of-rhythms-at-index layer (1- indexx)))
                                                                  (number-of-needed-pitches-in-layer (get-number-of-rhythms-at-index layer indexx))
                                                                  (first-rhythm-or-pause-in-cell (get-number-of-rhythms-and-pauses-at-index layer (1- indexx))) ;nth, first is 0
                                                                  (number-of-rhythm-and-pause (get-number-of-rhythms-and-pauses-at-index layer indexx))

                                                                  (start-nth-rhythm-or-pause (1+ (- first-rhythm-or-pause-in-cell nr-of-variables-in-fn))))
                                                               ;(system::pwgl-print 'rhythm)
                                                             (if (minusp start-nth-rhythm-or-pause) (setf start-nth-rhythm-or-pause 0))
                                                             (if (>= number-of-rhythm-and-pause nr-of-variables-in-fn)

                                                                 (let* ((start-pitch-pointer (1+ (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer start-nth-rhythm-or-pause))) ;nth+1
                                                                        (stop-pitch-pointer (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer number-of-rhythm-and-pause))     ;nth+1
                                                                        (pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer start-pitch-pointer stop-pitch-pointer indexx))
                                                                        (rhythms-and-pauses-this-cell (get-durations-from-vector layer (1+ start-nth-rhythm-or-pause) (1+ number-of-rhythm-and-pause)))
                                                                        (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                        (onsets (mapcar #'(lambda (onset) (1- (abs onset)))
                                                                                        (get-onsets-from-vector layer (1+ start-nth-rhythm-or-pause) number-of-rhythm-and-pause)))
                                                                        (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                        (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list (get-total-duration-timesigns-at-index indexx)))))
                                                                        ;get-total-duration-timesigns-at-index adds the end time for measures
 
                                                                        (pitch-dur-offset-triplets (remove-not-assignd-and-remaining-triplets 
                                                                                                    (apply filter-fn (list
                                                                                                                      (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets))))))
                                                                   
                                                                   (apply '+
                                                                          (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                                collect (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))))))
                                                              
                                                               0)))
                                               (timesign (let* ((starttime (get-total-duration-timesigns-at-index (1- indexx)))
                                                                (endtime (get-total-duration-timesigns-at-index indexx))
                                                                (tot-length-rhythm-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                (first-pointer-in-this-measure (get-pointer-for-rhythm-at-or-after-timepoint layer starttime tot-length-rhythm-layer))
                                                                (start-nth-rhythm-or-pause (- first-pointer-in-this-measure nr-of-variables-in-fn)))
                                                           ;(system::pwgl-print 'time)
                                                           (if (minusp start-nth-rhythm-or-pause) (setf start-nth-rhythm-or-pause 0))
                                                           (if (>= tot-length-rhythm-layer nr-of-variables-in-fn)
                                                               (let* ((start-pitch-pointer (1+ (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer start-nth-rhythm-or-pause)))
                                                                      (stop-pitch-pointer (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer tot-length-rhythm-layer))
                                                                      (pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer start-pitch-pointer stop-pitch-pointer indexx))
                                                                      (rhythms-and-pauses-this-cell (get-durations-from-vector layer (1+ start-nth-rhythm-or-pause) (1+ tot-length-rhythm-layer)))
                                                                      (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                      (onsets (mapcar #'(lambda (onset) (1- (abs onset)))
                                                                                      (get-onsets-from-vector layer (1+ start-nth-rhythm-or-pause) tot-length-rhythm-layer)))
                                                                      (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                      (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list endtime))))
                                                                      (pitch-dur-offset-triplets (remove-not-assignd-and-remaining-triplets 
                                                                                                  (apply filter-fn (list
                                                                                                                    (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets))))))
                                                                 
                                                                 (apply '+
                                                                        (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                              collect (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))))))
                                                             0)))
                                               )
                                           0)
                        )))))




(defun pitch-rhythm-and-beat-no-pauses-heuristic-rule (rulefn layers metric-div-fn)
  (let* ((nr-of-variables-in-fn (length (system::arglist rulefn)))
         (filter-fn 'filter-remove-pauses))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer) (= (get-layer-nr x) *TIMESIGNLAYER*))
                                             (typecase x
                                               (pitchcell (let* ((number-of-events-in-cell (get-nr-of-events x))
                                                                 (number-of-pitches-in-layer (get-number-of-pitches-at-index layer indexx))
                                                                 (start-nth-pitch (1+ (- number-of-pitches-in-layer number-of-events-in-cell nr-of-variables-in-fn)));include events before this cell
                                                                 )
                                                            ;(if (minusp start-nth-pitch) (let ((nr-of-pauses+1 (get-localpointer-at-nthrhythm layer indexx 0)))
                                                            ;                               (if (and nr-of-pauses+1 (>= (1- nr-of-pauses+1) (abs start-nth-pitch)))  (setf start-nth-pitch 0))))
                                                            (if (>= start-nth-pitch 0)
                                                                (let* ((stop-nth-pitch (1- number-of-pitches-in-layer))
                                                                       (preceeding-pauses (check-if-pauses-before layer indexx start-nth-pitch))
                                                                       (following-pauses (check-if-pauses-after layer indexx stop-nth-pitch))
                                                                       (rhythms-and-pauses-this-cell (append preceeding-pauses
                                                                                                             (get-rhythm-for-pitches-include-nil layer indexx start-nth-pitch stop-nth-pitch)
                                                                                                             following-pauses))
                                                                       (pitches-this-cell-no-pause (get-pitches-between-nths-when-all-exist layer indexx 
                                                                                                                                            start-nth-pitch 
                                                                                                                                            stop-nth-pitch))
                                                                       (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                       

                                                                       (onsets (get-onsets-between-nth-pitches-include-preceeding&following-pauses layer indexx start-nth-pitch stop-nth-pitch))
                                                                       (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                       (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list (get-total-duration-timesigns-at-index indexx)))))
                                                                       (pitch-dur-offset-triplets (remove-not-assignd-and-remaining-triplets 
                                                                                                   (apply filter-fn (list
                                                                                                                     (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets))))))
                                                                  
                                                                  (apply '+
                                                                         (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                               collect (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))))))
                                                                  
                                                              0)))



                                               (rhythmcell (let* ((first-rhythm-no-pauses-in-cell (get-number-of-rhythms-at-index layer (1- indexx)))   ;nth, first is 0
                                                                  (number-of-rhythms-no-pauses-in-layer (get-number-of-rhythms-at-index layer indexx))
                                                                  (start-nth-rhythm-no-pauses (1+ (- first-rhythm-no-pauses-in-cell nr-of-variables-in-fn))))
                                                               
                                                             (if (minusp start-nth-rhythm-no-pauses) (setf start-nth-rhythm-no-pauses 0))
                                                             (if (and (>= number-of-rhythms-no-pauses-in-layer nr-of-variables-in-fn) (/= number-of-rhythms-no-pauses-in-layer first-rhythm-no-pauses-in-cell))

                                                                 (let* ((pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer (1+ start-nth-rhythm-no-pauses) number-of-rhythms-no-pauses-in-layer indexx))
                                                                        (rhythms-and-pauses-this-cell (get-rhythm-for-pitches layer indexx start-nth-rhythm-no-pauses (1- number-of-rhythms-no-pauses-in-layer)))
                                                                        (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                        (start-pointer-rhythm-or-pause (get-localpointer-at-nthrhythm layer indexx start-nth-rhythm-no-pauses))
                                                                        (stop-pointer-rhythm-or-pause (get-localpointer-at-nthrhythm layer indexx (1- number-of-rhythms-no-pauses-in-layer)))
                                                                        (onsets (mapcar #'(lambda (onset) (1- (abs onset)))
                                                                                        (get-onsets-from-vector layer start-pointer-rhythm-or-pause stop-pointer-rhythm-or-pause)))
                                                                        (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                        (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list (get-total-duration-timesigns-at-index indexx)))))
                                                                        ;get-total-duration-timesigns-at-index adds the end time for measures
                                                                        
                                                                        (pitch-dur-offset-triplets (remove-not-assignd-and-remaining-triplets 
                                                                                                    (apply filter-fn (list
                                                                                                                      (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets))))))
                                                                   
                                                                   (apply '+
                                                                          (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                                collect (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))))))
                                                                   
                                                              
                                                               0)))



                                               (timesign (let* ((starttime (get-total-duration-timesigns-at-index (1- indexx)))
                                                                (endtime (get-total-duration-timesigns-at-index indexx))
                                                                (tot-length-rhythm-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                (first-pointer-in-this-measure (get-pointer-for-rhythm-at-or-after-timepoint layer starttime tot-length-rhythm-layer))
                                                                ;(start-nth-rhythm-or-pause (- first-pointer-in-this-measure nr-of-variables-in-fn))
                                                                (start-nth-pitch (- (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer first-pointer-in-this-measure)
                                                                                    nr-of-variables-in-fn)))
                                                           (if (minusp start-nth-pitch) (setf start-nth-pitch 0))
                                                           (if (and (get-localpointer-at-nthrhythm layer indexx start-nth-pitch) (>= tot-length-rhythm-layer nr-of-variables-in-fn))
                                                               (let* ((start-nth-rhythm-or-pause (1- (get-localpointer-at-nthrhythm layer indexx start-nth-pitch)))
                                                                      (start-pitch-pointer (1+ (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer start-nth-rhythm-or-pause)))
                                                                      (stop-pitch-pointer (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer tot-length-rhythm-layer))
                                                                      (pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer start-pitch-pointer stop-pitch-pointer indexx))
                                                                      (rhythms-and-pauses-this-cell (get-durations-from-vector layer (1+ start-nth-rhythm-or-pause) (1+ tot-length-rhythm-layer)))
                                                                      (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                      (onsets (mapcar #'(lambda (onset) (1- (abs onset)))
                                                                                      (get-onsets-from-vector layer (1+ start-nth-rhythm-or-pause) tot-length-rhythm-layer)))
                                                                      (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                      (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list endtime))))
                                                                      (pitch-dur-offset-triplets (remove-not-assignd-and-remaining-triplets 
                                                                                                  (apply filter-fn (list
                                                                                                                    (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets))))))
                                                                 (apply '+
                                                                        (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                              collect (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))))))
                                                             0)))
                                               )
                                           t)
                        )))))





(defun pitch-rhythm-and-beat-include-not-assigned-heuristic-rule (rulefn layers metric-div-fn)
  (let* ((nr-of-variables-in-fn (length (system::arglist rulefn)))
         (filter-fn 'filter-keep-all))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer) (= (get-layer-nr x) *TIMESIGNLAYER*))
                                             (typecase x
                                               (pitchcell (let* ((number-of-events-in-cell (get-nr-of-events x))
                                                                 (number-of-pitches-in-layer (get-number-of-pitches-at-index layer indexx))
                                                                 (start-nth-pitch (1+ (- number-of-pitches-in-layer number-of-events-in-cell nr-of-variables-in-fn)));include events before this cell
                                                                 preceeding-notassigned-nils)
                                                            (if (minusp start-nth-pitch) (progn 
                                                                                           (setf preceeding-notassigned-nils (make-list (abs start-nth-pitch) :initial-element '(nil nil nil)))
                                                                                           (setf start-nth-pitch 0)))
                                                            ;(system::pwgl-print 'pitch)
                                                            
                                                            (let* ((stop-nth-pitch (1- number-of-pitches-in-layer))
                                                                   (preceeding-pauses (check-if-pauses-before layer indexx start-nth-pitch))
                                                                   (following-pauses (check-if-pauses-after layer indexx stop-nth-pitch))
                                                                   (rhythms-and-pauses-this-cell (append preceeding-pauses
                                                                                                         (get-rhythm-for-pitches-include-nil layer indexx start-nth-pitch stop-nth-pitch)
                                                                                                         following-pauses))
                                                                   (pitches-this-cell-no-pause (get-pitches-between-nths-when-all-exist layer indexx 
                                                                                                                                        start-nth-pitch 
                                                                                                                                        stop-nth-pitch))
                                                                   (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                   (onsets (get-onsets-between-nth-pitches-include-preceeding&following-pauses layer indexx start-nth-pitch stop-nth-pitch))
                                                                   (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                   (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list (get-total-duration-timesigns-at-index indexx)))))
                                                                   (pitch-dur-offset-triplets (append preceeding-notassigned-nils
                                                                                                      (remove-not-assignd-and-remaining-triplets 
                                                                                                       (apply filter-fn (list
                                                                                                                         (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets)))))))
                                                                  
                                                              (apply '+
                                                                     (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                           collect (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))))))
                                                                  
                                                            ))

                                               (rhythmcell (let* ((first-pitch-in-cell (get-number-of-rhythms-at-index layer (1- indexx)))
                                                                  (number-of-needed-pitches-in-layer (get-number-of-rhythms-at-index layer indexx))
                                                                  (first-rhythm-or-pause-in-cell (get-number-of-rhythms-and-pauses-at-index layer (1- indexx))) ;nth, first is 0
                                                                  (number-of-rhythm-and-pause (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                  (start-nth-rhythm-or-pause (1+ (- first-rhythm-or-pause-in-cell nr-of-variables-in-fn)))
                                                                  preceeding-notassigned-nils)
                                                               ;(system::pwgl-print 'rhythm)
                                                             (if (minusp start-nth-rhythm-or-pause) (progn 
                                                                                                      (setf preceeding-notassigned-nils (make-list (abs start-nth-rhythm-or-pause) :initial-element '(nil nil nil)))
                                                                                                      (setf start-nth-rhythm-or-pause 0)))
                                                             (let* ((start-pitch-pointer (1+ (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer start-nth-rhythm-or-pause))) ;nth+1
                                                                    (stop-pitch-pointer (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer number-of-rhythm-and-pause))     ;nth+1
                                                                    (pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer start-pitch-pointer stop-pitch-pointer indexx))
                                                                    (rhythms-and-pauses-this-cell (get-durations-from-vector layer (1+ start-nth-rhythm-or-pause) (1+ number-of-rhythm-and-pause)))
                                                                    (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                    (onsets (mapcar #'(lambda (onset) (1- (abs onset)))
                                                                                    (get-onsets-from-vector layer (1+ start-nth-rhythm-or-pause) number-of-rhythm-and-pause)))
                                                                    (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                    (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list (get-total-duration-timesigns-at-index indexx)))))
                                                                        ;get-total-duration-timesigns-at-index adds the end time for measures
 
                                                                    (pitch-dur-offset-triplets (append preceeding-notassigned-nils
                                                                                                       (remove-not-assignd-and-remaining-triplets 
                                                                                                        (apply filter-fn (list
                                                                                                                          (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets)))))))
                                                                   
                                                               (apply '+
                                                                      (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                            collect (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))))))
                                                              
                                                             ))
                                               (timesign (let* ((starttime (get-total-duration-timesigns-at-index (1- indexx)))
                                                                (endtime (get-total-duration-timesigns-at-index indexx))
                                                                (tot-length-rhythm-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                (first-pointer-in-this-measure (get-pointer-for-rhythm-at-or-after-timepoint layer starttime tot-length-rhythm-layer))
                                                                (start-nth-rhythm-or-pause (- first-pointer-in-this-measure nr-of-variables-in-fn))
                                                                preceeding-notassigned-nils)
                                                           ;(system::pwgl-print 'time)
                                                           (if (minusp start-nth-rhythm-or-pause) (progn 
                                                                                                    (setf preceeding-notassigned-nils (make-list (abs start-nth-rhythm-or-pause) :initial-element '(nil nil nil)))
                                                                                                    (setf start-nth-rhythm-or-pause 0)))
                                                           (if (>= tot-length-rhythm-layer nr-of-variables-in-fn)
                                                               (let* ((start-pitch-pointer (1+ (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer start-nth-rhythm-or-pause)))
                                                                      (stop-pitch-pointer (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer tot-length-rhythm-layer))
                                                                      (pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer start-pitch-pointer stop-pitch-pointer indexx))
                                                                      (rhythms-and-pauses-this-cell (get-durations-from-vector layer (1+ start-nth-rhythm-or-pause) (1+ tot-length-rhythm-layer)))
                                                                      (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                      (onsets (mapcar #'(lambda (onset) (1- (abs onset)))
                                                                                      (get-onsets-from-vector layer (1+ start-nth-rhythm-or-pause) tot-length-rhythm-layer)))
                                                                      (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                      (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list endtime))))
                                                                      (pitch-dur-offset-triplets (append preceeding-notassigned-nils
                                                                                                         (remove-not-assignd-and-remaining-triplets 
                                                                                                          (apply filter-fn (list
                                                                                                                            (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets)))))))
                                                                 
                                                                 (apply '+
                                                                        (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                              collect (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))))))
                                                             0)))
                                               )
                                           0)
                        )))))



(defun pitch-rhythm-and-beat-no-pauses-include-not-assigned-heuristic-rule (rulefn layers metric-div-fn)
  (let* ((nr-of-variables-in-fn (length (system::arglist rulefn)))
         (filter-fn 'filter-remove-pauses))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer) (= (get-layer-nr x) *TIMESIGNLAYER*))
                                             (typecase x
                                               (pitchcell (let* ((number-of-events-in-cell (get-nr-of-events x))
                                                                 (number-of-pitches-in-layer (get-number-of-pitches-at-index layer indexx))
                                                                 (start-nth-pitch (1+ (- number-of-pitches-in-layer number-of-events-in-cell nr-of-variables-in-fn)));include events before this cell
                                                                 preceeding-notassigned-nils)
                                                            (if (minusp start-nth-pitch) (progn 
                                                                                           (setf preceeding-notassigned-nils (make-list (abs start-nth-pitch) :initial-element '(nil nil nil)))
                                                                                           (setf start-nth-pitch 0)))                                                           
                                                            (let* ((stop-nth-pitch (1- number-of-pitches-in-layer))
                                                                   (preceeding-pauses (check-if-pauses-before layer indexx start-nth-pitch))
                                                                   (following-pauses (check-if-pauses-after layer indexx stop-nth-pitch))
                                                                   (rhythms-and-pauses-this-cell (append preceeding-pauses
                                                                                                         (get-rhythm-for-pitches-include-nil layer indexx start-nth-pitch stop-nth-pitch)
                                                                                                         following-pauses))
                                                                   (pitches-this-cell-no-pause (get-pitches-between-nths-when-all-exist layer indexx 
                                                                                                                                        start-nth-pitch 
                                                                                                                                        stop-nth-pitch))
                                                                   (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                   (onsets (get-onsets-between-nth-pitches-include-preceeding&following-pauses layer indexx start-nth-pitch stop-nth-pitch))
                                                                   (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                   (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list (get-total-duration-timesigns-at-index indexx)))))
                                                                   (pitch-dur-offset-triplets (append preceeding-notassigned-nils
                                                                                                      (remove-not-assignd-and-remaining-triplets 
                                                                                                       (apply filter-fn (list
                                                                                                                         (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets)))))))
                                                                  
                                                              (apply '+
                                                                     (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                           collect (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))))))
                                                                  
                                                            ))



                                               (rhythmcell (let* ((first-rhythm-no-pauses-in-cell (get-number-of-rhythms-at-index layer (1- indexx)))   ;nth, first is 0
                                                                  (number-of-rhythms-no-pauses-in-layer (get-number-of-rhythms-at-index layer indexx))
                                                                  (start-nth-rhythm-no-pauses (1+ (- first-rhythm-no-pauses-in-cell nr-of-variables-in-fn)))
                                                                  preceeding-notassigned-nils)
                                                               
                                                             (if (minusp start-nth-rhythm-no-pauses) (progn 
                                                                                                       (setf preceeding-notassigned-nils (make-list (abs start-nth-rhythm-no-pauses) :initial-element '(nil nil nil)))
                                                                                                       (setf start-nth-rhythm-no-pauses 0)))
                                                             (if (> number-of-rhythms-no-pauses-in-layer 0)  ;special case - only pauses in layer
                                                                 (let* ((pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer (1+ start-nth-rhythm-no-pauses) number-of-rhythms-no-pauses-in-layer indexx))
                                                                        (rhythms-and-pauses-this-cell (get-rhythm-for-pitches layer indexx start-nth-rhythm-no-pauses (1- number-of-rhythms-no-pauses-in-layer)))
                                                                        (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                        (start-pointer-rhythm-or-pause (get-localpointer-at-nthrhythm layer indexx start-nth-rhythm-no-pauses))
                                                                        (stop-pointer-rhythm-or-pause (get-localpointer-at-nthrhythm layer indexx (1- number-of-rhythms-no-pauses-in-layer)))
                                                                        (onsets (mapcar #'(lambda (onset) (1- (abs onset)))
                                                                                        (get-onsets-from-vector layer start-pointer-rhythm-or-pause stop-pointer-rhythm-or-pause)))
                                                                        (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                        (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list (get-total-duration-timesigns-at-index indexx)))))
                                                                        ;get-total-duration-timesigns-at-index adds the end time for measures
                                                                        
                                                                        (pitch-dur-offset-triplets (append preceeding-notassigned-nils
                                                                                                           (remove-not-assignd-and-remaining-triplets 
                                                                                                            (apply filter-fn (list
                                                                                                                              (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets)))))))
                                                                   
                                                                   (apply '+
                                                                          (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                                collect (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))))))
                                                               0)
                                                             ))



                                               (timesign (let* ((starttime (get-total-duration-timesigns-at-index (1- indexx)))
                                                                (endtime (get-total-duration-timesigns-at-index indexx))
                                                                (tot-length-rhythm-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                (first-pointer-in-this-measure (get-pointer-for-rhythm-at-or-after-timepoint layer starttime tot-length-rhythm-layer))
                                                                (start-nth-pitch (- (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer first-pointer-in-this-measure)
                                                                                    nr-of-variables-in-fn))
                                                                preceeding-notassigned-nils)


                                                           (if (minusp start-nth-pitch) (progn 
                                                                                          (setf preceeding-notassigned-nils (make-list (abs start-nth-pitch) :initial-element '(nil nil nil)))
                                                                                          (setf start-nth-pitch 0)))
                                                           (if (get-localpointer-at-nthrhythm layer indexx start-nth-pitch) ;check that event exists
                                                               (let* ((start-nth-rhythm-or-pause (1- (get-localpointer-at-nthrhythm layer indexx start-nth-pitch))) ;BUG - måste kolla nil
                                                                      (start-pitch-pointer (1+ (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer start-nth-rhythm-or-pause)))
                                                                      (stop-pitch-pointer (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer tot-length-rhythm-layer))
                                                                      (pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer start-pitch-pointer stop-pitch-pointer indexx))
                                                                      (rhythms-and-pauses-this-cell (get-durations-from-vector layer (1+ start-nth-rhythm-or-pause) (1+ tot-length-rhythm-layer)))
                                                                      (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                      (onsets (mapcar #'(lambda (onset) (1- (abs onset)))
                                                                                      (get-onsets-from-vector layer (1+ start-nth-rhythm-or-pause) tot-length-rhythm-layer)))
                                                                      (all-metric-starttimes (mapcar '1- (apply metric-div-fn (list indexx))))
                                                                      (metric-offsets (find-measure-offsets onsets (append all-metric-starttimes (list endtime))))
                                                                      (pitch-dur-offset-triplets (remove-not-assignd-and-remaining-triplets 
                                                                                                  (apply filter-fn (list
                                                                                                                    (mc-mattrans3 pitches-this-cell rhythms-and-pauses-this-cell metric-offsets))))))
                                                                 (apply '+
                                                                        (loop for n from 0 to (- (length pitch-dur-offset-triplets) nr-of-variables-in-fn) 
                                                                              collect (apply rulefn (strip-selection pitch-dur-offset-triplets n (+ n (1- nr-of-variables-in-fn)))))))
                                                             0)
                                                           ))
                                               )
                                           0)
                        )))))
