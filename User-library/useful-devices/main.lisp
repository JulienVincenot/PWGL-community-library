;;; arch-tag: 74C791DD-1BA0-1213-E4914C871761

;;; Copyright (c) 2007, Jacopo Baboni Schilingi.  All rights reserved.
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

(in-package :useful-devices)

(define-menu useful-devices)

;; lists
(define-menu lists :in useful-devices)
(in-menu lists)

(define-box scale-by-sum ((list (1 2 3)) (sum 10))
  (let ((factor (/ sum (apply #'+ list))))
    (mapcar #'(lambda (x) (* x factor)) list)))

(define-box synchronize-lengths ((list-a (1 2 3)) (list-b (a b c d))
				 (mode min))
  :outputs 2
  :menu (mode min max)
  (case mode
    (min (loop for a in list-a
	    for b in list-b
	    collect a into new-a
	    collect b into new-b
	    finally (return (values new-a new-b))))
    (max (error "Sorry, the mode max in synchronize-lengths is not impl yet."))))

;; (om::defmethod! cmi::circular-lists-reading ((list-1 list) (list-2 list))
;;   "If list-1 is shorter than list-2, so list-1 is reded in a circular way in order to incerase
;; its length to be identical to list-2."
  
;;   :initvals '('(a b c) '(1 2 3 4 5 6 7 8 9))
;;   :icon 782

;;   (let ((ros nil))
;;     (dotimes (y (length list-2) (nreverse ros))
;;       (push 
;;        (if (< (length list-1) (length list-2))
;;          (nth 
;;           (mod y (length list-1))
;;           list-1)
;;          (nth y list-1)) ros))))

(define-box first-n ((list (1 2 3)) (n 2))
  (subseq list 0 (min (length list) n)))

(define-box last-n ((list (1 2 3)) (n 2))
  (subseq list (max 0 (- (length list) n))))

(define-box member-in-sublists? ((item-or-items (b c)) (lists ((a b c d) (b c d e))) (mode every))  
  :menu (mode every some notevery notany)
  (let* ((items (if (listp item-or-items) item-or-items (list item-or-items)))
	 (predicate #'(lambda (list) (subsetp items list))))
    (ecase mode
      (every (every predicate lists))
      (some (some predicate lists))
      (notevery (notevery predicate lists))
      (notany (notany predicate lists)))))

(define-box segment-by-length ((list (1 2 3 4 5)) (num-or-nums (2 3)) (mode :linear))
  "Segments LIST by NUM-OR-NUMS, which can be one
number or a list of numbers.

If the mode is :linear, the process stops, when the LIST
is finished or when the groups are finished.
If the mode is :circular, the process only stops,
when the groupings are finished. The LIST is read in
circular manner, if needed."
  :menu (mode :linear :circular)
  (let ((orig-list list))
    (unless (listp num-or-nums) (setq num-or-nums (list num-or-nums)))
    (labels ((next-item ()
	       (if list
		   (pop list)
		   (case mode
		     (:circular
		      (setq list orig-list)
		      (pop list))
		     (:linear nil)))))
      (loop for n in num-or-nums
	 for ni = (loop repeat n
		     for ni = (next-item)
		     while ni
		     collect ni)
	 while ni
	 collect ni))))

;; combinatorial
(define-menu combinatorial :in useful-devices)
(in-menu combinatorial)

(define-box all-permutations ((list (1 2 3)))
  :non-generic t
  (cond ((cdr list)
	 (let ((element (car list))
	       (len (length (cdr list)))
	       (result ())
	       c-list)
	   (dolist (perm (all-permutations (cdr list)))
	     (push (cons element perm) result)
	     (dotimes (i len)
	       (setf c-list (copy-list perm))
	       (psetf (nth i c-list) element ; Exchange 1st and Ith element
		      element (nth i c-list))
	       (push (cons element c-list) result)
	       (setf element (nth i c-list))))
	   result))
	(T (list list))))

;; all-rotations
(defun permut-circn (list &optional (nth 1))
  (when list
    (let ((length (length list)) n-1thcdr)
      (setq nth (mod nth length))
      (if (zerop nth) list
          (prog1
	      (cdr (nconc (setq n-1thcdr (nthcdr (1- nth) list)) list))
            (rplacd n-1thcdr ()))))))

(defun rotate (list &optional (nth 1))
  "Returns a circular permutation of a copy of <list> starting from its <nth> 
element"
  (permut-circn (copy-list list) nth))

(define-box all-rotations ((list (1 2 3)))
  (loop for x from 0 to (1- (length list))
     collect (rotate list x)))

(defun fcomb (list n function)
  (let ((choice (make-list n)))
    (labels ((fcomb-1 (choices c-length tail t-length)
               (cond 
		 ((null tail) (funcall function choice))
		 ((>= c-length t-length)
		  (loop for l on choices
		     for i from c-length downto t-length
		     do (setf (car tail) (car l))
		     do (fcomb-1 (cdr l) (1- i) (cdr tail) (1- t-length))))))) 
      (fcomb-1 list (length list) choice n))))

(define-box all-combinations ((list (a b c d)) (num 2))
  (let ((choices nil))
    (fcomb list num #'(lambda (choice)
			(push (copy-list choice) choices)))
    choices))

(install-menu useful-devices)


(define-box bidon2 ())