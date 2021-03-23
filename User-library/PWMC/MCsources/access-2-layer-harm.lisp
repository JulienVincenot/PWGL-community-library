(in-package MC)
;bugfix bandpass-filter-with-preceeding-elements (if list is empty, nil will be returned)

(defun get-first-nth-for-pitchcell (index x)
  (let ((this-layer (get-layer-nr x)))
    (get-number-of-pitches-at-index this-layer (1- index))))


(defun get-last-nth-for-pitchcell (index x)
  (let ((length-pitchcell (get-nr-of-events x)))
    (1- (+ (get-first-nth-for-pitchcell index x) length-pitchcell))))

;(get-number-of-rhythms-and-pauses-at-index 1 40)
;(get-ordernr-for-onsets-from-vector-at-timepoints 0 '(1 12/8) 16)
;(get-ordernr-for-onsets-from-vector-at-timepoints 35 0 '(1))
;get-ordernr-for-onsets-from-vector-at-timepoints skips gracenotes
(defun get-pitches-at-timepoints (index layernr timepoints)
  (let* ((tot-length-this-layer (get-number-of-rhythms-and-pauses-at-index layernr index))
         (ordernr (get-ordernr-for-onsets-from-vector-at-timepoints layernr timepoints tot-length-this-layer)))
    (mapcar #'(lambda (nth) (if nth (get-pitch-at-nthrhythm layernr index nth) '(nil))) ordernr)))


;(get-pitches-at-timepoints-include-gracenotes 39 1 '(10/8 11/8))
(defun get-pitches-at-timepoints-include-gracenotes (index layernr timepoints)
  (let* ((tot-length-this-layer (get-number-of-rhythms-and-pauses-at-index layernr index))
         (ordernr (get-ordernr-for-onsets-from-vector-at-timepoints-include-gracenotes layernr timepoints tot-length-this-layer)))
    (mapcar #'(lambda (nth) (if nth (if (listp nth) (mapcar #'(lambda (n) (get-pitch-at-nthrhythm layernr index n)) nth)
                                      (get-pitch-at-nthrhythm layernr index nth)) '(nil))) ordernr)))

;;;the following 2 functions are copied from old file - identical (redefined if old file will be trashed)
(defun get-onsets-for-this-pitchcell-with-endpoint (index x)
  (let* ((this-layer (get-layer-nr x))
         (length-pitchcell (get-nr-of-events x))
         (length-this-layer-before-cell (get-number-of-pitches-at-index this-layer (1- index))))
    (get-onsets-for-pitches-with-endpoint this-layer index length-this-layer-before-cell (1- (+ length-this-layer-before-cell length-pitchcell)))))


(defun filter-out-both-if-one-is-nil (two-lists)
  "OBS: Also appends sublists in each list."
  (let (layer1-pitches layer2-pitches)
    (loop for y in (first two-lists)
          for z in (second two-lists)
          do (if (and (car y) (car z)) (progn (setf layer1-pitches (append y layer1-pitches))
                             (setf layer2-pitches (append z layer2-pitches)))))
    (list layer1-pitches layer2-pitches)))


(defun filter-out-both-if-one-is-nil-with-gracenotes (two-lists)
  "OBS: Also appends sublists in each list."
  (let (layer1-pitches layer2-pitches)
    (loop for y in (first two-lists)
          for z in (second two-lists)
          do (if (and (car y) (car z)) (progn (setf layer1-pitches (append (if (listp (car y))
                                                                                     (list (apply 'append y))
                                                                                   y)
                                                                           layer1-pitches))
                                         (setf layer2-pitches (append (if (listp (car z))
                                                                                  (list (apply 'append z))
                                                                                z)
                                                                      layer2-pitches)))))
    (list layer1-pitches layer2-pitches)))


;(get-ordernr-for-onsets-from-vector-at-timepoints-include-gracenotes 0 '(1) 1)
;(get-ordernr-for-onsets-from-vector-at-timepoints 1 '(124999/100000) 6)
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
                                       (if (plusp this-onset) (return (1- (aref part-sol-vector layer local-pointer *#-RHYTHM-EVENT*))) 
                                         (return nil)) 
                                     (return (list 'error layer timepoints tot-length-layer)))
                                 (setf local-pointer (1+ local-pointer)))))))))


(defun get-ordernr-for-onsets-from-vector-at-timepoints-include-gracenotes (layer timepoints tot-length-layer)
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
                                       (if (>= timepoint (abs this-onset))
                                           (if (plusp this-onset) (return (1- (aref part-sol-vector layer local-pointer *#-RHYTHM-EVENT*))) 
                                             (return nil)) 
                                         (return (list 'error layer timepoints tot-length-layer))))
                                 (if (and (= timepoint (abs next-onset)) (= timepoint (abs this-onset)))
                                     (if (plusp this-onset) (return (let ((retur nil)) ;;;this is where gracenotes needs to be checked
                                                                      
                                                                      (loop do (if (= (aref part-sol-vector layer local-pointer *ONSETTIME*)
                                                                                      (aref part-sol-vector layer (1+ local-pointer) *ONSETTIME*))
                                                                                   (progn (setf retur (append retur (list (1- (aref part-sol-vector layer local-pointer *#-RHYTHM-EVENT*)))))
                                                                                     (setf local-pointer (1+ local-pointer)))
                                                                                 (return (if retur (append retur (list (1- (aref part-sol-vector layer local-pointer *#-RHYTHM-EVENT*))))
                                                                                           (1- (aref part-sol-vector layer local-pointer *#-RHYTHM-EVENT*))))))))
                                       (return nil)) 
                                   (setf local-pointer (1+ local-pointer))))
                               ))))))


      
;;; This function is defined in access-pitch-and-rhythm:
;(defun strip-selection (list from-nth to-nth)
;  "Return selection between from-nth to-nth."
;  (loop for n from from-nth to to-nth
;        collect (nth n list)))
;;;;;;


;This function filters out grace notes
(defun get-pitches-for-pitchcell-and-other-layer-always (index x other-layernr nr-of-preceeding-pitches-to-include)
  (let* ((this-layer (get-layer-nr x))
         (first-nth-this-pitchcell (get-first-nth-for-pitchcell index x))
         (last-nth-this-layer (get-last-nth-for-pitchcell index x))
         (first-nth-this-layer (- first-nth-this-pitchcell nr-of-preceeding-pitches-to-include)))
    (if (minusp first-nth-this-layer) (setf first-nth-this-layer 0))
    (let* ((onsets-this-layer-with-endpoint (get-onsets-for-pitches-with-endpoint this-layer index first-nth-this-layer last-nth-this-layer))
           (start-time (first onsets-this-layer-with-endpoint))
           (end-time (car (last (remove nil onsets-this-layer-with-endpoint))))
           (nr-of-events-other-layer (get-number-of-rhythms-and-pauses-at-index other-layernr index))
           (onsets-in-other-layer-during-this-cell 
            (if start-time (get-onsets-from-vector-between-timepoints other-layernr start-time  end-time  nr-of-events-other-layer) ; if no onset in first layer, return '(nil)
              '(nil)))
           (all-onsets (remove-duplicates (sort                               ;remove-duplicates will alsow filter out gracenotes
                                           (append (butlast (remove nil onsets-this-layer-with-endpoint))
                                                   (remove nil onsets-in-other-layer-during-this-cell)) 
                                           '<)))
           (pitches-this-layer (get-pitches-at-timepoints index this-layer all-onsets))
           (pitches-other-layer (get-pitches-at-timepoints index other-layernr all-onsets)))
      (list pitches-this-layer pitches-other-layer))))
  

;(get-pitches-for-rhythmcell-and-other-layer-always 11
;(get-total-duration-rhythms-at-index 1 12)
;(get-number-of-rhythms-and-pauses-at-index 0 12)
;(get-number-of-rhythms-at-index 1 12)
;(get-ordernr-for-onsets-from-vector-at-timepoints 1 (list 28/24) 6)
;(get-number-of-rhythms-at-index 1 8)
;(get-onsets-for-pitches-with-endpoint 1 12 0 4)
;(get-total-duration-rhythms-at-index 1 12)
;(get-onsets-from-vector-between-timepoints 0 1  5/4  4)
;;;;;bug kolla detta??? fixed???
(defun get-pitches-for-rhythmcell-and-other-layer-always (index x other-layernr nr-of-preceeding-pitches-to-include)
  (let* ((this-layer (get-layer-nr x))
         (start-time-cell (1+ (get-total-duration-rhythms-at-index this-layer (1- index)))) ;add offset 1
         (end-time (1+ (get-total-duration-rhythms-at-index this-layer index)))       ;add offset 1
         (nr-of-events-this-layer (get-number-of-rhythms-and-pauses-at-index this-layer index))
        ; (first-nth-this-cell 
        ;  (car (get-ordernr-for-onsets-from-vector-at-timepoints this-layer (list start-time-cell) nr-of-events-this-layer))))
         (first-nth-this-cell (get-number-of-rhythms-at-index this-layer (1- index))))
;(system::pwgl-print 'test)

;;;;;BUG HERE???
    (if (not first-nth-this-cell) nil
      (let* ((first-nth-this-layer (if (minusp (- first-nth-this-cell nr-of-preceeding-pitches-to-include))
                                       0 (- first-nth-this-cell nr-of-preceeding-pitches-to-include)))
             ;(last-nth-this-layer 
             ;  (car (get-ordernr-for-onsets-from-vector-at-timepoints this-layer (list (- end-time 1/100000)) nr-of-events-this-layer)))  ;- 1/10000 to get item just before end-time
(last-nth-this-layer (get-number-of-rhythms-at-index this-layer index))

;;;;;;NEXT LINE IS THE BUG - remove nil must be there
             (onsets-this-layer-with-endpoint (remove nil (get-onsets-for-pitches-with-endpoint this-layer index first-nth-this-layer last-nth-this-layer)))
             (start-time (car onsets-this-layer-with-endpoint))
             (nr-of-events-other-layer (get-number-of-rhythms-and-pauses-at-index other-layernr index))
             (onsets-in-other-layer-during-this-cell 
              (if start-time (get-onsets-from-vector-between-timepoints other-layernr start-time  end-time  nr-of-events-other-layer) ; if no onset in first layer, return '(nil)
                '(nil)))
             (all-onsets (remove-duplicates (sort
                                             (append (butlast onsets-this-layer-with-endpoint) (remove nil onsets-in-other-layer-during-this-cell))
                                             '<)))
             (pitches-this-layer (get-pitches-at-timepoints index this-layer all-onsets))
             (pitches-other-layer (get-pitches-at-timepoints index other-layernr all-onsets)))

;;;;;;BUG BEFORE HERE
        (list pitches-this-layer pitches-other-layer)))))



(defun get-pitches-for-pitchcell-and-other-layer-always-include-gracenotes (index x other-layernr nr-of-preceeding-pitches-to-include)
  (let* ((this-layer (get-layer-nr x))
         (first-nth-this-pitchcell (get-first-nth-for-pitchcell index x))
         (last-nth-this-layer (get-last-nth-for-pitchcell index x)) ;;;;!!!!!error nil
         (first-nth-this-layer (- first-nth-this-pitchcell nr-of-preceeding-pitches-to-include)))
    (if (minusp first-nth-this-layer) (setf first-nth-this-layer 0))
    (let* ((onsets-this-layer-with-endpoint (get-onsets-for-pitches-with-endpoint this-layer index first-nth-this-layer last-nth-this-layer))
           (start-time (first onsets-this-layer-with-endpoint))
           (end-time (car (last (remove nil onsets-this-layer-with-endpoint))))
           (nr-of-events-other-layer (get-number-of-rhythms-and-pauses-at-index other-layernr index))
           (onsets-in-other-layer-during-this-cell 
            (if start-time (get-onsets-from-vector-between-timepoints other-layernr start-time  end-time  nr-of-events-other-layer) ;this gives nil if start/end time are the same - this will however not be a problem
              '(nil)))  ; if no onset in first layer, return '(nil)
           (all-onsets (remove-duplicates (sort                               ;remove-duplicates will alsow filter out gracenotes
                                           (append (butlast (remove nil onsets-this-layer-with-endpoint))
                                                   (remove nil onsets-in-other-layer-during-this-cell)) 
                                           '<)))
           (pitches-this-layer (get-pitches-at-timepoints-include-gracenotes index this-layer all-onsets))
           (pitches-other-layer (get-pitches-at-timepoints-include-gracenotes index other-layernr all-onsets)))
      (list pitches-this-layer pitches-other-layer))))


;(get-number-of-rhythms-at-index 1 10)
;(get-onsets-for-pitches-with-endpoint 1 20 0 6)
;(get-number-of-rhythms-and-pauses-at-index 0 20)
;(get-onsets-from-vector-between-timepoints 2 1  5/4  6)
;(get-pitches-at-timepoints-include-gracenotes 10 0 '(1 9/8))
;(get-pitches-at-timepoints 10 1 '(1 9/8))
(defun get-pitches-for-rhythmcell-and-other-layer-always-include-gracenotes (index x other-layernr nr-of-preceeding-pitches-to-include)
  (let* ((this-layer (get-layer-nr x))
         (start-time-cell (1+ (get-total-duration-rhythms-at-index this-layer (1- index)))) ;add offset 1
         
         (end-time (1+ (get-total-duration-rhythms-at-index this-layer index)))       ;add offset 1
         (nr-of-events-this-layer (get-number-of-rhythms-and-pauses-at-index this-layer index))
         ;(first-nth-this-cell 
         ; (car (get-ordernr-for-onsets-from-vector-at-timepoints-include-gracenotes this-layer (list start-time-cell) nr-of-events-this-layer)))

        ; (first-nth-this-cell 
        ;  (if (listp first-nth-this-cell) (car first-nth-this-cell) first-nth-this-cell))
(first-nth-this-cell (get-number-of-rhythms-at-index this-layer (1- index)))
         )
(system::pwgl-print (list this-layer start-time-cell end-time nr-of-events-this-layer first-nth-this-cell))
    (if (not first-nth-this-cell) nil
      (let* ((first-nth-this-layer (if (minusp (- first-nth-this-cell nr-of-preceeding-pitches-to-include))
                                       0 (- first-nth-this-cell nr-of-preceeding-pitches-to-include)))
             (last-nth-this-layer (if (= start-time-cell end-time)
                                      (1- (car (last (car (get-ordernr-for-onsets-from-vector-at-timepoints-include-gracenotes this-layer (list end-time) nr-of-events-this-layer))))) ;grace note-error
                                    ;(car (get-ordernr-for-onsets-from-vector-at-timepoints this-layer (list (- end-time 1/100000)) nr-of-events-this-layer))  ;- 1/10000 to get item just before end-time
                                    (get-number-of-rhythms-at-index this-layer index)
                                    )) 
             (onsets-this-layer-with-endpoint (remove nil (get-onsets-for-pitches-with-endpoint this-layer index first-nth-this-layer last-nth-this-layer)));remove nil
             (start-time (car onsets-this-layer-with-endpoint))
             (nr-of-events-other-layer (get-number-of-rhythms-and-pauses-at-index other-layernr index))
             (onsets-in-other-layer-during-this-cell 
              (if start-time (get-onsets-from-vector-between-timepoints other-layernr start-time  end-time  nr-of-events-other-layer) ; if no onset in first layer, return '(nil)
                '(nil)))
             (all-onsets (remove-duplicates (sort
                                             (append (remove nil (butlast onsets-this-layer-with-endpoint))
                                                     (remove nil onsets-in-other-layer-during-this-cell))
                                             '<)))
             (pitches-this-layer (get-pitches-at-timepoints-include-gracenotes index this-layer all-onsets))
             (pitches-other-layer (get-pitches-at-timepoints-include-gracenotes index other-layernr all-onsets)))
         (list pitches-this-layer pitches-other-layer)))))


(defun format-2-layer-harm-rule (testfn layer1 layer2)
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn))
         pitches-both-layers pitches-layer1 pitches-layer2)
    #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer1) (= (get-layer-nr x) layer2))
                             (cond ((typep x 'pitchcell)
                                    (cond ((= (get-layer-nr x) layer1)

                                           (setf pitches-both-layers (get-pitches-for-pitchcell-and-other-layer-always indexx x layer2 nr-of-preceeding-pitches-to-include))
                                          
                                           (setf pitches-both-layers (filter-out-both-if-one-is-nil pitches-both-layers))

                                           (setf pitches-layer1 (first pitches-both-layers))
                                           (setf pitches-layer2 (second pitches-both-layers))
                                           (setf pitches-both-layers (reverse (mapcar 'list pitches-layer1 pitches-layer2))))
                                          ((= (get-layer-nr x) layer2)
   
                                           (setf pitches-both-layers (get-pitches-for-pitchcell-and-other-layer-always indexx x layer1 nr-of-preceeding-pitches-to-include))
                                          
                                           (setf pitches-both-layers (filter-out-both-if-one-is-nil pitches-both-layers))
                                           (setf pitches-layer2 (first pitches-both-layers))
                                           (setf pitches-layer1 (second pitches-both-layers))
                                           (setf pitches-both-layers (reverse (mapcar 'list pitches-layer1 pitches-layer2)))))
                                    
                                    (if pitches-layer1
                                        (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                                              do (if (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include))) t (return nil))
                                              finally (return t))
                                      t))
                                   ((typep x 'rhythmcell)
                                    
                                    (cond ((= (get-layer-nr x) layer1)

                                           (setf pitches-both-layers (get-pitches-for-rhythmcell-and-other-layer-always indexx x layer2 nr-of-preceeding-pitches-to-include))

                                           (setf pitches-both-layers (filter-out-both-if-one-is-nil pitches-both-layers))
                                           (setf pitches-layer1 (first pitches-both-layers))
                                           (setf pitches-layer2 (second pitches-both-layers))
                                           (setf pitches-both-layers (reverse (mapcar 'list pitches-layer1 pitches-layer2))))
                                          ((= (get-layer-nr x) layer2)

                                           (setf pitches-both-layers (get-pitches-for-rhythmcell-and-other-layer-always indexx x layer1 nr-of-preceeding-pitches-to-include))
                                           (setf pitches-both-layers (filter-out-both-if-one-is-nil pitches-both-layers))
                                           (setf pitches-layer2 (first pitches-both-layers))
                                           (setf pitches-layer1 (second pitches-both-layers))
                                           (setf pitches-both-layers (reverse (mapcar 'list pitches-layer1 pitches-layer2)))))
                                    (if pitches-layer1
                                        (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                                              do (if (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include))) t (return nil))
                                              finally (return t))
                                      t))
                                   (t t))
                           t)
        )))

(defun combine-pitches-2layers (pitches-layer1 pitches-layer2)
  (apply 'append (mapcar #'(lambda (a b)  (cond ((and (listp a) (listp b))
                                                (append (loop for x in a
                                                              collect (list x (car (last b))))
                                                        (loop for x in b
                                                              collect (list (car (last a)) x))))
                                               ((listp a)
                                                (loop for x in a
                                                      collect (list x b)))
                                               ((listp b)
                                                (loop for x in b
                                                      collect (list a x)))
                                               (t (list (list a b)))))
                        pitches-layer1 pitches-layer2)))


(defun format-2-layer-harm-rule-include-gracenotes (testfn layer1 layer2)
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn))
         pitches-both-layers pitches-layer1 pitches-layer2)
    #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer1) (= (get-layer-nr x) layer2))
                             (cond ((typep x 'pitchcell)
(system::pwgl-print (get-layer-nr x))
                                    (cond ((= (get-layer-nr x) layer1)
                                           (setf pitches-both-layers (get-pitches-for-pitchcell-and-other-layer-always-include-gracenotes indexx x layer2 nr-of-preceeding-pitches-to-include))
                                           ;(system::pwgl-print pitches-both-layers)
                                           (setf pitches-both-layers (filter-out-both-if-one-is-nil-with-gracenotes pitches-both-layers))
                                           (setf pitches-layer1 (first pitches-both-layers))
                                           (setf pitches-layer2 (second pitches-both-layers))
                                           (setf pitches-both-layers (combine-pitches-2layers pitches-layer1 pitches-layer2)))
                                          ((= (get-layer-nr x) layer2)
                                           (setf pitches-both-layers (get-pitches-for-pitchcell-and-other-layer-always-include-gracenotes indexx x layer1 nr-of-preceeding-pitches-to-include))
                                          ; (system::pwgl-print pitches-both-layers)
                                           (setf pitches-both-layers (filter-out-both-if-one-is-nil-with-gracenotes pitches-both-layers))
                                           (setf pitches-layer2 (first pitches-both-layers))
                                           (setf pitches-layer1 (second pitches-both-layers))
                                           (setf pitches-both-layers (combine-pitches-2layers pitches-layer1 pitches-layer2))))
                                   
                                    (if pitches-layer1
                                        (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                                              do (if (apply testfn (system::pwgl-print (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include)))) t (return nil))
                                              finally (return t))
                                      t))
                                   ((typep x 'rhythmcell)

                                    (cond ((= (get-layer-nr x) layer1)
                                           (setf pitches-both-layers (get-pitches-for-rhythmcell-and-other-layer-always-include-gracenotes indexx x layer2 nr-of-preceeding-pitches-to-include))
                                           (setf pitches-both-layers (filter-out-both-if-one-is-nil-with-gracenotes pitches-both-layers))
                                           (setf pitches-layer1 (first pitches-both-layers))
                                           (setf pitches-layer2 (second pitches-both-layers))
                                           (setf pitches-both-layers (combine-pitches-2layers pitches-layer1 pitches-layer2)))
                                          ((= (get-layer-nr x) layer2)
                                           (setf pitches-both-layers (get-pitches-for-rhythmcell-and-other-layer-always-include-gracenotes indexx x layer1 nr-of-preceeding-pitches-to-include))
                                           ;(system::pwgl-print pitches-both-layers)
                                           (setf pitches-both-layers (filter-out-both-if-one-is-nil-with-gracenotes pitches-both-layers))
                                           (setf pitches-layer2 (first pitches-both-layers))
                                           (setf pitches-layer1 (second pitches-both-layers))
                                           (setf pitches-both-layers (combine-pitches-2layers pitches-layer1 pitches-layer2))))
                                    ;(system::pwgl-print pitches-layer1)
                                    (if pitches-layer1
                                        (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                                              do (if (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include))) t (return nil))
                                              finally (return t))
                                      t))
                                   (t t))
                           t)
        )))

(defun format-2-layer-harm-heuristic-rule (testfn layer1 layer2)
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn))
         pitches-both-layers pitches-layer1 pitches-layer2)
    #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer1) (= (get-layer-nr x) layer2))
                             (cond ((typep x 'pitchcell)
                                    (cond ((= (get-layer-nr x) layer1)
                                           (setf pitches-both-layers (get-pitches-for-pitchcell-and-other-layer-always indexx x layer2 nr-of-preceeding-pitches-to-include))
                                           (setf pitches-both-layers (filter-out-both-if-one-is-nil pitches-both-layers))
                                           (setf pitches-layer1 (first pitches-both-layers))
                                           (setf pitches-layer2 (second pitches-both-layers))
                                           (setf pitches-both-layers (reverse (mapcar 'list pitches-layer1 pitches-layer2))))
                                          ((= (get-layer-nr x) layer2)
                                           (setf pitches-both-layers (get-pitches-for-pitchcell-and-other-layer-always indexx x layer1 nr-of-preceeding-pitches-to-include))
                                           (setf pitches-both-layers (filter-out-both-if-one-is-nil pitches-both-layers))
                                           (setf pitches-layer2 (first pitches-both-layers))
                                           (setf pitches-layer1 (second pitches-both-layers))
                                           (setf pitches-both-layers (reverse (mapcar 'list pitches-layer1 pitches-layer2)))))
                                    
                                    (if pitches-layer1
                                        (apply '+ (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                                                        collect (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include)))))
                                      0))
                                   ((typep x 'rhythmcell)
                                    (cond ((= (get-layer-nr x) layer1)
                                           (setf pitches-both-layers (get-pitches-for-rhythmcell-and-other-layer-always indexx x layer2 nr-of-preceeding-pitches-to-include))
                                           (setf pitches-both-layers (filter-out-both-if-one-is-nil pitches-both-layers))
                                           (setf pitches-layer1 (first pitches-both-layers))
                                           (setf pitches-layer2 (second pitches-both-layers))
                                           (setf pitches-both-layers (reverse (mapcar 'list pitches-layer1 pitches-layer2))))
                                          ((= (get-layer-nr x) layer2)
                                           (setf pitches-both-layers (get-pitches-for-rhythmcell-and-other-layer-always indexx x layer1 nr-of-preceeding-pitches-to-include))
                                           (setf pitches-both-layers (filter-out-both-if-one-is-nil pitches-both-layers))
                                           (setf pitches-layer2 (first pitches-both-layers))
                                           (setf pitches-layer1 (second pitches-both-layers))
                                           (setf pitches-both-layers (reverse (mapcar 'list pitches-layer1 pitches-layer2)))))

                                    (if pitches-layer1
                                        (apply '+ (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                                                        collect (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include)))))
                                      0))
                                   (t 0))
                           0)
        )))

(defun format-2-layer-harm-heuristic-rule-include-gracenotes (testfn layer1 layer2)
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn))
         pitches-both-layers pitches-layer1 pitches-layer2)
    #'(lambda (indexx x) (if (or (= (get-layer-nr x) layer1) (= (get-layer-nr x) layer2))
                             (cond ((typep x 'pitchcell)
                                    (cond ((= (get-layer-nr x) layer1)
                                           (setf pitches-both-layers (get-pitches-for-pitchcell-and-other-layer-always-include-gracenotes indexx x layer2 nr-of-preceeding-pitches-to-include))
                                           ;(system::pwgl-print pitches-both-layers)
                                           (setf pitches-both-layers (filter-out-both-if-one-is-nil-with-gracenotes pitches-both-layers))
                                           (setf pitches-layer1 (first pitches-both-layers))
                                           (setf pitches-layer2 (second pitches-both-layers))
                                           (setf pitches-both-layers (combine-pitches-2layers pitches-layer1 pitches-layer2)))
                                          ((= (get-layer-nr x) layer2)
                                           (setf pitches-both-layers (get-pitches-for-pitchcell-and-other-layer-always-include-gracenotes indexx x layer1 nr-of-preceeding-pitches-to-include))
                                          ; (system::pwgl-print pitches-both-layers)
                                           (setf pitches-both-layers (filter-out-both-if-one-is-nil-with-gracenotes pitches-both-layers))
                                           (setf pitches-layer2 (first pitches-both-layers))
                                           (setf pitches-layer1 (second pitches-both-layers))
                                           (setf pitches-both-layers (combine-pitches-2layers pitches-layer1 pitches-layer2))))
                                    
                                    (if pitches-layer1
                                        (apply '+ (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                                                        collect (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include)))))
                                      0))
                                   ((typep x 'rhythmcell)
                                    ;(system::pwgl-print 'ok)
                                    (cond ((= (get-layer-nr x) layer1)
                                           (setf pitches-both-layers (get-pitches-for-rhythmcell-and-other-layer-always-include-gracenotes indexx x layer2 nr-of-preceeding-pitches-to-include))
                                           (setf pitches-both-layers (filter-out-both-if-one-is-nil-with-gracenotes pitches-both-layers))
                                           (setf pitches-layer1 (first pitches-both-layers))
                                           (setf pitches-layer2 (second pitches-both-layers))
                                           (setf pitches-both-layers (combine-pitches-2layers pitches-layer1 pitches-layer2)))
                                          ((= (get-layer-nr x) layer2)
                                           (setf pitches-both-layers (get-pitches-for-rhythmcell-and-other-layer-always-include-gracenotes indexx x layer1 nr-of-preceeding-pitches-to-include))
                                           ;(system::pwgl-print pitches-both-layers)
                                           (setf pitches-both-layers (filter-out-both-if-one-is-nil-with-gracenotes pitches-both-layers))
                                           (setf pitches-layer2 (first pitches-both-layers))
                                           (setf pitches-layer1 (second pitches-both-layers))
                                           (setf pitches-both-layers (combine-pitches-2layers pitches-layer1 pitches-layer2))))
                                    ;(system::pwgl-print pitches-layer1)
                                    (if pitches-layer1
                                        (apply '+ (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                                                        collect (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include)))))
                                      0))
                                   (t 0))
                           0)
        )))
;;;;


;;;;
;not used
;(defun get-start-time-at-preceeding-pitch (layernr index cell-starttime nr-of-preceeding-pitches-to-include)
;  (let* ((ordernr (car (get-ordernr-for-onsets-from-vector-at-timepoints 
;                       layernr (list cell-starttime) (get-number-of-rhythms-and-pauses-at-index layernr index))))
;         (startnth (if ordernr (- ordernr nr-of-preceeding-pitches-to-include) -1)))
;    (if (minusp startnth)
;        nil
;      (car (get-onsets-for-pitches layernr index startnth startnth)))
;    ))

;get-timepoints-at-beats-with-endpoint-upto-index



;;;access for metric pitch rules
(defun find-beat-onsets-between-timepoints3 (spanstart spanstop subdiv index nr-of-preceeding-beats-to-include)
  "Gives all beats (from measure) that the timespan covers including the extra beats preceeding the timespan.

Spanstart and spanstop counts from time 1, beat onsets are returned from time 1."
  (let* ((all-beats (get-timepoints-at-beats-with-endpoint-upto-index index)) ;starts from 1
         (position-start (position spanstart all-beats :test '>= :from-end t))
         (stop-position (position spanstop all-beats :test '<=)))
    
    (if position-start
        (let ((start-position-with-pre (if (minusp (- position-start nr-of-preceeding-beats-to-include))
                                           0 (- position-start nr-of-preceeding-beats-to-include))))
          (if (not stop-position) (setf stop-position (1- (length all-beats))))
          (nthcdr start-position-with-pre (before-nth (1+ stop-position) all-beats)))
      nil)))


;(find-beat-onsets-between-timepoints3 3/2 5 1 26 3)


;(get-total-duration-rhythms-at-index 0 (1- 8))
;;;;;from metric-pitch-rule.lisp
(defun get-time-for-rhythm (indexx x)
  (let ((layer (get-layer-nr x)))
  (get-total-duration-rhythms-at-index layer (1- indexx))))

(defun get-time-at-nthpitch (layer index nth)
  (let* ((local-pointer (get-localpointer-at-nthrhythm layer (1- index) nth));1- for index since the rhythm must have existed before
         (time+1 (if local-pointer
                     (aref part-sol-vector layer local-pointer *ONSETTIME*))))
    (if time+1 (1- time+1))))

;(get-number-of-pitches-at-index 0 (1- 8))
;(get-time-at-nthpitch 0 18 4)
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


(defun get-endtime-or-last-at-nthpitch (layer index endnth startnth)
"If endtim does not exist, the last existing time before startnth is returned"
  (let* ((local-pointer (get-localpointer-at-nthrhythm layer (1- index) endnth));1- for index since the rhythm must have existed before
         (time+1 (if local-pointer
                     (abs (aref part-sol-vector layer (1+ local-pointer) *ONSETTIME*)))))
    (if time+1 (1- time+1)
      (let ((number-of-rhythms (get-number-of-rhythms-at-index layer (1- index))))
        (if (> number-of-rhythms (1+ startnth))
            (get-endtime-at-nthpitch layer index (1- number-of-rhythms)))))))

;(get-number-of-pitches-at-index 0 7) 
;(get-endtime-or-last-at-nthpitch 0 8 0 0)
(defun get-endtime-or-last-for-pitch (indexx x)
"If endtim does not exist, the last existing time in pitchcell is returned"
  (let* ((layer (get-layer-nr x))
         (endpitchnr (get-number-of-pitches-at-index layer indexx));gives (1+ nth) pitch for the last pitch in tis cell
         (startpitchnr (get-number-of-pitches-at-index layer (1- indexx))));gives nth pitch for the first pitch in tis cell
    (get-endtime-or-last-at-nthpitch layer indexx (1- endpitchnr) startpitchnr)))

(defun get-starttime (indexx x)
  (cond ((typep x 'rhythmcell)
         (get-time-for-rhythm indexx x))
        ((typep x 'pitchcell)
         (get-time-for-pitch indexx x))
        ((typep x 'timesign)
         (get-total-duration-timesigns-at-index (1- indexx)))))

;;;new from here; december 1 2007
(defun get-stoptime2 (indexx x)
"If stoptime exist INSIDE pitchcell (not last pitch), last existing stoptime will be returned"
  (cond ((typep x 'rhythmcell)
         (get-time-for-rhythm (1+ indexx) x))
        ((typep x 'pitchcell)
         (get-endtime-or-last-for-pitch indexx x))
        ((typep x 'timesign)
         (get-total-duration-timesigns-at-index indexx))))


;(find-beat-onsets-between-timepoints3 1 (- 5/4 1/10000) 1 2 0)
(defun harm-on-beat-rule (highlayernr lowlayernr subdiv testfn) 
  "Checks pitches that exist on beat (not only onsets) in two simultaneous layers.
If no time signature exists, the first beat in the whole sequence will still be checked."
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn)))
    #'(lambda (indexx x)
        (let* ((this-layer-nr (get-layer-nr x))
               (start-this-cell (get-starttime indexx x)) ;1+ to compensate for offset
               (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for offset 
               beat-onsets
               )
          
          (cond ((or (and (or (= this-layer-nr highlayernr) 
                              (= this-layer-nr lowlayernr))
                          start-this-cell)
                     (typep x 'timesign))  ;check that time for pitch event is assigned
                 (setf start-this-cell (1+ start-this-cell)) ;1+ to compensate for offset
                 (setf stop-this-cell (if stop-this-cell (1+ stop-this-cell)
                                        (1+ (get-total-duration-rhythms-at-index this-layer-nr indexx))))

                 ;-1/10000 to stop BEFORE next beat
                 (setf beat-onsets (find-beat-onsets-between-timepoints3 start-this-cell (- stop-this-cell 1/10000) subdiv indexx nr-of-preceeding-pitches-to-include))

                 (let* ((pitches-high-layer (get-pitches-at-timepoints indexx highlayernr beat-onsets)) ;1+ for offset
                        (pitches-low-layer (get-pitches-at-timepoints indexx lowlayernr beat-onsets)) ;1+ for offset
                        (pitches-both-layers (filter-out-both-if-one-is-nil (list pitches-high-layer pitches-low-layer))))
                   (setf pitches-both-layers (reverse (mapcar 'list (first pitches-both-layers) (second pitches-both-layers))))
                   (if (car pitches-both-layers)
                       (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                             do (if (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include))) t (return nil))
                             finally (return t))
                     t)))
                                                
                (t t))))))


(defun harm-on-beat-include-gracenotes-rule (highlayernr lowlayernr subdiv testfn) 
  "Checks pitches that exist on beat (not only onsets) in two simultaneous layers.
If no time signature exists, the first beat in the whole sequence will still be checked."
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn)))
    #'(lambda (indexx x)
        (let* ((this-layer-nr (get-layer-nr x))
               (start-this-cell (get-starttime indexx x)) ;1+ to compensate for offset
               (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for offset 
               beat-onsets
               )
          
          (cond ((or (and (or (= this-layer-nr highlayernr) 
                              (= this-layer-nr lowlayernr))
                          start-this-cell)
                     (typep x 'timesign))  ;check that time for pitch event is assigned
                 (setf start-this-cell (1+ start-this-cell)) ;1+ to compensate for offset
                 (setf stop-this-cell (if stop-this-cell (1+ stop-this-cell)
                                        (1+ (get-total-duration-rhythms-at-index this-layer-nr indexx))))

                 ;-1/10000 to stop BEFORE next beat
                 (setf beat-onsets (find-beat-onsets-between-timepoints3 start-this-cell (- stop-this-cell 1/10000) subdiv indexx nr-of-preceeding-pitches-to-include))
                ; (system::pwgl-print (list beat-onsets subdiv))
 
                 (let* ((pitches-high-layer (get-pitches-at-timepoints-include-gracenotes indexx highlayernr beat-onsets)) ;1+ for offset
                        (pitches-low-layer (get-pitches-at-timepoints-include-gracenotes indexx lowlayernr beat-onsets)) ;1+ for offset
                        (pitches-both-layers (filter-out-both-if-one-is-nil-with-gracenotes (list pitches-high-layer pitches-low-layer))))

                   (setf pitches-both-layers (combine-pitches-2layers (first pitches-both-layers) (second pitches-both-layers))) ;grace-notes compatible
                   (if (car pitches-both-layers)
                       (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                             do (if (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include))) t (return nil))
                             finally (return t))
                     t)))
                                                
                (t t))))))


(defun harm-on-beat-heuristic-rule (highlayernr lowlayernr subdiv testfn) 
  "Checks pitches that exist on beat (not only onsets) in two simultaneous layers."
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn)))
    #'(lambda (indexx x)
        (let* ((this-layer-nr (get-layer-nr x))
               (start-this-cell (get-starttime indexx x)) ;1+ to compensate for offset
               (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for offset 
               beat-onsets
               )
          
          (cond ((or (and (or (= this-layer-nr highlayernr) 
                              (= this-layer-nr lowlayernr))
                          start-this-cell)
                     (typep x 'timesign))  ;check that time for pitch event is assigned
                 (setf start-this-cell (1+ start-this-cell)) ;1+ to compensate for offset
                 (setf stop-this-cell (if stop-this-cell (1+ stop-this-cell)
                                        (1+ (get-total-duration-rhythms-at-index this-layer-nr indexx))))
                 

                 (setf beat-onsets (find-beat-onsets-between-timepoints3 start-this-cell (- stop-this-cell 1/10000) subdiv indexx nr-of-preceeding-pitches-to-include))

                 (let* ((pitches-high-layer (get-pitches-at-timepoints indexx highlayernr beat-onsets)) ;1+ for offset
                        (pitches-low-layer (get-pitches-at-timepoints indexx lowlayernr beat-onsets)) ;1+ for offset
                        (pitches-both-layers (filter-out-both-if-one-is-nil (list pitches-high-layer pitches-low-layer))))
                   (setf pitches-both-layers (reverse (mapcar 'list (first pitches-both-layers) (second pitches-both-layers))))

                   (if (car pitches-both-layers)
                       (apply '+ (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                                       collect (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include)))))
                     0)))
                                                
                (t 0))))))

(defun harm-on-beat-include-gracenotes-heuristic-rule (highlayernr lowlayernr subdiv testfn) 
  "Checks pitches that exist on beat (not only onsets) in two simultaneous layers.
If no time signature exists, the first beat in the whole sequence will still be checked."
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn)))
    #'(lambda (indexx x)
        (let* ((this-layer-nr (get-layer-nr x))
               (start-this-cell (get-starttime indexx x)) ;1+ to compensate for offset
               (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for offset 
               beat-onsets
               )
          
          (cond ((or (and (or (= this-layer-nr highlayernr) 
                              (= this-layer-nr lowlayernr))
                          start-this-cell)
                     (typep x 'timesign))  ;check that time for pitch event is assigned
                 (setf start-this-cell (1+ start-this-cell)) ;1+ to compensate for offset
                 (setf stop-this-cell (if stop-this-cell (1+ stop-this-cell)
                                        (1+ (get-total-duration-rhythms-at-index this-layer-nr indexx))))

                 ;-1/10000 to stop BEFORE next beat
                 (setf beat-onsets (find-beat-onsets-between-timepoints3 start-this-cell (- stop-this-cell 1/10000) subdiv indexx nr-of-preceeding-pitches-to-include))

                 (let* ((pitches-high-layer (get-pitches-at-timepoints-include-gracenotes indexx highlayernr beat-onsets)) ;1+ for offset
                        (pitches-low-layer (get-pitches-at-timepoints-include-gracenotes indexx lowlayernr beat-onsets)) ;1+ for offset
                        (pitches-both-layers (filter-out-both-if-one-is-nil-with-gracenotes (list pitches-high-layer pitches-low-layer))))

                   (setf pitches-both-layers (combine-pitches-2layers (first pitches-both-layers) (second pitches-both-layers))) ;grace-notes compatible
                   (if (car pitches-both-layers)
                       (apply '+ (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                                       collect (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include)))))
                     0)))
                                                
                (t 0))))))


;;;;Access for homophony rules
;(intersection '(1 2 3 5 6 ) '(1 3 4 5 6))
;(position 5 '(1 2 3 5 7) :from-end t :test '>=)
;(strip-selection '(0 1 20 30 41 51 6 7) 3 3) 


(defun bandpass-filter-with-preceeding-elements (list startvalue stopvalue nr-of-preceedinf-elements)
  (if list
      (let* ((startvalue-nth (position startvalue list :test '<=))
             (startnth (if startvalue-nth (- startvalue-nth nr-of-preceedinf-elements) -1))
             (stopvalue-nth (position stopvalue list :from-end t :test '>=)))
        (if (minusp startnth) (setf startnth 0))
        (strip-selection list startnth stopvalue-nth)
        )
    nil))
;(bandpass-filter-with-preceeding-elements '(1 2 3 4 5 6) 2.2 4 0)
;(filter-out-both-if-one-is-nil '(((nil)(nil))((nil)(nil))))
;(reverse (mapcar 'list nil nil))
;(intersection '(1  5/4 11/8) '(1 9/8 19/16 5/4))

(defun homophony-harm-rule (highlayernr lowlayernr testfn) 
  "Checks pitches that exist on homophonic rhyhtms (i.e. has simutaneous onsets) in two simultaneous layers."
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn)))
    #'(lambda (indexx x)
        (let* ((this-layer-nr (get-layer-nr x))
               (start-this-cell (get-starttime indexx x)) ;1+ to compensate for offset
               (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for offset 
               )
          
          (cond ((and (or (= this-layer-nr highlayernr) 
                          (= this-layer-nr lowlayernr))
                      start-this-cell)  ;check that time for pitch event is assigned
                 (setf start-this-cell (1+ start-this-cell)) ;1+ to compensate for offset
                 (setf stop-this-cell (if stop-this-cell (1+ stop-this-cell)
                                        (1+ (get-total-duration-rhythms-at-index this-layer-nr indexx))))
                

                 (let* ((onsets-high-layer (get-one-rhythmlayer-at-index highlayernr indexx))
                        (onsets-low-layer (get-one-rhythmlayer-at-index lowlayernr indexx))
                        (onsets-in-common (sort (intersection onsets-high-layer onsets-low-layer) '<));intersection gives often the reverse order, but not always!
                        (filtered-onsets-in-common (bandpass-filter-with-preceeding-elements onsets-in-common start-this-cell stop-this-cell nr-of-preceeding-pitches-to-include))
                        (pitches-high-layer (get-pitches-at-timepoints indexx highlayernr filtered-onsets-in-common))
                        (pitches-low-layer (get-pitches-at-timepoints indexx lowlayernr filtered-onsets-in-common))
                        (pitches-both-layers (filter-out-both-if-one-is-nil (list pitches-high-layer pitches-low-layer))))

                   (setf pitches-both-layers (reverse (mapcar 'list (first pitches-both-layers) (second pitches-both-layers))))
                  
                   (if (car pitches-both-layers)
                       (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                             do (if (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include))) t (return nil))
                             finally (return t))
                     t)))
                                                
                (t t))))))


(defun homophony-harm-include-gracenotes-rule (highlayernr lowlayernr testfn) 
  "Checks pitches that exist on homophonic rhyhtms (i.e. has simutaneous onsets) in two simultaneous layers."
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn)))
    #'(lambda (indexx x)
        (let* ((this-layer-nr (get-layer-nr x))
               (start-this-cell (get-starttime indexx x)) ;1+ to compensate for offset
               (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for offset 
               )
          
          (cond ((and (or (= this-layer-nr highlayernr) 
                          (= this-layer-nr lowlayernr))
                      start-this-cell)  ;check that time for pitch event is assigned
                 (setf start-this-cell (1+ start-this-cell)) ;1+ to compensate for offset
                 (setf stop-this-cell (if stop-this-cell (1+ stop-this-cell)
                                        (1+ (get-total-duration-rhythms-at-index this-layer-nr indexx))))
                

                 (let* ((onsets-high-layer (get-one-rhythmlayer-at-index highlayernr indexx))
                        (onsets-low-layer (get-one-rhythmlayer-at-index lowlayernr indexx))
                        (onsets-in-common (sort (intersection onsets-high-layer onsets-low-layer) '<));intersection gives often the reverse order, but not always!
                        (filtered-onsets-in-common (bandpass-filter-with-preceeding-elements onsets-in-common start-this-cell stop-this-cell nr-of-preceeding-pitches-to-include))
                        (pitches-high-layer (get-pitches-at-timepoints-include-gracenotes indexx highlayernr filtered-onsets-in-common))
                        (pitches-low-layer (get-pitches-at-timepoints-include-gracenotes indexx lowlayernr filtered-onsets-in-common))
                        (pitches-both-layers (filter-out-both-if-one-is-nil-with-gracenotes (list pitches-high-layer pitches-low-layer))))

                   (setf pitches-both-layers (combine-pitches-2layers (first pitches-both-layers) (second pitches-both-layers)))
                  
                   (if (car pitches-both-layers)
                       (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                             do (if (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include))) t (return nil))
                             finally (return t))
                     t)))
                                                
                (t t))))))
;(bandpass-filter-with-preceeding-elements nil 1 9/8 0)

(defun homophony-harm-heuristic-rule (highlayernr lowlayernr testfn) 
  "Checks pitches that exist on homophonic rhyhtms (i.e. has simutaneous onsets) in two simultaneous layers."
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn)))
    #'(lambda (indexx x)
        (let* ((this-layer-nr (get-layer-nr x))
               (start-this-cell (get-starttime indexx x)) ;1+ to compensate for offset
               (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for offset 
               )
          
          (cond ((and (or (= this-layer-nr highlayernr) 
                          (= this-layer-nr lowlayernr))
                      start-this-cell)  ;check that time for pitch event is assigned
                 (setf start-this-cell (1+ start-this-cell)) ;1+ to compensate for offset
                 (setf stop-this-cell (if stop-this-cell (1+ stop-this-cell)
                                        (1+ (get-total-duration-rhythms-at-index this-layer-nr indexx))))

                
                 (let* ((onsets-high-layer (get-one-rhythmlayer-at-index highlayernr indexx))
                        (onsets-low-layer (get-one-rhythmlayer-at-index lowlayernr indexx))
                        (onsets-in-common (sort (intersection onsets-high-layer onsets-low-layer) '<));intersection gives often the reverse order, but not always!
                        (filtered-onsets-in-common (bandpass-filter-with-preceeding-elements onsets-in-common start-this-cell stop-this-cell nr-of-preceeding-pitches-to-include))
                        (pitches-high-layer (get-pitches-at-timepoints indexx highlayernr filtered-onsets-in-common))
                        (pitches-low-layer (get-pitches-at-timepoints indexx lowlayernr filtered-onsets-in-common))
                        (pitches-both-layers (filter-out-both-if-one-is-nil (list pitches-high-layer pitches-low-layer))))
                   (setf pitches-both-layers (reverse (mapcar 'list (first pitches-both-layers) (second pitches-both-layers))))
                   
                   (if (car pitches-both-layers)
                       (apply '+ (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                                       collect (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include)))))
                     0)))
                                                
                (t 0))))))

(defun homophony-harm-include-gracenotes-heuristic-rule (highlayernr lowlayernr testfn) 
  "Checks pitches that exist on homophonic rhyhtms (i.e. has simutaneous onsets) in two simultaneous layers."
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn)))
    #'(lambda (indexx x)
        (let* ((this-layer-nr (get-layer-nr x))
               (start-this-cell (get-starttime indexx x)) ;1+ to compensate for offset
               (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for offset 
               )
          
          (cond ((and (or (= this-layer-nr highlayernr) 
                          (= this-layer-nr lowlayernr))
                      start-this-cell)  ;check that time for pitch event is assigned
                 (setf start-this-cell (1+ start-this-cell)) ;1+ to compensate for offset
                 (setf stop-this-cell (if stop-this-cell (1+ stop-this-cell)
                                        (1+ (get-total-duration-rhythms-at-index this-layer-nr indexx))))
                

                 (let* ((onsets-high-layer (get-one-rhythmlayer-at-index highlayernr indexx))
                        (onsets-low-layer (get-one-rhythmlayer-at-index lowlayernr indexx))
                        (onsets-in-common (sort (intersection onsets-high-layer onsets-low-layer) '<));intersection gives often the reverse order, but not always!
                        (filtered-onsets-in-common (bandpass-filter-with-preceeding-elements onsets-in-common start-this-cell stop-this-cell nr-of-preceeding-pitches-to-include))
                        (pitches-high-layer (get-pitches-at-timepoints-include-gracenotes indexx highlayernr filtered-onsets-in-common))
                        (pitches-low-layer (get-pitches-at-timepoints-include-gracenotes indexx lowlayernr filtered-onsets-in-common))
                        (pitches-both-layers (filter-out-both-if-one-is-nil-with-gracenotes (list pitches-high-layer pitches-low-layer))))

                   (setf pitches-both-layers (combine-pitches-2layers (first pitches-both-layers) (second pitches-both-layers)))
                  
                   (if (car pitches-both-layers)
                       (apply '+ (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                                       collect (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include)))))
                     0)))
                                                
                (t 0))))))

;(get-pitches-at-timepoints 13 1 '(1 3))
;(defun test (pree-pitch)
;  #'(lambda (indexx x) (get-pitches-for-rhythmcell-and-other-layer-always indexx x 1 pree-pitch)))

(defun harm-onset-on-beat-rule (highlayernr lowlayernr subdiv testfn) 
  "Checks pitches that has an onset on a beat in two simultaneous layers.
If no time signature exists, the first beat in the whole sequence will still be checked."
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn)))
    #'(lambda (indexx x)
        (let* ((this-layer-nr (get-layer-nr x))
               (start-this-cell (get-starttime indexx x)) ;1+ to compensate for offset
               (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for offset 
               beat-onsets
               )
          
          (cond ((or (and (or (= this-layer-nr highlayernr) 
                              (= this-layer-nr lowlayernr))
                          start-this-cell)
                     (typep x 'timesign))  ;check that time for pitch event is assigned
                 (setf start-this-cell (1+ start-this-cell)) ;1+ to compensate for offset
                 (setf stop-this-cell (if stop-this-cell (1+ stop-this-cell)  ;1+ to compensate for offset
                                        (1+ (get-total-duration-rhythms-at-index this-layer-nr indexx))))  ;1+ to compensate for offset

                 ;-1/10000 to stop BEFORE next beat
                 (setf beat-onsets (find-beat-onsets-between-timepoints3 start-this-cell (- stop-this-cell 1/10000) subdiv indexx nr-of-preceeding-pitches-to-include))

                 (let* ((onsets-high-layer (get-one-rhythmlayer-at-index highlayernr indexx))
                        (onsets-low-layer (get-one-rhythmlayer-at-index lowlayernr indexx))
                        (all-onsets-both-layers (append onsets-high-layer onsets-low-layer))
                        (onsets-on-beats (remove-duplicates (sort (intersection all-onsets-both-layers beat-onsets) '<)))
                        (pitches-high-layer (get-pitches-at-timepoints indexx highlayernr onsets-on-beats))
                        (pitches-low-layer (get-pitches-at-timepoints indexx lowlayernr onsets-on-beats))
                        (pitches-both-layers (filter-out-both-if-one-is-nil (list pitches-high-layer pitches-low-layer))))
                   (setf pitches-both-layers (reverse (mapcar 'list (first pitches-both-layers) (second pitches-both-layers))))
                   
                   (if (car pitches-both-layers)
                       (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                             do (if (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include))) t (return nil))
                             finally (return t))
                     t)))
                                                
                (t t))))))


(defun harm-onset-on-beat-include-gracenotes-rule (highlayernr lowlayernr subdiv testfn) 
  "Checks pitches that has an onset on a beat in two simultaneous layers.
If no time signature exists, the first beat in the whole sequence will still be checked."
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn)))
    #'(lambda (indexx x)
        (let* ((this-layer-nr (get-layer-nr x))
               (start-this-cell (get-starttime indexx x)) ;1+ to compensate for offset
               (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for offset 
               beat-onsets
               )
          
          (cond ((or (and (or (= this-layer-nr highlayernr) 
                              (= this-layer-nr lowlayernr))
                          start-this-cell)
                     (typep x 'timesign))  ;check that time for pitch event is assigned
                 (setf start-this-cell (1+ start-this-cell)) ;1+ to compensate for offset
                 (setf stop-this-cell (if stop-this-cell (1+ stop-this-cell)  ;1+ to compensate for offset
                                        (1+ (get-total-duration-rhythms-at-index this-layer-nr indexx))))  ;1+ to compensate for offset

                 ;-1/10000 to stop BEFORE next beat
                 (setf beat-onsets (find-beat-onsets-between-timepoints3 start-this-cell (- stop-this-cell 1/10000) subdiv indexx nr-of-preceeding-pitches-to-include))

                 (let* ((onsets-high-layer (get-one-rhythmlayer-at-index highlayernr indexx))
                        (onsets-low-layer (get-one-rhythmlayer-at-index lowlayernr indexx))
                        (all-onsets-both-layers (append onsets-high-layer onsets-low-layer))
                        (onsets-on-beats (remove-duplicates (sort (intersection all-onsets-both-layers beat-onsets) '<)))
                        (pitches-high-layer (get-pitches-at-timepoints-include-gracenotes indexx highlayernr onsets-on-beats))
                        (pitches-low-layer (get-pitches-at-timepoints-include-gracenotes indexx lowlayernr onsets-on-beats))
                        (pitches-both-layers (filter-out-both-if-one-is-nil-with-gracenotes (list pitches-high-layer pitches-low-layer))))
                   (setf pitches-both-layers (combine-pitches-2layers (first pitches-both-layers) (second pitches-both-layers)))
                   
                   (if (car pitches-both-layers)
                       (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                             do (if (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include))) t (return nil))
                             finally (return t))
                     t)))
                                                
                (t t))))))


(defun harm-onset-on-beat-heuristic-rule (highlayernr lowlayernr subdiv testfn) 
  "Checks pitches that has an onset on a beat in two simultaneous layers.
If no time signature exists, the first beat in the whole sequence will still be checked."
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn)))
    #'(lambda (indexx x)
        (let* ((this-layer-nr (get-layer-nr x))
               (start-this-cell (get-starttime indexx x)) ;1+ to compensate for offset
               (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for offset 
               beat-onsets
               )
          
          (cond ((or (and (or (= this-layer-nr highlayernr) 
                              (= this-layer-nr lowlayernr))
                          start-this-cell)
                     (typep x 'timesign))  ;check that time for pitch event is assigned
                 (setf start-this-cell (1+ start-this-cell)) ;1+ to compensate for offset
                 (setf stop-this-cell (if stop-this-cell (1+ stop-this-cell)  ;1+ to compensate for offset
                                        (1+ (get-total-duration-rhythms-at-index this-layer-nr indexx))))  ;1+ to compensate for offset

                 ;-1/10000 to stop BEFORE next beat
                 (setf beat-onsets (find-beat-onsets-between-timepoints3 start-this-cell (- stop-this-cell 1/10000) subdiv indexx nr-of-preceeding-pitches-to-include))

                 (let* ((onsets-high-layer (get-one-rhythmlayer-at-index highlayernr indexx))
                        (onsets-low-layer (get-one-rhythmlayer-at-index lowlayernr indexx))
                        (all-onsets-both-layers (append onsets-high-layer onsets-low-layer))
                        (onsets-on-beats (remove-duplicates (sort (intersection all-onsets-both-layers beat-onsets) '<)))
                        (pitches-high-layer (get-pitches-at-timepoints indexx highlayernr onsets-on-beats))
                        (pitches-low-layer (get-pitches-at-timepoints indexx lowlayernr onsets-on-beats))
                        (pitches-both-layers (filter-out-both-if-one-is-nil (list pitches-high-layer pitches-low-layer))))
                   (setf pitches-both-layers (reverse (mapcar 'list (first pitches-both-layers) (second pitches-both-layers))))
                   
                   (if (car pitches-both-layers)
                       (apply '+ (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                                       collect (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include)))))
                     0)))
                                                
                (t 0))))))

(defun harm-onset-on-beat-include-gracenotes-heuristic-rule (highlayernr lowlayernr subdiv testfn) 
  "Checks pitches that has an onset on a beat in two simultaneous layers.
If no time signature exists, the first beat in the whole sequence will still be checked."
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn)))
    #'(lambda (indexx x)
        (let* ((this-layer-nr (get-layer-nr x))
               (start-this-cell (get-starttime indexx x)) ;1+ to compensate for offset
               (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for offset 
               beat-onsets
               )
          
          (cond ((or (and (or (= this-layer-nr highlayernr) 
                              (= this-layer-nr lowlayernr))
                          start-this-cell)
                     (typep x 'timesign))  ;check that time for pitch event is assigned
                 (setf start-this-cell (1+ start-this-cell)) ;1+ to compensate for offset
                 (setf stop-this-cell (if stop-this-cell (1+ stop-this-cell)  ;1+ to compensate for offset
                                        (1+ (get-total-duration-rhythms-at-index this-layer-nr indexx))))  ;1+ to compensate for offset

                 ;-1/10000 to stop BEFORE next beat
                 (setf beat-onsets (find-beat-onsets-between-timepoints3 start-this-cell (- stop-this-cell 1/10000) subdiv indexx nr-of-preceeding-pitches-to-include))

                 (let* ((onsets-high-layer (get-one-rhythmlayer-at-index highlayernr indexx))
                        (onsets-low-layer (get-one-rhythmlayer-at-index lowlayernr indexx))
                        (all-onsets-both-layers (append onsets-high-layer onsets-low-layer))
                        (onsets-on-beats (remove-duplicates (sort (intersection all-onsets-both-layers beat-onsets) '<)))
                        (pitches-high-layer (get-pitches-at-timepoints-include-gracenotes indexx highlayernr onsets-on-beats))
                        (pitches-low-layer (get-pitches-at-timepoints-include-gracenotes indexx lowlayernr onsets-on-beats))
                        (pitches-both-layers (filter-out-both-if-one-is-nil-with-gracenotes (list pitches-high-layer pitches-low-layer))))
                   (setf pitches-both-layers (combine-pitches-2layers (first pitches-both-layers) (second pitches-both-layers)))
                   
                   (if (car pitches-both-layers)
                       (apply '+ (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                                       collect (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include)))))
                     0)))
                                                
                (t 0))))))
;;;;
;

(defun 1st-voice-onsets-harm-rule (highlayernr lowlayernr testfn) 
  "Checks pitches that exist on homophonic rhyhtms (i.e. has simutaneous onsets) in two simultaneous layers."
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn)))
    #'(lambda (indexx x)
        (let* ((this-layer-nr (get-layer-nr x))
               (start-this-cell (get-starttime indexx x)) ;1+ to compensate for offset
               (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for offset 
               )
          
          (cond ((and (or (= this-layer-nr highlayernr) 
                          (= this-layer-nr lowlayernr))
                      start-this-cell)  ;check that time for pitch event is assigned
                 (setf start-this-cell (1+ start-this-cell)) ;1+ to compensate for offset
                 (setf stop-this-cell (if stop-this-cell (1+ stop-this-cell)
                                        (1+ (get-total-duration-rhythms-at-index this-layer-nr indexx))))
                
                 (let* ((onsets-high-layer (get-one-rhythmlayer-at-index highlayernr indexx))
                        (filtered-onsets (bandpass-filter-with-preceeding-elements onsets-high-layer start-this-cell stop-this-cell nr-of-preceeding-pitches-to-include))
                        (pitches-high-layer (get-pitches-at-timepoints indexx highlayernr filtered-onsets))
                        (pitches-low-layer (get-pitches-at-timepoints indexx lowlayernr filtered-onsets))
                        (pitches-both-layers (filter-out-both-if-one-is-nil (list pitches-high-layer pitches-low-layer))))
                   (setf pitches-both-layers (reverse (mapcar 'list (first pitches-both-layers) (second pitches-both-layers))))
                   
                   (if (car pitches-both-layers)
                       (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                             do (if (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include))) t (return nil))
                             finally (return t))
                     t)))
                                                
                (t t))))))


(defun 1st-voice-onsets-harm-include-gracenotes-rule (highlayernr lowlayernr testfn) 
  "Checks pitches that exist on homophonic rhyhtms (i.e. has simutaneous onsets) in two simultaneous layers."
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn)))
    #'(lambda (indexx x)
        (let* ((this-layer-nr (get-layer-nr x))
               (start-this-cell (get-starttime indexx x)) ;1+ to compensate for offset
               (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for offset 
               )
          
          (cond ((and (or (= this-layer-nr highlayernr) 
                          (= this-layer-nr lowlayernr))
                      start-this-cell)  ;check that time for pitch event is assigned
                 (setf start-this-cell (1+ start-this-cell)) ;1+ to compensate for offset
                 (setf stop-this-cell (if stop-this-cell (1+ stop-this-cell)
                                        (1+ (get-total-duration-rhythms-at-index this-layer-nr indexx))))
                
                 (let* ((onsets-high-layer (get-one-rhythmlayer-at-index highlayernr indexx))
                        (filtered-onsets (bandpass-filter-with-preceeding-elements onsets-high-layer start-this-cell stop-this-cell nr-of-preceeding-pitches-to-include))
                        (pitches-high-layer (get-pitches-at-timepoints-include-gracenotes indexx highlayernr filtered-onsets))
                        (pitches-low-layer (get-pitches-at-timepoints-include-gracenotes indexx lowlayernr filtered-onsets))
                        (pitches-both-layers (filter-out-both-if-one-is-nil-with-gracenotes (list pitches-high-layer pitches-low-layer))))
                   (setf pitches-both-layers (combine-pitches-2layers (first pitches-both-layers) (second pitches-both-layers)))
                   
                   (if (car pitches-both-layers)
                       (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                             do (if (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include))) t (return nil))
                             finally (return t))
                     t)))
                                                
                (t t))))))



(defun 1st-voice-onsets-harm-heuristic-rule (highlayernr lowlayernr testfn) 
  "Checks pitches that exist on homophonic rhyhtms (i.e. has simutaneous onsets) in two simultaneous layers."
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn)))
    #'(lambda (indexx x)
        (let* ((this-layer-nr (get-layer-nr x))
               (start-this-cell (get-starttime indexx x)) ;1+ to compensate for offset
               (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for offset 
               )
          
          (cond ((and (or (= this-layer-nr highlayernr) 
                          (= this-layer-nr lowlayernr))
                      start-this-cell)  ;check that time for pitch event is assigned
                 (setf start-this-cell (1+ start-this-cell)) ;1+ to compensate for offset
                 (setf stop-this-cell (if stop-this-cell (1+ stop-this-cell)
                                        (1+ (get-total-duration-rhythms-at-index this-layer-nr indexx))))
                
                 (let* ((onsets-high-layer (get-one-rhythmlayer-at-index highlayernr indexx))
                        (filtered-onsets (bandpass-filter-with-preceeding-elements onsets-high-layer start-this-cell stop-this-cell nr-of-preceeding-pitches-to-include))
                        (pitches-high-layer (get-pitches-at-timepoints indexx highlayernr filtered-onsets))
                        (pitches-low-layer (get-pitches-at-timepoints indexx lowlayernr filtered-onsets))
                        (pitches-both-layers (filter-out-both-if-one-is-nil (list pitches-high-layer pitches-low-layer))))
                   (setf pitches-both-layers (reverse (mapcar 'list (first pitches-both-layers) (second pitches-both-layers))))
                   
                   (if (car pitches-both-layers)
                       (apply '+ (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                                       collect (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include)))))
                     0)))
                                                
                (t 0))))))


(defun 1st-voice-onsets-harm-include-gracenotes-heuristic-rule (highlayernr lowlayernr testfn) 
  "Checks pitches that exist on homophonic rhyhtms (i.e. has simutaneous onsets) in two simultaneous layers."
  (let* ((nr-of-variables-in-fn (length (system::arglist testfn)))
         (nr-of-preceeding-pitches-to-include (1- nr-of-variables-in-fn)))
    #'(lambda (indexx x)
        (let* ((this-layer-nr (get-layer-nr x))
               (start-this-cell (get-starttime indexx x)) ;1+ to compensate for offset
               (stop-this-cell (get-stoptime2 indexx x)) ;1+ to compensate for offset 
               )
          
          (cond ((and (or (= this-layer-nr highlayernr) 
                          (= this-layer-nr lowlayernr))
                      start-this-cell)  ;check that time for pitch event is assigned
                 (setf start-this-cell (1+ start-this-cell)) ;1+ to compensate for offset
                 (setf stop-this-cell (if stop-this-cell (1+ stop-this-cell)
                                        (1+ (get-total-duration-rhythms-at-index this-layer-nr indexx))))
                
                 (let* ((onsets-high-layer (get-one-rhythmlayer-at-index highlayernr indexx))
                        (filtered-onsets (bandpass-filter-with-preceeding-elements onsets-high-layer start-this-cell stop-this-cell nr-of-preceeding-pitches-to-include))
                        (pitches-high-layer (get-pitches-at-timepoints-include-gracenotes indexx highlayernr filtered-onsets))
                        (pitches-low-layer (get-pitches-at-timepoints-include-gracenotes indexx lowlayernr filtered-onsets))
                        (pitches-both-layers (filter-out-both-if-one-is-nil-with-gracenotes (list pitches-high-layer pitches-low-layer))))
                   (setf pitches-both-layers (combine-pitches-2layers (first pitches-both-layers) (second pitches-both-layers)))
                   
                   (if (car pitches-both-layers)
                       (apply '+ (loop for n from 0 to (- (length pitches-both-layers) nr-of-variables-in-fn) 
                                       collect (apply testfn (strip-selection pitches-both-layers n (+ n nr-of-preceeding-pitches-to-include)))))
                     0)))
                                                
                (t 0))))))