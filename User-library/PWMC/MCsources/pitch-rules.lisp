(in-package MC)
 

(defun pitch-canon (x layer2 transp2 index)
  (let* ((this-layer (get-layer-nr x))
         (length-this-layer (get-number-of-pitches-at-index this-layer index))
         (length-this-layer-before-cell (get-number-of-pitches-at-index this-layer (1- index)))
         (length-other-layer (get-number-of-pitches-at-index layer2 index))
         (this-pitchcell (get-pitchcell x)))
    (if (<= length-this-layer length-other-layer)
        (equal (mapcar #'(lambda (x) (- x transp2)) (get-pitches-from-vector layer2 (1+ length-this-layer-before-cell)  length-this-layer))
             this-pitchcell)
      (if (> length-other-layer length-this-layer-before-cell)
          (equal (mapcar #'(lambda (x) (- x transp2)) (get-pitches-from-vector layer2 (1+ length-this-layer-before-cell)  length-other-layer))
                 (get-pitches-from-vector this-layer (1+ length-this-layer-before-cell)  length-other-layer))
        t))))


(defun the-pitch-canon-rule (layer1 layer2 transp2)
  #'(lambda (indexx x) (if (typep x 'pitchcell)
                           (cond ((= (get-layer-nr x) layer1)
                                  (pitch-canon x layer2 transp2 indexx))
                                 ((= (get-layer-nr x) layer2)
                                  (pitch-canon x layer1 (- transp2) indexx))
                                 (t t))
                         t)))
  

(defun test-one-startpitch (layer pitch)
  #'(lambda (indexx x) (if (and (typep x 'pitchcell) (= (get-layer-nr x)  layer)
                                (= 1 (get-number-of-pitches-at-index (get-layer-nr x) indexx)))
                             (equal  (get-pitchcell x)  (list pitch))
                         t)))




(defun the-start-pitches-rule (layers pitches)
  (if (/= (length layers) (length pitches)) (error "PWMC error in the startpitch-rule: The length of layer numbers and the number of given pitches are not the same in the startpitch-rule. "))
  (loop for n from 0 to (1- (length layers))
        collect (test-one-startpitch (nth n layers) (nth n pitches))))

