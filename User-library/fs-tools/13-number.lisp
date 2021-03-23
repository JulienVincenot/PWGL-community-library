
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
;;;                                                     ;;;;;;;;;;;;;;                                                                   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; NUMBER ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                     ;;;;;;;;;;;;;;                                                                   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(in-package :fs-tools)





;;; deep sort ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;take length list of a list-of-lists, removes dupls and sort > result
(defun sort-remdups-maplength (list-of-lists)
  (sort (remove-duplicates (map-length list-of-lists)) '>))



;;in menu, se serve
;'(7 5 3 2) -> '((7 6) (5 4) (3) (2 1))
(defun fill-group-ser (list)
  (let ((rest+0 (append (rest list) '(0))))
    (mapcar #'(lambda (x y) (pw::arithm-ser x -1 (1+ y))) list rest+0)))



(pwgldef sort-by-nth ((list-of-lists '((2 a) (3 b) (1 c))) (nth 0) (sort-pred '<))
         "
It sorts a number LIST-OF-LISTS by NTH element of every sublist."

         (:class 'fs-tools
          :groupings '(1 2)
          :w 0.4)
         
         (sort list-of-lists sort-pred :key #'(lambda (x) (nth nth x))))



; sort and re-sort a list of list by nths list
(defun loop-sort-by-nth (list-of-lists nths)
  (dolist (l nths list-of-lists)
    (setf list-of-lists (sort-by-nth list-of-lists l '<))))



(pwgldef deep-sort ((list-of-lists '((7 9) (2 3 4) (7 5) (2 3) (2 3 5) (3) (3 1)))
                    (direction () (ccl::mk-menu-subview :menu-list '(:ascending :descending) :value 0)))
         "
It sort LIST-OF-LISTS according to DIRECTION. The lengths of sublists can be different each others"

         (:class 'fs-tools
          :groupings '(1 1)
          :w 0.4)

         (do ((grouped (reverse (group-by-length list-of-lists)) (cdr grouped))
              (lengths (fill-group-ser (sort-remdups-maplength list-of-lists)) (cdr lengths))
              (ris nil))

             ((null grouped)
              (case direction
                (:ascending ris)
                (:descending (nreverse ris))))

           (setf ris (loop-sort-by-nth (append (car grouped) ris) (mapcar #'1- (car lengths))))))



;;; end of deep-sort ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(system::add-box-type :interval-fn-menu
                      `(system::mk-menu-subview
                        :menu-list
                        ,(system::add-menu-list-keyword
                          :interval-fn-list
                          '(:interval
                            :abs-interval
                            :simple-interval
                            :abs-simple-interval
                            :interval-class))
                        :value 0))



(defun abs-interval (x)
  (system::g-abs (pw::x->dx x)))



(defun simple-interval (x)
  (let ((int (pw::x->dx x)))
    (system::g* (fs-tools::deep-mapcar #'signum int) (system::mod12 (system::g-abs int)))))



(defun abs-simple-interval (x)
  (system::mod12 (abs-interval x)))



(defun interval-class (x)
  (let* ((int (abs-simple-interval x))
         (int-inv (system::g- 12 int)))
   (fs-tools::deep-mapcar #'min int int-inv)))



(pwgldef interval ((list '(60 67 65 80)) (interval-fn () :interval-fn-menu))
         "
..."

         (:class 'fs-tools
          :groupings '(1 1)
                     :w 0.4)

(case interval-fn
  (:interval (pw::x->dx list))
  (:abs-interval (abs-interval list))
  (:simple-interval (simple-interval list))
  (:abs-simple-interval (abs-simple-interval list))
  (:interval-class (interval-class list))))
         


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef fit-to-limits ((list '(1 2 3 4 5))
                        (low 2) (high 4))
         "
It modify LIST, repalacing every number lower than LOW with LOW value and every number higher than HIGH with HIGH value."

         (:class 'fs-tools
          :groupings '(1 2)
          :w 0.4)

         (cond ((null list) ())
               ((< (car list) low) (cons low (fit-to-limits (cdr list) low high)))
               ((> (car list) high) (cons high (fit-to-limits (cdr list) low high)))
               (t (cons (car list) (fit-to-limits (cdr list) low high)))))



;;; repeat-until-sum ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defclass fs-repeat-until-sum (fs-tools) ())



(defmethod patch-value ((self fs-repeat-until-sum) output)
  (let ((pos (position output (pwgl-outputs self))))
    (nth-output-patch-value self pos)))



(defmethod nth-output-patch-value ((self fs-repeat-until-sum) (out (eql 0)))
  (repeat-until-sum-list (nth-patch-value self 0) (nth-patch-value self 1) (nth-patch-value self 2)))



(defmethod nth-output-patch-value ((self fs-repeat-until-sum) (out (eql 1)))
  (repeat-until-sum-remainder (nth-patch-value self 0) (nth-patch-value self 1) (nth-patch-value self 2))) 



(defun repeat-until-sum-list (n sum cut-mode)
  (labels ((precise (n sum)
             (cond ((<= sum n) (list sum))
                   (t (cons n (precise n (- sum n))))))
           (before (n sum)
             (cond ((= sum n) (list n))
                   ((< sum n) ())
                   (t (cons n (before n (- sum n))))))
           (after (n sum)
             (cond ((<= sum n) (list n))
                   (t (cons n (after n (- sum n)))))))
    (case cut-mode
      (:precise (precise n sum))
      (:before (before n sum))
      (:after (after n sum)))))



(defun repeat-until-sum-remainder (n sum cut-mode)
  (- sum (apply #'+ (repeat-until-sum-list n sum cut-mode))))



(pwgldef repeat-until-sum ((n 2) (sum 7)
                           (cut-mode () (ccl::mk-menu-subview :menu-list '(("precise" :precise) ("<= sum" :before) (">= sum" :after)) :value 0)))
         "
L'output LIST restituisce una lista in cui N è ripetuto finché la somma degli N ripetuti non sia pari a SUM.
Poiché non sempre è possibile raggiungere la somma esatta, il parametro CUT-MODE stabilisce se:
- concludere la lista con un numero pari inferiore a N, in modo che la somma degli elementi della lista sia esattamente uguale a SUM ('precise')
- concludere la lista senza alterare il valore dell'ultimo elemento, ripetendo N il maggior numero di volte possibile senza però che la somma degli elementi della lista superi il valore di SUM; la somma degli elementi della lista potrebbe dunque risultare inferiore o uguale a SUM (<= sum)
- concludere la lista senza alterare il valore dell'ultimo elemento, ripetendo N il maggior numero di volte possibile senza però che la somma degli elementi della lista sia inferiore al valore di SUM; la somma degli elementi della lista potrebbe dunque risultare superiore o uguale a SUM (>= sum)

L'output REMAINDER restituisce la differenza fra la somma degli elementi della lista in uscita e il valore di SUM"
       
         (:class 'fs-repeat-until-sum
                 :groupings '(2 1)
                 :outputs '("list" "remainder"))
         
         ())



;;; end of repeat-until-sum ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;; cut-on-sum ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defclass fs-cut-on-sum (fs-tools) ())



(defmethod patch-value ((self fs-cut-on-sum) output)
  (let ((pos (position output (pwgl-outputs self))))
    (nth-output-patch-value self pos)))



(defmethod nth-output-patch-value ((self fs-cut-on-sum) (out (eql 0)))
  (cut-on-sum-list (nth-patch-value self 0) (nth-patch-value self 1) (nth-patch-value self 2) (nth-patch-value self 3)))



(defmethod nth-output-patch-value ((self fs-cut-on-sum) (out (eql 1)))
 (cut-on-sum-remainder (nth-patch-value self 0) (nth-patch-value self 1) (nth-patch-value self 2) (nth-patch-value self 3))) 



(defun cut-on-sum-list (list sum cut-mode sum-mode)
  (labels ((precise+- (list sum)
             (cond
              ((null list) list)
              ((<= sum (car list)) (list sum))
              (t (cons (car list) (precise+- (cdr list) (- sum (car list)))))))

           (precise-abs (list sum)
             (cond
              ((null list) list)
              ((<= sum (abs (car list))) (list (* (signum (car list)) sum)))
              (t (cons (car list) (precise-abs (cdr list) (- sum (abs (car list))))))))

           (before+- (list sum)
             (cond
              ((null list) list)
              ((= sum (car list)) (list (car list)))
              ((< sum (car list)) ())
              (t (cons (car list) (before+- (cdr list) (- sum (car list)))))))

           (before-abs (list sum)
             (cond
              ((null list) list)
              ((= sum (abs (car list))) (list (car list)))
              ((< sum (abs (car list))) ())
              (t (cons (car list) (before-abs (cdr list) (- sum (abs (car list))))))))

           (after+- (list sum)
             (cond
              ((null list) list)
              ((<= sum (car list)) (list (car list)))
              (t (cons (car list) (after+- (cdr list) (- sum (car list)))))))

           (after-abs (list sum)
             (cond
              ((null list) list)
              ((<= sum (abs (car list))) (list (car list)))
              (t (cons (car list) (after-abs (cdr list) (- sum (abs (car list)))))))))
    ;end of labels
    (case sum-mode
      (:+/-
       (case cut-mode
         (:precise (precise+- list sum))
         (:before (before+- list sum))
         (:after (after+- list sum))))
      (:absolute
       (case cut-mode
         (:precise (precise-abs list sum))
         (:before (before-abs list sum))
         (:after (after-abs list sum))))
      )))



(defun cut-on-sum-remainder (list sum cut-mode sum-mode)
  (- (apply #'+ list) (apply #'+ (cut-on-sum-list list sum cut-mode sum-mode))))



;;aggiungere terzo output con resto della lista?
(PWGLDef cut-on-sum
         ((list '(1 2 3 4)) (sum 5)
          (cut-mode () (ccl::mk-menu-subview :menu-list '(("precise" :precise) ("before-sum" :before) ("after-sum" :after)) :value 0))
          (sum-mode () (ccl::mk-menu-subview :menu-list '(("absolute" :absolute) ("+/-" :+/-)) :value 0)))
         "
it cuts a number list when the sum of elements reaches cut
last number of return value could be reduced in order to reach the exact cut sum"
;;rivedere testo

         (:class 'fs-cut-on-sum
                 :groupings '(2 2)
                 :outputs '("list" "remainder"))

         ())



;;; end of cut-on-sum ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;oppure, se non trova soluz, fare concorso di somiglianza morfologica tra lista orig e candidat, usando una funzione di FV
(pwgldef integer-scaling/sum ((list '(1 2 3 4))
                              (sum 11))
         "
It resizes LIST number elements so that the sum of elements is equal to SUM.
Since the specificity of this function is returning an integer list, the proportion between elements could be relatively altered by rounding.

(integer-scaling/sum '(1 2 3 4) 11)
> (1 2 4 4)"
;;rivedere testo

         (:class 'fs-tools
          :groupings '(1 1)
          :w 0.4)

         (labels ((rec (try-sum ctrl) 
                    (let ((res (pw::g-round (pw::g-scaling/sum list try-sum))))
                      (cond ((= (length ctrl) 3)
                             (let* ((diffs (mapcar #'cadr ctrl))
                                    (closest-ind (car (nearest-indices sum diffs)))
                                    (best (nth closest-ind (mapcar #'car ctrl)))
                                    (maxbest (pw::g-max best)))  
                               (index-subst
                                best
                                (get-index best maxbest)
                                (list (pw::g+ (pw::g- sum (nth closest-ind diffs)) maxbest)))))
                            ((= sum (apply #'+ res)) res)
                            ((< sum (apply #'+ res))
                             (rec (1- try-sum) (cons (list res (apply #'+ res)) ctrl)))
                            ((> sum (apply #'+ res))
                             (rec (1+ try-sum) (cons (list res (apply #'+ res)) ctrl)))))))
           (rec sum nil)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef sum-consec-same-signum-n ((lst (list 1 1 -2 0 1)))
         "
It sums all same signum consecutive numbers

(sum-consec-same-signum-n '(2 2 -4 -2 -2 1 -1))
> (4 -8 1 -1)"

         (:class 'fs-tools
          :w 0.6)

         (cond ((null lst) ())
               ((single lst) lst)
               ((= (signum (car lst)) (signum (cadr lst)))
                (sum-consec-same-signum-n (cons (+ (car lst) (cadr lst)) (cddr lst))))
               (t (cons (car lst) (sum-consec-same-signum-n (cdr lst))))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef around-ser ((n 5) (step 1)
                     (from -2) (to 1))
         "
It returns a series of numbers starting from (+ N FROM) to (+ N TO) incrementing by STEP.
It's like 'arithm-ser', but starting from a different parametric point of view.

(around-ser 5 1 -2 1)
[(arithm-ser 3 1 6)]
> (3 4 5 6)"
;;rivedere testo

         (:class 'fs-tools
          :groupings '(2 2))

         (pw::arithm-ser (+ n from) step (+ n to)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef join-points ((start 1) (end 4)
                      (no-of-steps 3)
                      (number-type () (ccl::mk-menu-subview :menu-list '(("float" :float) ("ratio" :ratio)) :value 0))
                      ;;[se metto optional il menu numbertype e non lo apro nel box, la fn mi dà NIL]
                      &optional 
                      (round-decimals 2))
         "
It returns a number series starting from START and ending on END.
Between START and END, there are as much steps as defined by NO-OF-STEPS, whose values are calculated so that they are equally distant."
;;rivedere testo

         (:class 'fs-tools
          :groupings '(2 2)
          :extension-pattern '(1))

         (let* ((step (/ (- end start) (1+ no-of-steps)))
                (ser (pw::arithm-ser start step end)))
           (case number-type
             (:float (mapcar #'(lambda (x)
                                 (if (integerp x)
                                     x
                                     (pw::g-round x round-decimals)))
                             ser))
             (:ratio ser))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef min-max-rnd ((min 0) (max 9))
         "
..."
         
         (:class 'fs-tools)
         
         (+ min (random (1+ (- max min)))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef rnd-list ((min 0) (max 9)
                   (length 5))
         "
..."
         
         (:class 'fs-tools)
         
         (let (ris)
           (dotimes (i length ris)
             (push (min-max-rnd min max) ris))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef rnd-list-of-lists ((min 0) (max 9)
                            (length 5) (sub-length 3))
         "
..."
         
         (:class 'fs-tools)
         
         (let (ris)
           (dotimes (i length ris)
             (push (rnd-list min max sub-length) ris))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef rnd-length-rnd-list-of-lists ((min 0) (max 9)
                                       (sub-length-min 1) (sub-length-max 4)
                                       (length 5))
         "
..."
         
         (:class 'fs-tools)
         
         (let (ris)
           (dotimes (i length ris)
             (push (rnd-list min max (min-max-rnd sub-length-min sub-length-max)) ris))))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; END OF FILE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


