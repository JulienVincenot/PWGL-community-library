(in-package :GeneticAlgorithm)

;;; just write as much plain lisp as you want
(defun a-convential-lisp-function ()
  (print "any lisp code can go here"))

;; ...

;;; you can also define macros

;; just make sure that this file
;; is listed before the file where
;; those macros are actually used
;; in the ASDF system definition file
(defmacro incr (symb)
  `(setf ,symb (+ ,symb 1))) 

(defmacro decr (symb)
  `(setf ,symb (- ,symb 1)))

(defmacro newr (place item) 
  `(if ,place
       (nconc  ,place (list ,item))
       (setf ,place (list ,item))))


;;; test
;; (let ((z 0)) (dotimes (i 10) (print (incr z))) z)
;; (let ((z ())) (dotimes (i 10) (newr z i)) z)
