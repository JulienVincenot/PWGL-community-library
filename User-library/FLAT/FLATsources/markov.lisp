(in-package studioflat)

;list-all-items-in-order from probabilities.lisp

(defun empty-markov-table (items)
         (loop for i1 in items
               collect (loop for i2 in items
                             collect (list (list i1 i2) 0))))

(defun empty-2ndorder-markov-table (items)
         (loop for i1 in items
               collect (loop for i2 in items
                             collect (loop for i3 in items
                             collect (list (list i1 i2 i3) 0)))))


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



(defun add-to-2ndorder-markov-table (item 2nd-order-markov-table)
  "The function will write into the markov table. No value is returned."
  (loop for 1st-level-row in 2nd-order-markov-table
        for n from 0
        do (if (equal (caaaar 1st-level-row) (car item))
               (loop for 2nd-level-row in 1st-level-row
                     for m from 0
                     do (if (equal (cadaar 2nd-level-row) (cadr item))
                            (loop for case in 2nd-level-row
                                  for o from 0
                                  do (if (equal (first case) item)
                                         (progn (setf (second (nth o (nth m (nth n 2nd-order-markov-table))))  (1+ (second (nth o (nth m (nth n 2nd-order-markov-table))))))
                                           (return)))
                                  finally (return)))
                     finally (return)))
        finally (return)))

;(add-to-2ndorder-markov-table '(2 1 2) (add-to-2ndorder-markov-table '(2 1 2) (empty-2ndorder-markov-table '(1 2 3))))

(defun make-1st-order-markov-analysis-of-sequence (seq items)
  "Items that are not found in list of items will be ignored."
  (let ((markov-table (empty-markov-table items)))
    
    (loop for x in seq
          for y in (cdr seq)
          do (add-to-markov-table (list x y) markov-table))
    markov-table))


(defun make-2nd-order-markov-analysis-of-sequence (seq items)
  "Items that are not found in list of items will be ignored."
  (let ((2ndorder-markov-table (empty-2ndorder-markov-table items)))
    
    (loop for x in seq
          for y in (cdr seq)
          for z in (cddr seq)
          do (add-to-2ndorder-markov-table (list x y z) 2ndorder-markov-table))
    2ndorder-markov-table))


(defun convert-markov-table-to-% (markov-table)
  "Returns the converted markov table."
  (loop for row in markov-table
        for n from 0
        collect (let ((tot-sum-row (apply '+ (mapcar 'second row))))
                  (if (plusp tot-sum-row)
                      (loop for case in row
                            collect (list (first case) (* 100.0 (/ (second case) tot-sum-row))))
                    row))))


(defun convert-2ndorder-markov-table-to-% (2ndorder-markov-table)
  "Returns the converted markov table."
  (loop for 1stlevel-row in 2ndorder-markov-table
        for n from 0
        collect  (loop for 2nd-level-row in 1stlevel-row
                       for m from 0
                       collect(let ((tot-sum-row (apply '+ (mapcar 'second 2nd-level-row))))
                                (if (plusp tot-sum-row)
                                    (loop for case in 2nd-level-row
                                          collect (list (first case) (* 100.0 (/ (second case) tot-sum-row))))
                                  2nd-level-row)))))


        


