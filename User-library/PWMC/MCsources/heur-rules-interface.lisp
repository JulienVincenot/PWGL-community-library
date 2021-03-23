(in-package MC)

(defun format-heuristic-pitch-rule (pitchfn layers)
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
                                                       (apply '+ (loop for n from 1 to number-of-events-in-cell
                                                                       collect (apply pitchfn (get-pitches-between-nths-when-all-exist 
                                                                                               layer indexx 
                                                                                               (- number-of-pitches-in-layer n 
                                                                                                  (1- nr-of-variables-in-fn)) 
                                                                                               (- number-of-pitches-in-layer n)))))
                                                     (apply '+ (loop for n from 1 to nr-of-possible-loops
                                                                     collect (apply pitchfn (get-pitches-between-nths-when-all-exist 
                                                                                             layer indexx 
                                                                                             (- number-of-pitches-in-layer n 
                                                                                                (1- nr-of-variables-in-fn)) 
                                                                                             (- number-of-pitches-in-layer n))))))
                                                 0))
                                           0))))))


(defun format-heuristic-pitch-rule-list-all-pitches (pitchfn layers)
  "this rule gives the testfunction a list of ALL pitches that exist in a layer."
  (let* ((nr-of-variables-in-fn (length (system::arglist pitchfn))))
    (if (/= nr-of-variables-in-fn 1) (error "PWMC error: The melodic rule expects only one input to the rule (a list of all picthes is passed to the rule)."))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                                             (let* ((number-of-events-in-cell (get-nr-of-events x))
                                                    (number-of-pitches-in-layer (get-number-of-pitches-at-index layer indexx))
                                                    (nr-of-possible-loops (1+ (- number-of-pitches-in-layer nr-of-variables-in-fn))))
                                               
                                               (if (< 0 nr-of-possible-loops) 
                                                   (if (<= number-of-events-in-cell nr-of-possible-loops)
                                                       (apply '+ (loop for n from 1 to number-of-events-in-cell
                                                                       collect (apply pitchfn (list (get-pitches-between-nths-when-all-exist 
                                                                                                     layer indexx 
                                                                                                     0 
                                                                                                     (- number-of-pitches-in-layer n))))
                                                                       ))
                                                     (apply '+ (loop for n from 1 to nr-of-possible-loops
                                                                     collect (apply pitchfn (list (get-pitches-between-nths-when-all-exist 
                                                                                                   layer indexx 
                                                                                                   0 
                                                                                                   (- number-of-pitches-in-layer n))))
                                                                     )))
                                                 0))
                                           0))))))



(defun format-heuristic-rhythm-rule (rhythmfn layers)
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
                                                       (apply '+ (loop for n from 1 to number-of-events-in-cell
                                                                       collect (apply rhythmfn (get-durations-between-nths-when-all-exist 
                                                                                                layer indexx 
                                                                                                (- number-of-rhythms-and-pauses-in-layer n 
                                                                                                   (1- nr-of-variables-in-fn)) 
                                                                                                (- number-of-rhythms-and-pauses-in-layer n)))
                                                                       ))
                                                     (apply '+ (loop for n from 1 to nr-of-possible-loops
                                                                     collect (apply rhythmfn (get-durations-between-nths-when-all-exist 
                                                                                              layer indexx 
                                                                                              (- number-of-rhythms-and-pauses-in-layer n 
                                                                                                 (1- nr-of-variables-in-fn)) 
                                                                                              (- number-of-rhythms-and-pauses-in-layer n)))
                                                                     )))
                                                 0))
                                           0))))))



(defun format-heuristic-rhythm-rule-list-all-rhythms (rhythmfn layers)
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
                                                       (apply '+ (loop for n from 1 to number-of-events-in-cell
                                                                       collect (apply rhythmfn (list (get-durations-between-nths-when-all-exist 
                                                                                                      layer indexx 
                                                                                                      0 
                                                                                                      (- number-of-rhythms-and-pauses-in-layer n))))
                                                                       ))
                                                     (apply '+ (loop for n from 1 to nr-of-possible-loops
                                                                     collect (apply rhythmfn (list (get-durations-between-nths-when-all-exist 
                                                                                                    layer indexx 
                                                                                                    0 
                                                                                                    (- number-of-rhythms-and-pauses-in-layer n))))
                                                                     )))
                                                 0))
                                           0))))))




(defun format-heuristic-pitch-rule-include-nil (pitchfn layers)
  (let* ((nr-of-variables-in-fn (length (system::arglist pitchfn))))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                                             (let* ((number-of-events-in-cell (get-nr-of-events x))
                                                    (number-of-pitches-in-layer (get-number-of-pitches-at-index layer indexx))
                                                    )
                                               
                                               (apply '+ (loop for n from 1 to number-of-events-in-cell
                                                               collect (apply pitchfn (get-pitches-between-nths-add-nil-for-not-assigned 
                                                                                       layer indexx 
                                                                                       (- number-of-pitches-in-layer n 
                                                                                          (1- nr-of-variables-in-fn)) 
                                                                                       (- number-of-pitches-in-layer n))))))
                                           0))))))





(defun format-heuristic-rhythm-rule-include-nil (rhythmfn layers)
  (let* ((nr-of-variables-in-fn (length (system::arglist rhythmfn))))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'rhythmcell))
                                             (let* ((number-of-events-in-cell (length (get-rhythmcell x)))
                                                    (number-of-rhythms-and-pauses-in-layer (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                    )
                                               
                                               (apply '+ (loop for n from 1 to number-of-events-in-cell
                                                               collect (apply rhythmfn
                                                                              (get-durations-between-nths-add-nil-for-not-assigned  
                                                                               layer indexx 
                                                                               (- number-of-rhythms-and-pauses-in-layer n 
                                                                                  (1- nr-of-variables-in-fn)) 
                                                                               (- number-of-rhythms-and-pauses-in-layer n)))
                                                               )))
                                           0))))))



(defun  format-heuristic-chord-rule (testfn layer1 layer2)
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
                                      (apply '+ (mapcar #'(lambda (p1 p2) (funcall testfn p1 p2)) pitches-layer1 pitches-layer2))
                                    0))
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
                                      (apply '+ (mapcar #'(lambda (p1 p2) (funcall testfn p1 p2)) pitches-layer1 pitches-layer2))
                                    0))
                                 (t 0))
                         0)
      )))


;;;PWGL below

(defun heuristic-rules-to-pmc (rules)
  (let ((rulelist (append '(+) (heuristic-rule-put-this-object) (loop for rulex from 0 to (1- (length rules))
                                     collect (list 'funcall (nth rulex rules) '(system::cur-index) '?1)))))
    (list 'system::* '?1 (list 'system::?if rulelist))))


(system::PWGLDef heuristic-r->pmc   (&rest (rules  nil))
        "Collects all heuristic rules and formats them to be readable by the 
multi-pmc inside the PWMC library.

The box is expandable and accepts any number of rules. Rules can also
be input as list of rules (the function will make any list flat)."  
        ()
 (heuristic-rules-to-pmc  (patch-work::flat (remove nil rules))))