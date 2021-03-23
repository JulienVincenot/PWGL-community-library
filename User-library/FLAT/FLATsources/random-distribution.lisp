(in-package studioflat)

(defun linear-dist ()
      (max (random 1.0) (random 1.0)))

(defun exp-dist (lambda)
  (let ((ran (random 1.0)))
    (if (= ran 0) 0
      (- (/ (log ran) lambda)))))


(system::PWGLDef probability-distribution ((length 10)
                                           (distr?  10 (ccl::mk-menu-subview :menu-list '(":uniform" ":linear" ":exponential")))
                                           (lambda 0.9))
    ""
    (:groupings '(3)  :x-proportions '((0.2 0.6 0.2)))
  (cond ((equal distr? :uniform)
         (loop for n from 1 to length collect (random 1.0)))
        ((equal distr? :linear)
         (loop for n from 1 to length collect (linear-dist)))
        ((equal distr? :exponential)
         (loop for n from 1 to length collect (exp-dist lambda)))))


