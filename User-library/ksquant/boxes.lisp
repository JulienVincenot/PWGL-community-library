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

(define-menu ksquant :print-name "KSQuant")
(in-menu ksquant)

(define-box score2simple ((score nil))
  "Converts a score to the simple representation."	 
  (ksquant::score2simple* score))

(define-box simple2score ((simple (0 1 2 3))
			  &key
			  (time-signatures (4 4))
			  (metronomes (4 60))
			  (scale 1/4)
			  (max-div 8)
			  (forbidden-divs (7))
			  (forbidden-patts nil)
			  (merge-marker :bartok-pizzicato))
  :non-generic t
  (ccl::make-score
   (iter
     (for part in (simple-change-type* :score simple))
     (for (values voices options) = (extract-options part))
     (collect (nconc
	       (iter (for v in voices)
		     (collect (simple2voice v
					    :time-signatures time-signatures
					    :metronomes metronomes
					    :scale scale
					    :max-div max-div
					    :forbidden-divs forbidden-divs
					    :forbidden-patts forbidden-patts
					    :merge-marker merge-marker)))
	       options)))))

(define-box simple2nm-score ((simple (0 1 2 3)))
  :non-generic t
  ;; (iter
  ;;     (for part in (simple-change-type* :score simple))
  ;;     (for (values voices options) = (extract-options part))
  ;;     (collect (nconc
  ;;               (iter (for v in voices)
  ;;                     (collect v))
  ;;               options)))
  nil
  (error "simple2nm-score this is not working yet... sorry"))

(menu-separator)

(define-box simple-type ((simple (0 1 2 3)))
  ""	 
  (ksquant::simple-type* simple))

(define-box simple-change-type ((type :score)
				(simple (0 1 2 3)))
  :menu (type :score :part :voice)	 
  (ksquant::simple-change-type* type simple))

(define-box simple-select ((simple (0 1 2 3)) (from 0) &optional (to nil))
  ""	 
  (ksquant::simple-select* simple from to))

(define-box simple-shift ((simple (0 1 2 3)) (delta 0))
  ""	 
  (ksquant::simple-shift* simple delta))

(define-box simple-scale ((simple (0 1 2 3)) (factor 0))
  ""	 
  (ksquant::simple-scale* simple factor))

(define-box simple-transpose ((simple (0 1 2 3)) (transp 0))
  ""	 
  (ksquant::simple-transpose* simple transp))

(define-box simple-enharmonic ((simple (0 1 2 3)) model-score)
  "Changes the enharmonic spelling of SIMPLE according to MODEL-SCORE.
Pitches in SIMPLE will be looked up in (the first voice of)
MODEL-SCORE and are changed to the spelling of the first corresponding
note found there. Comparison is done modulo 12."
  (ksquant::simple-enharmonic* simple model-score))

(define-box simple-merge ((simple1 (0 1 2 3)) (simple2 (0 0.5 2.5 3))
			  &key (strict-durations nil))
  ""	 
  (ksquant::simple-merge* simple1 simple2 strict-durations))

(define-box simple-append ((ignore-last-rest t) &rest simples)
  ""	 
  (apply #'ksquant::simple-append* ignore-last-rest simples))

(menu-separator)

(define-box pitches-durs2simple ((pitches (60 61 62)) (durs (1/4 1/8)))
  ""	 
  (ksquant::pitches-durs2simple* pitches durs))

(define-box simple2pitches-durs ((simple (0 1 2 3)))
  :outputs 2
  ""	 
  (ksquant::simple2pitches-durs* simple))

(install-menu ksquant)