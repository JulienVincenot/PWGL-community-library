(in-package :fe)

;; tests below outdated. Necessary changes:
;; - all uccurances of env have been replaced by fenv
;; - linear-env, sin-env, sin-env1 and expon-env are now functions (named with fenv, not env) that expect a list of points
;; - plot is not defined (BPF is used instead)

;
;(defun test1 (x &key (min 0) (max 1))
;  (+ min (* x (- max min))))
;(dotimes (i 11)
;  (print (test1 (* i 0.1) :min -2 :max 1)))
;
;(dotimes (i 11)
;  (print 
;   (funcall (env #'identity :min 0.3 :max 0.7)
;            (* i 0.1))))
;
;(dotimes (i 11)
;  (print
;   (funcall (env1 #'identity :min 0.3 :max 0.7)
;            (funcall (env #'identity :min 0.3 :max 0.7)
;                     (* i 0.1)))))


;; examples
; (ds:make "gnuplot")

(plot (make-env #'sin :min (- pi) :max pi))

(plot
  (funcs->env (list #'identity
		    #'identity
		    #'identity)
	      :min 1 :max 5))

(plot (env-seq (make-env #'sin :max pi)
	   0.1 (make-env #'sin :max pi)
	   0.4 (make-env #'sin :max pi)))

(plot (osciallator (make-env #'identity) 5))
	       
  
(plot (linear-env (0 1) (0.2 3) (0.7 2) (1 -1)))

(plot (linear-env (0 0) (1 2)))

(plot (sin-env (0 1) (0.2 5) (0.3 -2) (0.8 7) (1 1)))

(plot (sin-env (0 1) (0.2 0) (0.3 1) (0.8 0) (1 1)))

(plot (sin-env1 (0 1) (0.2 5) (0.3 -2) (0.8 7) (1 1)))
      
(plot (sin-env1 (0 1) (0.2 0) (0.3 1) (0.8 0) (1 1)))


;; !! not OK yet
(plot (expon-env (0 1) (0.2 5) (0.3 2) (0.8 7) (1 1)))


(plot (combine-envs #'+
		    10
		    (linear-env (0 0) (1 2))
		    (make-env #'sin :max (* pi 2))
		    (make-env #'sin :max pi)))


(plot (linear-env (0 0) (0.7 2) (1 1)))
(plot (reverse-env (linear-env (0 0) (0.7 2) (1 1))))

(plot (saw 3))
(plot (saw1 3 :amplitude 3 :offset 1))

(plot (triangle 3 :amplitude 3 :offset 1))

(plot (square 3 :amplitude 3 :offset 1))

(plot (steps 1 2 3 2 1))

(plot (random-steps 20 :min-y -10 :max-y -1)))

(plot (random-steps 20 :min-y -1 :max-y 3))

(plot (combine-envs #'*
		    (triangle 7)
		    (linear-env (0 0) (0.3 1) (1 0))))


(plot 
 (scale-env 
  (make-env #'(lambda (x)
		(let ((exp 1000))
		  (/ (expt exp x) exp))))
  0.2 0.1))

;;
(let ((env (make-env #'sin :max pi)))
  (plot (mapcar #'(lambda (env2)
		    (waveshape env env2))
		(list
		 (make-env #'identity) ; no waveshaping
		 (make-env #'(lambda (x) (/ (expt 2 x) 32))
			   :min -5 :max 5)
		 (make-env #'cos
			   :max (* pi 0.5))
		 env))))

(plot (rising-expon-env 10))

(plot 
 (scale-env (rising-expon-env 10)
	    3 0.1))

;; convert a fenv into a CM pattern (load in-cm.lisp first)
(gp:plot (next (make-fenv-pattern (fe::sin-env1 (0 0) (0.7 1) (1 0.5))
			 (new cycle of '(20 10)))
	       50))
