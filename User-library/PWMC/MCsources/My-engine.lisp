(in-package MC)

(defun random-shuffle (list)
  (sort (copy-list list) #'(lambda (x y) (if (= (random 2) 0) t nil))))

(defvar *MC-ENDINDEX*)

(defun search-engine-random (end-index domain)
  (let* ((index 0)
         (rule #'(lambda (index solution) (if (> index 0) (< (car (nth index solution)) (car (nth (1- index) solution))) t)))
         (solution (make-list (+ end-index 2) :initial-element nil)))

    (setf (nth index solution) (random-shuffle domain))

    (loop 
     while (and (<= index end-index) (>= index 0))
     do (if (not (nth index solution))
            (progn (setf index (1- index)) (if (>= index 0) (setf (nth index solution) (cdr (nth index solution))))) ;BACKTRACK


          (if (funcall rule index solution) ;CHECK RULE

              (progn (setf index (1+ index)) ; OK - step forward
                (setf (nth index solution) (random-shuffle domain))
                ;(random-shuffle (nth index solution))
               ; (print solution)
                )  ;(random-shuffle domain)


            (progn (setf (nth index solution) (cdr (nth index solution))) ;FAIL - reduce domain

              ))))

    (mapcar 'car (butlast solution))))



(defun search-engine (end-index domain)
  (time (let* ((index 0)
         (rule #'(lambda (index solution) (if (> index 0) (< (car (nth index solution)) (car (nth (1- index) solution))) t)))
         (solution (make-list (+ end-index 2) :initial-element nil)))

    (declare (type integer index end-index))
    (declare (type function rule))
    (declare (type list solution))

    (setf (nth index solution) domain)

    (loop 
     while (and (<= index end-index) (>= index 0))
     do (if (not (nth index solution))
            (progn (setf index (1- index)) (if (>= index 0) (setf (nth index solution) (cdr (nth index solution))))) ;BACKTRACK


          (if (the boolean (funcall rule index solution)) ;CHECK RULE

              (progn (setf index (1+ index)) ; OK - step forward
                (setf (nth index solution) domain)) ; new variable


            (progn (setf (nth index solution) (cdr (nth index solution))) ;FAIL - reduce solution

              ))))

    (mapcar 'car (butlast solution)))))


;(typep (make-array (list (+ 1 2)) :initial-element nil :element-type 'list) 'vector )

;(make-array (list *max-numberof-layers* *max-numberof-notes* 3) :initial-element nil)
;(aref solution n)



(defun search-engine-vector (end-index domain)
  (time (let* ((index 0)
               (rule #'(lambda (index solution) (if (> index 0) (< (car (aref solution index)) (car (aref solution (1- index) ))) t)))
               (solution (make-array (list (+ end-index 2)) :initial-element nil :element-type 'list)))

    (declare (type integer index end-index))
    (declare (type function rule))
    (declare (type vector solution))
    (declare (type list domain))

    (setf (aref solution index) domain)

    (loop 
     while (and (<= index end-index) (>= index 0))
     do (if (not (aref solution index))
            (progn (setf index (1- index)) (if (>= index 0) (setf (aref solution index) (cdr (aref solution index))))) ;BACKTRACK


          (if (the boolean (funcall rule index solution)) ;CHECK RULE

              (progn (setf index (1+ index)) ; OK - step forward
                (setf (aref solution index) domain)) ; new variable


            (progn (setf (aref solution index) (cdr (aref solution index))) ;FAIL - reduce solution

              ))))
(print solution)
(loop for n from 0 to end-index
      collect (car (aref solution n)))

    )))



(defun MC-search-engine (end-index domain rule)
  (time (let* ((index 0)
               (solution (make-array (list (+ end-index 2)) :initial-element nil :element-type 'list)))

          (setf *MC-ENDINDEX* end-index)
          
          (declare (type integer index end-index))
          (declare (type function rule))
          (declare (type vector solution))
          (declare (type list domain))

          (setf (aref solution index) domain)

          (loop 
           while (and (<= index end-index) (>= index 0))
           do (if (not (aref solution index))
                  (progn (setf index (1- index)) (if (>= index 0) (setf (aref solution index) (cdr (aref solution index))))) ;BACKTRACK


                (if (the boolean (funcall rule index solution)) ;CHECK RULE

                    (progn (setf index (1+ index)) ; OK - step forward
                      (setf (aref solution index) domain)) ; new variable


                  (progn (setf (aref solution index) (cdr (aref solution index))) ;FAIL - reduce solution

                    ))))

          (loop for n from 0 to end-index
                collect (car (aref solution n)))

          )))



;;;;;TEST BELOW

(defun pmc-solutionlists-from-vectors (solution)
  (if (equal solution '())
      (progn (ccl::pwgl-print "No solution found") nil)
    (progn
      (put-object-at-index (car (last (car solution))) (1+ *MC-ENDINDEX*))
      (mrpsolution-from-vector (1+ *MC-ENDINDEX*)))
    ))

(defun pmc-solutionlists-from-vectors (solution)
  ;(check-and-correct-locked-rlayers (1- (system::cur-index)))
  ;(unlock-players)
  (if (equal solution '())
      (progn (ccl::pwgl-print "No solution found") nil)
    (progn
      (put-object-at-index (car (last (car solution))) (1- (system::cur-index)))
      (mrpsolution-from-vector (1- (system::cur-index))))
    ))


(defun MCrules-to-pmc (rules)
  (clear-all-debug-vector)
  #'(lambda (index solution)
      (progn 
        (MCrule-put-previous-object index solution)
        (MCrule-no-start-with-pitch-motif index solution)
        (MCrule-put-this-object index solution)
        (MCdebugg-update index solution)
        (loop for rule in rules
              do (if (funcall rule (1+ index) (car (aref solution index))) t (return nil))
              finally (return t)
              ))))



(defun MCrule-put-previous-object (index solution)
  (if (> index 0)
      (put-object-at-index (car (aref solution (1- index))) index)
    t))


(defun MCrule-put-this-object (index solution)
  (put-object-at-index (car (aref solution index)) (1+ index)))

(defun MCrule-no-start-with-pitch-motif (index solution)  ;THIS HAS TO BE THE SECOND RULE!!! FIRST PREVIOUS OBJECT HAS TO BE PUT IN VECTORS
                                            ;THEN THIS RULE HAS TO PUT PITCHES ON THE MOTIF. LAST THIS CELL HAS TO BE PUT IN VECTORS
  (if (typep (car (aref solution index)) 'pitchmotifcell)
       (if (first-pitch? (car (aref solution index)) (1+ index)) nil t)
     t))

(defun MCdebugg-update (index solution)
    (if (> index 0) (debugger-put-last-candidate index (car (aref solution (1- index)))) t))


(system::PWGLDef MCrules->pmc   (&rest (rules  nil))
        "Collects all rules and formats them to be readable by the multi-pmc.

The box is expandable and accepts any number of rules. Rules can also
be input as list of rules (the function will make any list flat).

This box needs to be connected to the multi-pmc to make the PWMC
system work (even if no rule is attached to it, you need to have 
it attached)!"  
        ()
 (MCrules-to-pmc  (patch-work::flat (remove nil rules))))