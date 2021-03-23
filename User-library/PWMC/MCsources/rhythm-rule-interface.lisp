(in-package MC)

(defun get-durations-between-nths-when-all-exist (layer index startnth stopnth)
  "This function does NOT check if length is beyond the limit of the vector!!"
      (get-durations-from-vector layer (1+ startnth) (+ stopnth 2)))

(defun format-rhythm-rule (rhythmfn layers)
  (let* ((nr-of-variables-in-fn (length (system::arglist rhythmfn))))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'rhythmcell))
                                             (let* ((number-of-events-in-cell (length (get-rhythmcell x)))
                                                    (number-of-rhythms-and-pauses-in-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                    (nr-of-possible-loops (1+ (- number-of-rhythms-and-pauses-in-layer nr-of-variables-in-fn))))
                                               
                                               (if (< 0 nr-of-possible-loops) 
                                                   (if (<= number-of-events-in-cell nr-of-possible-loops)
                                                       (eval (append '(and) (loop for n from 1 to number-of-events-in-cell
                                                                                  collect (if (apply rhythmfn (get-durations-between-nths-when-all-exist 
                                                                                                               layer indexx 
                                                                                                               (- number-of-rhythms-and-pauses-in-layer n 
                                                                                                                  (1- nr-of-variables-in-fn)) 
                                                                                                               (- number-of-rhythms-and-pauses-in-layer n)))
                                                                                              t))))
                                                     (eval (append '(and) (loop for n from 1 to nr-of-possible-loops
                                                                                collect (if (apply rhythmfn (get-durations-between-nths-when-all-exist 
                                                                                                             layer indexx 
                                                                                                             (- number-of-rhythms-and-pauses-in-layer n 
                                                                                                                (1- nr-of-variables-in-fn)) 
                                                                                                             (- number-of-rhythms-and-pauses-in-layer n)))
                                                                                            t)))))
                                                 t))
                                           t))))))


(defun get-durations-between-nths-add-nil-for-not-assigned (layer index startnth stopnth)
  (let ((tot-length (get-number-of-rhythms-and-pauses-at-index layer index)))
    (if (< startnth  0)
        (append (make-list (- startnth)) (get-durations-from-vector layer 1 (+ stopnth 2)))
      (get-durations-from-vector layer (1+ startnth) (+ stopnth 2)))))


(defun format-rhythm-rule-include-nil (rhythmfn layers)
  (let* ((nr-of-variables-in-fn (length (system::arglist rhythmfn))))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'rhythmcell))
                                             (let* ((number-of-events-in-cell (length (get-rhythmcell x)))
                                                    (number-of-rhythms-and-pauses-in-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                    )
                                               
                                               (eval (append '(and) (loop for n from 1 to number-of-events-in-cell
                                                                          collect (if (apply rhythmfn
                                                                                             (get-durations-between-nths-add-nil-for-not-assigned  
                                                                                              layer indexx 
                                                                                              (- number-of-rhythms-and-pauses-in-layer n 
                                                                                                 (1- nr-of-variables-in-fn)) 
                                                                                              (- number-of-rhythms-and-pauses-in-layer n)))
                                                                                      t)))))
                                           t))))))


;;;new
(defun format-rhythm-rule-list-all-rhythms (rhythmfn layers)
  (let* ((nr-of-variables-in-fn (length (system::arglist rhythmfn))))
    (if (/= nr-of-variables-in-fn 1) (error "PWMC error in access-rhythm: In the list-all-rhythms mode the rhythm rule expects only one input to the rule (a list of all rhythms is passed to the rule)."))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'rhythmcell))
                                             (let* ((number-of-events-in-cell (length (get-rhythmcell x)))
                                                    (number-of-rhythms-and-pauses-in-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                    (nr-of-possible-loops number-of-rhythms-and-pauses-in-layer))
                                               
                                               (if (< 0 nr-of-possible-loops) 
                                                   (if (<= number-of-events-in-cell nr-of-possible-loops)
                                                       (eval (append '(and) (loop for n from 1 to number-of-events-in-cell
                                                                                  collect (if (apply rhythmfn (list (get-durations-between-nths-when-all-exist 
                                                                                                                     layer indexx 
                                                                                                                     0 
                                                                                                                     (- number-of-rhythms-and-pauses-in-layer n))))
                                                                                              t))))
                                                     (eval (append '(and) (loop for n from 1 to nr-of-possible-loops
                                                                                collect (if (apply rhythmfn (list (get-durations-between-nths-when-all-exist 
                                                                                                                   layer indexx 
                                                                                                                   0 
                                                                                                                   (- number-of-rhythms-and-pauses-in-layer n))))
                                                                                            t)))))
                                                 t))
                                           t))))))







(defun get-durations-upto-this-including-this-add-nil-for-not-assigned (layer index length)
  (let ((tot-length (get-number-of-rhythms-and-pauses-at-index layer index)))
    (if (> length tot-length)
        (append (make-list (- length tot-length)) (get-durations-from-vector layer 1 (1+ tot-length)))
      (get-durations-from-vector layer (1+ (- tot-length length)) (1+ tot-length)))))



(defun get-durations-upto-this-including-this-if-all-exist (layer index length)
  "This function does NOT check if length is beyond the limit of the vector!!"
  (let ((tot-length (get-number-of-rhythms-and-pauses-at-index layer index)))
    (get-durations-from-vector layer (1+ (- tot-length length)) (1+ tot-length))))


;;;
;get-n-last-rhythmcells (layer index nn)

(defun format-rhythmcell-rule (rhythmfn layers)
  (let* ((nr-of-variables-in-fn (length (system::arglist rhythmfn))))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'rhythmcell))
                                             (let* ((rhythmcells (get-n-last-rhythmcells layer indexx nr-of-variables-in-fn))
                                                    (number-of-rhythmcells-available (length rhythmcells)))
                                               (if (= number-of-rhythmcells-available nr-of-variables-in-fn)
                                                   (if (apply rhythmfn rhythmcells)
                                                       t)
                                                 t))
                                           t))))))

(defun format-heuristic-rhythmcell-rule (rhythmfn layers)
  (let* ((nr-of-variables-in-fn (length (system::arglist rhythmfn))))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'rhythmcell))
                                             (let* ((rhythmcells (get-n-last-rhythmcells layer indexx nr-of-variables-in-fn))
                                                    (number-of-rhythmcells-available (length rhythmcells)))
                                               (if (= number-of-rhythmcells-available nr-of-variables-in-fn)
                                                   (apply rhythmfn rhythmcells)
                                                 0))
                                           0))))))
