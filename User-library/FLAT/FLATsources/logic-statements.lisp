(in-package studioflat)

(system::PWGLDef all-diff? ((list nil))
    "Test that all elements in a list are unique"
    ()
  (cond ((null list) t)
        ((member (car list) (cdr list) :test #'equal) nil)
        (t (all-diff? (cdr list)))))


(system::PWGLDef within-deviation? ((value 0)(tolerance 0)(x 0))
    "Test that a value doesn't exceed maximum deviation from x."
    (:groupings '(3)  :x-proportions '((0.3 0.15 0.3)))
  (cond ((> value (+ x tolerance)) nil)
        ((< value (- x tolerance)) nil)
        (t t)))