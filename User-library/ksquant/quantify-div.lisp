;;; -*- Mode: LISP; Syntax: COMMON-LISP; Package: KSQUANT; Base: 10 -*-

;;; Copyright (c) 2007, Kilian Sprotte.  All rights reserved.

;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:

;;;   * Redistributions of source code must retain the above copyright
;;;     notice, this list of conditions and the following disclaimer.

;;;   * Redistributions in binary form must reproduce the above
;;;     copyright notice, this list of conditions and the following
;;;     disclaimer in the documentation and/or other materials
;;;     provided with the distribution.

;;; THIS SOFTWARE IS PROVIDED BY THE AUTHOR 'AS IS' AND ANY EXPRESSED
;;; OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
;;; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
;;; GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
;;; WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

(in-package :ksquant)

(defvar *quant-max-div*)
(defvar *quant-forbidden-divs*)
(defvar *quant-forbidden-patts*)
(defconstant +quant-forbidden-error+ 1000)

(defun closest-unit (ratio unit)
  (* (round (/ (* (/ (denominator unit) (denominator ratio))
		  (numerator ratio))
	       (numerator unit)))
     unit))

(defun evaluate-div (notated-dur-points unit)
  (iter
    (for point in notated-dur-points)
    (for closest-unit = (closest-unit point unit))
    (for diff = (sqr (diff (float closest-unit) (float point))))
    (sum diff into error)
    (collect closest-unit into new-points)
    (finally (return
	       (if (member (x->dx new-points) *quant-forbidden-patts* :test #'equal)
		   +quant-forbidden-error+
		   error)))))

(defun quantify-durs (div-notated-dur notated-durs)
  ;; (assert (= (apply #'+ notated-durs) div-notated-dur) nil
  ;; 	  "The sum of notated-durs should be = to div-notated-dur.
  ;; TODO Maybe this assertion is not correct, I wanted to find out,
  ;; this is a case that speaks against it.")
  (let* ((notated-dur-points (dx->x 0 notated-durs))
	 (quant-div
	  (iter
	    ;; this loop cycles through all possible
	    ;; divisions and evaluates the associated
	    ;; error, the division with the minimum
	    ;; error is returned
	    (for d from 2 to *quant-max-div*)
	    (when (member d *quant-forbidden-divs*)
	      (next-iteration))
	    (for unit = (/ div-notated-dur d))
	    (for error = (evaluate-div notated-dur-points unit))
	    (finding d minimizing error)))
	 (tuplet-ratio
	  (div2tuplet-ratio div-notated-dur quant-div 'down quant-div))) ; TODO prop arg!! - was 'msym:down
    (iter
      (with unit = (/ div-notated-dur quant-div))
      (with fact = (mr2r tuplet-ratio))
      (for point in notated-dur-points)
      (collect (* (closest-unit point unit) fact) into new-points)
      (finally (return (values (x->dx new-points) tuplet-ratio))))))

(defun change-proportionally (orig new change)
  (iter
    (for o in orig)
    (for n in new)
    (for c in change)
    (collect (* c (/ n o)))))

;; (defun calc-merge-list (durs)
;;   (iter
;;     (with i = 0)
;;     (for d in durs)
;;     (collect i)
;;     (if (zerop d)
;;         (error "needing to merge attacks")
;;	(incf i))))

(defun calc-merge-list (durs)
  "@lisp
\(calc-merge-list '(1 2 0 0 2 1 1))
@end lisp"
  (iter
    (with merge-stack)
    (for i upfrom 0)
    (for d in durs)
    (if (zerop d)
	(push i merge-stack)
	(if merge-stack
	    (progn
	      (push i merge-stack)
	      (collect (nreverse merge-stack) into merge-list)
	      (setq merge-stack nil))
	    (collect i into merge-list)))
    (finally (return (values merge-list (nreverse merge-stack))))))



;; #|
;; (defun quantify-div (div-dur children-durs children-notated-durs)
;;   (let (new-children-dur tuplet-ratio)
;;     (iter
;;       (for notated-dur in children-notated-durs)
;;       (for denom = (denominator notated-dur))
;;       (reducing denom by #'lcm into common-denom)
;;       (finally (setq new-children-dur
;;                      (denominator
;;                       (/ (/ 1 common-denom)
;;                          div-dur)))))
;;     (setq tuplet-ratio (div2tuplet-ratio div-dur new-children-dur))
;;     (iter
;;       (with fact = (mr2r tuplet-ratio))
;;       (for notated-dur in children-notated-durs)
;;       (for dur in children-durs)
;;       (collect (* notated-dur fact) into notated-durs-bag)
;;       (collect (* dur fact) into durs-bag)
;;       (finally (setq children-durs durs-bag
;;                      children-notated-durs notated-durs-bag)))
;;     (values tuplet-ratio children-durs children-notated-durs)))
;; |#

(export 'quantify-div)
(defun quantify-div (div-notated-dur children-durs children-notated-durs)
  "Returns: @code{tuplet-ratio}, @code{quant-durs}, @code{quant-notated-durs},
@code{merge-list}, @code{next-div}.

The following example shows the quantification of a 9-tuplet:
@lisp
\(quantify-div 1/4
	      '(1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9)
	      '(1/36 1/36 1/36 1/36 1/36 1/36 1/36 1/36 1/36))
@end lisp"
  (multiple-value-bind (quant-notated-durs tuplet-ratio)
      (quantify-durs div-notated-dur children-notated-durs)
    (let ((quant-durs (change-proportionally children-notated-durs quant-notated-durs children-durs)))
      (multiple-value-bind (merge-list next-div)
	  (calc-merge-list quant-notated-durs)
	(setq quant-durs (delete 0 quant-durs))
	(setq quant-notated-durs (delete 0 quant-notated-durs))
	(values tuplet-ratio quant-durs quant-notated-durs merge-list next-div)))))


(export 'quantify-set-prefs)
(defun quantify-set-prefs (&key
			   (max-div nil max-div-supplied)
			   (forbidden-divs nil forbidden-divs-supplied)
			   (forbidden-patts nil forbidden-patts-supplied))
  "Change those quantify-settings that are supplied
in key args."
  (when max-div-supplied
    (setq *quant-max-div* max-div))
  (when forbidden-divs-supplied
    (setq *quant-forbidden-divs* forbidden-divs))
  (when forbidden-patts-supplied
    (setq *quant-forbidden-patts* forbidden-patts))
  t)

(export 'quantify-set-defaults)
(defun quantify-set-defaults ()
  "@lisp
\(quantify-set-defaults)
*quant-max-div*

*quant-forbidden-divs*

\(pprint *quant-forbidden-patts*)
@end lisp"
  (setq *quant-max-div* 8)
  (setq *quant-forbidden-divs* '(7))
  (setq *quant-forbidden-patts* '((1/16 3/32 3/32) (3/32 1/16 3/32) (5/32 3/32) (3/32 5/32)				  
				  (1/16 5/32 1/32)
				  (1/32 5/32 2/32)))
  t)

;; set them now!!
(quantify-set-defaults)

;;; quantify 2

(defun closest-unit2 (point-list unit)
  (destructuring-bind (point &optional start) point-list
    (let ((new-point (* (round point unit) unit)))
      (when (and start (= new-point (* (round start unit) unit)))
	(incf new-point unit))
      new-point)))

(defun evaluate-div2 (points unit div-start div-notated-dur)
  "POINTS here can be atoms, which means there
are not constrained, or a list of two elems:
\(end start) where end should be quantized while
ensuring that is does not get equal to start and
thus resulting in a dur of 0."
  ;; TODO *quant-forbidden-patts*
  ;; what about patterns that are tied over?
  ;; should they be treated the same?
  (flet ((m/ (list x)
           (mapcar #'(lambda (a) (/ a x)) list)))
    (iter
      (for point in points)
      (for pointl = (list! point))
      (for closest-unit = (closest-unit2 pointl unit))
      (for diff = (sqr (diff (float closest-unit) (float (car pointl)))))
      (sum diff into error)
      (collect closest-unit into new-points)
      (finally (return
		 ;; we can destroy new-points here
		 (if (member (m/ (x->dx (sort (delete-duplicates (cons (+ div-start div-notated-dur)
								       new-points)) #'<)) 4)
			     *quant-forbidden-patts* :test #'equal)
		     +quant-forbidden-error+
		     error))))))

(export 'quantify2)
(defun quantify2 (points div-start div-notated-dur)
  "POINTS here can be atoms, which means there
are not constrained, or a list of two elems:
\(end start) where end should be quantized while
ensuring that is does not get equal to start and
thus resulting in a dur of 0.

The frame that is quantized should start at DIV-START
\(even if there is no point) and continue over a period
of DIV-NOTATED-DUR.

The same preferences as for QUANTIFY-DIV are used.

@lisp
\(quantify2 '(0 0.3 0.6 0.999) 0 1)
\(quantify2 '(1 1.3 1.6 1.999) 1 1)
@end lisp"
  (when points
    (let ((quant-div
	   (iter
	     ;; this loop cycles through all possible
	     ;; divisions and evaluates the associated
	     ;; error, the division with the minimum
	     ;; error is returned
	     (for d from 2 to *quant-max-div*)
	     (when (member d *quant-forbidden-divs*)
	       (next-iteration))
	     (for unit = (/ div-notated-dur d))
	     (for error = (evaluate-div2 points unit div-start div-notated-dur))
	     ;; TODO if error is equal, we should prefer
	     ;; the smaller division
	     (finding d minimizing error))))
      (iter
	(with unit = (/ div-notated-dur quant-div))
	(for point in points)
	(collect (closest-unit2 (list! point) unit))))))
