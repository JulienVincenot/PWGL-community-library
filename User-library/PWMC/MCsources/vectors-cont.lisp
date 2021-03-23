(in-package MC)
;;functions for matching pitch and rhythm in rules
;;vers 0.77 bug fixed in get-rhythm-for-pitches (dec 15 2006).

(defun get-localpointer-at-nthrhythm (layer index nth)
  (let ((number-of-rhythms (get-number-of-rhythms-at-index layer index)))
    (if (> (1+ nth) number-of-rhythms)
        nil
      (loop for local-pointer from nth ; no endpoint since it is not known
            when (= (1- (aref part-sol-vector layer local-pointer *#-RHYTHM-EVENT*))
                    nth)
                   return local-pointer)
                 )))

(defun get-nth-for-pitch-at-localpointer-for-rhythm (layer index local-pointer)
  "nth for pitch counts from 0, local-pointer counts from 1"
  (let ((number-of-rhythms (get-number-of-rhythms-and-pauses-at-index layer index)))
    (if (> local-pointer number-of-rhythms)
        nil
      (if (minusp (aref part-sol-vector layer local-pointer *ONSETTIME*)) nil
        (loop for nth from 0 ; no endpoint since it is not known
              when (= (1- (aref part-sol-vector layer local-pointer *#-RHYTHM-EVENT*))
                      nth)
              return nth)
        ))))

;(get-pitches-for-localpointers-rhythm&pause 0 16 1 8)


(defun get-duration-at-nthpitch (layer index nth)
  (let ((local-pointer (get-localpointer-at-nthrhythm layer index nth)))
    (if local-pointer
        (get-durations-from-vector layer local-pointer (1+ local-pointer)))))


(defun get-rhythm-for-pitches (layer index start-nth-pitch stop-nth-pitch)
    "This function will output rhythms that corresponds to pitches, given as order numbers starting from 0. If no rhythm is yet assigned, nil will be returned. If some of the durations are assigned, those will be returned (including pauses - as negative ratios)"
  (let ((start-local-pointer (get-localpointer-at-nthrhythm layer index start-nth-pitch))
        (stop-local-pointer (get-localpointer-at-nthrhythm layer index stop-nth-pitch)))
    (if stop-local-pointer
        (get-durations-from-vector layer start-local-pointer (1+ stop-local-pointer))
      (if start-local-pointer
          (progn (setf stop-local-pointer 
                       (1+ (get-localpointer-at-nthrhythm layer index (1- (get-number-of-rhythms-at-index layer index))))) ;1+ added Dec 15 2006.
            (get-durations-from-vector layer start-local-pointer stop-local-pointer))
        nil))))


(defun get-rhythm-for-pitches-include-nil (layer index start-nth-pitch stop-nth-pitch)
    "This function will output rhythms that corresponds to pitches, given as order numbers starting from 0. If no rhythm is yet assigned, nil will be returned. If some of the durations are assigned, those will be returned together with nil for those missing (including pauses - as negative ratios)"
  (let ((start-local-pointer (get-localpointer-at-nthrhythm layer index start-nth-pitch))
        (stop-local-pointer (get-localpointer-at-nthrhythm layer index stop-nth-pitch)))
    (if stop-local-pointer
        (get-durations-from-vector layer start-local-pointer (1+ stop-local-pointer))
      (if start-local-pointer
          (let ((number-of-rhythms (get-number-of-rhythms-at-index layer index))
                durations)
            (progn (setf stop-local-pointer 
                         (1+ (get-localpointer-at-nthrhythm layer index (1- number-of-rhythms)))) ;1+ added Dec 15 2006.
              (setf durations (get-durations-from-vector layer start-local-pointer stop-local-pointer))
              (setf durations (append durations (make-list (- stop-nth-pitch (1- number-of-rhythms)) :initial-element nil)))))
        (make-list (1+ (- stop-nth-pitch start-nth-pitch)) :initial-element nil)))))

;(get-rhythm-for-pitches-include-nil 0 13 0 3)


(defun get-onsets-for-pitches (layer index start-nth-pitch stop-nth-pitch)
    "This function will output onsets that corresponds to pitches, given as order numbers starting from 0. If no rhythm is yet assigned, nil will be returned. If some of the durations are assigned, existing onsets will be returned together with nil for those missing. Pauses will NOT be included."
     
     (let ((start-local-pointer (get-localpointer-at-nthrhythm layer index start-nth-pitch))
           (stop-local-pointer (get-localpointer-at-nthrhythm layer index stop-nth-pitch)))
       (if stop-local-pointer
           (remove nil (mapcar #'(lambda (x) (if (minusp x) nil x))
                               (get-onsets-from-vector layer start-local-pointer stop-local-pointer)))
         (if start-local-pointer
             (let ((nr-of-pitches (1+ (- stop-nth-pitch start-nth-pitch)))
                   truncated-onset-list)
               (setf stop-local-pointer 
                     (get-localpointer-at-nthrhythm layer index (1- (get-number-of-rhythms-at-index layer index))))
               (setf truncated-onset-list (remove nil (mapcar #'(lambda (x) (if (minusp x) nil x))
                               (get-onsets-from-vector layer start-local-pointer stop-local-pointer))))
               (append truncated-onset-list (make-list (- nr-of-pitches (length truncated-onset-list)) :initial-element nil))
               )
           (make-list (1+ (- stop-nth-pitch start-nth-pitch)) :initial-element nil)))))



(defun get-starttime-for-pitchcell (layer index start-nth-pitch)
  (let ((local-pointer (get-localpointer-at-nthrhythm layer index start-nth-pitch)))
    (if local-pointer (car (get-onsets-from-vector layer local-pointer local-pointer))
      nil)))

(defun get-endtime-for-pitchcell (layer index stop-nth-pitch)
  (let ((local-pointer (get-localpointer-at-nthrhythm layer index stop-nth-pitch)))
    (if local-pointer  (abs (car (get-onsets-from-vector layer (1+ local-pointer) (1+ local-pointer))))
      nil)))

;(get-onsets-for-pitches-with-endpoint 0 18 4 nil)
(defun get-onsets-for-pitches-with-endpoint (layer index start-nth-pitch stop-nth-pitch)
    "This function will output onsets that corresponds to pitches, given as order numbers starting from 0. If no rhythm is yet assigned, nil will be returned. If some of the durations are assigned, existing onsets will be returned together with nil for those missing."
    ; (system::pwgl-print (list layer index start-nth-pitch stop-nth-pitch))

     (let ((start-local-pointer (get-localpointer-at-nthrhythm layer index start-nth-pitch))
           (stop-local-pointer (get-localpointer-at-nthrhythm layer index stop-nth-pitch)))
       (if stop-local-pointer
           (let ((onsets (get-onsets-from-vector layer start-local-pointer (1+ stop-local-pointer))))
             (setf onsets (append (butlast onsets) (list (abs (car (last onsets)))))) ;make sure endpoint is not negative
             (remove nil (mapcar #'(lambda (x) (if (minusp x) nil x))
                     onsets)))
         (if start-local-pointer
             (let ((nr-of-pitches (1+ (- stop-nth-pitch start-nth-pitch)))
                   truncated-onset-list)
               (setf stop-local-pointer 
                     (1+ (get-localpointer-at-nthrhythm layer index (1- (get-number-of-rhythms-at-index layer index)))))
               (setf truncated-onset-list (get-onsets-from-vector layer start-local-pointer stop-local-pointer))
               (setf truncated-onset-list (remove nil (mapcar #'(lambda (x) (if (minusp x) nil x)) truncated-onset-list))) ;remove pauses
               (append truncated-onset-list (make-list (1+ (- nr-of-pitches (length truncated-onset-list))) :initial-element nil))
               )
            (make-list (1+ (- stop-nth-pitch start-nth-pitch)) :initial-element nil)))))




(defun get-pitch-at-nthrhythm (layer index nth)
  "excluding pauses in numbering"
  (let ((number-of-pitches (get-number-of-pitches-at-index layer index)))
        (if (> (1+ nth) number-of-pitches)
        nil
    (get-pitches-from-vector layer (1+ nth) (1+ nth)))))


(defun get-pitch-at-nthrhythm-2 (layer index nth)
  "Excluding pauses in numbering. This version returns '(nil) if no value (instad of nil)."
  (let ((number-of-pitches (get-number-of-pitches-at-index layer index)))
        (if (> (1+ nth) number-of-pitches)
        '(nil)
    (get-pitches-from-vector layer (1+ nth) (1+ nth)))))

(defun get-pitches-for-rhythms (layer index start-nth-rhythm stop-nth-rhythm)
  "This function will output pitches that corresponds to rhythms, given as order numbers starting from 0 (not counting pauses). If no pitch is yet assigned, nil will be returned. If some of the pitches are assigned, those will be returned (excluding the missing pitches)"
  (let ((number-of-pitches (get-number-of-pitches-at-index layer index)))
        (if (> (1+ stop-nth-rhythm) number-of-pitches)
            (if (> (1+ start-nth-rhythm) number-of-pitches)
                nil
            (get-pitches-from-vector layer (1+ start-nth-rhythm) number-of-pitches)) 
          (get-pitches-from-vector layer (1+ start-nth-rhythm) (1+ stop-nth-rhythm)))))

(defun get-pitches-for-rhythms-indicate-absence (layer index start-nth-rhythm stop-nth-rhythm)
  "This function will output pitches that corresponds to rhythms, given as order numbers starting from 0 (not counting pauses). If no pitch is yet assigned, nil will be returned. If only some of the pitches are assigned, the missing pitches will get nil)"
  (let ((number-of-pitches (get-number-of-pitches-at-index layer index)))
        (if (> (1+ stop-nth-rhythm) number-of-pitches)
            (if (> (1+ start-nth-rhythm) number-of-pitches)
                nil
            (append (get-pitches-from-vector layer (1+ start-nth-rhythm) number-of-pitches) (make-list (- (1+ stop-nth-rhythm) number-of-pitches))) )
          (get-pitches-from-vector layer (1+ start-nth-rhythm) (1+ stop-nth-rhythm)))))


(defun get-pitches-from-vector-include-nil (layer start-local-pointer stop-local-pointer index)
  "Get pitches between pointers from vector. Returns nil for each pitch not assigned. Pointer starts from 1.
Differs from get-pitches-for-rhythms-indicate-absence in the way no assigned pitch is returned: (nil nil etc..) or just nil."
  (let ((max-local-pointer (aref pointers-vector layer index *PITCH* *ENDPOINTER*)))
    (if (> start-local-pointer max-local-pointer)
        (make-list (1+ (- stop-local-pointer start-local-pointer)) :initial-element nil)
      (if (<= stop-local-pointer max-local-pointer)
        (get-pitches-from-vector layer start-local-pointer stop-local-pointer)
        (append (get-pitches-from-vector layer start-local-pointer max-local-pointer)
                (make-list (- stop-local-pointer max-local-pointer) :initial-element nil)))
      )))


(defun get-nr-of-pitches-at-pointer-for-rhythms-and-pauses (layer pointer)
  "Pointer starts to count from 1. No check for out-of-range of vector!"
       (aref part-sol-vector layer pointer *#-RHYTHM-EVENT*))


;(get-nth-for-pitch-at-localpointer-for-rhythm 0 16 7)
;(get-pitch-at-nthrhythm 0 16 nil)
;(get-pitches-for-localpointers-rhythm&pause 0 16 2 9)
(defun get-pitches-for-localpointers-rhythm&pause (layer index localpointers-start localpointers-end)
  "localpointers start to count from 1"
  (let ((nthpitch-list (mapcar #'(lambda (pointer) (get-nth-for-pitch-at-localpointer-for-rhythm layer index pointer)) 
                               (loop for n from localpointers-start to localpointers-end collect n))))
    (mapcar #'(lambda (nth) (if nth (car (get-pitch-at-nthrhythm layer index nth)) nil)) nthpitch-list)))

;(get-pitch-for-localpointer-rhythm&pause 0 16 7)
(defun get-pitch-for-localpointer-rhythm&pause (layer index localpointer)
  "localpointers start to count from 1"
  (let ((nthpitch (get-nth-for-pitch-at-localpointer-for-rhythm layer index localpointer)))                         
     (if nthpitch (get-pitch-at-nthrhythm layer index nthpitch) nil)))


;;;;

;;maybe this function can be more efficient
(defun get-timesign-at-timepoint (timepoint index)
  (if (>= timepoint (get-total-duration-timesigns-at-index index))
      nil
    (let ((all-timesigns (get-timesigns-upto-index index))
          (all-barlines-onsettime (append (get-timepoints-at-measures-upto-index index) (list (1+ (get-total-duration-timesigns-at-index index)))))) ;add endtime to onsets
      (loop for n from 0 to (length all-timesigns)
            when (< (1+ timepoint) (nth n all-barlines-onsettime))  ;1+ since the offset of 1 is still in all-barlines-onsettime 
            return (nth (1- n) all-timesigns))
      )))