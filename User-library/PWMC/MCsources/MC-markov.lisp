(in-package mc)

(defvar *my-markov-table* nil)


(defun empty-markov-table (items)
         (loop for i1 in items
               collect (loop for i2 in items
                             collect (list (list i1 i2) 0))))

;(setf *my-markov-table* (empty-markov-table '(1 2 3 4 5)))


(defun add-to-markov-table (item markov-table)
  "The function will write into the markov table. No need to use the return value."
  (loop for row in markov-table
        for n from 0
        do (if (equal (caaar row) (car item))
               (progn (loop for case in row
                            for m from 0
                            do (if (equal (first case) item)
                                   (progn (setf (second (nth m (nth n markov-table)))  (1+ (second (nth m (nth n markov-table)))))
                                     (return))))
                 (return markov-table))
             )))

(defun make-1st-order-markov-analysis-of-sequence (seq items)
  "Items that are not found in list of items will be ignored."
  (let ((markov-table (empty-markov-table items)))
    (loop for x in seq
          for y in (cdr seq)
          do (add-to-markov-table (list x y) markov-table))
    markov-table))


;(make-1st-order-markov-analysis-of-sequence '(1 2 2 1 2 3 2 3 4 3 1 3 1 3 1 10 20) '(1 2 3 4 5 6))
;(add-to-markov-table '(3 2) *my-markov-table*)

(defun convert-markov-table-to-% (markov-table)
  "Returns the converted markov table."
  (loop for row in markov-table
        for n from 0
        collect (let ((tot-sum-row (apply '+ (mapcar 'second row))))
                  (if (plusp tot-sum-row)
                      (loop for case in row
                            collect (list (first case) (* 100.0 (/ (second case) tot-sum-row))))
                    row))))


(defun convert-markov-table-to-%-replace-nil (markov-table)
  "Returns the converted markov table. Nil is a special case which will be kept (unconverted)."
  (loop for row in markov-table
        for n from 0
        collect (let ((tot-sum-row (apply '+ (substitute 0 nil (mapcar 'second row)))))
                  (if (plusp tot-sum-row)
                      (loop for case in row
                            collect (list (first case) (if (second case)
                                                           (* 100.0 (/ (second case) tot-sum-row))
                                                         nil)))
                    row))))


(defun convert-markov-table-replace-0-with-nil (markov-table)
  "Returns the converted markov table. Nil is a special case which will be kept (unconverted)."
  (loop for row in markov-table
        for n from 0
        collect (loop for case in row
                      collect (list (first case) (if (and (second case) (= (second case) 0))
                                                     nil
                                                   (second case))))
        ))

;(convert-markov-table-to-% *my-markov-table*)


(defun compare-markov-tables-max-deviation-for-each-item (markov-table1 markov-table2)
  "The two markov tables have to contain the same row indexes (i.e. the same rows and columns have to exist)."
  (loop for row1 in markov-table1
        for row2 in markov-table2
        collect  (apply 'max (loop for case1 in row1
                                   for case2 in row2
                                   collect (abs (- (second case1) (second case2)))))))

;(compare-markov-tables-max-deviation (convert-markov-table-to-% *my-markov-table*) (convert-markov-table-to-% *my-markov-table2*))

(defun step-in-grid-% (items-analyzed-in-row)
  "The step is equal to the maximum accuracy for the markov chain. The longer analysis, the more exact table."
  (/ 100.0 items-analyzed-in-row))


(defun get-number-of-analyzed-items-in-rows (markov-table)
  (loop for row in markov-table
        for n from 0
        collect (apply '+ (mapcar 'second row))))

;(get-number-of-analyzed-items-in-rows *my-markov-table*)

(defun get-step-in-grid-%-for-rows (markov-table)
  (loop for row in markov-table
        for n from 0
        collect (let ((number-of-items (apply '+ (mapcar 'second row))))
                  (if (plusp number-of-items)
                      (/ 100.0 number-of-items)
                    100.0)))) ;if row is empty grid will be set to 100.0

;(get-step-in-grid-%-for-rows *my-markov-table*)




(defun check-markov-tables-within-max-deviation (markov-table-ref markov-table-test max-deviation-%)
  "Check if two markov-tabels are within max deviation. Markov-table-ref has to be normalized to 100 % for each row.
Nil in the reference table indicates that no connection of this type is allowed (regardless of deviation).
0 in the reference table indicates that max-deviation will be allowed for that connection."
  (let ((step-in-grid-%-for-rows (get-step-in-grid-%-for-rows markov-table-test))
        (%-normalized-markov-table-test (convert-markov-table-to-% markov-table-test)))
    (loop for row-test in %-normalized-markov-table-test
          for row-ref in markov-table-ref
          for grid in step-in-grid-%-for-rows
          do (if (loop for test in row-test
                       for ref in row-ref
                       collect (if (second ref)
                                   (if (> (abs (- (second test) (second ref))) (+ max-deviation-% grid))
                                       (return nil) ;nil if any deviation between the markov tables exceed max + grid
                                     t)
                                 (if (/= 0 (second test)) ; if nil then no items of this type shold exist
                                     (return nil)
                                   t))
                       finally (return t))
                 t
               (return nil)) ;return nil if nil is passed from inner loop
          finally (return t))
    ))

   