(defun get-random-from-markovrow (markovtable-row)
  "Divide probability space, make a random number, match to item in row."
   (let* ((markovtable-row-no-0 (remove nil (mapcar #'(lambda (element) (if (= 0 (second element)) nil element)) markovtable-row)))
          (row-probabilities (mapcar 'second markovtable-row-no-0))
          (items-no-0 (mapcar 'cadar markovtable-row-no-0))
          (probability-space (loop for list on row-probabilities collect (apply '+ list)))
          (this-random-number (/ (random 10000) 100.0)))
     (loop for n from 1 to (1- (length probability-space))
           do (if (> this-random-number (nth n probability-space))
                  (return (nth (1- n) items-no-0)))
           finally (return (car (last items-no-0))))
    ))


(defun get-random-from-2ndorder-2ndlevel-markovrow (2ndorder-markovtable-row)
  "Divide probability space, make a random number, match to item in row. The input row has to be normalized!"
   (let* ((2ndorder-markovtable-row-no-0 (remove nil (mapcar #'(lambda (element) (if (= 0 (second element)) nil element)) 2ndorder-markovtable-row)))
          (row-probabilities (mapcar 'second 2ndorder-markovtable-row-no-0))
          (items-no-0 (mapcar 'caddar 2ndorder-markovtable-row-no-0))
          (probability-space (loop for list on row-probabilities collect (apply '+ list)))
          (this-random-number (/ (random 10000) 100.0)))
     (loop for n from 1 to (1- (length probability-space))
           do (if (> this-random-number (nth n probability-space))
                  (return (nth (1- n) items-no-0)))
           finally (return (car (last items-no-0))))
    ))
     

(defun seq-from-1storder-markov (markov-table seq-length)
  (let* ((items (mapcar 'caaar markov-table))
         (normalized-table (convert-markov-table-to-% markov-table))
         seq)
    (setf seq (list (nth (random (length items)) items)))  ;random start
    (loop for n from 1 to (1- seq-length)
          do (let* ((last-item (car (last seq)))
                    (nth (position last-item items)))
               (if nth
                   (let ((table-row (nth nth normalized-table)))
                     (setf seq (append seq (list (get-random-from-markovrow table-row)))))
                 (progn (system::pwgl-print "Dead end found in 1st-order Markov Table. Sequence was truncated, length of generated sequence:")
                   (system::pwgl-print (1- x))
                   (return)))))
    seq))
 
;2nd-order-remove-all-0 is not used, but can be useful to display the content of a 2nd order markov table   
(defun 2nd-order-remove-all-0 (2ndorder-markov-table)
  (loop for 1stlevel-row in 2ndorder-markov-table
        collect (remove nil (loop for 2nd-level-row in 1stlevel-row
                      collect (remove nil (mapcar #'(lambda (element) (if (= 0 (second element)) nil element)) 2nd-level-row))))))


(defun random-startvalues-2ndorder-markov (2ndorder-markov-table)
  "No weight is applied for the start values."
  (let ((2ndorder-markovtable-row-no-0 
         (apply 'append (loop for 1stlevel-row in 2ndorder-markov-table
                              collect (apply 'append (loop for 2nd-level-row in 1stlevel-row
                                                           collect (remove nil (mapcar #'(lambda (element) (if (= 0 (second element)) nil element)) 2nd-level-row))))))))
    (butlast (car (nth (random (length 2ndorder-markovtable-row-no-0)) 2ndorder-markovtable-row-no-0)))))
         
 
(defun seq-from-2ndorder-markov (2ndorder-markov-table seq-length)
  (let ((items (mapcar 'caaaar 2ndorder-markov-table))
        (normalized-table (convert-2ndorder-markov-table-to-% 2ndorder-markov-table))
        seq)
    (setf seq (random-startvalues-2ndorder-markov 2ndorder-markov-table))  ;random start
    (loop for x from 2 to (1- seq-length)
          do (let* ((last-items (nthcdr (- (length seq) 2) seq))
                    (n (position (first last-items) items))
                    (m (position (second last-items) items)))
               (if m
                   (let* ((1stlevel-table-row (nth n normalized-table))
                          (2ndlevel-table-row (nth m 1stlevel-table-row)))
                     (setf seq (append seq (list (get-random-from-2ndorder-2ndlevel-markovrow 2ndlevel-table-row)))))
                 (progn (system::pwgl-print "Dead end found in 2nd-order Markov Table. Sequence was truncated, length of generated sequence:")
                   (system::pwgl-print (1- x))
                   (return)))))
    seq))


;;;PWGL functions start here

(system::PWGLDef markov-analysis ((sequence '(5))
                                  (order?  10 (ccl::mk-menu-subview :menu-list '(":1st" ":2nd")))
                                  (mode?  10 (ccl::mk-menu-subview :menu-list '(":raw" ":normalized"))))
    "Markov chain is a sequence of random values whose probabilities at a time 
interval depends upon the value of the number at the previous time.

The function will return a probability table containing all transition 
probabilities for for a Markov Chain that describes a given sequence.
The sequence can contain numbers or any type of symbols (except . and ,).

ORDER? defines if the probability table describes a Markov process of 1st 
or 2nd order.

MODE? defines if the probability table shows the count for how many times 
a pair of values exist (raw) or if each row in the probability table is 
normalized to indicate weights in %.

The format for each transition in the probability table is
((value1 value2) weight) or ((value1 value2 value3) weight). 
Transition probabilities are grouped in sublists for identical values of 
value1 (2nd order probability tables are grouped based both on value1 and 
value2)."
    (:groupings '(3)  :x-proportions '((0.2 0.4 0.4)))

  (cond ((equal order? :1st)
         (if (equal mode? :raw)
             (make-1st-order-markov-analysis-of-sequence sequence (list-all-items-in-order sequence))
           (convert-markov-table-to-% (make-1st-order-markov-analysis-of-sequence sequence (list-all-items-in-order sequence)))))
        ((equal order? :2nd)
         (if (equal mode? :raw)
             (make-2nd-order-markov-analysis-of-sequence sequence (list-all-items-in-order sequence))
           (convert-2ndorder-markov-table-to-% (make-2nd-order-markov-analysis-of-sequence sequence (list-all-items-in-order sequence)))))
        ))



(system::PWGLDef markov-seq ((markov-table '())
                             (order?  10 (ccl::mk-menu-subview :menu-list '(":1st" ":2nd")))
                             (nr-of-items 20))
                             
    "Markov chain is a sequence of random values whose probabilities at a time 
interval depends upon the value of the number at the previous time.

The function returns a sequence based on a table with transition 
probabilities for a Markov process.
 
ORDER? defines if the probability table describes a Markov process of 
1st or 2nd order.

MARKOV-TABLE is the table with all transition probabilities. This is normally 
taken from the function markov-analysis.

The format for each transition in the probability table is
((value1 value2) weight) or ((value1 value2 value3) weight). 
Transition probabilities are grouped in sublists for identical values of 
value1 (2nd order probability tables are grouped based both on value1 and 
value2)."
    (:groupings '(3)  :x-proportions '((0.2 0.2 0.2)))
  (cond ((equal order? :1st)
         (seq-from-1storder-markov markov-table nr-of-items))
        ((equal order? :2nd)
         (seq-from-2ndorder-markov markov-table nr-of-items))
        (t nil)))