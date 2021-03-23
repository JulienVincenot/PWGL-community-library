(in-package MC)

(defun debug-from-vectors (index)
  (check-and-correct-locked-rlayers (1- (system::cur-index)))
  (unlock-players)
  (put-object-at-index *this-variable* (1- (system::cur-index)))
  (mrpsolution-from-vector index)
  )

;;;;;
;debug vector stores the last 100 tried variables with indexnumber  
(defvar *debug-vector* (make-array (list 100 2) :initial-element nil))
(defvar *debug-index* 0)
(defvar *debug-sol-vector* (make-array (list *max-numberof-variables*)))

(defun put-variable-to-debug-sol-vector (index x)   ;this one is not used
	(setf (aref *debug-sol-vector* index) x))

(defun clear-all-debug-vector ()
  (loop for i from 1 to (1- *max-numberof-variables*)
	do (if (aref *debug-sol-vector* i)
               (setf (aref *debug-sol-vector* i) nil)
             (return)))
  (loop for n from 0 to 99
	do (progn (setf (aref *debug-vector* n 0) nil)
             (setf (aref *debug-vector* n 1) nil)))
  (setf *debug-index* 0))

(defun shift-1step-debug-vector ()
	(loop for n from 99 downto 1
	do (progn (setf (aref *debug-vector* n 0) (aref *debug-vector* (1- n) 0))
             (setf (aref *debug-vector* n 1) (aref *debug-vector* (1- n) 1)))))

(defun debugger-put-last-candidate (index x)   ;;;index-1 compensated below - otherwise it does not work
	(if (/= index *debug-index*)
            (progn (setf *debug-index* index)
              (shift-1step-debug-vector)))
	(setf (aref *debug-vector* 0 0) x)
	(setf (aref *debug-vector* 0 1) index)
	(setf (aref *debug-sol-vector* index) x)
        t)

;(clear-all-debug-vector)
;;;;;below functions to read debug related vectors

(defun get-first-n-in-debug-vector ()
  (if (aref *debug-vector* 99 1) 
      99
    (loop for n from 0 to 99 
          do (if (aref *debug-vector* n 1) t (return (1- n)))
          )))

(defun combine-debug-vector (n)
  "Overwrite *debug-sol-vector* with values from *debug-vector* upto n generations from given partial solution.
Last index at n will be returned."
  (let ((first-n (get-first-n-in-debug-vector)))
    (if (>= first-n n)
        (progn (loop for x from first-n downto n
                     do (let ((index (aref *debug-vector* x 1))
                              (variable (aref *debug-vector* x 0)))
                          (setf (aref *debug-sol-vector* index) variable)))
          (aref *debug-vector* n 1)) ; return index
      nil)))

(defun get-pmcindex-at-historyindex (history-index)
  (aref *debug-vector* (1- (- history-index)) 1))


;(get-pmcindex-at-historyindex -1)
(defun get-variables-from-debug-vector (stop-index)
  (loop for index from 1 to stop-index
        collect (aref *debug-sol-vector* index)))


(defun get-historic-temp-solution (n)
  (let ((stop-index (combine-debug-vector n)))
    (if stop-index
        (append (get-variables-from-debug-vector stop-index)
                (get-locked-layers))
      nil)))

(defun get-locked-layers ()
  (apply 'append (apply 'append (loop for layer from 0 to (1- *max-numberof-layers*)
        collect (list (if (locked-rlayer? layer)
                          (create-rdomain layer (list (x-dx-pause-ok (get-one-rhythmlayer-at-index layer 1)))))
                      (if (locked-player? layer)
                          (create-pdomain layer (list (get-pitches-upto-index layer 1)))))
                      ))))
;(get-locked-layers)
;(create-rdomain 0 '((1 1 1)))
;(length '(1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4 1/4))
;(locked-player? 1)
;(get-pitches-upto-index 3 1)


(defvar *rhythms* (make-array (list *max-numberof-layers*)))
(defvar *pitches* (make-array (list *max-numberof-layers*)))
(defvar *timesigns* nil)


(defun clear*rhythms*and*pitches*and*timesigns* ()
  (loop for layer from 0 to (1- *max-numberof-layers*)
        do (progn (setf (aref *rhythms* layer) nil)
             (setf (aref *pitches* layer) nil)))
  (setf *timesigns* nil))

(defun sort-debug-sol-list (list)
  "sort the variables from the debug-sol-vector into layers, etc."
  (clear*rhythms*and*pitches*and*timesigns*)
  (loop for variable in list
        do (let ((layernr (get-layer-nr variable)))
             (cond ((typep variable 'rhythmcell) (setf (aref *rhythms* layernr) (append (aref *rhythms* layernr) (get-rhythmcell variable))))
                   ((typep variable 'pitchcell) (setf (aref *pitches* layernr) (append (aref *pitches* layernr) (get-pitchcell variable))))
                   ((typep variable 'timesign) (setf *timesigns* (append *timesigns* (list (get-timesign variable))))))))
  (append (list *timesigns*) (loop for layer from 0 to (1- *max-numberof-layers*)
                                   collect (list (aref *rhythms* layer) (aref *pitches* layer)))))


(defun read-historic-solution (history-index tempo)
    "Get partial solution from last run of PMC."
  (let ((solutionlist nil))
    (setf history-index (1- (- history-index))) ;compensate for (1- (cur-index))
    (setf solutionlist (sort-debug-sol-list (get-historic-temp-solution history-index)))
    (if solutionlist
        (let ((supply-measures? t))
          (solutionlists-to-PWGLtree solutionlist supply-measures? tempo))
          )))


;(get-historic-temp-solution 1)

;(sort-debug-sol-list (get-historic-temp-solution 1))

(defun debug-one-rule (fn index)
  "Test one rule on a variable at index in last solution."
  (if (listp fn) (setf fn (car fn)))
  (print-debug-info index)
  (funcall fn index (nth (1- index) (get-variables-from-debug-vector index))))

(defun print-debug-info (index)
  (system::pwgl-print (list "Layernr:"
        (get-layer-nr (nth (1- index) (get-variables-from-debug-vector index)))
        (nth (1- index) (get-variables-from-debug-vector index))
        (cond ((typep (nth (1- index) (get-variables-from-debug-vector index)) 'rhythmcell) 
               (get-rhythmcell (nth (1- index) (get-variables-from-debug-vector index))))
              ((typep (nth (1- index) (get-variables-from-debug-vector index)) 'pitchcell) 
               (get-pitchcell (nth (1- index) (get-variables-from-debug-vector index))))
              ((typep (nth (1- index) (get-variables-from-debug-vector index)) 'timesign) 
               (get-timesign (nth (1- index) (get-variables-from-debug-vector index)))))
        ))
  nil)