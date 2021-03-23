(in-package MC)

(defconstant *extra-pitch-color* 10100000)
(defconstant *extra-pitchmeasure-color* 10100000)


(defun msolution-from-vector (index)
  (get-timesigns-upto-index index)) 


(defun rsolution-from-vector (index)
  (loop for layer from 0 to (1- *max-numberof-layers*) 
        collect (get-durations-upto-index layer index)))

(defun psolution-from-vector (index)
  (loop for layer from 0 to (1- *max-numberof-layers*)
        collect (get-pitches-upto-index layer index)))

(defun rpsolution-from-vector (index)
  (loop for layer from 0 to (1- *max-numberof-layers*)
        collect (list (get-durations-upto-index layer index)
                      (get-pitches-upto-index layer index))))

(defun mrpsolution-from-vector (index)
  (append (list (msolution-from-vector index))
  (loop for layer from 0 to (1- *max-numberof-layers*)
        collect (list (get-durations-upto-index layer index)
                      (get-pitches-upto-index layer index)))))

;;Changed nov 2007
(defun pmc-solutionlists-from-vectors (solution)
  ;(check-and-correct-locked-rlayers (1- (system::cur-index)))
  ;(unlock-players)
  (if (equal solution '())
      (progn (ccl::pwgl-print "No solution found") nil)
    (progn
      (put-object-at-index (car (last (car solution))) (1- (system::cur-index)))
      (mrpsolution-from-vector (1- (system::cur-index))))
    ))

(defun remove-overflow-pitch (rhythm-seq pitch-seq)
  (let ((no-revents-without-pause (length (remove 0 rhythm-seq :test #'(lambda (x y) (> x y)))))
        (no-pevents (length pitch-seq)))
    (if (> no-pevents no-revents-without-pause)
        (butlast pitch-seq (- no-pevents no-revents-without-pause))
      pitch-seq)))

(defun collect-overflow-pitch (rhythm-seq pitch-seq)
    (let ((no-revents-without-pause (length (remove 0 rhythm-seq :test #'(lambda (x y) (> x y)))))
        (no-pevents (length pitch-seq)))
    (if (> no-pevents no-revents-without-pause)
        (last pitch-seq (- no-pevents no-revents-without-pause))
      nil)))

(defun collect-overflow-rhythm (rhythm-seq pitch-seq)
  (let ((no-revents-without-pause (length (remove 0 rhythm-seq :test #'(lambda (x y) (> x y)))))
        (no-pevents (length pitch-seq)))
    (if (> no-revents-without-pause no-pevents)
        (progn (loop for x from 1 to no-pevents
                     do (progn (loop while (minusp (pop rhythm-seq)))
                          (loop while (minusp (car rhythm-seq))
                                do (pop rhythm-seq))))
          rhythm-seq)
      nil)))

(defun remove-overflow-rhythm (rhythm-seq pitch-seq)
  (let ((no-revents-without-pause (length (remove 0 rhythm-seq :test #'(lambda (x y) (> x y)))))
        (no-pevents (length pitch-seq)))
    (if (> no-revents-without-pause no-pevents)
        (apply 'append
               (loop for x from 1 to no-pevents
                     collect (loop 
                              collect (pop rhythm-seq)
                              while (minusp (car rhythm-seq)))))
      rhythm-seq)))


;Changed nov 2007
(defun partial-solutionlists-from-vectors ()
  ;(check-and-correct-locked-rlayers (1- (system::cur-index)))
  ;(unlock-players)
  (put-object-at-index *this-variable* (1- (system::cur-index)))
  (mrpsolution-from-vector (1- (system::cur-index)))
  )


;(check-and-correct-locked-rlayers (1- 0))