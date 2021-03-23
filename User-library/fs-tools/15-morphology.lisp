
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                    ;;;
;;;                        FS-TOOLS for PWGL                           ;;;
;;;                                                                    ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                    ;;;
;;;                                                                    ;;;
;;; Copyright (c) 2016, Filippo Saya. All rights reserved.             ;;;
;;;                                                                    ;;;
;;; Redistribution and use in source and binary forms, with or without ;;;
;;; modification, are permitted provided that the following conditions ;;;
;;; are met:                                                           ;;;
;;;                                                                    ;;;
;;;   * Redistributions of source code must retain the above copyright ;;;
;;;     notice, this list of conditions and the following disclaimer.  ;;;
;;;                                                                    ;;;
;;;   * Redistributions in binary form must reproduce the above        ;;;
;;;     copyright notice, this list of conditions and the following    ;;;
;;;     disclaimer in the documentation and/or other materials         ;;;
;;;     provided with the distribution.                                ;;;
;;;                                                                    ;;;
;;; THIS SOFTWARE IS PROVIDED BY THE AUTHOR 'AS IS' AND ANY EXPRESSED  ;;;
;;; OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED  ;;;
;;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ;;;
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY    ;;;
;;; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL ;;;
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE  ;;;
;;; GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS      ;;;
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,       ;;;
;;; WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING          ;;;
;;; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS ;;;
;;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.       ;;;
;;;                                                                    ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                    ;;;;;;;;;;;;;;;;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MORPHOLOGY ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                    ;;;;;;;;;;;;;;;;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ?accorparlo in list, menu Selection (-> search), a parte bpf to list che va in number, oppure tutto in number



(in-package :fs-tools)





;;; find-peaks ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;fare versione evoluta che calcola da sola ciò che è trascurabile in base a proporzione col tutto ecc...
;;most-n-peaks, elenca i primi n picchi più rilevanti



(defclass fs-find-peaks (fs-tools) ())



(defmethod patch-value ((self fs-find-peaks) output)
  (let ((pos (position output (pwgl-outputs self))))
    (nth-output-patch-value self pos)))



(defmethod nth-output-patch-value ((self fs-find-peaks) (out (eql 0)))
  (find-peak-values (nth-patch-value self 0) (nth-patch-value self 1) (nth-patch-value self 2) (nth-patch-value self 3)))



(defmethod nth-output-patch-value ((self fs-find-peaks) (out (eql 1)))
  (find-peak-indices (nth-patch-value self 0) (nth-patch-value self 1) (nth-patch-value self 2) (nth-patch-value self 3))) 



(defun find-peak-values (number-list peak-signum min-interval one-or-two-side-min-int?)
  (labels ((2sides (lst index first?)
             (cond ((null lst) ())
                   ((and (single lst)
                         (= peak-signum (signum (car lst)))
                         (>= (abs (car lst)) (abs min-interval)))
                    (list (nth index number-list)))
                   ((single lst) ())
                   ((and first?
                         (= (signum (car lst)) (signum (cadr lst))))
                    (2sides (cons (+ (car lst) (cadr lst)) (cddr lst)) (1+ index) t))
                   ((and first?
                         (/= peak-signum (signum (car lst)))
                         (>= (abs (car lst)) (abs min-interval)))
                    (cons (car number-list) (2sides (cdr lst) (1+ index) nil)))
                   ((= (signum (car lst)) (signum (cadr lst)))
                    (2sides (cons (+ (car lst) (cadr lst)) (cddr lst)) (1+ index) nil))
                   ((and (= peak-signum (signum (car lst)))
                         (>= (abs (car lst)) (abs min-interval))
                         (>= (abs (cadr lst)) (abs min-interval)))
                    (cons (nth index number-list) (2sides (cdr lst) (1+ index) nil)))
                   (t (2sides (cdr lst) (1+ index) nil))))

           (1side (lst index first?)
             (cond ((null lst) ())
                   ((and (single lst)
                         (= peak-signum (signum (car lst)))
                         (>= (abs (car lst)) (abs min-interval)))
                    (list (nth index number-list)))
                   ((single lst) ())
                   ((and first?
                         (= (signum (car lst)) (signum (cadr lst))))
                    (1side (cons (+ (car lst) (cadr lst)) (cddr lst)) (1+ index) t))
                   ((and first?
                         (/= peak-signum (signum (car lst)))
                         (>= (abs (car lst)) (abs min-interval)))
                    (cons (car number-list) (1side (cdr lst) (1+ index) nil)))
                   ((= (signum (car lst)) (signum (cadr lst)))
                    (1side (cons (+ (car lst) (cadr lst)) (cddr lst)) (1+ index) nil))
                   ((and (= peak-signum (signum (car lst)))
                         (or (>= (abs (car lst)) (abs min-interval))
                             (>= (abs (cadr lst)) (abs min-interval))))
                    (cons (nth index number-list) (1side (cdr lst) (1+ index) nil)))
                   (t (1side (cdr lst) (1+ index) nil)))))

    (if one-or-two-side-min-int?
         (1side (pw::x->dx number-list) 1 t)
         (2sides (pw::x->dx number-list) 1 t))))



