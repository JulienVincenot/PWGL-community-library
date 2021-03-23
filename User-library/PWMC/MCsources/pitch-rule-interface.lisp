(in-package MC)

;;;   MELODIC INTERFACE

        
(defun get-pitches-between-nths-when-all-exist (layer index startnth stopnth)
  "This function does NOT check if length is beyond the limit of the vector!!"
      (get-pitches-from-vector layer (1+ startnth) (1+ stopnth)))

(defun format-pitch-rule (pitchfn layers)
  (let* ((nr-of-variables-in-fn (length (system::arglist pitchfn))))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                                             (let* ((number-of-events-in-cell (get-nr-of-events x))
                                                    (number-of-pitches-in-layer (get-number-of-pitches-at-index layer indexx))
                                                    (nr-of-possible-loops (1+ (- number-of-pitches-in-layer nr-of-variables-in-fn))))
                                               
                                               (if (< 0 nr-of-possible-loops) 
                                                   (if (<= number-of-events-in-cell nr-of-possible-loops)
                                                       (eval (append '(and) (loop for n from 1 to number-of-events-in-cell
                                                                                  collect (if (apply pitchfn (get-pitches-between-nths-when-all-exist 
                                                                                                              layer indexx 
                                                                                                              (- number-of-pitches-in-layer n 
                                                                                                                 (1- nr-of-variables-in-fn)) 
                                                                                                              (- number-of-pitches-in-layer n)))
                                                                                              t))))
                                                     (eval (append '(and) (loop for n from 1 to nr-of-possible-loops
                                                                                collect (if (apply pitchfn (get-pitches-between-nths-when-all-exist 
                                                                                                            layer indexx 
                                                                                                            (- number-of-pitches-in-layer n 
                                                                                                               (1- nr-of-variables-in-fn)) 
                                                                                                            (- number-of-pitches-in-layer n)))
                                                                                            t)))))
                                                 t))
                                           t))))))


(defun get-pitches-between-nths-add-nil-for-not-assigned (layer index startnth stopnth)
  (let ((tot-length (get-number-of-pitches-at-index layer index)))
    (if (< startnth  0)
        (append (make-list (- startnth)) (get-pitches-from-vector layer 1 (1+ stopnth)))
      (get-pitches-from-vector layer (1+ startnth) (1+ stopnth)))))

(defun format-pitch-rule-include-nil (pitchfn layers)
  (let* ((nr-of-variables-in-fn (length (system::arglist pitchfn))))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                                             (let* ((number-of-events-in-cell (get-nr-of-events x))
                                                    (number-of-pitches-in-layer (get-number-of-pitches-at-index layer indexx))
                                                    (nr-of-possible-loops (1+ (- number-of-pitches-in-layer nr-of-variables-in-fn))))
                                               
                                               (eval (append '(and) (loop for n from 1 to number-of-events-in-cell
                                                                          collect (if (apply pitchfn (get-pitches-between-nths-add-nil-for-not-assigned  
                                                                                                      layer indexx 
                                                                                                      (- number-of-pitches-in-layer n 
                                                                                                         (1- nr-of-variables-in-fn)) 
                                                                                                      (- number-of-pitches-in-layer n)))
                                                                                      t)))))
                                           t))))))


(defun format-pitch-rule-list-all-pitches (pitchfn layers)
  "this rule gives the testfunction a list of ALL pitches that exist in a layer."
  (let* ((nr-of-variables-in-fn (length (system::arglist pitchfn))))
    (if (/= nr-of-variables-in-fn 1) (error "PWMC error in access-melody: In the list-all-pitches mode the melodic rule expects only one input to the rule (a list of all picthes is passed to the rule)."))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                                             (let* ((number-of-events-in-cell (get-nr-of-events x))
                                                    (number-of-pitches-in-layer (get-number-of-pitches-at-index layer indexx))
                                                    (nr-of-possible-loops number-of-pitches-in-layer))
                                               
                                               (if (< 0 nr-of-possible-loops) 
                                                   (if (<= number-of-events-in-cell nr-of-possible-loops)
                                                       (eval (append '(and) (loop for n from 1 to number-of-events-in-cell
                                                                                  collect (if (apply pitchfn (list (get-pitches-between-nths-when-all-exist 
                                                                                                                    layer indexx 
                                                                                                                    0 
                                                                                                                    (- number-of-pitches-in-layer n))))
                                                                                              t))))
                                                     (eval (append '(and) (loop for n from 1 to nr-of-possible-loops
                                                                                collect (if (apply pitchfn (list (get-pitches-between-nths-when-all-exist 
                                                                                                                  layer indexx 
                                                                                                                  0 
                                                                                                                  (- number-of-pitches-in-layer n))))
                                                                                            t)))))
                                                 t))
                                           t))))))



;;; CHORD INTERFACE


(defun get-onsets-for-this-pitchcell-with-endpoint (index x)
  (let* ((this-layer (get-layer-nr x))
         (length-pitchcell (get-nr-of-events x))
         (length-this-layer-before-cell (get-number-of-pitches-at-index this-layer (1- index))))
    (get-onsets-for-pitches-with-endpoint this-layer index length-this-layer-before-cell (1- (+ length-this-layer-before-cell length-pitchcell)))))



