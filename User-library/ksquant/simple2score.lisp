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

(defun extract-options (list)
  (iter
    (with collecting-options)
    (for elt in list)
    (when (and (not collecting-options)
               (keywordp elt))
      (setq collecting-options t))
    (if collecting-options
        (collect elt into options)
	(collect elt into children))
    (finally (return (values children options)))))

;;; enp-voice-maker
(defmacro push-at-end (value place)
  `(setf ,place (nconc ,place (list ,value))))

(defclass enp-voice-maker ()
  ((voice :accessor voice :initform nil)
   (stack :accessor stack :initform nil)))

;; TODO use this for measure too
(defun append-to-current (vm obj &key notated-dur type)
  (let ((container-type (getf (first (stack vm)) :type))
	(container-obj (getf (first (stack vm)) :obj)))
    (ecase container-type
      (:measure
       (let ((pos (position-if #'keywordp container-obj)))
	 (if (zerop pos)
	     (rplaca container-obj obj)
	     (rplacd (nthcdr (1- pos) container-obj)
		     (cons obj (nthcdr pos container-obj))))))
      (:beat
       (push-at-end obj (second container-obj))))
    (unless (eql type :event)
      (push (list :obj obj :space notated-dur :notated-dur notated-dur :type type)
	    (stack vm)))))

(defun finish-containers-if-needed (vm)
  (dbgformat 1 "finish-containers-if-needed")
  (let ((stack (stack vm)))
    (unless (and stack (zerop (getf (first stack) :space)))
      (if (null stack)
	  (dbgformat 3 "  not needed, stack is null")
	  (dbgformat 3 "  not needed, space is ~s"
		     (getf (first stack) :space))))
    (when (and stack (zerop (getf (first stack) :space)))
      (let ((current (pop (stack vm))))
	(when (eql (getf current :type) :measure)
	  (dbgformat 3 "  nothing to do for ~s" (getf current :type)))
	(unless (eql (getf current :type) :measure)
	  (let* ((obj (getf current :obj))
		 ;; TODO dont use apply here but reducing
		 (factor (apply #'lcm
				(loop
				   for item in (second obj)
				   for notated-dur = (first item)
				   collect (denominator notated-dur)))))
	    (dbgformat 3 "  dealing with ~s, factor: ~s" obj factor)
	    (loop
	       for item in (second obj)
	       do (setf (first item) (* factor (first item)))
	       when (atom (second item)) ; its an event...
	       do (let ((tied (getf (cdr item) :tied))
			(rest (getf (cdr item) :rest)))
		    (remf (cdr item) :tied)
		    (remf (cdr item) :rest)
		    (when tied (setf (first item) (float (first item))))
		    (when rest
		      (setf (first item) (* -1 (first item)))
		      (unless (getf (cdr item) :notes)
			(setf (getf (cdr item) :notes) (copy-list '(60)))))))
	    (dbgformat 3 "  resulting in ~s" obj)))
	(finish-containers-if-needed vm)))))

(defmethod add-measure ((vm enp-voice-maker) ts metro)
  (dbgformat 1 "adding measure of ts ~s metro ~s" ts metro)
  (flet ((empty-measure (ts)
	   (copy-tree `(:start :time-signature ,ts :metronome ,metro))))
    (with-accessors ((stack stack)) vm
      (assert (null stack) nil
	      "The previous measure is not filled yet.")
      (let ((mes (empty-measure ts))
	    (notated-dur (/ (first ts) (second ts))))
	(push-at-end mes (voice vm))
	(push (list :space notated-dur
		    :obj mes
		    :type :measure
		    :notated-dur notated-dur)
	      stack)))))