(defun find-peak-indices (number-list peak-signum min-interval one-or-two-side-min-int?)
  (labels ((2sides (lst index first?)
             (cond ((null lst) ())
                   ((and (single lst)
                         (= peak-signum (signum (car lst)))
                         (>= (abs (car lst)) (abs min-interval)))
                    (list index))
                   ((single lst) ())
                   ((and first?
                         (= (signum (car lst)) (signum (cadr lst))))
                    (2sides (cons (+ (car lst) (cadr lst)) (cddr lst)) (1+ index) t))
                   ((and first?
                         (/= peak-signum (signum (car lst)))
                         (>= (abs (car lst)) (abs min-interval)))
                    (cons 0 (2sides (cdr lst) (1+ index) nil)))
                   ((= (signum (car lst)) (signum (cadr lst)))
                    (2sides (cons (+ (car lst) (cadr lst)) (cddr lst)) (1+ index) nil))
                   ((and (= peak-signum (signum (car lst)))
                         (>= (abs (car lst)) (abs min-interval))
                         (>= (abs (cadr lst)) (abs min-interval)))
                    (cons index (2sides (cdr lst) (1+ index) nil)))
                   (t (2sides (cdr lst) (1+ index) nil))))

           (1side (lst index first?)
             (cond ((null lst) ())
                   ((and (single lst)
                         (= peak-signum (signum (car lst)))
                         (>= (abs (car lst)) (abs min-interval)))
                    (list index))
                   ((single lst) ())
                   ((and first?
                         (= (signum (car lst)) (signum (cadr lst))))
                    (1side (cons (+ (car lst) (cadr lst)) (cddr lst)) (1+ index) t))
                   ((and first?
                         (/= peak-signum (signum (car lst)))
                         (>= (abs (car lst)) (abs min-interval)))
                    (cons 0 (1side (cdr lst) (1+ index) nil)))
                   ((= (signum (car lst)) (signum (cadr lst)))
                    (1side (cons (+ (car lst) (cadr lst)) (cddr lst)) (1+ index) nil))
                   ((and (= peak-signum (signum (car lst)))
                         (or (>= (abs (car lst)) (abs min-interval))
                             (>= (abs (cadr lst)) (abs min-interval))))
                    (cons index (1side (cdr lst) (1+ index) nil)))
                   (t (1side (cdr lst) (1+ index) nil)))))

    (if one-or-two-side-min-int?
         (1side (pw::x->dx number-list) 1 t)
         (2sides (pw::x->dx number-list) 1 t))))



