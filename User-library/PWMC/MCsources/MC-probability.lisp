(in-package mc)

(defvar *my-probability-table* nil)


(defun empty-probability-table (items)
         (loop for i1 in items
               collect (list i1 0)))

;(setf *my-probability-table* (empty-probability-table '(12 7 5 4 3 2)))

(defun add-to-probability-table (item probability-table)
  "The function will write into the markov table. No need to use the return value."
  (loop for row in probability-table
        for n from 0
        do (if (equal (car row) item)
               (progn (setf (second (nth n probability-table))  (1+ (second (nth n probability-table))))
                 (return))))
  probability-table)


;(add-to-probability-table 1 *my-probability-table*)

(defun make-probability-analysis-of-sequence (seq items)
  "Items that are not found in list of items will be ignored."
  (let ((probability-table (empty-probability-table items)))
    (loop for x in seq
          do (add-to-probability-table x probability-table))
    probability-table))


;(make-probability-analysis-of-sequence '(1 2 3 2 3 4 3 2 3 1) '(1 2 3 4))

(defun convert-probability-table-to-% (probability-table)
  "Returns the converted probability table."
  (let ((tot-sum-weights (apply '+ (mapcar 'second probability-table))))
    (if (plusp tot-sum-weights)
        (loop for case in probability-table
              collect (list (first case) (* 100.0 (/ (second case) tot-sum-weights))))
      probability-table)))


;(convert-probability-table-to-% (make-probability-analysis-of-sequence '(1 2 3 2 3 4 3 2 3 1) '(1 2 3 4)))


(defun convert-probability-table-to-%-replace-nil (probability-table)
  "Returns the converted probability table. Nil is a special case which will be kept (unconverted)."
  (let ((tot-sum-weights (apply '+ (substitute 0 nil (mapcar 'second probability-table)))))
    (if (plusp tot-sum-weights)
        (loop for case in probability-table
              collect (list (first case) (if (second case)
                                             (* 100.0 (/ (second case) tot-sum-weights))
                                           nil)))
      probability-table)))


;(convert-probability-table-to-% '((1 0) (2 3) (3 4) (4 1)))

(defun compare-probability-tables-max-deviation-for-each-item (probability-table1 probability-table2)
  "The two probability tables have to contain the same row indexes (i.e. the same rows and columns have to exist)."
   (apply 'max (loop for case1 in probability-table1
                     for case2 in probability-table2
                     collect (abs (- (second case1) (second case2))))))

;(compare-probability-tables-max-deviation-for-each-item '((1 0.0) (2 30.5) (3 10.0) (4 12.5)) '((1 0.0) (2 37.5) (3 50.0) (4 12.5)))

;;;;;;;Below function is already defined in MC-markoc.lisp;;;;;;;
;(defun step-in-grid-% (items-analyzed-in-row)
;  "The step is equal to the maximum accuracy for the markov chain. The longer analysis, the more exact table."
;  (/ 100.0 items-analyzed-in-row))

(defun get-step-in-grid-%-for-probability-table (probability-table)
  (let ((number-of-items (apply '+ (mapcar 'second probability-table))))
    (if (plusp number-of-items)
        (/ 100.0 number-of-items)
      100.0)))

(defun check-probability-tables-within-max-deviation (probabiliy-table-ref probability-table-test max-deviation-%)
  "Check if two probability-tabels are within max deviation. Probability-table-ref has to be normalized to 100 % for each row.
Probability-table-test should NOT be normalized! Number of analyzed items have to be possible to access.
Nil in the reference table indicates that no connection of this type is allowed (regardless of deviation).
0 in the reference table indicates that max-deviation will be allowed for that connection.

Both tables have to be formated identically!"
  (let ((grid (get-step-in-grid-%-for-probability-table probability-table-test))
        (%-normalized-probability-table-test (convert-probability-table-to-% probability-table-test)))
    (loop for test in %-normalized-probability-table-test
          for ref in probabiliy-table-ref
          collect (if (second ref)
                      (if (> (abs (- (second test) (second ref))) (+ max-deviation-% grid))
                          (return nil) ;nil if any deviation between the markov tables exceed max + grid
                        t)
                    (if (/= 0 (second test)) ; if nil then no items of this type should exist
                        (return nil)
                      t))
          finally (return t))
    ))

