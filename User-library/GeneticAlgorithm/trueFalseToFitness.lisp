(in-package :GeneticAlgorithm)


;; Box for the genetic algorithm
(defun tfRulesToFitness (weight tfRule weight-TFRule-list)
    "This function additive combines any amount of fitness functions into one fitness function, usable by the genetic algorithm. The functions can be weighted to vary the importance of each function."

(let (currFunction)
#'(lambda (candidate) (sum-list (cons (if (and (functionp tfRule) (funcall tfRule candidate)) weight 0)
               (loop for i from 0 to (1- (length weight-TFRule-list)) by 2 collect
                   (if (and (functionp (setq currFunction (nth (1+ i) weight-TFRule-list))) 
                           (funcall currFunction candidate)) 
                            (nth i weight-TFRule-list) 0)  ) ) ) ) 
) ; end let
)