(PWGLDef find-peaks ((number-list '(10 1 11 9 13))
                     (peak-signum () (ccl::mk-menu-subview :menu-list '(("positive" 1) ("negative" -1)) :value 0));;aggiungere both
                     (min-interval 3)
                     (one-or-two-side-min-int? () (ccl::mk-menu-subview :menu-list '(("one side min interv" t) ("two side min interv" nil)) :value 0)))
         "

Data una NUMBER-LIST, restituisce tutti gli elementi di tale lista (o i relativi indici, nel secondo output) che corrispondano a un 'picco'.
Per picco di una lista numerica s'intende un numero che sia preceduto da uno o più intervalli consecutivi nella stessa direzione e seguito da uno o più intervalli nella direzione opposta.
PEAK-SIGNUM: indica se considerare i picchi positivi (quindi i numeri preceduti da uno o più intervalli ascendente e seguiti da uno o più intervalli discendente), o, viceversa, i picchi negativi.
MIN-INTERVAL: indica la dimensione minima che gli intervalli (o la somma di intervalli consecutivi nella stessa direzione) che circondano un determinato numero debbano avere perché tale numero sia considerato 'picco'.
ONE-SIDE-MIN-INTERVAL?: se si sceglie 'yes', basta che solo l'intervallo che precede un determinato numero (o la somma di intervalli consecutivi nella stessa direzione), oppure quello che segue soddisfi la dimensione minima indicata in MIN-INTERVAL. Nel caso si scelga 'no', perché un candidato picco sia considerato tale, sia l'intervallo precedente (o la somma di intervalli consecutivi nella stessa direzione) che quello seguente devono soddisfare la dimensione minima indicata in MIN-INTERVAL. NB: anche scegliendo 'yes', il primo e l'ultimo valore della lista possono essere considerati 'picchi' se l'unico intervallo adiacente (o la somma di intervalli consecutivi nella stessa direzione) è maggiore o uguale a MIN-INTERVAL."

         (:class 'fs-find-peaks :outputs '("values" "indices")
                 :groupings '(1 1 2)
                 :w 0.4)

         ())



;;; end of find-peaks ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;; near-interval-range ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defclass fs-near-interval-range (fs-tools) ())



(defmethod patch-value ((self fs-near-interval-range) output)
  (let ((pos (position output (pwgl-outputs self))))
    (nth-output-patch-value self pos)))



;values
(defmethod nth-output-patch-value ((self fs-near-interval-range) (out (eql 0)))
  (near-interval-range-values (nth-patch-value self 0) (nth-patch-value self 1) (nth-patch-value self 2) (nth-patch-value self 3) (nth-patch-value self 4)))



;indices
(defmethod nth-output-patch-value ((self fs-near-interval-range) (out (eql 1)))
  (near-interval-range-indices (nth-patch-value self 0) (nth-patch-value self 1) (nth-patch-value self 2) (nth-patch-value self 3) (nth-patch-value self 4))) 


  
(defun near-interval-range-values (list min max mode position)
  (let ((pos (case position
               (:before 'car)
               (:after 'cadr)))
        (minim (min min max))
        (maxim (max min max)))

    (labels ((absolute (list)
               (if (cadr list)
                   (let ((int (abs (- (cadr list) (car list)))))
                     (cond ((<= minim int maxim)
                            (cons (funcall pos list)
                                  (absolute (cdr list))))
                           (t (absolute (cdr list)))))))

             (positive-negative (list)
               (if (cadr list)
                   (let ((int (- (cadr list) (car list))))
                     (cond ((<= minim int maxim)
                            (cons (funcall pos list)
                                  (positive-negative (cdr list))))
                           (t (positive-negative (cdr list))))))))

             (case mode
               (:abs (absolute list))
               (:posneg (positive-negative list))))))



(defun near-interval-range-indices (list min max mode position)
  (let ((pos (case position
               (:before 0)
               (:after 1)))
        (minim (min min max))
        (maxim (max min max)))

    (labels ((absolute (list ind)
               (if (cadr list)
                   (let ((int (abs (- (cadr list) (car list)))))
                     (cond ((<= minim int maxim)
                            (cons (+ pos ind)
                                  (absolute (cdr list) (1+ ind))))
                           (t (absolute (cdr list) (1+ ind)))))))

             (positive-negative (list ind)
               (if (cadr list)
                   (let ((int (- (cadr list) (car list))))
                     (cond ((<= minim int maxim)
                            (cons (+ pos ind)
                                  (positive-negative (cdr list) (1+ ind))))
                           (t (positive-negative (cdr list) (1+ ind))))))))

      (case mode
               (:abs (absolute list 0))
               (:posneg (positive-negative list 0))))))



(pwgldef near-interval-range ((number-list '(0 1 10 9 2))
                              (min-interval 1) (max-interval 2)
                              (mode () (ccl::mk-menu-subview :menu-list '(("absolute" :abs) ("ascend/descend" :posneg)) :value 0))
                              (position () (ccl::mk-menu-subview :menu-list '(("before-interval" :before) ("after-interval" :after)) :value 0)));;aggiungere both
         "
Data una lista numerica, la funzione restituisce tutti gli elementi di tale lista (oppure i relativi indici, nel secondo output) che siano contigui a ciascun intervallo compreso fra min-interval incluso e max-interval incluso.
Scegliendo absolute mode, vengono considerati sia gli intervalli ascendenti che discendenti (min-interval e max-interval devono essere esclusivamente valori positivi), mentre in ascend/descend mode gli intervalli ascendenti o discendenti sono distinti.
Position determina se la funzione debba restituire il numero (o l'indice) precedente oppure successivo a ciascun intervallo compreso fra min-interval e max-interval."

         (:class 'fs-near-interval-range :outputs '("values" "indices")
          :groupings '(1 2 1 1)
          :w 0.5)

         ())
                              


;;; end of near-interval-range ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef bpf->list ((objects ()) (no-of-points 10) (min 1) (max 100) &optional (round-decimals 0))
         "
Trasforma uno o più bpf in altrettante liste numeriche, in base ai parametri di campionamento prescelti.
objects: il o i bpf (se metti objects avrai lol, se metti active una flat list)
no-of-points: il numero di campioni
min: il valore minimo di campionamento
max: il valore massimo di campionamento
round-decimal: il numero di cifre decimali desiderato per l'arrotondamento dei numeri delle liste in uscita
Ciascun parametro può essere liberamente indicato come atomo o come lista. Nel caso i bpf siano più di uno, si possono indicare come atomi i parametri per cui si desidera lo stesso valore per tutte le liste in uscita e come lista i parametri per cui si desiderano valori differenziati per ciascuna lista in uscita"

         (:class 'fs-tools)

         
         (let ((result
                (eval
                 `(mapcar #'(lambda (obj points mn mx round)
                              (pw::g-round
                               (pw::g-scaling
                                (system::pwgl-sample obj points)
                                mn
                                mx)
                               round))
                          ,@(mapcar #'(lambda (x) (list 'quote x)) ;only lisp can be so ingenious and perverse
                                    (align-to-max-length
                                     (list
                                      (ccl::list! objects)
                                      (ccl::list! no-of-points)
                                      (ccl::list! min) 
                                      (ccl::list! max)
                                      (ccl::list! round-decimals))
                                     :last-elem))))))
           (if (atom objects) ;if you insert 2d-editor 'active' output in bpf->list objects input, result is car-ed
               (car result)
               result)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; END OF FILE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