;(check-probability-tables-within-max-deviation '((1 20.0) (2 30.000002) (3 25) (4 10.0)) '((1 2) (2 3) (3 4) (4 1)) 10)
;(step-in-grid-% '((1 0.0) (2 37.5) (3 10.0) (4 12.5)))
;(get-step-in-grid-%-for-probability-table '((1 0.0) (2 37.5) (3 10.0) (4 12.5)))
(defun check-only-memebers (list allowed-members)
  (loop for item in list
        do (if (member item allowed-members)
               t
             (return nil))
        finally (return t)))

;(check-only-memebers '(0 0 12 7 5 0 1) '(0 5 7 12))

(defun rule-check-if-intervals-in-pitchseq-match-probability-table (layernrs probability-table-ref +-%)
  (let ((probability-table-ref-normalized (convert-probability-table-to-%-replace-nil probability-table-ref))
        (items (mapcar 'car probability-table-ref)))
    (if (not (typep layernrs 'list)) (setf layernrs (list layernrs)))
    (loop for n from 0 to (1- (length layernrs))
          collect (let ((layernr (nth n layernrs))) 
                    #'(lambda (indexx x) (if (and (typep x 'pitchcell) (= (get-layer-nr x) layernr))
                                             (let* ((all-pitches  (get-pitches-upto-index layernr indexx))
                                                    (mel-intervals (mapcar 'abs (pw::x->dx all-pitches)))
                                                    (probability-table-test (make-probability-analysis-of-sequence mel-intervals items)))
                               ;(system::pwgl-print all-pitches)
                                               (and (check-only-memebers mel-intervals items) ; don't allow intervals not in table
                                                    (check-probability-tables-within-max-deviation probability-table-ref-normalized probability-table-test +-%)))
                                           t))))
    
    ))


(defun rule-check-if-pitches-in-pitchseq-match-probability-table (layernrs probability-table-ref +-%)
  (let ((probability-table-ref-normalized (convert-probability-table-to-%-replace-nil probability-table-ref))
        (items (mapcar 'car probability-table-ref)))
    (if (not (typep layernrs 'list)) (setf layernrs (list layernrs)))
    (loop for n from 0 to (1- (length layernrs))
          collect (let ((layernr (nth n layernrs)))
                    #'(lambda (indexx x) (if (and (typep x 'pitchcell) (= (get-layer-nr x) layernr))
                                             (let* ((all-pitches  (get-pitches-upto-index layernr indexx))
                                                    (probability-table-test (make-probability-analysis-of-sequence all-pitches items)))
                               ;(system::pwgl-print all-pitches)
                                               (and (check-only-memebers all-pitches items) ; don't allow pitches not in table
                                                    (check-probability-tables-within-max-deviation probability-table-ref-normalized probability-table-test +-%)))
                                           t)))
    
          )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;heuristic rules from here;;;;;;;;;;;;;

(defun count-non-memebers (list allowed-members)
  (apply '+ (loop for item in list
                  collect (if (member item allowed-members)
                              0
                            1)
                  )))

;(count-non-memebers '(1 2  4 5) '(1 2 3 4 5))

(defun check-probability-tables-average-deviation (probabiliy-table-ref probability-table-test)
  "Returns the sum of all deviations above the grid. Probability-table-ref has to be normalized to 100 % for each row.
Probability-table-test should NOT be normalized! Number of analyzed items have to be possible to access.
Nil in the reference table indicates that no connection of this type is allowed (regardless of deviation).
0 in the reference table indicates that max-deviation will be allowed for that connection.

Both tables have to be formated identically!"
  (let ((grid (get-step-in-grid-%-for-probability-table probability-table-test))
        (nr-of-items (apply '+ (mapcar 'second probability-table-test)))
        (%-normalized-probability-table-test (convert-probability-table-to-% probability-table-test)))
    (if (plusp nr-of-items)
        (/ (apply '+
                  (loop for test in %-normalized-probability-table-test
                        for ref in probabiliy-table-ref
                        collect (if (second ref)
                                    (if (> (abs (- (second test) (second ref))) grid)
                                        (- (abs (- (second test) (second ref))) grid) ;nil if any deviation between the markov tables exceed max + grid
                                      0)
                                  (if (/= 0 (second test)) ; if nil then no items of this type should exist
                                      (* 1000 (second test))  ;1000 % penalty for each item that is not allowed (nil in ref-table)
                                    0))
                        ))
           nr-of-items)
      0)
    ))



(defun heuristic-rule-check-if-pitches-in-pitchseq-is-close-to-probability-table (layernrs probability-table-ref)
"Weights:
- average deviation above the local grid
every non-member of the tabel:-100
every-not-allowed; -1000"
  (let ((probability-table-ref-normalized (convert-probability-table-to-%-replace-nil probability-table-ref))
        (items (mapcar 'car probability-table-ref)))
    (if (not (typep layernrs 'list)) (setf layernrs (list layernrs)))
    (loop for n from 0 to (1- (length layernrs))
          collect (let ((layernr (nth n layernrs)))
                    #'(lambda (indexx x) (if (and (typep x 'pitchcell) (= (get-layer-nr x) layernr))
                                             (let* ((all-pitches  (get-pitches-upto-index layernr indexx))
                                                    (probability-table-test (make-probability-analysis-of-sequence all-pitches items)))
                               ;(system::pwgl-print all-pitches)
                                              
                                               (- 0 (check-probability-tables-average-deviation probability-table-ref-normalized probability-table-test)
                                                  (if items (* 100 (count-non-memebers all-pitches items))
                                                    0)))
                                           0)))
    
          )))


(defun heuristic-rule-check-if-intervals-in-pitchseq-is-close-to-probability-table (layernrs probability-table-ref)
"Weights:
- average deviation above the local grid
every non-member of the tabel:-100
every-not-allowed; -1000"
  (let ((probability-table-ref-normalized (convert-probability-table-to-%-replace-nil probability-table-ref))
        (items (mapcar 'car probability-table-ref)))
    (if (not (typep layernrs 'list)) (setf layernrs (list layernrs)))
    (loop for n from 0 to (1- (length layernrs))
          collect (let ((layernr (nth n layernrs)))
                    #'(lambda (indexx x) (if (and (typep x 'pitchcell) (= (get-layer-nr x) layernr))
                                             (let* ((all-pitches  (get-pitches-upto-index layernr indexx))
                                                    (mel-intervals (mapcar 'abs (pw::x->dx all-pitches)))
                                                    (probability-table-test (make-probability-analysis-of-sequence mel-intervals items)))
                                                    
                               ;(system::pwgl-print all-pitches)
                                              
                                               (- 0 (check-probability-tables-average-deviation probability-table-ref-normalized probability-table-test)
                                                  (if items (* 100 (count-non-memebers mel-intervals items))
                                                    0)))
                                           0)))
    
          )))

;(check-only-memebers '(1 2 3 2 3 4 3 2) '(1 2 3 4 5 6))


;;;;PWGL specific functions start here
(system::PWGLDef rule-pitch-probability ((layer 0)
                                         (deviation 5)
                                         (table nil)
                                         (mode?  10 (ccl::mk-menu-subview :menu-list '(":intervals" ":pitches")))
                                         (type?  10 (ccl::mk-menu-subview :menu-list '(":rule" ":heuristic-rule"))))
    "This rule checks that the melodic line follow a given probability table. Either pitches or
melodic intervals are checked (the probability table has to be defined for either dimension).

The rule controls that a melody has to have a certain amount of defined melodic intervals or pitches.
It can be thought of as a probability simulator.

If nil is given as a weigh in the markov table, that indicates a special case when that connection
is not allowed. (This is not fully implemented).

Deviation is the maximum deviation (in percent %) from the probability table that will be accepted.

The heuristic rules (pitch or interval) try to be as close as possible to the probability table. 

To understand how the heuristic rule evaluate a proposed item, read the following:
The heuristic weight is set to minus the average deviation (in %) for the sequence (i.e. the sum of all deviations divided by the 
length of the sequence). If a not allowed pitch/interval is checked (i.e. an item that has the probability nil 
in the given table) a penalty weight of -1000 % is added for that variable. If an item that does not exist in
the probability table is checked, a penalty weight of -100 % is added for that variable.

The heuristic rules will most likely not behave well together with other heuristic rules that are affected by
pitches in the same layers.
"
    (:groupings '(3 2)  :x-proportions '((0.33 0.33 0.33) (0.5 0.5)))

  (cond ((equal type? :rule)
         (if (equal mode? :intervals)
             (rule-check-if-intervals-in-pitchseq-match-probability-table layer table deviation)
           (rule-check-if-pitches-in-pitchseq-match-probability-table layer table deviation)))
        ((equal type? :heuristic-rule)
         (if (equal mode? :intervals)
             (heuristic-rule-check-if-intervals-in-pitchseq-is-close-to-probability-table layer table)
           (heuristic-rule-check-if-pitches-in-pitchseq-is-close-to-probability-table layer table)))))

;;;; Below inspired by the Illiac suite
(defun rule-check-if-intervals-in-pitchseq-match-dynamic-probability-table (layernrs probability-tables-ref +-% length-sections)
  (let ((probability-tables-ref-normalized (mapcar 'convert-probability-table-to-%-replace-nil probability-tables-ref))
        (items-all-tables (mapcar #'(lambda (table) (mapcar 'car table)) probability-tables-ref)))
    (if (not (typep layernrs 'list)) (setf layernrs (list layernrs)))
    
    (loop for n from 0 to (1- (length layernrs))
          collect (let ((layernr (nth n layernrs)))
                    #'(lambda (indexx x) (if (and (typep x 'pitchcell) (= (get-layer-nr x) layernr))
                                             (progn ;(system::pwgl-print layernr)
                                               (let* ((all-pitches  (get-pitches-upto-index layernr indexx))
                                                      (no-of-pitches (length all-pitches))
                                                      (section-nr (truncate (1- no-of-pitches) length-sections))
                                                      (pitches-in-section (nthcdr (if (= section-nr 0) 0
                                                                                    (1- (* length-sections section-nr)))
                                                                                  all-pitches))
                                                      (mel-intervals (mapcar 'abs (pw::x->dx pitches-in-section)))
                                                      (items (nth section-nr items-all-tables))
                                                      (probability-table-test (make-probability-analysis-of-sequence mel-intervals items)))

                                                 (and (if items (check-only-memebers mel-intervals items) t)
                                                      (check-probability-tables-within-max-deviation (nth section-nr probability-tables-ref-normalized) probability-table-test +-%))))
                                           t))))
    
    ))

(system::PWGLDef rule-interval-dynamic-prob ((layer 0)
                                             (deviation 5)
                                             (table nil)
                                             (length-sections 12))
    "This rule models the last movment of the Illiac suite.
Table is a list of probability tables. These are the base for how melodic interval occurs.
Length-sections is the number of pitches each table is valid for.
The rule steps through the probability tables for each subsection defined by length-section."
    (:groupings '(2 2)  :x-proportions '((0.5 0.5) (0.5 0.5)))

  (rule-check-if-intervals-in-pitchseq-match-dynamic-probability-table layer table deviation length-sections))





