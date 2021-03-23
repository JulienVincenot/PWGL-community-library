(in-package :mc)

(defun get-pointer-for-rhythm-at-or-before-timepoint (layer timepoint tot-length-rhythm-layer)
  "Returns the pointer to the rhythm or pause that coinside with the timepoint (starting from 0) or, if no exists, the rhythm or pause 
that comes immediate before."
  (let (this-timepoint)  
    (loop for local-pointer from 1 to tot-length-rhythm-layer 
          while (progn (setf this-timepoint (aref part-sol-vector layer local-pointer *ONSETTIME*))
                  (< (1- (abs this-timepoint)) timepoint))
          finally (return (if (= (1- (abs this-timepoint)) timepoint) 
                              local-pointer (1- local-pointer))))))



(defun get-timesigns-for-last-beats (index find-nr-beats)
  "The result is reverse"
  (let ((all-local-pointers (remove nil (remove-duplicates 
                                         (loop for this-index from 1 to index
                                               collect (aref pointers-vector *TIMESIGNLAYER* this-index *ONSETTIME* *STARTPOINTER*)))))
        (beats-so-far 0))
    
    (if (/= 0 find-nr-beats)
        (if all-local-pointers
            (loop for i from (1- (length all-local-pointers)) downto 0
                  collect (aref part-sol-timegridvector *TIMESIGN* (nth i all-local-pointers))
                  while (> find-nr-beats (setf beats-so-far (+ beats-so-far (car (aref part-sol-timegridvector *TIMESIGN* (nth i all-local-pointers)))))))
          '())
      nil)
    ))



(defun get-last-beats (index find-nr-beats)
  "Not assigned beats will be indicatedd by nil."
  (let* ((timesigns (get-timesigns-for-last-beats index find-nr-beats))
         (beats (apply 'append 
                       (mapcar #'(lambda (timesign) (make-list (car timesign) :initial-element (/ 1 (second timesign))))
                               timesigns))))
    (loop for n from (1- find-nr-beats) downto 0 
          collect (nth n beats))))


(defun get-timesigns-for-last-measures (index find-nr-measures)
  "The result is reverse"
  (let* ((all-local-pointers (remove nil (remove-duplicates 
                                          (loop for this-index from 1 to index
                                                collect (aref pointers-vector *TIMESIGNLAYER* this-index *ONSETTIME* *STARTPOINTER*)))))
         (first-measure-nr (- (length all-local-pointers) find-nr-measures)))
    
    (if (minusp first-measure-nr) (setf first-measure-nr 0))
    (if all-local-pointers
        (loop for i from (1- (length all-local-pointers)) downto first-measure-nr
              collect (aref part-sol-timegridvector *TIMESIGN* (nth i all-local-pointers))
              )
      nil)
    ))

(defun get-last-measures-lengths (index find-nr-measures)
  "Not assigned measures will be indicated by nil."
  (let* ((timesigns (get-timesigns-for-last-measures index find-nr-measures))
         (measure-lengths (mapcar #'(lambda (timesign) (/ (car timesign) (second timesign)))
                               timesigns)))
    (loop for n from (1- find-nr-measures) downto 0
          collect (nth n measure-lengths))))



(defun ratios-to-onsets-to-endtime (list-of-ratios endtime)
  "ratios are expected to be positive (no pauses). Nil will break calculation. Endtime is not included in te result."
  (let ((time endtime))
    (reverse (loop for n from (1- (length list-of-ratios)) downto 0
                   while (nth n list-of-ratios)
                   collect (setf time (- time (nth n list-of-ratios)))))))



(defun at-beat-metric-rule (rulefn layers)
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
                                                                      (offset-at-or-before-beats (mapcar #'(lambda (onset beat-pos) (- onset beat-pos)) onset-at-or-before-beats filtered-beat-pos))
                                                                      (dur-offset-pairs (mc-mattrans duration-at-or-before-beats offset-at-or-before-beats)))


                                                                 (eval (append '(and)
                                                                               (loop for n from 0 to (- (length pointer-at-or-before-beats) nr-of-variables-in-fn)
                                                                                     collect (if (apply rulefn (strip-selection dur-offset-pairs n (+ n (1- nr-of-variables-in-fn)))) t)))))
                                                             t)))
                                               


                                               (rhythmcell (let* ((start-time-this-cell (get-total-duration-rhythms-at-index layer (1- indexx)))
                                                                  (tot-number-of-dur-this-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                  (end-time-this-cell (get-total-duration-rhythms-at-index layer indexx))
                                                                  (all-beat-except-last (mapcar #'(lambda (time) (1- time)) (get-timepoints-at-beats-upto-index2 indexx))); 1- compensate for offset
                                                                  (tot-length-measures (get-total-duration-timesigns-at-index indexx))
                                                                  (all-beats (append all-beat-except-last (list tot-length-measures)))
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
                                                                              (dur-offset-pairs (mc-mattrans duration-at-or-before-beats offset-at-or-before-beats)))
                                                                         
                                                                         (eval (append '(and)
                                                                                       (loop for n from 0 to (- (length pointer-at-or-before-beats) nr-of-variables-in-fn)
                                                                                             collect (if (apply rulefn (strip-selection dur-offset-pairs n (+ n (1- nr-of-variables-in-fn)))) t)))))
                                                                     t))
                                                               t)))
                                               (t t))
                                           t))))))




