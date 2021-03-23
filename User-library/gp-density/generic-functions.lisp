;;;       gp-density PWGL

;;; Copyright (c) 2011,Giacomo Platini.  All rights reserved.
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
;;;                                GENERIC-FUNCTIONS FOR gp-density    2011    
;;;==============================================================================================
;===================================     Package    =============================================
;
(in-package :gp-density)
;
;============================  subs-prof-list FROM BRIAN FERNEYHOUGH  ===============================================
;
(defvar *index* nil)

(defun subs-prof-list (list1 list2)
  (cond ((null list1) nil)
        ((atom list1) (nth (setf *index* (incf *index*)) list2))
        (t (cons ( subs-prof-list (first list1) list2) 
                 ( subs-prof-list(rest list1) list2)))))

(defun gl-subs (list1 list2)
  (setf *index* -1)
  (subs-prof-list list1 list2))

;;;==============================================================================================
;;;                                FOR    CROSSFADES   
;;;==============================================================================================
;
;============================  test  ===============================================
;

;
;============================  formattatore di parentesi  con nth ===============================================
;
;;;;;;;;;;;;;4/7/2003;;;;;;;;;;;

(define-box primo ((l list))
  "da fare la doc"
  :non-generic t
  :class gp-box
  (pw::x->dx (pw::sort-list l)))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define-box vf7 ((l list) (polo number))
 (pw::sort-list
  (pw::rem-dups
   (let ((ris nil))
    (dolist (x l (nreverse ris))  
      (if (<= x polo)
         (push x ris))
      (/= x polo)
        (push polo ris)))
   'eq 1)))

;;;;;;;;;;;;;;;;;;;

(define-box vf8 ((l list) (polo number))
 (pw::sort-list
  (pw::rem-dups
   (let ((ris nil))
    (dolist (x l (nreverse ris))  
      (if (>= x polo)
         (push x ris))
      (/= x polo)
        (push polo ris)))
   'eq 1)))

;;;;;;;;;;;;;;;;;;;;;;;;;

(define-box vf9 ((l list) (polo 60))
  (list (vf7 l polo) (vf8 l polo)))

;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;



