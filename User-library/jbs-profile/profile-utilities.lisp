;;;       JBS-PROFILE for PWGL

;;;       Copyright (c) 2009, Jacopo Baboni Schilingi.  All rights reserved.

;;;;;;;;;;;;;;;;;BASED ON THE OPEN-MUSIC VERSION DONE in 2001 BY;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Jacopo Baboni Schilingi, Nicola Evangelisti e Mikhail Mal ;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;     Redistribution and use in source and binary forms, with or without
;;;     modification, are permitted provided that the following conditions
;;;     are met:

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


(in-package :jbs-profile)

(import '(ccl::for ccl::while))

;===========================
;===========================

(ccl::add-menu-list-keyword :Profile-up/down? '(":up" ":down")) ;dichiarazione del menu
(ccl::add-box-type :Profile-up/down?-box 
    `(ccl::mk-menu-subview :menu-list :Profile-up/down?)) ;sub-menu con -box
(defun Profile-up/down? (up/down?)  (if (eq up/down? :up) 1 2)) ;valori del menu


(ccl::add-menu-list-keyword :Profile-int-note? '(":inter" ":note")) ;dichiarazione del menu
(ccl::add-box-type :Profile-int-note?-box 
    `(ccl::mk-menu-subview :menu-list :Profile-int-note?)) ;sub-menu con -box
(defun Profile-int-note? (mode?)  (if (eq mode? :inter) 1 2)) ;valori del menu


(ccl::add-menu-list-keyword :Profile-inclu? '(":yes" ":no!")) ;dichiarazione del menu
(ccl::add-box-type :Profile-inclu?-box 
    `(ccl::mk-menu-subview :menu-list :Profile-inclu?)) ;sub-menu con -box
(defun Profile-inclu? (inclu?)  (if (eq inclu? :yes) 1 2)) ;valori del menu


(ccl::add-menu-list-keyword :Profile-orig-first? '(":first" ":orig")) ;dichiarazione del menu
(ccl::add-box-type :Profile-orig-first?-box 
    `(ccl::mk-menu-subview :menu-list :Profile-orig-first?)) ;sub-menu con -box
(defun Profile-orig-first? (start?)  (if (eq start? :first) 1 2)) ;valori del menu


(ccl::add-menu-list-keyword :Profile-baric-orig? '(":first" ":orig")) ;dichiarazione del menu
(ccl::add-box-type :Profile-baric-orig?-box 
    `(ccl::mk-menu-subview :menu-list :Profile-baric-orig?)) ;sub-menu con -box
(defun Profile-baric-first? (start?)  (if (eq start? :first) 1 2)) ;valori del menu


(ccl::add-menu-list-keyword :Profile-stop-circ-scal? '(":stop" ":circ" ":scal")) ;dichiarazione del menu
(ccl::add-box-type :Profile-stop-circ-scal?-box 
    `(ccl::mk-menu-subview :menu-list :Profile-stop-circ-scal?)) ;sub-menu con -box
(defun Profile-stop-circ-scal? (mode?)  (cond ((eq mode? :stop) 1)
                                           ((eq mode? :circ) 2)
                                           ((eq mode? :scal) 3))) ;valori del menu


(ccl::add-menu-list-keyword :Profile-lecture? '(":stop" ":circ")) ;dichiarazione del menu
(ccl::add-box-type :Profile-lecture?-box 
    `(ccl::mk-menu-subview :menu-list :Profile-lecture?)) ;sub-menu con -box
(defun Profile-lecture? (lecture?)  (if (eq lecture? :stop) 1 2)) ;valori del menu


(ccl::add-menu-list-keyword :Four-forms-menu? '(":original" ":reverse" ":inversion" ":rever-inver")) ;dichiarazione del menu
(ccl::add-box-type :Four-forms-menu?-box 
    `(ccl::mk-menu-subview :menu-list :Four-forms?)) ;sub-menu con -box
(defun Four-forms-menu? (four-forms?)  (cond ((eq four-forms? :original) 1)
                                             ((eq four-forms? :reverse) 2)
                                             ((eq four-forms? :inversion) 3)
                                             ((eq four-forms? :rever-inver) 4)));valori del menu


;=========================== mie macro
;
(defun repeat-n (count body)
  (let ((ris nil))
    (dotimes (x count (nreverse ris))
      (push body ris))))


;(defparameter s (ccl::mk2D-object :bpf (list '(1 2 3))))
;(setf s (ccl::mk2D-object :bpf (list '(1 2 3) '(1 2 30))))




;===========================
; TEST
;===========================

(ccl::add-menu-list-keyword :test-menu? '(":plus" ":minus"))
(ccl::add-box-type :test-menu?-box 
    `(ccl::mk-menu-subview :menu-list :test-menu?))
(defun test-menu? (plus-minus)  (if (equalp plus-minus :plus) 1 2))

(print (test-menu? 'plus))


(system::PWGLdef let-us-hope ((list '(1 2 3 4))
                      (plus-minus () :test-menu?-box)
                      (value 100))
    ""
    ()
  (let ((plus-minus (test-menu? plus-minus)))
    (case plus-minus
      (1 (pw::g+ list value))
      (2 (pw::g- list value)))))



(system::PWGLdef let-us-hope-again ((list '(1 2 3 4))
                            (plus-minus () :test-menu?-box)
                            (value 100))
    ""
    ()
  (let ((plus-minus (test-menu? plus-minus)))
    (case plus-minus
      (1 (let-us-hope list :plus value))
      (2 (let-us-hope list :minus value)))))

