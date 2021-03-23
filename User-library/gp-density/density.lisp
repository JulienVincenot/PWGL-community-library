;;;      gp-density PWGL

;;; Copyright (c) 2011, Giacomo Platini.  All rights reserved.
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
;;;                              Def menu gp-density    2011    
;;;==============================================================================================
;===================================     Package    =============================================
;
(in-package :gp-density)

(define-menu density :print-name "gp-density")


(in-menu density)


;
;;;==============================================================================================
;                                   
;;;==============================================================================================
;
;
(define-box absolute-harmonic-density ((l list))
  "doc da fare"
  :outputs 2
  (let ((second-out 
         (pw::g-round (apply #'+ 
                             (mapcar #'(lambda (x) 
                                         (first (pw::g-scaling 100.0 0 100.0 0 x)))
                                     (gp-density::primo l))) 2)))
    (values
     (first (pw::g-round 
             (pw::g-scaling second-out 0 1.0 0 (* (- (length l) 1) 100.0 )) 2))
     (pw::g-round (pw::g/ second-out 100) 0))))
    







(define-box harmonic-density-from-high ((l list))
  :outputs 2
  (let ((second-out (pw::g-round (apply '+
                                        (let* 
                                            ((q (mapcar #' (lambda (x) (- (first (last l)) x))
                                                        (rest (reverse l))))
                                             (z (pw::arithm-ser 100 100 (* 100 (- (length l) 1)) ))
                                             (j (pw::mat-trans (list z q))))
                                          (mapcar #' (lambda (x) (first (pw::g-scaling (first x) 0.0 100.0 0.0 (second x))))
                                                  j))) 2)))
    (values
     (first (pw::g-round 
             (pw::g/ (pw::g-scaling second-out 0 100 0  (* (- (length l) 1) 100)) 100) 2))
     (pw::g-round (pw::g/ second-out 100) 0))))






(define-box harmonic-density-from-low ((l list))
  "doc da fare"
  :outputs 2
  (let ((second-out 
         (pw::g-round (apply '+
                             (let* 
                                 ((q (mapcar #' (lambda (x) (-  x (first l)))
                                             (rest l)))
                                  (z (pw::arithm-ser 100 100 (* 100 (- (length l) 1)) ))
                                  (j (pw::mat-trans (list z q))))
                               (mapcar #' (lambda (x) (first (pw::g-scaling (first x) 0.0 100.0 0.0 (second x))))
                                       j))) 2)))
    (values
     (first (pw::g-round (pw::g/ (pw::g-round (pw::g-scaling second-out 0 100 0  (* (- (length l) 1) 100)) 2) 100) 2))
     (pw::g-round (pw::g/ second-out 100) 0))))




(define-box harmonic-density-from-point ((l list) (polo 60))
  ""
  :non-generic t
  :class gp-box
  (if (= (gp-density::harmonic-density-from-high (first (vf9 l polo))) 0.0)
            (gp-density::harmonic-density-from-low (second (vf9 l polo)))
            (if (= (gp-density::harmonic-density-from-low (second (vf9 l polo))) 0.0)
                      (gp-density::harmonic-density-from-high (first (vf9 l polo))) 
                      (pw::g-round 
                       (/ 
                        (+
                         (gp-density::harmonic-density-from-high (second (vf9 l polo)))
                         (gp-density::harmonic-density-from-low (first (vf9 l polo))))
                        2) 2))))
  









(define-box estrattore-altezze-2 ((lista list))
  "From Paolo Aralla Morphological Analysis library:
estrae i rest elementi della lista segmentata con -segmenta-analisi-new/old-su-old- / senza flattare il materiale original"
  :non-generic t
  :class gp-box 
  
  
  (let ((risultato nil)
        (raggruppa (jbs-cmi::ON-OLD/NEW-OLD/ANALYSIS-SEGMENTATION lista)))
    
    (pw::flat-once (mapcar #' (lambda (x) (rest x))
            raggruppa))))







(define-box estrattore-altezze-3 ((lista list))
  "From Paolo Aralla Morphological Analysis library: estrae i rest elementi della lista segmentata con -segmenta-analisi-new/old-su-old-, ma trasponpendo ogni frammento sulla testa della sequenza originale"
  :non-generic t
  :class gp-box 
  
  (let* ((risultato nil)
         (raggruppa (jbs-cmi::ON-OLD/NEW-OLD/ANALYSIS-SEGMENTATION lista))
         (resto  (mapcar #' (lambda (x) (rest x))
                         raggruppa))
         (lunghezza2 (mapcar #' (lambda (x) (length x))
                             resto)))
   
    (jbs-cmi::group-list 
     (pw::dx->x (first (pw::flat lista))
                (pw::x->dx 
                 (pw::flat (mapcar #' (lambda (x) (rest x))
                                   raggruppa))))
     lunghezza2 ':stop)))

;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     INSTALL MENU     ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; at the end
(install-menu density)