(defun at-beat-metric-heuristic-rule (rulefn layers)
  (let* ((nr-of-variables-in-fn (length (system::arglist rulefn))))
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
                                                                      (offset-at-or-before-beats (mapcar #'(lambda (onset beat-pos) (- onset beat-pos)) onset-at-or-before-beats filtered-beat-pos))
                                                                      (dur-offset-pairs (mc-mattrans duration-at-or-before-beats offset-at-or-before-beats)))


                                                                 (apply '+
                                                                        (loop for n from 0 to (- (length pointer-at-or-before-beats) nr-of-variables-in-fn)
                                                                              collect (apply rulefn (strip-selection dur-offset-pairs n (+ n (1- nr-of-variables-in-fn)))))))
                                                             0)))
                                               


                                               (rhythmcell (let* ((start-time-this-cell (get-total-duration-rhythms-at-index layer (1- indexx)))
                                                                  (tot-number-of-dur-this-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                  (end-time-this-cell (get-total-duration-rhythms-at-index layer indexx))
                                                                  (all-beat-except-last (mapcar #'(lambda (time) (1- time)) (get-timepoints-at-beats-upto-index2 indexx))); 1- compensate for offset
                                                                  (tot-length-measures (get-total-duration-timesigns-at-index indexx))
                                                                  (all-beats (append all-beat-except-last (list tot-length-measures)))
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
                                                                              (dur-offset-pairs (mc-mattrans duration-at-or-before-beats offset-at-or-before-beats)))
                                                                         
                                                                         (system::pwgl-print (apply '+
                                                                                 (loop for n from 0 to (- (length pointer-at-or-before-beats) nr-of-variables-in-fn)
                                                                                       collect (apply rulefn (strip-selection dur-offset-pairs n (+ n (1- nr-of-variables-in-fn))))))))
                                                                     0))
                                                               0)))
                                               (t 0))
                                           0))))))




