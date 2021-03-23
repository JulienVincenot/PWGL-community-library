(in-package studioflat)

(defun list-all-items-in-order (sequence)
  (let ((seq (copy-list sequence)))
    (if (typep (car seq) 'number)
        (sort (remove-duplicates seq) '<)
      (remove-duplicates seq :test 'equal))))


;(list-all-items-in-order '(a b dfd))


(defun empty-probability-table (items)
         (loop for i1 in items
               collect (list i1 0)))


(defun add-to-probability-table (item probability-table)
  "The function will write into the markov table. No need to use the return value."
  (loop for row in probability-table
        for n from 0
        do (if (equal (car row) item)
               (progn (setf (second (nth n probability-table))  (1+ (second (nth n probability-table))))
                 (return))))
  probability-table)



(defun make-probability-analysis-of-sequence (seq items)
  "Items that are not found in list of items will be ignored."
  (let ((probability-table (empty-probability-table items)))
    (loop for x in seq
          do (add-to-probability-table x probability-table))
    probability-table))


(defun convert-probability-table-to-% (probability-table)
  "Returns the converted probability table."
  (let ((tot-sum-weights (apply '+ (mapcar 'second probability-table))))
    (if (plusp tot-sum-weights)
        (loop for case in probability-table
              collect (list (first case) (* 100.0 (/ (second case) tot-sum-weights))))
      probability-table)))


(defun convert-probability-table-to-%-replace-nil (probability-table)
  "Returns the converted probability table. Nil is a special case which will be kept (unconverted)."
  (let ((tot-sum-weights (apply '+ (substitute 0 nil (mapcar 'second probability-table)))))
    (if (plusp tot-sum-weights)
        (loop for case in probability-table
              collect (list (first case) (if (second case)
                                             (* 100.0 (/ (second case) tot-sum-weights))
                                           nil)))
      probability-table)))


(defun seq-from-probabilities (prob-table nr-of-items)
  (let* ((items (mapcar 'first prob-table))
         (normalized-table (convert-probability-table-to-% prob-table))
         (probabilities (mapcar 'second normalized-table))
         (division-of-random-space (mapcon #'(lambda (l) (list (* 100 (apply '+ l)))) probabilities)))

    (loop for n from 1 to nr-of-items
          collect (let ((this-random (random 10000)))
                    (loop for n from 0 to (1- (length items))
                          do (if (> this-random (nth n division-of-random-space))
                                 (return (nth (1- n) items)))
                          finally (return (nth (1- n) items)))))))

;;;PWGL functions start here

(system::PWGLDef probability-analysis ((sequence '())
                                       (mode?  10 (ccl::mk-menu-subview :menu-list '(":raw" ":normalized"))))
    "Returns an analysis of the probability for different values to exist 
in a sequence in the format '((item probability) (item probability)... ).

The sequence can be a sequence of any numerical values or symbols (with a 
few exemptions like , or .)."
    (:groupings '(2)  :x-proportions '((0.3 0.7)))

  (if (equal mode? :raw)
      (make-probability-analysis-of-sequence sequence (list-all-items-in-order sequence))
    (convert-probability-table-to-% (make-probability-analysis-of-sequence sequence (list-all-items-in-order sequence)))))



(system::PWGLDef probability-seq ((probability-table '())
                                             (nr-of-items 20))
    "Generates a sequence of ivalues based on a probability table.

The probability table should be in the format 
'((item probability) (item probability)... ).

The table can either be normalized to 100 %, or have any sum for all weights."
    (:groupings '(2)  :x-proportions '((0.3 0.7)))

  (seq-from-probabilities probability-table nr-of-items))