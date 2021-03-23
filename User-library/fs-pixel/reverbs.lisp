;;;       fs-pixel PWGL

;;; Copyright (c) 2011, Filippo Saya.  All rights reserved.
;;;

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

;;;==============================================================================================
;;;                               CROSSFADES FOR fs-pixel    2011    
;;;==============================================================================================
;===================================     Package    =============================================
;
(in-package :fs-pixel)

(define-menu fs-pixel :print-name "fs-pixel")


(define-menu reverbs :in fs-pixel)
(in-menu reverbs)


;
;;;==============================================================================================
;                                   crossfade-curve
;;;==============================================================================================
;
;
(define-box tremolo-reverb-with-curve-limiter  ((input1 nil) (input2 nil) (input3 nil) (input4 nil) (input5 nil))
  ""
  :non-generic t
  :class fs-box

  (fs-pixel::output 
   input5
   (fs-pixel::quasi-reverb input1 input2 input3 input4)
   (fs-pixel::bypass input1 (fs-pixel::which-part input1 input2))))
    
  
;(ccl::collect-enp-objects (nreverse ris) :part)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     INSTALL MENU     ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; at the end
(install-menu reverbs)