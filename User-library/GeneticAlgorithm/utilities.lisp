(in-package :GeneticAlgorithm)

;; transpose function - tranpose a matrix x
(defun transpose (x)
   (apply #'mapcar (cons #'list x)))

;; sum-list function - sums together all elements of a list
(defun sum-list (lst)
  (if lst
      (+ (car lst) (sum-list (cdr lst)))
    0))