(defun get-last-measure-lengths-simple-rule (index nr-timesigns)
  "The result is reverse"
  (let* ((all-local-pointers (remove nil (remove-duplicates 
                                          (loop for this-index from 1 to index
                                                collect (aref pointers-vector *TIMESIGNLAYER* this-index *ONSETTIME* *STARTPOINTER*)))))
         (nth-first-pointer (- (length all-local-pointers) nr-timesigns)))
    (if (minusp nth-first-pointer) (setf nth-first-pointer 0)) ;simple rule
    
    (if (/= 0 nr-timesigns)
        (if all-local-pointers
            (reverse
             (loop for i from (1- (length all-local-pointers)) downto nth-first-pointer
                   collect (apply '/ (aref part-sol-timegridvector *TIMESIGN* (nth i all-local-pointers)))))
          nil)
      nil)
    ))



(defun at-measure-metric-rule (rulefn layers)
  (let* ((nr-of-variables-in-fn (length (system::arglist rulefn)))
         )
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
                                                                      (offset-at-or-before-measures (mapcar #'(lambda (onset beat-pos) (- onset beat-pos)) onset-at-or-before-measures filtered-measure-pos))
                                                                      (dur-offset-pairs (mc-mattrans duration-at-or-before-meaures offset-at-or-before-measures)))


                                                                 (eval (append '(and)
                                                                               (loop for n from 0 to (- (length pointer-at-or-before-measures) nr-of-variables-in-fn)
                                                                                     collect (if (apply rulefn (strip-selection dur-offset-pairs n (+ n (1- nr-of-variables-in-fn)))) t)))))
                                                             t)))
                                               

                                               (rhythmcell (let* ((start-time-this-cell (get-total-duration-rhythms-at-index layer (1- indexx)))
                                                                  (tot-number-of-dur-this-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                  (end-time-this-cell (get-total-duration-rhythms-at-index layer indexx))
                                                                  (all-measures-except-last (mapcar #'(lambda (time) (1- time)) (get-timepoints-at-measures-upto-index2 indexx))); 1- compensate for offset
                                                                  (tot-length-measures (get-total-duration-timesigns-at-index indexx))
                                                                  (all-measures (append all-measures-except-last (list tot-length-measures)))
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
                                                                              (dur-offset-pairs (mc-mattrans duration-at-or-before-measures offset-at-or-before-measures)))
                                                                         
                                                                         (eval (append '(and)
                                                                                       (loop for n from 0 to (- (length pointer-at-or-before-measures) nr-of-variables-in-fn)
                                                                                             collect (if (apply rulefn (strip-selection dur-offset-pairs n (+ n (1- nr-of-variables-in-fn)))) t)))))
                                                                     t))
                                                               t)))
                                               (t t))
                                           t)
                                           )))))





(defun at-measure-metric-heuristic-rule (rulefn layers)
  (let* ((nr-of-variables-in-fn (length (system::arglist rulefn)))
         )
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
                                                                      (offset-at-or-before-measures (mapcar #'(lambda (onset beat-pos) (- onset beat-pos)) onset-at-or-before-measures filtered-measure-pos))
                                                                      (dur-offset-pairs (mc-mattrans duration-at-or-before-meaures offset-at-or-before-measures)))


                                                                 (apply '+
                                                                        (loop for n from 0 to (- (length pointer-at-or-before-measures) nr-of-variables-in-fn)
                                                                              collect (apply rulefn (strip-selection dur-offset-pairs n (+ n (1- nr-of-variables-in-fn)))))))
                                                             0)))
                                               

                                               (rhythmcell (let* ((start-time-this-cell (get-total-duration-rhythms-at-index layer (1- indexx)))
                                                                  (tot-number-of-dur-this-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                  (end-time-this-cell (get-total-duration-rhythms-at-index layer indexx))
                                                                  (all-measures-except-last (mapcar #'(lambda (time) (1- time)) (get-timepoints-at-measures-upto-index2 indexx))); 1- compensate for offset
                                                                  (tot-length-measures (get-total-duration-timesigns-at-index indexx))
                                                                  (all-measures (append all-measures-except-last (list tot-length-measures)))
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
                                                                              (dur-offset-pairs (mc-mattrans duration-at-or-before-measures offset-at-or-before-measures)))
                                                                         
                                                                         (apply '+
                                                                                (loop for n from 0 to (- (length pointer-at-or-before-measures) nr-of-variables-in-fn)
                                                                                      collect (apply rulefn (strip-selection dur-offset-pairs n (+ n (1- nr-of-variables-in-fn)))))))
                                                                     0))
                                                               0)))
                                               (t 0))
                                           0))))))


;;;;;END HERE;;;;;