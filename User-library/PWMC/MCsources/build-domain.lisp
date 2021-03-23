(in-package MC)

;;;onset without pauses
(defun dx->x-offset_first (offset_and_ratios)
  "First value in the list is used as an offset for the absoulut values."
  (let ((offset (car offset_and_ratios))
        (ratios (cdr offset_and_ratios)))
    (cons offset (loop for dx in ratios
                       sum dx into thesum
                       collect (+ offset thesum)))))


(defun remove-pauses (proportion-list)
  "Ratios with (negative) pauses transformed to onset without pauses.Last value in the answer is last offset."
  (let ((result '(0)))
    (setf (car (last result)) 0) ;;;obegriplig bugg!!!!! Funerar med detta tillägg
    (loop while proportion-list
          do (progn 
               (if (minusp (first proportion-list))
                      (setf (car (last result)) (+ (abs (car (last result))) (abs (car proportion-list))))
                      (setf result (append result (list (car proportion-list)))))
                    (pop proportion-list)))
    (dx->x-offset_first result)))


(defun create-rdomain (layer-nr rhythmcell-list)
  "From a list of rhythm cells (i.e. motifs), create a list of objects of the class rhythmcell"
  (loop for x from 0 to (1- (length rhythmcell-list)) 
    collect
    (let ((this-instance (make-instance 'rhythmcell))
          (rhythm-cell (nth x rhythmcell-list)))
      (set-layer-nr layer-nr this-instance)
      (set-rhythmcell rhythm-cell this-instance)
      (set-variabledur (apply '+ (mapcar 'abs rhythm-cell)) this-instance)
      (set-local-onset-without-pauses
       (remove-pauses rhythm-cell)
       this-instance)
      (set-pauses-included? (if (= (apply '+ (mapcar #'(lambda (x) (if (minusp x) 1 0)) rhythm-cell)) 
                                   0)
                                nil
                              t) this-instance)
    this-instance)))




(defun create-mdomain (timesign-list)
  "From a list of tim signs, create a list of objects of the class timesign"
  (loop for x from 0 to (1- (length timesign-list)) 
    collect
    (let ((this-instance (make-instance 'timesign))
          (timesign (nth x timesign-list)))
      (set-layer-nr *TIMESIGNLAYER* this-instance)
      (set-timesign timesign this-instance)
      (set-variabledur (apply '/ timesign) this-instance)
      (set-low (cadr timesign) this-instance)
      this-instance)))



(defun create-pdomain (layer-nr pitchcell-list)
  "From a list of pitch cells (i.e. motifs), create a list of objects of the class pitchcell"
  (loop for x from 0 to (1- (length pitchcell-list)) 
    collect
    (let ((this-instance (make-instance 'pitchcell))
          (pitch-cell (nth x pitchcell-list)))
      (set-layer-nr layer-nr this-instance)
      (set-pitchcell pitch-cell this-instance)
      (set-nr-of-events (length pitch-cell) this-instance)
      (set-chords-included? (if (= (apply '+ (mapcar #'(lambda (x) (if (listp x) 1 0)) pitch-cell)) 
                                   0)
                                nil
                              t) this-instance)
      this-instance)))


(defun create-pmdomain (layer-nr pitchmotifcell-list)
  "From a list of pitch-motif cells (i.e. list of melodic intrvals), create a list of objects of the class pitchmotifcell"
  (loop for x from 0 to (1- (length pitchmotifcell-list)) 
    collect
    (let ((this-instance (make-instance 'pitchmotifcell))
          (pitchmotifcell (nth x pitchmotifcell-list)))
      (set-layer-nr layer-nr this-instance)
      (set-motif-intervals pitchmotifcell this-instance)
      (set-nr-of-events (length pitchmotifcell) this-instance) 
      (set-chords-included? nil this-instance)
      this-instance)))