;;;this is for pure testing of the logic statement. Not used in mc library. Works directly on pmc.
(defun check-if-seq-respects-markov-table (seq markov-table-ref +-%)
  (let* ((items (mapcar #'(lambda (x) (second (car x))) (car markov-table-ref)))
         (markov-table-test (make-1st-order-markov-analysis-of-sequence seq items)))
    (check-markov-tables-within-max-deviation markov-table-ref markov-table-test +-%)))
  
;(check-markov-tables-within-max-deviation (convert-markov-table-to-% *my-markov-table2*) *my-markov-table* 30)

;(setf *my-markov-table2* *my-markov-table*)


;;;;;;;Markov rule for pitches

(defun rule-check-if-pitchseq-is-markov-chain (layernrs markov-table-ref +-%)
  (let ((markov-table-ref-normalized (convert-markov-table-to-%-replace-nil markov-table-ref))
        (items (mapcar #'(lambda (x) (second (car x))) (car markov-table-ref))))
    
    (if (= +-% 0)   ;;special case - don't allow 0 %
        (setf markov-table-ref-normalized (convert-markov-table-replace-0-with-nil markov-table-ref-normalized)))
    (if (not (typep layernrs 'list))
        (setf layernrs (list layernrs)))
    
    (loop for n from 0 to (1- (length layernrs))
          collect (let ((layernr (nth n layernrs)))
                    #'(lambda (indexx x) (if (and (typep x 'pitchcell) (= (get-layer-nr x) layernr))
                                             (let* ((all-pitches  (get-pitches-upto-index layernr indexx))
                                                    (markov-table-test (make-1st-order-markov-analysis-of-sequence all-pitches items)))
                                               ;(system::pwgl-print all-pitches)
                                               (check-markov-tables-within-max-deviation markov-table-ref-normalized markov-table-test +-%))
                                           t))
                    ))))


;;;

(defun rule-check-if-rhythmseq-is-markov-chain (layernrs markov-table-ref +-%)
  (let ((markov-table-ref-normalized (convert-markov-table-to-%-replace-nil markov-table-ref))
        (items (mapcar #'(lambda (x) (second (car x))) (car markov-table-ref))))
    
    (if (= +-% 0)   ;;special case - don't allow 0 %
        (setf markov-table-ref-normalized (convert-markov-table-replace-0-with-nil markov-table-ref-normalized)))  
    (if (not (typep layernrs 'list))
        (setf layernrs (list layernrs)))

    (loop for n from 0 to (1- (length layernrs))
          collect (let ((layernr (nth n layernrs)))
                    #'(lambda (indexx x) (if (and (typep x 'rhythmcell) (= (get-layer-nr x) layernr))
                                             (let* ((all-durations  (get-durations-upto-index layernr indexx))
                                                    (markov-table-test (make-1st-order-markov-analysis-of-sequence all-durations items)))
                               ;(system::pwgl-print markov-table-test)
                                               (check-markov-tables-within-max-deviation markov-table-ref-normalized markov-table-test +-%))
                                           t))
                    ))))






;;;;PWGL specific functions start here


(system::PWGLDef rule-markov ((layer 0)
                              (type? () (ccl::mk-menu-subview :menu-list '(":pitch" ":rhythm")))
                              (order? () (ccl::mk-menu-subview :menu-list '(":1st")))
                              (deviation 5)
                              (markov-table nil))
    "This rule checks that a sequence follows a given markov chain. If elements are found that
 are not defined in the predefined markov chain, these will not be checked. The rules is a type
of markov-chain simulator.

If nil is given as a weigh in the markov table, that indicates a special case when that connection
is not allowed.

Deviation is the maximum deviation (in percent %) from the markov table that will be accepted.

IMPORTANT: small probabilities with a small deviation takes time to find. In some cases, deviation is 
necessary for finding a solution."
    (:groupings '(3 2)  :x-proportions '((0.15 0.43 0.43)(0.5 0.5)))


(cond ((equal type? :pitch) (rule-check-if-pitchseq-is-markov-chain layer markov-table deviation))
      ((equal type? :rhythm) (rule-check-if-rhythmseq-is-markov-chain layer markov-table deviation)))
  )






;;;;;Old function

(system::PWGLDef rule-melodic-markov ((layer 0)
                                      (deviation 5)
                                      (markov-table nil))
    "This rule checks that the melodic line follow a given markov chain. If pitches are found that
 are not defined in the predefined markov chain, these will not be checked. The rules is a type
of markov-chain simulator.

If nil is given as a weigh in the markov table, that indicates a special case when that connection
is not allowed.

Deviation is the maximum deviation (in percent %) from the markov table that will be accepted."
    (:groupings '(3)  :x-proportions '((0.2 0.2 0.6)))

  (rule-check-if-pitchseq-is-markov-chain layer markov-table deviation))