(defmethod add-beat ((vm enp-voice-maker) notated-dur)
  (dbgformat 1 "adding beat of notated-dur ~s" notated-dur)
  (let ((current (first (stack vm))))
    (assert (<= notated-dur (getf current :space)) nil
	    "There is not sufficient space for beat of dur ~S (in floats ~s).
The space left in the current container is ~s (in floats ~s)."
	    notated-dur (float notated-dur)
	    (getf current :space) (float (getf current :space)))
    (decf (getf current :space) notated-dur)
    (let ((dur (if (eql (getf current :type) :measure)
		   (let ((ts (second (member :time-signature (getf current :obj)))))
		     ;; (assert (let ((d (/ (getf current :notated-dur)
		     ;;					 notated-dur)))
		     ;;			       (and (integerp d) (<= d (first ts))))
		     ;;			     nil
		     ;;			     "The notated-dur of beat is not a possible div of measure.")
		     (* (numerator notated-dur)
			(/ (second ts) (denominator notated-dur))))
		   notated-dur)))
      (append-to-current vm (copy-tree `(,dur nil)) :notated-dur notated-dur :type :beat))))

(defmethod add-event ((vm enp-voice-maker) event)
  (dbgformat 1 "adding event ~s" event)
  (destructuring-bind (notated-dur &rest event-plist) event
    (let ((current (first (stack vm))))
      (assert (<= notated-dur (getf current :space)) nil
	      "There is not sufficient space.")
      (decf (getf current :space) notated-dur)
      (append-to-current vm (cons notated-dur event-plist) :type :event)
      (finish-containers-if-needed vm))))

(defmethod state ((vm enp-voice-maker))
  (copy-list `(:voice ,(voice vm) :stack ,(stack vm))))

(defmethod (setf state) (value (vm enp-voice-maker))
  (setf (voice vm) (getf value :voice))
  (setf (stack vm) (getf value :stack)))

;; test
;; (defparameter e (make-instance 'enp-voice-maker))

;; (add-measure e '(2 4))
;; (add-beat e 1/4)
;; (add-event e '(1/12 :notes (60 67)))
;; (add-event e '(1/12 :notes (60 67) :tied t))
;; (add-event e '(1/12 :rest t))
;; (add-beat e 1/4)
;; (add-event e '(1/8 :notes (62)))
;; (add-event e '(1/8 :notes ((63 :enharmonic :flat :expressions (:accent)))))

;; (add-measure e '(2 4))
;; (add-beat e 1/4)
;; (add-event e '(1/12 :notes (60 67)))
;; (add-event e '(1/12 :notes (60 67) :tied t))
;; (add-event e '(1/12 :rest t))
;; (add-beat e 1/4)
;; (add-event e '(1/8 :notes (62)))
;; (add-event e '(1/8 :notes ((63 :enharmonic :flat :expressions (:accent)))))

;;; END enp-voice-maker


;;; input-stream

(defclass input-stream ()
  ((input :accessor input :initform nil :initarg :input)
   (scale :accessor scale :initform 1 :initarg :scale)))

(defun token-start (token)
  (let ((f (first token)))
    (if (atom f)
	f
	(car f))))

(defun token-end (token)
  (let ((f (first token)))
    (assert (consp f))
    (second f)))

(defun read-next-token (s)
  (let ((token (pop (input s))))
    (unless (null (input s))		; last is only end marker
      (let ((end (if (atom (car (input s)))
		     (car (input s))
		     (let ((x (caar (input s))))
		       (if (consp x)
			   (car x)
			   x))))
	    (scale (scale s)))
	(assert (not (null end)))
	(setq end (rationalize (* scale (abs end))))
	(if (numberp token)
	    (if (minusp token)
		(copy-tree `((,(rationalize (* scale (abs token))) ,end) :rest t :notes (60)))
		(copy-tree `((,(rationalize (* scale token)) ,end) :notes (60))))
	    (if (consp (first token))
		token
		(cons (list (rationalize (* scale (first token))) end)
		      (cdr token))))))))

(defun event-change-for-tie (event)
  (remf (cdr event) :expressions)
  (setf (getf (cdr event) :tied) t))

(defun frame-concat-rests (frame)
  (iter
    (for token-tail initially frame then (progn (pop frame) frame))
    (while token-tail)
    (for token = (car token-tail))
    (for ((from to) . options) = token)
    (declare (ignorable to))
    (for rest = (getf options :rest))
    ;; (break "~s rest: ~s" token rest)
    (cond
      ;; we only care about rests
      ((not rest)
       ;; (break "we only care about rests")
       (collect token))
      ;; we are looking for consecutive rests
      ((progn
	 ;; (break "~s" token-tail)
	 ;; 	 (break "(null (cdr token-tail)) ~s" (null (cdr token-tail)))
	 ;; 	 (break "(not (getf (cdr (second token-tail)) :rest)) ~s" (not (getf (cdr (second token-tail)) :rest)))
	 (or (null (cdr token-tail))
	     (not (getf (cdr (second token-tail)) :rest))))
       ;; (break "we are looking for consecutive rests")
       (collect token))
      ;; this one and (at least) the next one is a rest
      (t       
       (pop frame)
       ;; (break "this one and the next one is a rest")
       (collect
	(iter
	  (while (and (car frame)
		      (getf (cdr (car frame)) :rest)))
	  (for last-rest-token = (pop frame))	  
	  (finally
	   ;; (break "we are collecting: ~s" (cons (list from (second (car last-rest-token)))
	   ;; 							options))
	   ;; (break "frame is now: ~s" frame)
	   (push last-rest-token frame)
	   (return (cons (list from (second (car last-rest-token)))
			 options)))))))))

(defmethod next-frame ((s input-stream) from to)
  (let* ((frame (iter
		  (for token = (read-next-token s))
		  (when (and (first-time-p) token) (assert (= (token-start token) from)))
		  (until (or (null token) (>= (token-start token) to)))
		  (collect token)
		  (finally (when token (push token (input s))))))
	 (last (car (last frame))))
    (when (and frame (< (token-end last) to))
      (setq last (copy-tree `((,(token-end last) ,to) :rest t :notes (60))))
      (setq frame (nconc frame (list last))))    
    (cond
      ((null frame)
       (copy-tree `(((,from ,to) :rest t :notes (60)))))
      (t (when (> (token-end last) to)
	   (let ((copy (copy-tree last)))
	     (setf (second (first last)) to)
	     (setf (first (first copy)) to)
	     (event-change-for-tie copy)
	     (when (null (input s))
	       ;; since the last elt will be ignored
	       ;; we push our end time here
	       (push (second (first copy)) (input s)))
	     (push copy (input s))))
	 ;; (setq frame (frame-concat-rests frame))
	 frame))))

(defmethod state ((s input-stream))
  (copy-list `(:input ,(input s) :scale ,(scale s))))

(defmethod eoi-p ((s input-stream))
  (null (input s)))


;; test
;; (defparameter i (make-instance 'input-stream :input '(0
;;						      -1/4
;;						      (1/2 :notes (63) :expressions (:staccato))
;;						      3/2
;;						      -4
;;						      5)))
;; (print (next-frame i 0 1))
;; (print (next-frame i 1 2))
;; (print (next-frame i 2 3))
;; (print (next-frame i 3 4))
;; (print (next-frame i 4 5))
;; (print (next-frame i 5 6))
;; (print (next-frame i 5 7))

;;; simple2enp
(defun time-signature2beats (ts)
  (if (consp ts)
      (time-signature2beats (/ (first ts) (second ts)))
      (if (zerop ts)
	  nil
	  (let ((beat (min 1/4 ts)))
	    (cons beat (time-signature2beats (- ts beat)))))))


(defun simple-voice-gq (simple)
  (let* ((voices (pw::gquantify
		  (list
		   (x->dx
		    (iter
		      (for e in simple)
		      (if (listp e)
			  (collect (abs (first e)))
			  (collect (abs e))))))))
	 (voice (first voices)))
    (iter
      (for e in simple)
      (for qx in (nconc (mapcar #'ccl::start-time
				(ccl::collect-enp-objects voice :chord :no-rest-p nil :no-tied-p nil))
			(last simple)))
      (if (listp e)
	  (collect (cons (if (minusp (car e))
			     (* -1 qx)
			     qx)
			 (cdr e)))
	  (collect (* (signum e) qx))))))

(defun simple2voice (simple &key
		     (time-signatures (list 4 4))
		     (metronomes (list 4 60))
		     (scale 1)
		     (max-div 8)
		     (forbidden-divs (list 7))
		     (forbidden-patts nil)
		     (merge-marker :bartok-pizzicato))
  ;; (with-open-file (*standard-output* "/tmp/ksquant.txt" :direction :output
  ;; 				     :if-exists :append
  ;; 				     :if-does-not-exist :create)
  ;;     (flet ((quote-if-needed (obj)
  ;; 	     (if (ccl::self-evaluate-p obj)
  ;; 		 obj
  ;; 		 `(quote ,obj))))
  ;;       (let ((*package* (find-package :ksquant)))
  ;; 	(pprint `(simple2voice ,(quote-if-needed simple)
  ;; 			       :time-signatures ,(quote-if-needed time-signatures)
  ;; 			       :metronomes ,(quote-if-needed metronomes)
  ;; 			       :scale ,(quote-if-needed scale)
  ;; 			       :max-div ,(quote-if-needed max-div)
  ;; 			       :forbidden-divs ,(quote-if-needed forbidden-divs)
  ;; 			       :forbidden-patts ,(quote-if-needed forbidden-patts)
  ;; 			       :merge-marker ,(quote-if-needed merge-marker))))))
  ;; gquantify hack
  ;; (setq simple (simple-voice-gq simple))
  (when (atom (first time-signatures))
    (setq time-signatures (list time-signatures)))
  (when (atom (first metronomes))
    (setq metronomes (list metronomes)))
  (when max-div
    (quantify-set-defaults)
    (quantify-set-prefs :max-div max-div
			:forbidden-divs forbidden-divs
			:forbidden-patts forbidden-patts))
  (let ((i (make-instance 'input-stream :input simple :scale scale))
	(vm (make-instance 'enp-voice-maker))
	(ts-gen (make-line-generator time-signatures))
        (metro-gen (make-line-generator metronomes)))
    (iter
      (with time = 0)
      (for ts = (funcall ts-gen))
      (for metro = (funcall metro-gen))
      (add-measure vm ts metro)
      (iter
	(for beat in (time-signature2beats ts))
	(add-beat vm beat)
	(for frame = (next-frame i time (+ time beat)))
	#+debug (assert (= time (caaar frame)))
	#+debug (assert (= (+ time beat) (second (car (car (last frame))))))
	(when max-div
	  ;; quantify
	  (let ((points
		 (iter
		   (for f in frame)
		   (if (getf (cdr f) :rest)
		       (progn
			 (collect (first (car f)))
			 (collect (second (car f)))) ; unconstrained
		       (progn
			 (collect (first (car f)))
			 (collect (list (second (car f)) ; constrained
					(first (car f)))))))))
	    (iter
	      (generating q in (m* (quantify2 (m* points 4) (* time 4) (* beat 4)) 1/4))
	      (for f in frame)
	      (setf (first f) (list (next q) (next q)))
	      (when (= (first (car f)) (+ time beat))
		(setf (second (car f)) (+ time beat))))
	    ;; delete rests that have a zero dur
	    (setq frame (delete-if #'(lambda (l) (and (= (first (car l)) (second (car l)))
						      (getf (cdr l) :rest)))
				   frame))
	    ;; (format t "~&now the frame is: ~s~%" frame)
	    ;; merge-events
	    (let ((frame-copy (copy-tree frame)))
	      (setq frame (delete-duplicates frame :test #'= :key #'caar :from-end t))
	      (iter
		(for f in frame)
		(for m = (iter
			   (for ff in (cdr (member (caar f) frame-copy :test #'= :key #'caar)))
			   (when (= (caar f) (caar ff))
			     (collect ff))))
		(when m (merge-events f m merge-marker))))
	    ;; next beat events
	    (setq frame
		  (iter
		    (for f in frame)
		    (if (= (first (car f)) (+ time beat))
			(collect f into next-beat-frames)
			(collect f))
		    (finally (when next-beat-frames
			       (let ((next-event (pop (input i))))
				 (setq next-event (merge-events next-event next-beat-frames merge-marker))
				 (remf (cdr next-event) :rest)
				 (remf (cdr next-event) :tied)
				 (push next-event (input i)))))))))
	(iter
	  (for f in frame)
	  (setf (first f) (- (second (first f))
			     (first (first f))))
	  (add-event vm f))
	(incf time beat))
      (until (eoi-p i)))
    ;; (system::enp-constructor :voice (voice vm))
    ;; (with-open-file (*standard-output* "/tmp/ksquant.txt" :direction :output
    ;; 				       :if-exists :append)
    ;;       (let (*package* (find-package :ksquant))
    ;; 	(pprint (voice vm))))
    (voice vm)
    ))

