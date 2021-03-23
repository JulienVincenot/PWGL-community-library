(in-package :fe)

;; NOTE: these definitions are not used in PWGL, because macros are not required in a visual programming language
;; Therefore, all corresponding functions (e.g., linear-fenv-fn) have been moved into fenv.lisp and renamed into the name previously taken by macros (e.g., linear-fenv).

(defun linear-fenv-fn (points)
  (points->fenv #'(lambda (x1 y1 x2 y2)
			(make-fenv1 #'(lambda (x)
					    (+ (* (- y2 y1) x) y1))
					:min x1 :max x2))
		    points))

(defmacro linear-fenv (&rest points)
  "Defines an fenv which interpolates the given points by a linear function. Expects a list of x-y-pairs as (0 y1) ... (1 yn)"
  `(linear-fenv-fn ',points))

(defun sin-fenv-fn (points)
  (points->fenv #'(lambda (x1 y1 x2 y2)
			(make-fenv1
			 #'(lambda (x)
			     (+ (* (sin (* x pi 0.5)) 
				   (- y2 y1))
				y1))
			 :min x1 :max x2))
		    points))

(defmacro sin-fenv (&rest points)
  "Defines an fenv which interpolates the given points by a sin function. Using only the intervals [0,pi/2] and [pi, 3pi/4] results in edges. Expects a list of x-y-pairs as (0 y1) ... (1 yn)."
  `(sin-fenv-fn ',points))

(defun sin-fenv1-fn (points)
  (points->fenv #'(lambda (x1 y1 x2 y2)
			(make-fenv1
			 #'(lambda (x)
			     (+ (* (+ (* (sin (- (* x pi) (* pi 0.5)))
					 0.5)
				      0.5)
				   (- y2 y1))
				y1))
			 :min x1 :max x2))
		    points))

(defmacro sin-fenv1 (&rest points)
  "Defines an fenv which interpolates the given points by a sin function without clear edges. Expects a list of x-y-pairs as (0 y1) ... (1 yn)."
  `(sin-fenv1-fn ',points))

;; !!! noch voellig falsch: die Steilheit stimmt nicht !!!
(defun expon-fenv-fn (points)
  (points->fenv #'(lambda (x1 x2 y1 y2)
			(make-fenv1 #'(lambda (x)
					    (+ (expt (/ y2 y1) x) y1 -1))
					:min x1 :max x2))
		    points))

(defmacro expon-fenv (&rest points)
  "Defines an envelope described be exponential functions. Expects a list of x-y-pairs as (0 y1) ... (1 yn). y values can not be negative."
  `(expon-env-fn ',points))
