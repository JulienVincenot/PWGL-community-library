(in-package :GeneticAlgorithm)


;; Box for the genetic algorithm
(defun combine-fitness (weight fitness-fcn weight-fcn-list)
    "This function additively combines any amount of fitness functions into a single fitness function, which is usable by the genetic algorithm box. The functions can be weighted to vary the importance of each function."

(let (currFunction)
#'(lambda (candidate) (sum-list (cons (if (functionp fitness-fcn) (* weight (funcall fitness-fcn candidate)) 0)
               (loop for i from 0 to (1- (length weight-fcn-list)) by 2 collect
                   (* (nth i weight-fcn-list) 
                      (if (functionp (setq currFunction (nth (1+ i) weight-fcn-list))) 
                           (funcall currFunction candidate) 
                            0)  ) ) ) ) )
) ; end let
)

