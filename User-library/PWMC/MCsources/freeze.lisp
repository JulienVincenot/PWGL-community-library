(in-package MC)

; Store sequense of variables from pmc

(defun compare-to-saved-pmc-solutionlist (saved-seq end-index transpose)
  "Compare and freeze solution to saved solution upto end-index."
  #'(lambda (indexx x)
      (if (<= indexx end-index)
        (let ((saved-types (first saved-seq))
              (saved-layernrs (second saved-seq))
              (saved-content (third saved-seq)))
          
          (if (and (equal (type-of x) (nth (1- indexx) saved-types))  
                   (= (get-layer-nr x) (nth (1- indexx) saved-layernrs)))   
            (typecase x
              (pitchcell 
               (equal (get-pitchcell x) (mapcar #'(lambda (p) (+ p transpose)) (nth (1- indexx) saved-content))))
              (rhythmcell 
               (equal (get-rhythmcell x) (nth (1- indexx) saved-content)))
              (timesign
               (equal (get-timesign x) (nth (1- indexx) saved-content)))
              (t nil))
            nil))
        t)))


(defun save-solution (sol)
  "Formats the pmc output for rule. The output can be saved in the patch and used in the rule."
  (list (mapcar 'type-of (car sol))
        (mapcar 'get-layer-nr (car sol))
        (mapcar #'(lambda (obj) (typecase obj
                                  (pitchcell (get-pitchcell obj))
                                  (rhythmcell (get-rhythmcell obj))
                                  (timesign (get-timesign obj))))
                (car sol))))

