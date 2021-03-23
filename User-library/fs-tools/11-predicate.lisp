
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
;;;                                                     ;;;;;;;;;;;;;;;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PREDICATE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                     ;;;;;;;;;;;;;;;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(in-package :fs-tools)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; EQUALITY ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef all-equalp ((list '(a a a)))
         "
Are all elements of LIST equal, according to equalp test?"

         (:class 'fs-tools)

         (labels ((rec (x)
                    (or
                     (single x)
                     (and (equalp (car x) (cadr x)) (rec (cdr x))))))
           (or
            (null list)
            (single list)
            (rec list))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(system::add-box-type :equality-mbox
                      `(system::mk-menu-subview
                        :menu-list
                        ,(system::add-menu-list-keyword
                          :equality-list
                          '(("eq" eq)
                            ("eql" eql)
                            ("equal" equal)
                            ("equalp" equalp)))
                        :value 3))



(pwgldef poly-equality ((predicate () :equality-mbox)
                         (item '(a b c))
                         &rest (more-items '(a b c)))
         "
With this function you can apply an equality PREDICATE on an indeterminate number of elements."

         (:class 'fs-tools
                 :groupings '(1 1))

         (labels ((rec (x)
                    (or
                     (single x)
                     (and (funcall predicate (car x) (cadr x)) (rec (cdr x))))))
           (let ((objs (cons item more-items)))
           (or
            (null objs)
            (single objs)
            (rec objs)))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(system::add-box-type :duplicates?-mbox
                      `(system::mk-menu-subview
                        :menu-list
                        ,(system::add-menu-list-keyword
                          :duplicates?-list
                          '(:consider-duplicates
                            :not-consider-duplicates))
                        :value 1))



(pwgldef set-equal ((set1 '(a a (b) 1)) (set2 '((b) 1 a)) (consider-duplicates? () :duplicates?-mbox))
         "
Verifies if the lists SET1 and SET2 contain all same elements, without regard on order.
With 'consider-duplicates?' you can choose if duplicates have to be considered or not for equality test."
;; rivedere testo
;; fare &rest?

         (:class 'fs-tools
                 :groupings '(2 1))

         (labels ((remove-first-appearance (item lst)
                    (cond ((null lst) ())
                          ((equalp item (car lst)) (cdr lst))
                          (t (cons (car lst) (remove-first-appearance item (cdr lst))))))
                  (compare (set1 set2)
                    (cond ((and (null set1) (null set2)) t)
                          ((or (null set1) (null set2)) nil)
                          ((find (car set1) set2 :test 'equalp) (compare (cdr set1) (remove-first-appearance (car set1) set2)))
                          (t nil))))
           (case consider-duplicates?
             (:not-consider-duplicates (compare (remove-duplicates set1 :test #'equalp) (remove-duplicates set2 :test #'equalp)))
             (:consider-duplicates (compare set1 set2)))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; LENGTH ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef single ((list '(a)))
         "
Is LIST a one element list?
(Paul Graham, On Lisp)"

         (:class 'fs-tools)

         (and (consp list) (not (cdr list))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef length-p ((list '(a b c)) (length 3))
         "
Is LIST length equal to LENGTH?"

         (:groupings '(1 1))

         (labels ((rec (lst len)
                    (cond ((and (null lst) (zerop len)) length)
                          ((null lst) ())
                          ((<= len 0) ())
                          (t (rec (cdr lst) (1- len))))))
           (rec list length)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef eq-length ((list '(a b c)) &rest (more-lists '(d e f)))
         "
Do all lists have the same length?"

         (:class 'fs-tools)

         (labels ((rec (lol)
                    (cond ((eval `(and ,@(mapcar #'consp lol)));se tutte le sottoliste sono cons, procedi con i cdr delle sottoliste
                           (rec (mapcar #'cdr lol)))
                          ((eval `(or ,@(mapcar #'consp lol)));se alcune sono cons e altre nil, le liste sono di diversa lungh
                           ())
                          (t t))));altrimenti, se alla fine arrivano tutte insieme a nil, le liste sono della stessa lungh
           (rec (cons list more-lists))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef longer ((list1 '(a b c)) (list2 '(a b)))
         "
Is LIST1 longer than LIST2?
(Paul Graham, On Lisp)"

         (:class 'fs-tools
          :groupings '(1 1))

         (labels ((compare (list1 list2)
                    (and (consp list1) 
                         (or (null list2)
                             (compare (cdr list1) (cdr list2))))))
           (if (and (listp list1) (listp list2))
               (compare list1 list2)
               (> (length list1) (length list2)))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; POSITION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef before ((list '(a b c d))
                 (x 'b) (y 'c)
                 &key (test 'equalp))
         "
Does X appear before Y in LIST? (It returns T even if it does not find Y in LIST)
(Paul Graham, On Lisp)"

         (:class 'fs-tools
          :groupings '(1 2))

         (and list
              (let ((first (car list)))
                (cond ((funcall test y first) nil)
                      ((funcall test x first) list)
                      (t (before (cdr list) x y :test test))))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef after ((list '(a b c d))
                (x 'c) (y 'a)
                &key (test 'equalp))
         "
Does X appear after Y in LIST?
(Paul Graham, On Lisp)"

         (:class 'fs-tools
          :groupings '(1 2))

         (let ((rest (before list y x :test test)))
           (and rest (member x rest :test test))))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; REPETITION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef atleast ((list '(a b a c a))
                  (item 'a) (n 2)
                  &key (test 'equalp))
         "
Are there at least N ITEMs in LIST?"

         (:class 'fs-tools
          :groupings '(1 2))

         (cond ((null list) ())
               ((zerop n) list)
               ((and (= n 1) (funcall test item (car list))) list)
               ((funcall test item (car list)) (atleast (cdr list) item (1- n)))
               (t (atleast (cdr list) item n))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef atmost ((list '(a b a c))
                 (item 'a) (n 2)
                 &key (test 'equalp))
         "
Are there at most N ITEMs in LIST?"

         (:class 'fs-tools
          :groupings '(1 2))

         (cond ((and (null list) (>= n 0)) t)   
               ((minusp n) ())
               ((funcall test item (car list)) (atmost (cdr list) item (1- n)))
               (t (atmost (cdr list) item n))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef item-repeat-p ((list '(a b a c)) (item 'a)
                        &key (test 'equalp))
         "
Is there any repetition of ITEM in LIST?
(Paul Graham's 'duplicate', On Lisp)"

         (:class 'fs-tools
          :groupings '(1 1))

         (member item (cdr (member item list :test test)) 
                 :test test))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef local-repeat-p ((list '(a b b c))
                         &key (test 'equalp))
         "
Is there any local repetition in LIST?"

         (:class 'fs-tools)

         (cond ((null list) nil)
               ((single list) nil)
               ((funcall test (car list) (cadr list)) list)
               (t (local-repeat-p (cdr list)))))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; END OF FILE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


