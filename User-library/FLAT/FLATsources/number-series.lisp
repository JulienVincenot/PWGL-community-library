(in-package studioflat)


(defun general-number-series (fn1 fn2 fact1 fact2 seed nr-of-elements)
  (let ((item seed)
        (nr-of-loops (/ nr-of-elements 2)))
    (if (oddp nr-of-elements)
        (append (list seed)
                (apply 'append (loop for n from 1 to nr-of-loops
                                     collect (list (setf item (funcall fn1 fact1 item))
                                                   (setf item (funcall fn2 fact2 item))))
                       ))
      (butlast (append (list seed)
                       (apply 'append (loop for n from 1 to nr-of-loops
                                            collect (list (setf item (funcall fn1 fact1 item))
                                                          (setf item (funcall fn2 fact2 item))))
                              ))))))


(defun simple-number-series (fn1 fact1 seed nr-of-elements)
  (let ((item seed)
        (nr-of-loops  nr-of-elements))
    (append (list seed)
            (loop for n from 2 to nr-of-loops
                  collect (setf item (funcall fn1 fact1 item)))
            )))


(system::PWGLDef number-ser ((seed 0)
                             (nr-of-elements 10)
                             (fn1  10 (ccl::mk-menu-subview :menu-list '("+" "*")))
                             (fact1 1)
                             &optional
                             (fn2  () (ccl::mk-menu-subview :menu-list '("+" "*")))
                             (fact2 1))
                             
    "Creates a number series of the length nr-of-elements.

Seed is the startingpoint.

fn1 and fact1 defines the step; either the next element is the last plus 
a constant or the last multiplied by a factor

The box can be expanded to alternate between to different steps."
    (:groupings '(2 2)  :x-proportions '((0.5 0.5)(0.5 0.5)) :extension-pattern '(2))
  (if fn2
      (general-number-series fn1 fn2 fact1 fact2 seed nr-of-elements)
    (simple-number-series fn1 fact1 seed nr-of-elements)))


(defun 3term-sum-series (a0 a1 a2 nr-of-elements)
  (let (a3)
    (append (list a0 a1 a2)
            (loop for n from 3 to nr-of-elements
                  collect (progn
                            (setf a3 (+ a0 a1 a2))
                            (setf a0 a1)
                            (setf a1 a2)
                            (setf a2 a3)
                            )
                  ))))


(system::PWGLDef 3sum-number-ser ((a0 0)
                                  (a1 1)
                                  (a2 1)
                                  (nr-of-elements 10))
                             
    "Creates a number series of the length nr-of-elements.

a0, a1 and a2 are the first three numbers

Each following number is the sum of the 3 preceding numbers."
    (:groupings '(4)  :x-proportions '((0.2 0.2 0.2 0.4)) :w 0.5)
  (3term-sum-series a0 a1 a2 nr-of-elements))


(defun shifted-power-number-series (seed b q nr-of-elements)
  (let ((item seed)
        (nr-of-loops  nr-of-elements)
        (bq (* b q)))
    (append (list seed)
            (loop for n from 2 to nr-of-loops
                  collect (progn 
                            (setf item (+ item bq))
                            (setf bq (* bq q))
                            item
                            )))))


(system::PWGLDef geometric-ser2 ((seed 0)
                                 (b 0.5)
                                 (q 1.5)
                                 (nr-of-elements 10))
                             
    "Creates a number series of the length nr-of-elements.

an = a0 + (b x qn)."
    (:groupings '(4)  :x-proportions '((0.2 0.2 0.2 0.2)) :w 0.5)
  (shifted-power-number-series seed b q nr-of-elements))

