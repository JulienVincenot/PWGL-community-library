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

(eval-when (:load-toplevel :compile-toplevel :execute)
  (defparameter *debug-level* 0
    "Integer indicating level of debug output, the higher the number
the more debug output.")
  #+nil(pushnew :debug *features*))

#+debug
(defmacro dbgformat (level &rest args)
  "Log `args' with `muproc-log-errorstream' iff `*muproc-dedbgformat-level*'
      is not NIL and `level' >= `*muproc-dedbgformat-level*'."
  `(when (and *debug-level* (>= *debug-level* ,level))
     (format t "~&L(~a): ~a~%" ,level (format nil ,@args))))

#-debug
(defmacro dbgformat (level &rest args)
  (declare (ignore level args))
  nil)

;;; pure lisp utils
(declaim (inline mod12))
(defun mod12 (x)
  (mod x 12))

(defun list! (thing)
  (if (listp thing) thing (list thing)))
  
(defmacro if-bind (var test then &optional else)
  (check-type var symbol)
  `(let ((,var ,test))
     (if ,var ,then ,else)))

(declaim (inline diff))
(defun diff (a b)
  (abs (- a b)))

(declaim (inline sqr))
(defun sqr (x)
  (* x x))

(defun x->dx (list)
  "Computes a list of intervals from a list of points.
@lisp
\(x->dx '(3 7 2 12 8))
@end lisp"
  (loop
     for x in list
     for y in (rest list)
     collect (- y x)))

(defun dx->x (start list)
  "Computes a list of points treating LIST as intervals starting from START.
@lisp
\(dx->x 10 '(3 7 2 12 8))
@end lisp"
  (iter
    (when (first-time-p) (collect start))
    (for dx in list)
    (collect (incf start dx))))

(defun make-line-generator (list)
  "Keep on returning the last element."
  #'(lambda ()
      (if (null (cdr list))
          (car list)
	  (pop list))))

(defun make-list-generator (list)
  "Simply return nil if list is finished."
  #'(lambda ()
      (pop list)))

(defgeneric m+ (a b)
  (:method ((a number) (b number))
    (+ a b))
  (:method ((a list) (b number))
    (mapcar #'(lambda (x) (m+ x b)) a)))

(defgeneric m* (a b)
  (:method ((a number) (b number))
    (* a b))
  (:method ((a list) (b number))
    (mapcar #'(lambda (x) (m* x b)) a)))

;;; other utils
(defun event-start (event)
  (abs
   (if (atom event)
       event
       (car event))))

(defun event-rest-p (event)
  (or (minusp (if (atom event)
                  event
		  (car event)))
      (and (consp event)
           (getf (cdr event) :rest))))

;; originally written for simple2score
(defun merge-events (event list merge-marker)
  "Merge list of events into event.
This function does not support an atom number representing an event."
  (assert (not (getf (cdr event) :rest)))
  (setq list (remove-if #'(lambda (x) (getf (cdr x) :rest)) list))
  (let ((event-tied (getf (cdr event) :tied)))
    (cond
      ((null list)
       event)
      (t
       (iter
	 (for field in '(:notes :expressions))
	 (setf (getf (cdr event) field)
	       (delete-duplicates
		(nconc
		 (getf (cdr event) field)
		 (iter
		   (for l in list)
		   (nconcing (getf (cdr l) field))))
		:test #'equal)))
       (setf (getf (cdr event) :notes)
	     (sort (getf (cdr event) :notes) #'< :key #'(lambda (l) (if (atom l) l (first l)))))
       (when (consp (car event))
	 (setf (second (car event))
	       (max
		(second (car event))
		(iter
		  (for l in list)
		  (maximizing (second (car l)))))))
       (when (and merge-marker (not event-tied))
	 (pushnew merge-marker (getf (cdr event) :expressions)))
       event))))

(defvar *simple-hierarchy* '(:score :part :voice :event))
(defvar *simple-reverse-hierarchy* (reverse *simple-hierarchy*))

(defun simple-type* (simple)
  (labels ((event-p (obj)
             (or (numberp obj)
                 (and (consp obj)
                      (numberp (first obj))
                      (keywordp (second obj)))))
           (rec (simple h)
             (assert h nil "Does not seem to be a correct simple obj.")
             (if (event-p simple)
                 (car h)
		 (rec (first simple) (cdr h)))))
    (rec simple *simple-reverse-hierarchy*)))

(defun simple-change-type* (new-type simple)
  (let* ((type (simple-type* simple))
         (type-diff (- (position new-type *simple-reverse-hierarchy*)
                       (position type *simple-reverse-hierarchy*))))
    (cond
      ((zerop type-diff)
       simple)
      ((plusp type-diff)
       (dotimes (i type-diff simple)
	 (setq simple (list simple))))
      (t
       (dotimes (i (abs type-diff) simple)
	 (setq simple (first simple)))))))

(defmacro with-upgrade-to-score ((obj) &body body)
  (assert (symbolp obj))
  `(let* ((orig-type (simple-type* ,obj))
          (,obj (simple-change-type* :score ,obj)))
     (simple-change-type* orig-type (progn ,@body))))

(defun simple-without-starting-rest (simple)
  (if (event-rest-p (first simple))
      (cdr simple)
      simple))

(defun simple-cons-rest-if-needed (simple)
  (if (zerop (event-start (first simple)))
      simple
      (cons '(0 :rest t) (simple-without-starting-rest simple))))

(defun simple-select* (simple from &optional to)
  (labels ((starting-at (voice from)
             (if (<= from (event-start (first voice)))
                 voice
               (starting-at (cdr voice) from))))
    (with-upgrade-to-score (simple)
      (iter
        (for part in simple)
        (for (values voices options) = (extract-options part))
        (collect
         (nconc
          (iter
            (for voice in voices)
            (unless to
              (setq to (event-start (car (last voice)))))
            (setq voice (starting-at voice from))
            (collect
             (iter
               (for event in voice)
               (for start = (event-start event))
               (for rest-p = (event-rest-p event))
               (if-first-time
                (progn
                  (when (or (not (zerop start))
                            rest-p)
                    (collect '(0 :rest t)))
                  (when rest-p
                    (next-iteration))))
               (cond             
                ((< start to)          
                 (collect event))
                (t           
                 (collect to)
                 (terminate))))))
          options))))))

(defun simple-change-event (simple fn)
  (with-upgrade-to-score (simple)
    (iter
      (for part in simple)
      (collect
	  (multiple-value-bind (voices options)
	      (extract-options part)
	    (iter
	      (for voice in voices)	 
	      (for new-voice =
		   (iter
		     (for event-tail on voice)
		     (for event = (car event-tail))
		     (for new-event = (funcall fn event (null (cdr event-tail))))
		     (when new-event (collect new-event))))	 
	      (setq new-voice (sort new-voice #'< :key #'event-start))
	      (unless (zerop (event-start (first new-voice)))
		(push '(0 :rest t) new-voice))
	      (collect new-voice into new-voices)
	      (finally (return (nconc new-voices options)))))))))

(defun simple-change-start (simple fn)
  (simple-change-event
   simple
   #'(lambda (event end-p)
       (let* ((rest-p (event-rest-p event))
              (new-start (funcall fn (event-start event) rest-p)))
         (when (<= 0 new-start)
           (cond
	     (rest-p
	      (if (zerop new-start)
		  '(0 :rest t)
		  (* -1 new-start)))
	     ((atom event)
	      new-start)
	     (t
	      (cons new-start (cdr event)))))))))

(defun simple-length (simple &optional ignore-last-rest)
  (iter
    top
    (for part in (simple-change-type* :score simple))
    (for (values voices options) = (extract-options part))
    (iter
      (for voice in voices)
      (for before-last-tail = (last voice 2))
      (for before-last = (car before-last-tail))
      (for last = (second before-last-tail))
      (in top (maximizing (event-start (if (and ignore-last-rest
                                                (event-rest-p before-last))
                                           before-last
					   last)))))))

(defun simple-shift* (simple delta)
  (simple-change-start simple #'(lambda (start rest-p) (+ start delta))))

(defun simple-scale* (simple factor)
  (simple-change-start simple #'(lambda (start rest-p) (* start factor))))

(defun simple-transpose* (simple transp)
  (simple-change-event
   simple
   #'(lambda (event end-p)
       (if (or end-p (event-rest-p event))
           event
	   (let ((event (copy-tree
			 (if (atom event)
			     `(,event :notes (60))
			     event))))
	     (setf (getf (cdr event) :notes)
		   (m+ (getf (cdr event) :notes) transp))
	     event)))))

(defun simple-enharmonic* (simple model-score)
  (labels ((spelling-alist (score)
             (let ((voice (simple-change-type*
                           :voice (typecase score
                                    (ccl::enp-application-window (score2simple score))
                                    (t score)))))
               (apply #'append (mapcar (lambda (event) (mapcar #'list! (getf (cdr event) :notes)))
                                       (remove-if #'atom voice)))))
           (lookup-spelling (pitch spelling-alist)
             (getf (cdr (assoc (mod12 pitch) spelling-alist :key #'mod12)) :enharmonic)))
    (let ((spelling-alist (spelling-alist model-score)))
      (simple-change-event
       simple
       #'(lambda (event end-p)
           (if (or end-p (event-rest-p event))
               event
               (let ((event (copy-tree
                             (if (atom event)
                                 `(,event :notes (60))
                                 event))))
                 (setf (getf (cdr event) :notes)
                       (loop for pitch in (getf (cdr event) :notes)
                          for enharmonic = (lookup-spelling pitch spelling-alist)
                          if enharmonic
                          collect `(,pitch :enharmonic ,enharmonic)
                          else collect `(,pitch)))
                 event)))))))

(defun simple-append* (ignore-last-rest &rest simples)
  (let ((new (list :score)))
    (labels ((get-nth (n list type)
	       (if-bind it (nth n (cdr list))
		 it
		 (if-bind it (nthcdr n list)
		   (cadr (rplacd it (list (list type))))
		   (error "The ~A before n ~S does not yet exist." type n))))
	     (delete-tags (list)
	       (if (and (consp list)
			(keywordp (car list)))
		   (map-into (cdr list) #'delete-tags (cdr list))
		   list))
	     (delete-second (list)
	       (rplacd list (nthcdr 2 list)))
	     (nconc-nbutlast (a b)
	       "(nconc (nbutlast a) b)"
	       (rplacd (last a 2) b)
	       a))
      (iter    
        (with start = 0)
        (for simple in simples)    
        (for shifted = (simple-shift* simple start))
	(iter
	  (for part in shifted)
	  (for partind upfrom 0)
	  (for (values voices options) = (extract-options part))
	  (for new-part = (get-nth partind new :part))
	  (iter
	    (for voice in voices)
	    (for voiceind upfrom 0)	    
	    (for new-voice = (get-nth voiceind new-part :voice))
	    (if (cdr new-voice)
		(setf (cdr new-voice) (nconc-nbutlast (cdr new-voice) (cdr voice)))
		(setf (cdr new-voice) (nconc (cdr new-voice)
					     (if (and (event-rest-p (first voice))
						      (event-rest-p (second voice)))
						 (delete-second voice)
						 voice))))))
        (incf start (simple-length simple ignore-last-rest))
	(finally (return (delete-tags new)))))))

(defun simple-merge* (simple1 simple2 &optional strict-durations)
  (let ((simple1 (simple-change-type* :voice simple1))
        (simple2 (simple-change-type* :voice simple2))
        res)
    (labels ((add (obj)
               (push obj res))
             (swap-last (last)
               (case last
                 (first 'second)
                 (second 'first)
                 (otherwise last)))
             (rec (s1 s2
                      ;; can be rest, first, second, equal, or nil....
                      ;; for a pause, note from first, note from second, or merged from both, or unknown
                      last 
                      )
               (cond
		 ((and (null s1) (null s2))) ; noop
		 ((null s1)
		  (unless (and (or (event-rest-p (car s2))
				   (null (cdr s2)))
			       (eql last 'rest))
		    (add (car s2)))
		  (dolist (e (cdr s2))
		    (add e)))
		 ((null s2)
		  (rec s2 s1 (swap-last last)))
		 (t
		  (let* ((s1-elt (car s1))
			 (s2-elt (car s2))
			 (s1-start (event-start s1-elt))
			 (s2-start (event-start s2-elt))
			 (s1-rest-p (if (null (cdr s1))
					(progn
					  (setq s1-elt (* -1 (event-start s1-elt)))
					  t)
					(event-rest-p s1-elt)))
			 (s2-rest-p (if (null (cdr s2))
					(progn
					  (setq s2-elt (* -1 (event-start s2-elt)))
					  t)
					(event-rest-p s2-elt))))
		    (cond
		      ((= s1-start s2-start)
		       (cond
			 ((and s1-rest-p s2-rest-p)
			  (unless (eql last 'rest)
			    (add s1-elt))
			  (rec (cdr s1) (cdr s2) 'rest))
			 (s1-rest-p
			  (add s2-elt)
			  (rec (cdr s1) (cdr s2) 'second))
			 (s2-rest-p
			  (rec s2 s1 (swap-last last)))
			 (t
			  (let ((one s1-elt)
				(two s2-elt))
			    (when (atom one)
			      (setq one `(,one :notes (60))))
			    (when (atom two)
			      (setq two `(,two :notes (60))))
			    (add (merge-events (copy-tree one) (list (copy-tree two)) nil))
			    (rec (cdr s1) (cdr s2) 'equal)))))
		      ((< s1-start s2-start)
		       (cond
			 ((not s1-rest-p)
			  (add s1-elt)
			  (rec (cdr s1) s2 'first))
			 ((or (eql last 'first)
			      (and strict-durations (eql last 'equal)))                       
			  (add s1-elt)
			  (rec (cdr s1) s2 'rest))
			 (t
			  (rec (cdr s1) s2 last))))
		      (t (rec s2 s1 (swap-last last)))
		      ))))))
      (rec simple1 simple2 nil)
      (setf (car res) (abs (car res)))	; dont need a minus at the end
      (nreverse res))))

(defun pitches-durs2simple* (pitches durs)
  (iter
    (with time = 0)
    (with pitches = (list! pitches))
    (with durs = (list! durs))
    (with p-gen = (make-line-generator pitches))
    (with d-gen = (make-line-generator durs))
    (with num-events = (max (length pitches) (length durs)))
    (for i from 1 to num-events)
    (for d = (funcall d-gen))
    (for rest-p = (minusp d))
    (if rest-p
        (collect (if (zerop time) '(0 :rest t) (* -1 time)))
	(collect (copy-list `(,time :notes ,(list! (funcall p-gen))))))
    (incf time (abs d))
    (when (= i num-events)
      (collect time))))

(defun simple2pitches-durs* (simple)
  (iter
    (for nevent in (simple-change-type* :voice simple))
    (for event previous nevent)
    (unless event (next-iteration))
    (for rest-p = (event-rest-p event))
    (for offset = (- (event-start nevent) (event-start event)))
    (unless rest-p
      (collect (if (atom event)
                   (copy-list '(60))
		   (getf (cdr event) :notes))
	into pitches))    
    (collect (if rest-p (* -1 offset) offset) into durs)
    (finally (return (values pitches durs)))))