(defun get-ordernr-for-onsets-from-vector-at-timepoints (layer timepoints tot-length-layer)
  "If timepoint does not exist, nil is returned. Offset is 1, layer start at time 1 (not 0).
Last offset in vector is not included. Ordernr starts to count from 0 (just like the nth-function)."
  (let ((local-pointer 1))
    (loop for timepoint in timepoints
          collect (loop for n from 1 to tot-length-layer
                        do (if (> local-pointer tot-length-layer) (return nil)
                             (let ((this-onset (aref part-sol-vector layer local-pointer *ONSETTIME*))
                                   (next-onset (aref part-sol-vector layer (1+ local-pointer) *ONSETTIME*)))
                               (if (< timepoint (abs next-onset))
                                   (if (>= timepoint (abs this-onset))
                                       (if (plusp this-onset) (return (1- (aref part-sol-vector layer local-pointer *#-RHYTHM-EVENT*))) (return nil)) (return (list 'error layer timepoints tot-length-layer)))
                                 (setf local-pointer (1+ local-pointer)))))))))


(defun get-pitch-at-timepoint-for-pitchcell (index x other-layer)
  "List pitches for x and for other layer at the time window for x."
  (let* ((this-cell-onsets-with-endpoint (get-onsets-for-this-pitchcell-with-endpoint index x))
         (start-time (first this-cell-onsets-with-endpoint)))
    (if start-time
        (let* ((this-layer (get-layer-nr x))
               (end-time (car (last (remove nil this-cell-onsets-with-endpoint))))
               (tot-length-this-layer (get-number-of-rhythms-and-pauses-at-index this-layer index))
               (tot-length-other-layer (get-number-of-rhythms-and-pauses-at-index other-layer index))
               (onsets-in-other-layer-during-this-cell 
                (get-onsets-from-vector-between-timepoints other-layer start-time  end-time  tot-length-other-layer))
               (all-onsets (remove-duplicates (sort
                                               (remove nil (append (butlast this-cell-onsets-with-endpoint)
                                                                   onsets-in-other-layer-during-this-cell)) 
                                               '<)))
               (ordernr-corresponding-onsets-this-layer 
                (get-ordernr-for-onsets-from-vector-at-timepoints this-layer all-onsets tot-length-this-layer))
               (ordernr-corresponding-onsets-other-layer 
                (get-ordernr-for-onsets-from-vector-at-timepoints other-layer all-onsets tot-length-other-layer))
               (pitches-this-layer (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm this-layer index nth) '(nil))) 
                                           ordernr-corresponding-onsets-this-layer))
               (pitches-other-layer (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm other-layer index nth) '(nil)))
                                            ordernr-corresponding-onsets-other-layer)))
           (list pitches-this-layer pitches-other-layer))
      '(((nil))((nil))))))


(defun get-pitch-at-timepoint-for-rhythmcell (index x other-layer)
  (let* ((this-layer (get-layer-nr x))
         (start-time (1+ (get-total-duration-rhythms-at-index this-layer (1- index))))  ;add offset 1
         (end-time (1+ (get-total-duration-rhythms-at-index this-layer index)))
         (this-cell-onsets (mapcar #'(lambda (x) (+ start-time x)) (butlast (get-local-onset-without-pauses x))))
         (tot-length-this-layer (get-number-of-rhythms-and-pauses-at-index this-layer index))
         (tot-length-other-layer (get-number-of-rhythms-and-pauses-at-index other-layer index))

         (onsets-in-other-layer-during-this-cell 
          (get-onsets-from-vector-between-timepoints other-layer start-time  end-time  tot-length-other-layer))
         (all-onsets (remove-duplicates (sort
                                         (append this-cell-onsets onsets-in-other-layer-during-this-cell) 
                                         '<)))
         (ordernr-corresponding-onsets-this-layer 
          (get-ordernr-for-onsets-from-vector-at-timepoints this-layer all-onsets tot-length-this-layer))
         (ordernr-corresponding-onsets-other-layer 
          (get-ordernr-for-onsets-from-vector-at-timepoints other-layer all-onsets tot-length-other-layer))
         (pitches-this-layer (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm this-layer index nth) '(nil))) 
                                     ordernr-corresponding-onsets-this-layer))
         (pitches-other-layer (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm other-layer index nth) '(nil)))
                                      ordernr-corresponding-onsets-other-layer)))
    (list pitches-this-layer pitches-other-layer)))

  

(defun filter-out-both-if-one-is-nil (two-lists)
  "OBS: Also appends sublists in each list."
  (let (layer1-pitches layer2-pitches)
    (loop for y in (first two-lists)
          for z in (second two-lists)
          do (if (and (car y) (car z)) (progn (setf layer1-pitches (append y layer1-pitches))
                             (setf layer2-pitches (append z layer2-pitches)))))
    (list layer1-pitches layer2-pitches)))


       
(defun  format-chord-rule (testfn layer1 layer2)
  (let (pitches-both-layers pitches-layer1 pitches-layer2)
  #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer1) (= (get-layer-nr x) layer2))
                           (cond ((typep x 'pitchcell)
                                  (cond ((= (get-layer-nr x) layer1)
                                         (setf pitches-both-layers (get-pitch-at-timepoint-for-pitchcell indexx x layer2))
                                         (setf pitches-both-layers (filter-out-both-if-one-is-nil pitches-both-layers))
                                         (setf pitches-layer1 (first pitches-both-layers))
                                         (setf pitches-layer2 (second pitches-both-layers)))
                                        ((= (get-layer-nr x) layer2)
                                         (setf pitches-both-layers (get-pitch-at-timepoint-for-pitchcell indexx x layer1))
                                         (setf pitches-both-layers (filter-out-both-if-one-is-nil pitches-both-layers))
                                         (setf pitches-layer2 (first pitches-both-layers))
                                         (setf pitches-layer1 (second pitches-both-layers))))
                                  (if pitches-layer1 
                                      (eval (append '(and) (mapcar #'(lambda (p1 p2) (if (funcall testfn p1 p2) t)) pitches-layer1 pitches-layer2)))
                                    t))
                                 ((typep x 'rhythmcell)
                                  (cond ((= (get-layer-nr x) layer1)
                                         (setf pitches-both-layers (get-pitch-at-timepoint-for-rhythmcell indexx x layer2))
                                         (setf pitches-both-layers (filter-out-both-if-one-is-nil pitches-both-layers))
                                         (setf pitches-layer1 (first pitches-both-layers))
                                         (setf pitches-layer2 (second pitches-both-layers)))
                                        ((= (get-layer-nr x) layer2)
                                         (setf pitches-both-layers (get-pitch-at-timepoint-for-rhythmcell indexx x layer1))
                                         (setf pitches-both-layers (filter-out-both-if-one-is-nil pitches-both-layers))
                                         (setf pitches-layer2 (first pitches-both-layers))
                                         (setf pitches-layer1 (second pitches-both-layers))))
                                  (if pitches-layer1 
                                      (eval (append '(and) (mapcar #'(lambda (p1 p2) (if (funcall testfn p1 p2) t)) pitches-layer1 pitches-layer2)))
                                    t))
                                 (t t))
                         t)
      )))
      

;;;;;November 2007 - below are new functions for harmonic access to 3 layers

;(defun test ()  #'(lambda (indexx x) (get-pitches-3layers-during-times-for-rhythmcell indexx x 1 2)))
;(get-pitches-during-times-for-pitchcell
(defun get-pitches-3layers-during-times-for-pitchcell (index x other-layer1 other-layer2)
  "List pitches for x and for other layer at the time window for x."
  (let* ((this-cell-onsets-with-endpoint (get-onsets-for-this-pitchcell-with-endpoint index x))
         (start-time (first this-cell-onsets-with-endpoint)))

    (if start-time
        (let* ((this-layer (get-layer-nr x))
               (end-time (car (last (remove nil this-cell-onsets-with-endpoint))))
               (tot-length-this-layer (get-number-of-rhythms-and-pauses-at-index this-layer index))
               (tot-length-other-layer1 (get-number-of-rhythms-and-pauses-at-index other-layer1 index))
               (tot-length-other-layer2 (get-number-of-rhythms-and-pauses-at-index other-layer2 index))
               (onsets-in-other-layer1-during-this-cell 
                (get-onsets-from-vector-between-timepoints other-layer1 start-time  end-time  tot-length-other-layer1))
               (onsets-in-other-layer2-during-this-cell 
                (get-onsets-from-vector-between-timepoints other-layer2 start-time  end-time  tot-length-other-layer2))
               (all-onsets (remove-duplicates (sort
                                               (remove nil (append (butlast this-cell-onsets-with-endpoint)
                                                                   onsets-in-other-layer1-during-this-cell
                                                                   onsets-in-other-layer2-during-this-cell)) 
                                               '<)))
               (ordernr-corresponding-onsets-this-layer 
                (get-ordernr-for-onsets-from-vector-at-timepoints this-layer all-onsets tot-length-this-layer))
               (ordernr-corresponding-onsets-other-layer1 
                (get-ordernr-for-onsets-from-vector-at-timepoints other-layer1 all-onsets tot-length-other-layer1))
               (ordernr-corresponding-onsets-other-layer2 
                (get-ordernr-for-onsets-from-vector-at-timepoints other-layer2 all-onsets tot-length-other-layer2))
               (pitches-this-layer (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 this-layer index nth) '(nil))) 
                                           ordernr-corresponding-onsets-this-layer))
               (pitches-other-layer1 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer1 index nth) '(nil)))
                                            ordernr-corresponding-onsets-other-layer1))
               (pitches-other-layer2 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer2 index nth) '(nil)))
                                            ordernr-corresponding-onsets-other-layer2)))
           (list pitches-this-layer pitches-other-layer1 pitches-other-layer2))
      '(((nil))((nil))((nil))))))


(defun get-pitches-3layers-during-times-for-rhythmcell (index x other-layer1 other-layer2)
  (let* ((this-layer (get-layer-nr x))
         (start-time (1+ (get-total-duration-rhythms-at-index this-layer (1- index))))  ;add offset 1
         (end-time (1+ (get-total-duration-rhythms-at-index this-layer index)))
         (this-cell-onsets (mapcar #'(lambda (x) (+ start-time x)) (butlast (get-local-onset-without-pauses x))))
         (tot-length-this-layer (get-number-of-rhythms-and-pauses-at-index this-layer index))
         (tot-length-other-layer1 (get-number-of-rhythms-and-pauses-at-index other-layer1 index))
         (tot-length-other-layer2 (get-number-of-rhythms-and-pauses-at-index other-layer2 index))
         (onsets-in-other-layer1-during-this-cell 
          (get-onsets-from-vector-between-timepoints other-layer1 start-time  end-time  tot-length-other-layer1))
         (onsets-in-other-layer2-during-this-cell 
          (get-onsets-from-vector-between-timepoints other-layer2 start-time  end-time  tot-length-other-layer2))
         (all-onsets (remove-duplicates (sort
                                         (append this-cell-onsets onsets-in-other-layer1-during-this-cell onsets-in-other-layer2-during-this-cell) 
                                         '<)))
         (ordernr-corresponding-onsets-this-layer 
          (get-ordernr-for-onsets-from-vector-at-timepoints this-layer all-onsets tot-length-this-layer))
         (ordernr-corresponding-onsets-other-layer1 
          (get-ordernr-for-onsets-from-vector-at-timepoints other-layer1 all-onsets tot-length-other-layer1))
         (ordernr-corresponding-onsets-other-layer2 
          (get-ordernr-for-onsets-from-vector-at-timepoints other-layer2 all-onsets tot-length-other-layer2))

         (pitches-this-layer (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 this-layer index nth) '(nil))) 
                                     ordernr-corresponding-onsets-this-layer))
         (pitches-other-layer1 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer1 index nth) '(nil)))
                                      ordernr-corresponding-onsets-other-layer1))
         (pitches-other-layer2 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer2 index nth) '(nil)))
                                      ordernr-corresponding-onsets-other-layer2)))
    (list pitches-this-layer pitches-other-layer1 pitches-other-layer2)))



(defun filter-out-three-if-two-are-nil (three-lists)
  "OBS: Also appends sublists in each list."
  (let (layer1-pitches layer2-pitches layer3-pitches)
    (loop for y in (first three-lists)
          for z in (second three-lists)
          for x in (third three-lists)
          do (if (or (and (car y) (car z))
                     (and (car y) (car x))
                     (and (car z) (car x))) (progn (setf layer1-pitches (append y layer1-pitches))
                                              (setf layer2-pitches (append z layer2-pitches))
                                              (setf layer3-pitches (append x layer3-pitches)))))
    (list layer1-pitches layer2-pitches layer3-pitches)))

;(filter-out-three-if-two-are-nil '(((nil) (1) (2) (3))((nil) (nil) (2) (3))((nil) (1) (nil) (3))))


(defun  format-3layers-harm-rule (testfn layer1 layer2 layer3)
  (let (pitches-both-layers pitches-three-layers pitches-layer1 pitches-layer2 pitches-layer3)
  #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer1) (= (get-layer-nr x) layer2) (= (get-layer-nr x) layer3))
                           (cond ((typep x 'pitchcell)
                                  (cond ((= (get-layer-nr x) layer1)
                                         (setf pitches-three-layers (get-pitches-3layers-during-times-for-pitchcell indexx x layer2 layer3))
                                         (setf pitches-three-layers (filter-out-three-if-two-are-nil pitches-three-layers))
                                         (setf pitches-layer1 (first pitches-three-layers))
                                         (setf pitches-layer2 (second pitches-three-layers))
                                         (setf pitches-layer3 (third pitches-three-layers)))
                                        ((= (get-layer-nr x) layer2)
                                         (setf pitches-three-layers (get-pitches-3layers-during-times-for-pitchcell indexx x layer1 layer3))
                                         (setf pitches-three-layers (filter-out-three-if-two-are-nil pitches-three-layers))
                                         (setf pitches-layer2 (first pitches-three-layers))
                                         (setf pitches-layer1 (second pitches-three-layers))
                                         (setf pitches-layer3 (third pitches-three-layers)))
                                        ((= (get-layer-nr x) layer3)
                                         (setf pitches-three-layers (get-pitches-3layers-during-times-for-pitchcell indexx x layer1 layer2))
                                         (setf pitches-three-layers (filter-out-three-if-two-are-nil pitches-three-layers))
                                         (setf pitches-layer3 (first pitches-three-layers))
                                         (setf pitches-layer1 (second pitches-three-layers))
                                         (setf pitches-layer2 (third pitches-three-layers))))
                                  ;;;
                                  (if pitches-layer1 
                                      (eval (append '(and) (mapcar #'(lambda (p1 p2 p3) (if (funcall testfn p1 p2 p3) t)) pitches-layer1 pitches-layer2 pitches-layer3)))
                                    t))
                                 ((typep x 'rhythmcell)
                                  (cond ((= (get-layer-nr x) layer1)
                                         (setf pitches-three-layers (get-pitches-3layers-during-times-for-rhythmcell indexx x layer2 layer3))
                                         (setf pitches-three-layers (filter-out-three-if-two-are-nil pitches-three-layers))
                                         (setf pitches-layer1 (first pitches-three-layers))
                                         (setf pitches-layer2 (second pitches-three-layers))
                                         (setf pitches-layer3 (third pitches-three-layers)))
                                        ((= (get-layer-nr x) layer2)
                                         (setf pitches-three-layers (get-pitches-3layers-during-times-for-rhythmcell indexx x layer1 layer3))
                                         (setf pitches-three-layers (filter-out-three-if-two-are-nil pitches-three-layers))
                                         (setf pitches-layer2 (first pitches-three-layers))
                                         (setf pitches-layer1 (second pitches-three-layers))
                                         (setf pitches-layer3 (third pitches-three-layers)))
                                        ((= (get-layer-nr x) layer3)
                                         (setf pitches-three-layers (get-pitches-3layers-during-times-for-rhythmcell indexx x layer1 layer2))
                                         (setf pitches-three-layers (filter-out-three-if-two-are-nil pitches-three-layers))
                                         (setf pitches-layer3 (first pitches-three-layers))
                                         (setf pitches-layer1 (second pitches-three-layers))
                                         (setf pitches-layer2 (third pitches-three-layers))))
                                  (if pitches-layer1 
                                      (eval (append '(and) (mapcar #'(lambda (p1 p2 p3) (if (funcall testfn p1 p2 p3) t)) pitches-layer1 pitches-layer2 pitches-layer3)))
                                    t))
                                 (t t))
                         t)
      )))


;;;;;below are new functions for harmonic access to 4 layers

;(defun test ()  #'(lambda (indexx x) (get-pitches-3layers-during-times-for-rhythmcell indexx x 1 2)))
;(get-pitches-during-times-for-pitchcell
(defun get-pitches-4layers-during-times-for-pitchcell (index x other-layer1 other-layer2 other-layer3)
  "List pitches for x and for other layer at the time window for x."
  (let* ((this-cell-onsets-with-endpoint (get-onsets-for-this-pitchcell-with-endpoint index x))
         (start-time (first this-cell-onsets-with-endpoint)))

    (if start-time
        (let* ((this-layer (get-layer-nr x))
               (end-time (car (last (remove nil this-cell-onsets-with-endpoint))))
               (tot-length-this-layer (get-number-of-rhythms-and-pauses-at-index this-layer index))
               (tot-length-other-layer1 (get-number-of-rhythms-and-pauses-at-index other-layer1 index))
               (tot-length-other-layer2 (get-number-of-rhythms-and-pauses-at-index other-layer2 index))
               (tot-length-other-layer3 (get-number-of-rhythms-and-pauses-at-index other-layer3 index))
               (onsets-in-other-layer1-during-this-cell 
                (get-onsets-from-vector-between-timepoints other-layer1 start-time  end-time  tot-length-other-layer1))
               (onsets-in-other-layer2-during-this-cell 
                (get-onsets-from-vector-between-timepoints other-layer2 start-time  end-time  tot-length-other-layer2))
               (onsets-in-other-layer3-during-this-cell 
                (get-onsets-from-vector-between-timepoints other-layer3 start-time  end-time  tot-length-other-layer3))
               (all-onsets (remove-duplicates (sort
                                               (remove nil (append (butlast this-cell-onsets-with-endpoint)
                                                                   onsets-in-other-layer1-during-this-cell
                                                                   onsets-in-other-layer2-during-this-cell
                                                                   onsets-in-other-layer3-during-this-cell)) 
                                               '<)))
               (ordernr-corresponding-onsets-this-layer 
                (get-ordernr-for-onsets-from-vector-at-timepoints this-layer all-onsets tot-length-this-layer))
               (ordernr-corresponding-onsets-other-layer1 
                (get-ordernr-for-onsets-from-vector-at-timepoints other-layer1 all-onsets tot-length-other-layer1))
               (ordernr-corresponding-onsets-other-layer2 
                (get-ordernr-for-onsets-from-vector-at-timepoints other-layer2 all-onsets tot-length-other-layer2))
               (ordernr-corresponding-onsets-other-layer3 
                (get-ordernr-for-onsets-from-vector-at-timepoints other-layer3 all-onsets tot-length-other-layer3))

               (pitches-this-layer (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 this-layer index nth) '(nil))) 
                                           ordernr-corresponding-onsets-this-layer))
               (pitches-other-layer1 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer1 index nth) '(nil)))
                                            ordernr-corresponding-onsets-other-layer1))
               (pitches-other-layer2 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer2 index nth) '(nil)))
                                            ordernr-corresponding-onsets-other-layer2))
               (pitches-other-layer3 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer3 index nth) '(nil)))
                                            ordernr-corresponding-onsets-other-layer3)))
           (list pitches-this-layer pitches-other-layer1 pitches-other-layer2 pitches-other-layer3))
      '(((nil))((nil))((nil))((nil))))))


(defun get-pitches-4layers-during-times-for-rhythmcell (index x other-layer1 other-layer2 other-layer3)
  (let* ((this-layer (get-layer-nr x))
         (start-time (1+ (get-total-duration-rhythms-at-index this-layer (1- index))))  ;add offset 1
         (end-time (1+ (get-total-duration-rhythms-at-index this-layer index)))
         (this-cell-onsets (mapcar #'(lambda (x) (+ start-time x)) (butlast (get-local-onset-without-pauses x))))
         (tot-length-this-layer (get-number-of-rhythms-and-pauses-at-index this-layer index))
         (tot-length-other-layer1 (get-number-of-rhythms-and-pauses-at-index other-layer1 index))
         (tot-length-other-layer2 (get-number-of-rhythms-and-pauses-at-index other-layer2 index))
         (tot-length-other-layer3 (get-number-of-rhythms-and-pauses-at-index other-layer3 index))
         (onsets-in-other-layer1-during-this-cell 
          (get-onsets-from-vector-between-timepoints other-layer1 start-time  end-time  tot-length-other-layer1))
         (onsets-in-other-layer2-during-this-cell 
          (get-onsets-from-vector-between-timepoints other-layer2 start-time  end-time  tot-length-other-layer2))
         (onsets-in-other-layer3-during-this-cell 
          (get-onsets-from-vector-between-timepoints other-layer3 start-time  end-time  tot-length-other-layer3))
         (all-onsets (remove-duplicates (sort
                                         (append this-cell-onsets onsets-in-other-layer1-during-this-cell onsets-in-other-layer2-during-this-cell onsets-in-other-layer3-during-this-cell) 
                                         '<)))
         (ordernr-corresponding-onsets-this-layer 
          (get-ordernr-for-onsets-from-vector-at-timepoints this-layer all-onsets tot-length-this-layer))
         (ordernr-corresponding-onsets-other-layer1 
          (get-ordernr-for-onsets-from-vector-at-timepoints other-layer1 all-onsets tot-length-other-layer1))
         (ordernr-corresponding-onsets-other-layer2 
          (get-ordernr-for-onsets-from-vector-at-timepoints other-layer2 all-onsets tot-length-other-layer2))
         (ordernr-corresponding-onsets-other-layer3 
          (get-ordernr-for-onsets-from-vector-at-timepoints other-layer3 all-onsets tot-length-other-layer3))

         (pitches-this-layer (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 this-layer index nth) '(nil))) 
                                     ordernr-corresponding-onsets-this-layer))
         (pitches-other-layer1 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer1 index nth) '(nil)))
                                      ordernr-corresponding-onsets-other-layer1))
         (pitches-other-layer2 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer2 index nth) '(nil)))
                                      ordernr-corresponding-onsets-other-layer2))
         (pitches-other-layer3 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer3 index nth) '(nil)))
                                      ordernr-corresponding-onsets-other-layer3)))
   (list pitches-this-layer pitches-other-layer1 pitches-other-layer2 pitches-other-layer3)))



(defun filter-out-four-if-three-are-nil (four-lists)
  "OBS: Also appends sublists in each list."
  (let (layer1-pitches layer2-pitches layer3-pitches layer4-pitches)
    (loop for y in (first four-lists)
          for z in (second four-lists)
          for x in (third four-lists)
          for w in (fourth four-lists)

          do (if (> 3 (count nil (list (car y) (car z) (car x) (car w))))
                     (progn (setf layer1-pitches (append y layer1-pitches))
                       (setf layer2-pitches (append z layer2-pitches))
                       (setf layer3-pitches (append x layer3-pitches))
                       (setf layer4-pitches (append w layer4-pitches)))))
          (list layer1-pitches layer2-pitches layer3-pitches layer4-pitches)))


;(filter-out-four-if-three-are-nil '(((nil) (2) (3) (nil))((nil) (nil) (3) (4))((nil) (nil) (nil) (4))((nil) (2) (nil) (nil))))

(defun  format-4layers-harm-rule (testfn layer1 layer2 layer3 layer4)
  (let (pitches-four-layers pitches-layer1 pitches-layer2 pitches-layer3 pitches-layer4)
  #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer1) (= (get-layer-nr x) layer2) (= (get-layer-nr x) layer3) (= (get-layer-nr x) layer4))
                           (cond ((typep x 'pitchcell)
                                  (cond ((= (get-layer-nr x) layer1)
                                         (setf pitches-four-layers (get-pitches-4layers-during-times-for-pitchcell indexx x layer2 layer3 layer4))
                                         (setf pitches-four-layers (filter-out-four-if-three-are-nil pitches-four-layers))
                                         (setf pitches-layer1 (first pitches-four-layers))
                                         (setf pitches-layer2 (second pitches-four-layers))
                                         (setf pitches-layer3 (third pitches-four-layers))
                                         (setf pitches-layer4 (fourth pitches-four-layers)))
                                        ((= (get-layer-nr x) layer2)
                                         (setf pitches-four-layers (get-pitches-4layers-during-times-for-pitchcell indexx x layer1 layer3 layer4))
                                         (setf pitches-four-layers (filter-out-four-if-three-are-nil pitches-four-layers))
                                         (setf pitches-layer2 (first pitches-four-layers))
                                         (setf pitches-layer1 (second pitches-four-layers))
                                         (setf pitches-layer3 (third pitches-four-layers))
                                         (setf pitches-layer4 (fourth pitches-four-layers)))
                                        ((= (get-layer-nr x) layer3)
                                         (setf pitches-four-layers (get-pitches-4layers-during-times-for-pitchcell indexx x layer1 layer2 layer4))
                                         (setf pitches-four-layers (filter-out-four-if-three-are-nil pitches-four-layers))
                                         (setf pitches-layer3 (first pitches-four-layers))
                                         (setf pitches-layer1 (second pitches-four-layers))
                                         (setf pitches-layer2 (third pitches-four-layers))
                                         (setf pitches-layer4 (fourth pitches-four-layers)))
                                        ((= (get-layer-nr x) layer4)
                                         (setf pitches-four-layers (get-pitches-4layers-during-times-for-pitchcell indexx x layer1 layer2 layer3))
                                         (setf pitches-four-layers (filter-out-four-if-three-are-nil pitches-four-layers))
                                         (setf pitches-layer4 (first pitches-four-layers))
                                         (setf pitches-layer1 (second pitches-four-layers))
                                         (setf pitches-layer2 (third pitches-four-layers))
                                         (setf pitches-layer3 (fourth pitches-four-layers))))
                                  (if pitches-layer1 
                                      (eval (append '(and) (mapcar #'(lambda (p1 p2 p3 p4) (if (funcall testfn p1 p2 p3 p4) t)) pitches-layer1 pitches-layer2 pitches-layer3 pitches-layer4)))
                                    t))
                                 ((typep x 'rhythmcell)
                                  (cond ((= (get-layer-nr x) layer1)
                                         (setf pitches-four-layers (get-pitches-4layers-during-times-for-rhythmcell indexx x layer2 layer3 layer4))
                                         (setf pitches-four-layers (filter-out-four-if-three-are-nil pitches-four-layers))
                                         (setf pitches-layer1 (first pitches-four-layers))
                                         (setf pitches-layer2 (second pitches-four-layers))
                                         (setf pitches-layer3 (third pitches-four-layers))
                                         (setf pitches-layer4 (fourth pitches-four-layers)))
                                        ((= (get-layer-nr x) layer2)
                                         (setf pitches-four-layers (get-pitches-4layers-during-times-for-rhythmcell indexx x layer1 layer3 layer4))
                                         (setf pitches-four-layers (filter-out-four-if-three-are-nil pitches-four-layers))
                                         (setf pitches-layer2 (first pitches-four-layers))
                                         (setf pitches-layer1 (second pitches-four-layers))
                                         (setf pitches-layer3 (third pitches-four-layers))
                                         (setf pitches-layer4 (fourth pitches-four-layers)))
                                        ((= (get-layer-nr x) layer3)
                                         (setf pitches-four-layers (get-pitches-4layers-during-times-for-rhythmcell indexx x layer1 layer2 layer4))
                                         (setf pitches-four-layers (filter-out-four-if-three-are-nil pitches-four-layers))
                                         (setf pitches-layer3 (first pitches-four-layers))
                                         (setf pitches-layer1 (second pitches-four-layers))
                                         (setf pitches-layer2 (third pitches-four-layers))
                                         (setf pitches-layer4 (fourth pitches-four-layers)))
                                        ((= (get-layer-nr x) layer4)
                                         (setf pitches-four-layers (get-pitches-4layers-during-times-for-rhythmcell indexx x layer1 layer2 layer3))
                                         (setf pitches-four-layers (filter-out-four-if-three-are-nil pitches-four-layers))
                                         (setf pitches-layer4 (first pitches-four-layers))
                                         (setf pitches-layer1 (second pitches-four-layers))
                                         (setf pitches-layer2 (third pitches-four-layers))
                                         (setf pitches-layer3 (fourth pitches-four-layers))))
                                  (if pitches-layer1 
                                      (eval (append '(and) (mapcar #'(lambda (p1 p2 p3 p4) (if (funcall testfn p1 p2 p3 p4) t)) pitches-layer1 pitches-layer2 pitches-layer3 pitches-layer4)))
                                    t))
                                 (t t))
                         t)
      )))





;(setf beat-onsets (find-beat-onsets-between-timepoints2 start-this-cell stop-this-cell subdiv indexx))
;(find-beat-onsets-between-timepoints2 0 1 1 100)

;;;below is a testfunction for 4-part chords
(defun x-to-dx (list)
  (loop for n in list
        for m in (cdr list)
        collect (- m n)))

(defun next-chord-position (chord)
  (mapcar #'(lambda (i) (- i (first chord))) (append (cdr chord) '(12))))


(defun test-if-pitches-match-chordstructure (p1 p2 p3 p4 chordlist)
  "Input will be sorted"
  (let* ((all-allowed-chord-positions (apply 'append 
                                             (loop for chord in chordlist
                                                   collect (loop for n from 0 to (length chord)
                                                                 collect (setf chord (next-chord-position chord))))))
         (these-pitches (sort (remove nil (list p1 p2 p3 p4)) '<))
         (this-chord (mapcar #'(lambda (p) (rem (- p (first these-pitches)) 12)) (cdr these-pitches))))
   ; (system::pwgl-print this-chord)
    (loop for testchord in all-allowed-chord-positions 
          do (if (subsetp (remove 0 this-chord) testchord)
                 (return t))
          finally (return nil))))





(defun  format-4layers-chord-rule (chordlist layer1 layer2 layer3 layer4)
  (let ((testfn #'(lambda (p1 p2 p3 p4) (test-if-pitches-match-chordstructure p1 p2 p3 p4 chordlist))))
    (format-4layers-harm-rule testfn layer1 layer2 layer3 layer4)))


;;;;4 part harmony on beats
;(find-beat-onsets-between-timepoints2 4/12 6/12 1 100)
(defun get-pitches-at-beats-4layers-during-times-for-pitchcell (index x subdiv other-layer1 other-layer2 other-layer3)
  "List pitches for x and for other layer at the time window for x."
  (let* ((this-cell-onsets-with-endpoint (get-onsets-for-this-pitchcell-with-endpoint index x))
         (start-time (first this-cell-onsets-with-endpoint)))

    (if start-time
        (let* ((this-layer (get-layer-nr x))
               (end-time (car (last (remove nil this-cell-onsets-with-endpoint))))
               (tot-length-this-layer (get-number-of-rhythms-and-pauses-at-index this-layer index))
               (tot-length-other-layer1 (get-number-of-rhythms-and-pauses-at-index other-layer1 index))
               (tot-length-other-layer2 (get-number-of-rhythms-and-pauses-at-index other-layer2 index))
               (tot-length-other-layer3 (get-number-of-rhythms-and-pauses-at-index other-layer3 index))
               (beat-onsets  (find-beat-onsets-between-timepoints2 (1- start-time) (1- end-time) subdiv index))
               (ordernr-corresponding-onsets-this-layer 
                (get-ordernr-for-onsets-from-vector-at-timepoints this-layer beat-onsets tot-length-this-layer))
               (ordernr-corresponding-onsets-other-layer1 
                (get-ordernr-for-onsets-from-vector-at-timepoints other-layer1 beat-onsets tot-length-other-layer1))
               (ordernr-corresponding-onsets-other-layer2 
                (get-ordernr-for-onsets-from-vector-at-timepoints other-layer2 beat-onsets tot-length-other-layer2))
               (ordernr-corresponding-onsets-other-layer3 
                (get-ordernr-for-onsets-from-vector-at-timepoints other-layer3 beat-onsets tot-length-other-layer3))

               (pitches-this-layer (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 this-layer index nth) '(nil))) 
                                           ordernr-corresponding-onsets-this-layer))
               (pitches-other-layer1 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer1 index nth) '(nil)))
                                            ordernr-corresponding-onsets-other-layer1))
               (pitches-other-layer2 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer2 index nth) '(nil)))
                                            ordernr-corresponding-onsets-other-layer2))
               (pitches-other-layer3 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer3 index nth) '(nil)))
                                            ordernr-corresponding-onsets-other-layer3)))
          
           (list pitches-this-layer pitches-other-layer1 pitches-other-layer2 pitches-other-layer3))
      '(((nil))((nil))((nil))((nil))))))



(defun get-pitches-at-beats-4layers-during-times-for-timesign (index x subdiv other-layer0 other-layer1 other-layer2 other-layer3)
  (let* ((start-time  (1+ (get-total-duration-timesigns-at-index (1- index))))  ;add offset 1
         (end-time  (1+ (get-total-duration-timesigns-at-index index)))
         (tot-length-other-layer0 (get-number-of-rhythms-and-pauses-at-index other-layer0 index))
         (tot-length-other-layer1 (get-number-of-rhythms-and-pauses-at-index other-layer1 index))
         (tot-length-other-layer2 (get-number-of-rhythms-and-pauses-at-index other-layer2 index))
         (tot-length-other-layer3 (get-number-of-rhythms-and-pauses-at-index other-layer3 index))
         (beat-onsets (find-beat-onsets-between-timepoints2 (1- start-time) (1- end-time) subdiv index))
         (ordernr-corresponding-onsets-other-layer0
          (get-ordernr-for-onsets-from-vector-at-timepoints other-layer0 beat-onsets tot-length-other-layer0))
         (ordernr-corresponding-onsets-other-layer1 
          (get-ordernr-for-onsets-from-vector-at-timepoints other-layer1 beat-onsets tot-length-other-layer1))
         (ordernr-corresponding-onsets-other-layer2 
          (get-ordernr-for-onsets-from-vector-at-timepoints other-layer2 beat-onsets tot-length-other-layer2))
         (ordernr-corresponding-onsets-other-layer3 
          (get-ordernr-for-onsets-from-vector-at-timepoints other-layer3 beat-onsets tot-length-other-layer3))

         (pitches-other-layer0 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer0 index nth) '(nil))) 
                                     ordernr-corresponding-onsets-other-layer0))
         (pitches-other-layer1 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer1 index nth) '(nil)))
                                      ordernr-corresponding-onsets-other-layer1))
         (pitches-other-layer2 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer2 index nth) '(nil)))
                                      ordernr-corresponding-onsets-other-layer2))
         (pitches-other-layer3 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer3 index nth) '(nil)))
                                      ordernr-corresponding-onsets-other-layer3)))
   (list pitches-other-layer0 pitches-other-layer1 pitches-other-layer2 pitches-other-layer3)))


(defun get-pitches-at-beats-4layers-during-times-for-rhythmcell (index x subdiv other-layer1 other-layer2 other-layer3)
  (let* ((this-layer (get-layer-nr x))
         (start-time (1+ (get-total-duration-rhythms-at-index this-layer (1- index))))  ;add offset 1
         (end-time (1+ (get-total-duration-rhythms-at-index this-layer index)))
         (this-cell-onsets (mapcar #'(lambda (x) (+ start-time x)) (butlast (get-local-onset-without-pauses x))))
         (tot-length-this-layer (get-number-of-rhythms-and-pauses-at-index this-layer index))
         (tot-length-other-layer1 (get-number-of-rhythms-and-pauses-at-index other-layer1 index))
         (tot-length-other-layer2 (get-number-of-rhythms-and-pauses-at-index other-layer2 index))
         (tot-length-other-layer3 (get-number-of-rhythms-and-pauses-at-index other-layer3 index))
         (beat-onsets  (find-beat-onsets-between-timepoints2 (1- start-time) (1- end-time) subdiv index))
         (ordernr-corresponding-onsets-this-layer 
          (get-ordernr-for-onsets-from-vector-at-timepoints this-layer beat-onsets tot-length-this-layer))
         (ordernr-corresponding-onsets-other-layer1 
          (get-ordernr-for-onsets-from-vector-at-timepoints other-layer1 beat-onsets tot-length-other-layer1))
         (ordernr-corresponding-onsets-other-layer2 
          (get-ordernr-for-onsets-from-vector-at-timepoints other-layer2 beat-onsets tot-length-other-layer2))
         (ordernr-corresponding-onsets-other-layer3 
          (get-ordernr-for-onsets-from-vector-at-timepoints other-layer3 beat-onsets tot-length-other-layer3))

         (pitches-this-layer (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 this-layer index nth) '(nil))) 
                                     ordernr-corresponding-onsets-this-layer))
         (pitches-other-layer1 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer1 index nth) '(nil)))
                                      ordernr-corresponding-onsets-other-layer1))
         (pitches-other-layer2 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer2 index nth) '(nil)))
                                      ordernr-corresponding-onsets-other-layer2))
         (pitches-other-layer3 (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm-2 other-layer3 index nth) '(nil)))
                                      ordernr-corresponding-onsets-other-layer3)))
   (list pitches-this-layer pitches-other-layer1 pitches-other-layer2 pitches-other-layer3)))




(defun  format-4layers-harm-on-beat-rule (testfn subdiv layer1 layer2 layer3 layer4)
  (let (pitches-four-layers pitches-layer1 pitches-layer2 pitches-layer3 pitches-layer4)
    #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer1) (= (get-layer-nr x) layer2) (= (get-layer-nr x) layer3) (= (get-layer-nr x) layer4))
                             (cond ((typep x 'pitchcell)
                                    (cond ((= (get-layer-nr x) layer1)
                                           (setf pitches-four-layers (get-pitches-at-beats-4layers-during-times-for-pitchcell indexx x subdiv layer2 layer3 layer4))
                                           (setf pitches-four-layers (filter-out-four-if-three-are-nil pitches-four-layers))
                                           (setf pitches-layer1 (first pitches-four-layers))
                                           (setf pitches-layer2 (second pitches-four-layers))
                                           (setf pitches-layer3 (third pitches-four-layers))
                                           (setf pitches-layer4 (fourth pitches-four-layers)))
                                          ((= (get-layer-nr x) layer2)
                                           (setf pitches-four-layers (get-pitches-at-beats-4layers-during-times-for-pitchcell indexx x subdiv layer1 layer3 layer4))
                                           (setf pitches-four-layers (filter-out-four-if-three-are-nil pitches-four-layers))
                                           (setf pitches-layer2 (first pitches-four-layers))
                                           (setf pitches-layer1 (second pitches-four-layers))
                                           (setf pitches-layer3 (third pitches-four-layers))
                                           (setf pitches-layer4 (fourth pitches-four-layers)))
                                          ((= (get-layer-nr x) layer3)
                                           (setf pitches-four-layers (get-pitches-at-beats-4layers-during-times-for-pitchcell indexx x subdiv layer1 layer2 layer4))
                                           (setf pitches-four-layers (filter-out-four-if-three-are-nil pitches-four-layers))
                                           (setf pitches-layer3 (first pitches-four-layers))
                                           (setf pitches-layer1 (second pitches-four-layers))
                                           (setf pitches-layer2 (third pitches-four-layers))
                                           (setf pitches-layer4 (fourth pitches-four-layers)))
                                          ((= (get-layer-nr x) layer4)
                                           (setf pitches-four-layers (get-pitches-at-beats-4layers-during-times-for-pitchcell indexx x subdiv layer1 layer2 layer3))
                                           (setf pitches-four-layers (filter-out-four-if-three-are-nil pitches-four-layers))
                                           (setf pitches-layer4 (first pitches-four-layers))
                                           (setf pitches-layer1 (second pitches-four-layers))
                                           (setf pitches-layer2 (third pitches-four-layers))
                                           (setf pitches-layer3 (fourth pitches-four-layers))))
                                    (if pitches-layer1 
                                        (eval (append '(and) (mapcar #'(lambda (p1 p2 p3 p4) (if (funcall testfn p1 p2 p3 p4) t)) pitches-layer1 pitches-layer2 pitches-layer3 pitches-layer4)))
                                      t))
                                   ((typep x 'rhythmcell)
                                    (cond ((= (get-layer-nr x) layer1)
                                           (setf pitches-four-layers (get-pitches-at-beats-4layers-during-times-for-rhythmcell indexx x subdiv layer2 layer3 layer4))
                                           (setf pitches-four-layers (filter-out-four-if-three-are-nil pitches-four-layers))
                                           (setf pitches-layer1 (first pitches-four-layers))
                                           (setf pitches-layer2 (second pitches-four-layers))
                                           (setf pitches-layer3 (third pitches-four-layers))
                                           (setf pitches-layer4 (fourth pitches-four-layers)))
                                          ((= (get-layer-nr x) layer2)
                                           (setf pitches-four-layers (get-pitches-at-beats-4layers-during-times-for-rhythmcell indexx x subdiv layer1 layer3 layer4))
                                           (setf pitches-four-layers (filter-out-four-if-three-are-nil pitches-four-layers))
                                           (setf pitches-layer2 (first pitches-four-layers))
                                           (setf pitches-layer1 (second pitches-four-layers))
                                           (setf pitches-layer3 (third pitches-four-layers))
                                           (setf pitches-layer4 (fourth pitches-four-layers)))
                                          ((= (get-layer-nr x) layer3)
                                           (setf pitches-four-layers (get-pitches-at-beats-4layers-during-times-for-rhythmcell indexx x subdiv layer1 layer2 layer4))
                                           (setf pitches-four-layers (filter-out-four-if-three-are-nil pitches-four-layers))
                                           (setf pitches-layer3 (first pitches-four-layers))
                                           (setf pitches-layer1 (second pitches-four-layers))
                                           (setf pitches-layer2 (third pitches-four-layers))
                                           (setf pitches-layer4 (fourth pitches-four-layers)))
                                          ((= (get-layer-nr x) layer4)
                                           (setf pitches-four-layers (get-pitches-at-beats-4layers-during-times-for-rhythmcell indexx x subdiv layer1 layer2 layer3))
                                           (setf pitches-four-layers (filter-out-four-if-three-are-nil pitches-four-layers))
                                           (setf pitches-layer4 (first pitches-four-layers))
                                           (setf pitches-layer1 (second pitches-four-layers))
                                           (setf pitches-layer2 (third pitches-four-layers))
                                           (setf pitches-layer3 (fourth pitches-four-layers))))
                                    (if pitches-layer1 
                                        (eval (append '(and) (mapcar #'(lambda (p1 p2 p3 p4) (if (funcall testfn p1 p2 p3 p4) t)) pitches-layer1 pitches-layer2 pitches-layer3 pitches-layer4)))
                                      t))
                                   ((typep x 'timesign)
                                    (setf pitches-four-layers (get-pitches-at-beats-4layers-during-times-for-timesign indexx x subdiv layer1 layer2 layer3 layer4))
                                    (setf pitches-four-layers (filter-out-four-if-three-are-nil pitches-four-layers))
                                    (setf pitches-layer1 (first pitches-four-layers))
                                    (setf pitches-layer2 (second pitches-four-layers))
                                    (setf pitches-layer3 (third pitches-four-layers))
                                    (setf pitches-layer4 (fourth pitches-four-layers))
                                    (if pitches-layer1 
                                        (eval (append '(and) (mapcar #'(lambda (p1 p2 p3 p4) (if (funcall testfn p1 p2 p3 p4) t)) pitches-layer1 pitches-layer2 pitches-layer3 pitches-layer4)))
                                      t))
                                  
                                   (t t))
                           t)
        )))



(defun  format-4layers-chord-at-beats-rule (chordlist subdiv layer1 layer2 layer3 layer4)
  (let ((testfn #'(lambda (p1 p2 p3 p4) (test-if-pitches-match-chordstructure p1 p2 p3 p4 chordlist))))
    (format-4layers-harm-on-beat-rule testfn subdiv layer1 layer2 layer3 layer4)))


(defun test1 (other-layer0 other-layer1 other-layer2 other-layer3)
  #'(lambda (indexx x) (get-pitches-at-beats-4layers-during-times-for-timesign indexx x 1 other-layer0 other-layer1 other-layer2 other-layer3)))