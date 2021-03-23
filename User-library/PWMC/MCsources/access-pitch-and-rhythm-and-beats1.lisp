(in-package MC)


(defun get-local-pointer-at-start-or-pause-before (layer index nth-pitch)
  "Returns the local pointer to the imediate preceeding pauses to the nth pitch. If non the pointer will be to the rhythm instead."
  (let ((local-pointer (get-localpointer-at-nthrhythm layer index nth-pitch))
        pause-before)
    (if (and local-pointer (> local-pointer 1))
        (loop while (and (> local-pointer 1)
                         (minusp (car (get-durations-from-vector layer (1- local-pointer) local-pointer))))        
                       do (setf local-pointer (1- local-pointer)))
      )
    local-pointer))

(defun get-local-pointer-at-last-or-pause-after (layer index stop-nth-pitch)
  "Returns the local pointer to the pauses that immediate follows the given nth event (i.e. nth pich/rhythm - not counting pauses. If non the pointer will be to the last rhythm instead"
  (let* ((stop-local-pointer (get-localpointer-at-nthrhythm layer index stop-nth-pitch))
         (return-pointer stop-local-pointer))
    (if stop-local-pointer
        (loop for pointer from (1+ stop-local-pointer) to (1- (get-number-of-rhythms-and-pauses-at-index layer index))
              while (minusp (car (get-durations-from-vector layer pointer (1+ pointer))))
              do (setf return-pointer pointer)
              ))
    return-pointer))

(defun get-onsets-between-nth-pitches-include-preceeding&following-pauses (layer index start-nth stop-nth)
  (let ((start-local-pointer (get-local-pointer-at-start-or-pause-before layer index start-nth))
        (stop-local-pointer (get-local-pointer-at-last-or-pause-after layer index stop-nth)))
    (if start-local-pointer
        (if stop-local-pointer
            (mapcar #'(lambda (x) (1- (abs x))) (get-onsets-from-vector layer start-local-pointer stop-local-pointer))
          (let ((max-local-pointer (get-number-of-rhythms-and-pauses-at-index layer index))
                (tot-nr-of-pitches (get-number-of-rhythms-at-index layer index)))
            (append (mapcar #'(lambda (x) (1- (abs x))) (get-onsets-from-vector layer start-local-pointer max-local-pointer))
                    (make-list (1+ (- stop-nth tot-nr-of-pitches)) :initial-element nil))))
      (make-list (1+ (- stop-nth start-nth)) :initial-element nil)
      )))


(defun find-equal-or-lower (value list)
  "Outputs value if found in list, otherwise the (lower) number preceeding it.
If value is greater than the last value in the list, nil will be output (the idea is to
find values INSIDE meaures or at first downbeat (not after last known measure)."
  ;filter out upto low limit
  (loop for n from 1 to (1- (length list))
        while (<= (second list) value)
        do (pop list))
  (if (and (= (length list) 1) (< (car list) value))
      nil
    (car list)))


(defun find-one-offset-in-measure (value list)
  "A version of find-equal-or-lower. It returns the distance to value insted of timepoints."

  (loop for n from 1 to (1- (length list))
        while (<= (second list) value)
        do (pop list))
  (if (and (= (length list) 1) (< (car list) value))
      nil
    (- value (car list))))


(defun find-measure-offsets (onsets measures-starttimes)
  (loop for onset in onsets
        collect (if onset
                    (find-one-offset-in-measure onset measures-starttimes)
                  nil)))



(defun mc-mattrans3 (list1 list2 list3)
  "All lists should be of equal lengths."
  (loop for n from 0 to (1- (length list1))
        collect (list (nth n list1) (nth n list2) (nth n list3))))

(defun remove-not-assignd-and-remaining-triplets (triplets-list)
  "Filter out all pairs starting with the first that contains nil."
  (loop for n from 0 to (1- (length triplets-list))
        while (and (first (nth n triplets-list)) (second (nth n triplets-list)) (third (nth n triplets-list)))
        collect (nth n triplets-list)))


(defun get-timepoints-at-measures-upto-index2 (index)
  "Almost identical to get-timepoints-at-measures-upto-index. Diffreence: if no timesign, return '(1)."
  (let ((all-local-pointers (remove nil (remove-duplicates 
                                         (loop for this-index from 1 to index
                                               collect (aref pointers-vector *TIMESIGNLAYER* this-index *ONSETTIME* *STARTPOINTER*))))))
    (if all-local-pointers
        (loop for i from 0 to (1- (length all-local-pointers))
              collect (aref part-sol-timegridvector *GRIDPOINTS* (nth i all-local-pointers)))
      '(1))))



(defun get-pointer-for-rhythm-at-or-after-timepoint (layer timepoint tot-length-rhythm-layer)
  "Returns the pointer to the rhythm or pause that coinside with the timepoint (starting from 0) or, if no exists, the rhythm or pause 
that comes immediate after."
  (loop for local-pointer from 1 to tot-length-rhythm-layer 
        while (let ((this-timepoint (aref part-sol-vector layer local-pointer *ONSETTIME*)))
                (< (1- (abs this-timepoint)) timepoint))
        finally (return local-pointer)))



(defun get-timepoints-at-beats-upto-index2 (index)
  "Differs from get-timepoints-at-beats-upto-index. Returns '(1) if no timesign exist."
  (let* ((measures-startpoints (get-timepoints-at-measures-upto-index2 index))
         (timesigns (get-timesigns-upto-index index)))
    (if (car timesigns)
         (let ((measurs-durtion-beatlist (mapcar #'(lambda (timesign) 
                                                     (make-list (1- (car timesign)) :initial-element (/ 1 (cadr timesign))))
                                                 timesigns)))
           (apply 'append (mapcar #'(lambda (durationlist measure-offset) (ratios-to-onsets-with-offset measure-offset durationlist)) measurs-durtion-beatlist measures-startpoints)))
     '(1))))