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

(defun score2simple* (score)
  (let (pres)
    (ccl::do-parts (p score)
      (let (vres)
        (ccl::do-voices (v p)
          (let ((events (iter
                          (with chords = (ccl::collect-enp-objects v :chord :no-rest-p nil :no-tied-p nil))
                          (for chord-tail on chords)
                          (for chord = (car chord-tail))
                          (for pchord previous chord)
                          ;; (when (and pchord (< (+ (system::start-time pchord) (system::duration pchord))
                          ;;                     (system::start-time chord)))
                          ;;  (collect (* -1 (+ (system::start-time pchord) (system::duration pchord)))))
                          (cond
			    ((system::rest-p chord)
			     (when (or (not pchord) (not (system::rest-p pchord)))
			       (collect (if (zerop (system::start-time chord))
					    '(0 :rest t)
					    (* -1 (system::start-time chord))))))
			    ((ccl::tied-p chord)
			     )		; noop
			    (t
			     (for chord-enp = (system::enp-score-notation chord :exclude '(:start-time)))
			     (setf (first chord-enp) (system::start-time chord))
			     (collect chord-enp)))
                          (when (null (cdr chord-tail))
                            (let ((last (car (last chords))))
                              (collect (+ (system::start-time last) (system::duration last))))))))            
            ;; we need this for non-mensural
            (unless (zerop (event-start (first events)))
              (push '(0 :rest t) events))
            (push events vres)))
	(let ((instr (ccl::instrument-identifier (ccl::instrument p))))
	  (when instr
	    (push :instrument vres)
	    (push instr vres)))	
        ;; everything is pushed on the part lets reverse it
	(push (nreverse vres) pres)))
    (nreverse pres)))

