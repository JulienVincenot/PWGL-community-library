
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
;;;                                                       ;;;;;;;;;;;;                                                                   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LIST ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                       ;;;;;;;;;;;;                                                                   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(in-package :fs-tools)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; TREE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;fare args &rest more-args, con labels, e parametri di esempio ['minusp '(1 (-1))] ma non riesco, prima devo capire il codice di Graham
(pwgldef deep-mapcar ((fn ()) &rest (args ()))
         "
It applies FN to every atom of ARGS. The difference with 'mapcar' is that ARGS can be trees.
(Paul Graham's 'rmapcar', On Lisp)"

         (:class 'fs-tools
          :w 0.3)

         (if (some #'atom args)
             (apply fn args)
             (apply #'mapcar 
                    #'(lambda (&rest args) 
                        (apply #'deep-mapcar fn args))
                    args)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef apply-tree-struct ((flat-list '(a b c))
                            (tree '((1) ((2) 3))))
        "
Applies tree structure of TREE on flat-list."

        (:class 'fs-tools
         :groupings '(1 1)
         :w 0.4)

        (cond ((or (null tree) (null flat-list))
               ())
              ((atom (car tree))
               (cons (car flat-list)
                     (apply-tree-struct (cdr flat-list) (cdr tree))))
              (t
               (cons (apply-tree-struct flat-list (car tree))
                     (apply-tree-struct (nthcdr (length (car tree)) flat-list) (cdr tree))))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef max-depth ((item '(a (b (c)))))
         "
It returns the max depth of ITEM."

         (:class 'fs-tools)

         (cond ((atom item) 0)
               (t (max (1+ (max-depth (car item)))
                       (max-depth (cdr item))))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; oppure list-n!
;; valuta se correggere la questione degli alberi irregolari, scrivendo una funzione alternativa a flat-once
(pwgldef list!! ((item '((a) (b))) (max-depth 3))
         "
It returns ITEM modified, adding or subtracting parenthesis level to ITEM so that ITEM max depth is equal to the choosed MAX-DEPTH.
ITEM can be an atom, a list or a tree.
NB: if ITEM is a tree with different depth elements, its max depth can't be reduced if one of its elements is an atom; e.g. (list!! '(a (b)) 1) -> (a (b))
If MAX-DEPTH is <= 0, it returns car of ITEM."

         (:class 'fs-tools)

         (labels ((rec (x ctrl)
                    (let ((d (max-depth x))) 
                    (cond ((= ctrl d) x) ;per evitare loop infiniti con flat-once, ad esempio con (a (b)) depth 1, flat-once non riduce la lista a (a b), resta (a (bv)
                          ((= d max-depth) x)
                          ((< d max-depth) (rec (list x) d))
                          ((> d max-depth) (rec (pw::flat-once x) d))))))
           
           (if (<= max-depth 0)
               (pw::car! item)
               (rec item -1))))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; INDEX ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef c-r ((ad-index 'aadadda) (list '((1 2 (3 (4))))))
         "It extends to infinity the possibility of c-a-d-r combinations.
(c-r 'ad '(1 2 3)) is the same of (cadr '(1 2 3))
(c-r 'aadadda '((1 2 (3 (4))))) is the same of (car (car (cdr (car (cdr (cdr (car '((1 2 (3 (4)))))))))))"

         (:class 'fs-tools
          :groupings '(1 1))
         
  (labels ((rec (i l)
             (cond ((nullstring i) l)
                   ((equalp (firstring i) "a") (rec (restring i) (car l)))
                   ((equalp (firstring i) "d") (rec (restring i) (cdr l)))
                   (t (rec (restring i) l)))))
    (rec (reverse (string ad-index)) list)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef get-index ((list '(a b a c))
                    (item 'a)
                    &key (test 'equalp))
         "
It returns all ITEM indices in LIST."

         (:class 'fs-tools
          :groupings '(1 1))

         (labels ((rec (list item index)
                    (cond ((null list) nil)
                          ((funcall test (car list) item) (cons index (rec (cdr list) item (1+ index))))
                          (t (rec (cdr list) item (1+ index))))))
           (rec list item 0)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef get-first-n-index ((list '(a b a c a d a))
                            (item 'a) (n 2)
                            &key (test 'equalp))
         "
It returns the first N ITEM indices in LIST."

         (:class 'fs-tools
          :groupings '(1 2)
          :w 0.4)

         (labels ((rec (item list index n)
                    (cond ((null list) ())
                          ((<= n 0) nil)
                          ((funcall test item (car list)) (cons index (rec item (cdr list) (1+ index) (1- n))))
                          (t (rec item (cdr list) (1+ index) n)))))
           (rec item list 0 n)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef get-index-if ((test 'minusp)
                       (list '(-1 2 3 -4)))
         "
It returns the indices of the elements in LIST selected by TEST."

         (:class 'fs-tools
          :groupings '(1 1)
          :w 0.4)

         (labels ((rec (list test index)
                    (cond ((null list) nil)
                          ((funcall test (car list)) (cons index (rec (cdr list) test (1+ index))))
                          (t (rec (cdr list) test (1+ index))))))
           (rec list test 0)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef get-first-n-index-if ((test 'minusp) (n 1)
                               (list '(-1 2 3 -4)))
         "
It returns the first N indices of the elements in LIST selected by TEST."
        
         (:class 'fs-tools
          :groupings '(2 1)
          :w 0.4)

         (labels ((rec (list test index n)
                    (cond ((null list) nil)
                          ((<= n 0) nil)
                          ((funcall test (car list)) (cons index (rec (cdr list) test (1+ index) (1- n))))
                          (t (rec (cdr list) test (1+ index) n)))))
           (rec list test 0 n)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef index-subst ((list '(a b c d))
                      (index-list '(1 3)) (new-items '(x y)))
         "
It puts the elements of NEW-ITEMS in LIST in the positions selected by index-list, substituting the existing ones."
        
         (:class 'fs-tools
          :groupings '(1 2)
          :w 0.4)

         (labels ((single-index-subst (list index new)
                    (cond ((null list) list)
                          ((= index 0) (cons new (cdr list)))
                          (t (cons (car list) (single-index-subst (cdr list) (1- index) new))))))
           (let ((temp (single-index-subst list (car index-list) (car new-items))))
             (cond ((or (null (cdr index-list)) (null (cdr new-items))) temp)
                   (t (index-subst temp (cdr index-list) (cdr new-items)))))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef index-remove ((list '(a b c d))
                       (index-list '(1 3)))
         "
It removes from LIST the elements selected by index-list."

         (:class 'fs-tools
          :groupings '(1 1)
          :w 0.4)

         (labels ((rec (list ind)
                    (cond ((or (null list) (null ind)) list)
                          ((zerop (car ind)) (rec (cdr list) (mapcar #'1- (cdr ind))))
                          (t (cons (car list) (rec (cdr list) (mapcar #'1- ind)))))))
           (rec list (sort index-list #'<))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef index-repeat ((list '(a b c))
                       (index-list '(0 1)) (time-list '(2 0)))
         "
It returns a list in which the elements selected by index-list are repeated respectively a number of time-list indicated in time-list. If time-list is 0, element is removed."

         (:class 'fs-tools
          :groupings '(1 2)
          :w 0.4)

         (let* ((index-list! (pw::list! index-list)) ;se index-list è uno solo, ok anche atom
                (time-list! (cond ((atom time-list) (repeat (length index-list!) time-list)) ;se time-list è uno solo ok anche atomo e vale per tutti gli index-list
                              (t time-list))))
           (labels ((nth-repeat (list nth time-list)
                      (cond ((null list) ())
                            ((zerop nth) (append (repeat time-list (car list)) (cdr list)))
                            (t (cons (car list) 
                                     (nth-repeat (cdr list) (1- nth) time-list)))))
                    (multi-nth-rep (list index-list time-list)
                      (cond ((or (null list) (null index-list) (null time-list)) list)
                            (t (multi-nth-rep
                                (nth-repeat list (car index-list) (car time-list))
                                (system::g+ (cdr index-list) (1- (car time-list)))
                                (cdr time-list))))))
             (apply #'multi-nth-rep `(,list ;accoppia index-list! e time-list!, li ordina per index-list e li disaccoppia
                                      ,@(pw::mat-trans
                                         (sort (pw::mat-trans (list index-list! time-list!))
                                               #'<
                                               :key #'car)))))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef mapindex ((fn '+)
                   (list '(1 1 1))
                   (index-list '(0 2)) &rest (args '(2 2)))
         "
...
NB: la lungh di index-list e di ciascun eventuale arg deve corrispondere"

         (:class 'fs-tools
          :groupings '(1 1 1)
          :extension-pattern '(1)
          :w 0.4)
         
         (labels ((index-fn (list index args-cars)
                    (cond ((null list) ())
                          ((zerop index) (cons (apply fn (cons (car list) args-cars)) (cdr list)))
                          (t (cons (car list) (index-fn (cdr list) (1- index) args-cars))))))

           (let ((temp (index-fn list (car index-list) (mapcar #'car args))))
             (cond ((null (cdr index-list)) temp)
                   (t (eval `(mapindex #',fn ',temp ',(cdr index-list) ,@(mapcar #'(lambda (x) (list 'quote (cdr x))) args))))))));eval con ,@ altrimenti ogni ricorsione mi aggiunge un livello di parentesi ad args a causa di &rest



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef deep-nth ((deep-index '(1 0))
                   (tree '(a (b))))
         "
It's a recursive nth:
(deep-nth '(1 0) '(a (b)))
equals
(nth 1 (nth 0 '(a (b))))"

         (:class 'fs-tools
          :groupings '(1 1)
          :w 0.4)

         (cond ((null deep-index) tree)
               (t (deep-nth (cdr deep-index) (nth (car deep-index) tree)))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef get-deep-index ((tree '(a (a b a)))
                         (item 'a)
                         &key (test 'equalp))
         "
It returns deep indices of item in TREE. E.g.
(get-deep-index '(a (a b a)) 'a) => ((0) (1 0) (1 2))"

         (:class 'fs-tools
          :groupings '(1 1)
          :w 0.4)

         (labels ((last+ (list)
                    (append (butlast list) (list (1+ (car (last list))))))
                  (rec (tree item index)
                    (cond ((null tree) nil)
                          ((funcall test (car tree) item)
                           (cons index (rec (cdr tree) item (last+ index))))
                          ((consp (car tree))
                           (append (rec (car tree) item (append index '(0)))
                                   (rec (cdr tree) item (last+ index))))
                          (t (rec (cdr tree) item (last+ index))))))
           (rec tree item '(0))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef deep-index-subst ((tree '(a (b c) ((d))))
                           (deep-indices '((0) (2 0 0))) (new-items '(x (y z))))
         "
It replaces NEW-ITEMS selected by DEEP-INDICES in TREE. E.g.
(deep-index-subst '(a (b c) ((d))) '((0) (2 0 0)) '(x (y z)))
> (x (b c) (((y z))))"

         (:class 'fs-tools
          :groupings '(1 2)
          :w 0.4)

         (labels ((deep-index-single-subst (tree deep-index new)
                    (cond ((or (null tree) (null deep-index))
                           new)
                          ((and (atom tree) (= (car deep-index) 0) (null (cdr deep-index)))
                           new)
                          ((= (car deep-index) 0)
                           (cons (deep-index-single-subst (car tree) (cdr deep-index) new) (cdr tree)))
                          (t
                           (cons (car tree)
                                 (deep-index-single-subst (cdr tree) (cons (1- (car deep-index)) (cdr deep-index)) new))))))
           (cond ((or (null deep-indices) (null new-items))
                  tree)
                 ((or (single deep-indices) (single new-items))
                  (deep-index-single-subst tree (car deep-indices) (car new-items)))
                 (t (deep-index-subst
                     (deep-index-single-subst tree (car deep-indices) (car new-items))
                     (cdr deep-indices)
                     (cdr new-items))))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef append-index ((list '(a b c)))
         "
It returns a list in which each element becomes a new sublist whose the car is his index."
         
         (:class 'fs-tools
          :w 0.4)

         (labels ((rec (list index)
                    (cond ((null list) ())
                          (t (cons (list index (car list))
                                   (rec (cdr list) (1+ index)))))))
           (rec list 0)))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; MODIFY ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef fill-nil ((list '(nil 1 nil nil 2 3 nil)))
         "
It substitutes nil with the previous non-nil item closest to every nil; if there are some nil on the list start, those are replaced by the first non-nil item."
         
         (:class 'fs-tools)

         (labels ((rep-prev (list)
                    (cond ((null (cdr list)) list)     
                          ((null (cadr list)) (cons (car list) (rep-prev (cons (car list) (cddr list)))))
                          (t (cons (car list) (rep-prev (cdr list))))))
                  (fill-start (list cnt)
                    (cond ((null list) ())
                          ((null (car list)) (fill-start (cdr list) (1+ cnt)))
                          (t (append (repeat cnt (car list)) list)))))
           (fill-start (rep-prev list) 0)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef deep-remove-if ((test 'evenp)
                         (tree '(1 (2 3) 4)))
         "
It's a remove-if for tree.
(Paul Graham's 'prune', On Lisp)"
         
         (:class 'fs-tools
          :groupings '(1 1)
          :w 0.4)

         (labels ((rec (tree acc)
                    (cond ((null tree) (nreverse acc))
                          ((consp (car tree))
                           (rec (cdr tree) 
                                (cons (rec (car tree) nil) acc)))
                          (t (rec (cdr tree)
                                  (if (funcall test (car tree))
                                      acc
                                      (cons (car tree) acc)))))))
           (rec tree nil)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; resize-list ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(system::add-box-type :approx-resize-list 
                      `(system::mk-menu-subview
                        :menu-list
                        ,(system::add-menu-list-keyword
                          :resize-list-list
                          '(":most-then-first"
                            ":most-then-last"
                            ":most-then-highest"
                            ":most-then-lowest"
                            ":the-first"
                            ":the-last"
                            ;":the-highest"
                            ;":the-lowest"
                            ":most-positive";;o the positive, o favor positive?
                            ;":most-negative"
                            ":average"))
                        :value 0))



(pwgldef resize-list ((list '(1 2 3))
                      (new-length 5)
                      (approx-mode () :approx-resize-list)
                      (round-decimals 2))
                      "
It resizes LIST to NEW-LENGTH, repeating or deleting its elements according to APPROX-MODE, that is the resampling method you can choose:
- MOST-THEN-FIRST chooses prevailing element in the sample, but, if various elements are perfectly balanced, this method choose the first one.
- MOST-THEN-LAST chooses prevailing element in the sample, but, if various elements are perfectly balanced, this method choose the last one.
- MOST-THEN-HIGHEST (only for number lists) chooses prevailing number in the sample, but, if various numbers are perfectly balanced, this method choose the higher one.
- MOST-THEN-LOWEST (only for number lists) chooses prevailing number in the sample, but, if various numbers are perfectly balanced, this method choose the lower one.
- THE-FIRST chooses the first element of the sample.
- THE-LAST chooses the last element of the sample.
- THE-HIGHEST (da fare)
- THE-LOWEST (da fare)
- MOST-POSITIVE (only for number lists) favors elements with positive signum
- MOST-NEGATIVE (da fare) favors elements with negative signum
- AVERAGE (only for number lists)

ROUND-DECIMALS: set this parameter if you choose 'average' approx-mode";;rivedere testo

                      (:class 'fs-tools
                       :groupings '(1 1 1 1)
                       :w 0.4)

                      (let ((append-slot (mapcar #'(lambda (x) (list new-length x)) list))
                            (old-length (length list)))
                        
                        (labels ((take-slice (list old-length) ;slice-car
                                   (cond ((null list) ())
                                         ((<= old-length (caar list)) (list (cons old-length (cdar list))))
                                         (t (cons (car list) (take-slice (cdr list) (- old-length (caar list)))))))
                                 
                                 (discard-slice (list old-length) ;slice-cdr
                                   (cond ((null list) ())
                                         ((> (caar list) old-length)
                                          (append (list (cons (- (caar list) old-length) (cdar list))) (cdr list)))
                                         (t (discard-slice (cdr list) (- old-length (caar list))))))
                                 
                                 (most-then-first (list)
                                   (cond ((null list) ())
                                         (t (cons (cadar (sort (take-slice list old-length) #'> :key #'car))
                                                  (most-then-first (discard-slice list old-length))))))
                                 
                                 (most-then-last (list)
                                   (cond ((null list) ())
                                         (t (cons (cadar (last (sort (take-slice list old-length) #'< :key #'car)))
                                                  (most-then-last (discard-slice list old-length))))))
                                 
                                 (most-then-highest (list)
                                   (cond ((null list) ())
                                         (t (cons (cadar (sort (sort (take-slice list old-length) #'> :key #'car) #'> :key #'length))
                                                  (most-then-highest (discard-slice list old-length))))))
                                 
                                 (most-then-lowest (list)
                                   (cond ((null list) ())
                                         (t (cons (cadar (sort (sort (take-slice list old-length) #'< :key #'car) #'> :key #'length))
                                                  (most-then-lowest (discard-slice list old-length))))))
                                 
                                 (the-first (list)
                                   (cond ((null list) ())
                                         (t (cons (cadar (take-slice list old-length))
                                                  (the-first (discard-slice list old-length))))))
                                 
                                 (the-last (list)
                                   (cond ((null list) ())
                                         (t (cons (cadar (last (take-slice list old-length)))
                                                  (the-last (discard-slice list old-length))))))
                                 
                                 (most-positive (list)
                                   (cond ((null list) ())
                                         (t
                                          (let* ((positive-list? (remove-if #'minusp (take-slice list old-length) :key 'cadr))
                                                 (positive-list (if (null positive-list?) (list (list 0 -1)) positive-list?)))
                                            (cons (cadar (sort positive-list #'> :key #'car))
                                                  (most-positive (discard-slice list old-length)))))))
                                 
                                 (average (list round-decimals);;rifarlo, in modo che riproduca la curva fedelmente, vedi JOIN-POINTS
                                   (cond ((null list) ())
                                         (t (cons (pw::g-round
                                                   (pw::g-average
                                                    (mapcar #'cadr (take-slice list old-length)) 
                                                    1)
                                                   round-decimals)
                                                  (average (discard-slice list old-length) round-decimals))))))
                          ;end of labels
                          
                          (if (<= new-length 0)
                              ()
                              (case approx-mode
                                (:most-then-first
                                 (most-then-first append-slot))
                                (:most-then-last
                                 (most-then-last append-slot))
                                (:most-then-highest
                                 (most-then-highest append-slot))
                                (:most-then-lowest
                                 (most-then-lowest append-slot))
                                (:the-first
                                 (the-first append-slot))
                                (:the-last
                                 (the-last append-slot))
                                (:most-positive
                                 (most-positive append-slot))
                                (:average
                                 (average append-slot round-decimals)))
                              ))))



;;; end of resize-list ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef align-to-min-length ((list-of-lists '((1 2) (4 5 6) (7)))
                              (method () (ccl::mk-menu-subview :menu-list '(("cut-end" :cut-end) ("cut-start" :cut-start) ("resize-list" :resize-list)) :value 0))
                              &optional
                              (approx-mode () :approx-resize-list)
                              (round-decimals 0))
         "
It alligns every sublist to the shorter list length, using the choosed method:
AVVISA DI ESTENDERE BOX SE USA RESIZE LIST (ALTRIMENTI NON VALORIZZA I PARAMETRI NASCOSTI)
..."
;;rivedere testo

         (:class 'fs-tools
          :groupings '(1 1)
          :extension-pattern '(1 1)
          :w 0.5)

         (let ((min-length (eval `(min ,@(mapcar #'length list-of-lists)))))
           (case method
             (:cut-end
              (mapcar #'(lambda (x) (subseq x 0 min-length)) list-of-lists))
             (:cut-start
              (mapcar #'(lambda (x) (subseq x (- (length x) min-length))) list-of-lists))
             (:resize-list
              (mapcar #'(lambda (x) (resize-list x min-length approx-mode round-decimals)) list-of-lists)))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef align-to-max-length ((list-of-lists '((1 2) (4 5 6) (7)))
                              (method () (ccl::mk-menu-subview :menu-list '(("last-elem" :last-elem) ("fill-item" :fill-item) ("resize-list" :resize-list)) :value 0))
                              &optional
                              (fill-item 0)
                              (approx-mode () :approx-resize-list)
                              (round-decimals 0))
         "
It alligns every sublist to the shorter list length, using the choosed method:
AVVISA DI ESTENDERE BOX SE USA RESIZE LIST (ALTRIMENTI NON VALORIZZA I PARAMETRI NASCOSTI (chissà perchéper fill-item non serve estendere, forse perché non è menu))
..."
;;rivedere testo

         (:class 'fs-tools
          :groupings '(1 1)
          :extension-pattern '(1 1 1)
          :w 0.5)

         (let ((max-length (eval `(max ,@(mapcar #'length list-of-lists)))))
           (case method
             (:last-elem
              (mapcar #'(lambda (x) (append x (repeat (- max-length (length x)) (car (last x))))) list-of-lists))
             (:fill-item
              (mapcar #'(lambda (x) (append x (repeat (- max-length (length x)) fill-item))) list-of-lists))
             (:resize-list
              (mapcar #'(lambda (x) (resize-list x max-length approx-mode round-decimals)) list-of-lists)))))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SEARCH ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;; first-most ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defclass fs-first-most (fs-tools) ())



(defmethod patch-value ((self fs-first-most) output)
  (let ((pos (position output (pwgl-outputs self))))
    (nth-output-patch-value self pos)))



(defmethod nth-output-patch-value ((self fs-first-most) (out (eql 0)))
  (first-most-most (nth-patch-value self 0) (nth-patch-value self 1)))



(defmethod nth-output-patch-value ((self fs-first-most) (out (eql 1)))
  (first-most-score (nth-patch-value self 0) (nth-patch-value self 1))) 



(defun first-most-most (fn list)
  (if (null list)
      ()
      (let* ((wins (car list))
             (max (funcall fn wins)))
        (dolist (obj (cdr list))
          (let ((score (funcall fn obj)))
            (when (> score max)
              (setq wins obj
                    max score))))
        wins)))



(defun first-most-score (fn list)
  (if (null list)
     ()
      (let* ((wins (car list))
             (max (funcall fn wins)))
        (dolist (obj (cdr list))
          (let ((score (funcall fn obj)))
            (when (> score max)
              (setq wins obj
                    max score))))
        max)))



(PWGLDef first-most ((fn 'length)
                     (list '((a b) (a b c) (a) (e f g))))
         "
It returns the best element of LIST (or the first of all the best elements), according to the FN criterion;
the second output returns the score of the best element, according to the FN criterion.
(Paul Graham's 'most', On Lisp)";;rivedere

         (:class 'fs-first-most :outputs '("most" "score")
                 :groupings '(1 1))

         ())



;;; end of first-most ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;; all-most ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defclass fs-all-most (fs-tools) ())



(defmethod patch-value ((self fs-all-most) output)
  (let ((pos (position output (pwgl-outputs self))))
    (nth-output-patch-value self pos)))



;
(defmethod nth-output-patch-value ((self fs-all-most) (out (eql 0)))
  (all-most-most (nth-patch-value self 0) (nth-patch-value self 1)))



;
(defmethod nth-output-patch-value ((self fs-all-most) (out (eql 1)))
  (all-most-score (nth-patch-value self 0) (nth-patch-value self 1))) 



(defun all-most-most (fn list)
  (if (null list)
      ()
      (let ((result (list (car list)))
            (max (funcall fn (car list))))
        (dolist (obj (cdr list))
          (let ((score (funcall fn obj)))
            (cond ((> score max)
                   (setq max score
                         result (list obj)))
                  ((= score max)
                   (push obj result)))))
        (nreverse result))))



(defun all-most-score (fn list)
  (if (null list)
      ()
      (let ((result (list (car list)))
            (max (funcall fn (car list))))
        (dolist (obj (cdr list))
          (let ((score (funcall fn obj)))
            (cond ((> score max)
                   (setq max score
                         result (list obj)))
                  ((= score max)
                   (push obj result)))))
        max)))



(PWGLDef all-most ((fn 'length) (list '((a b) (a b c) (a) (e f g))))
         "
It returns all the best elements of LIST, according to the FN criterion;
the second output returns the score of the best elements, according to the FN criterion.
(Paul Graham's 'most', On Lisp)";;rivedere

         (:class 'fs-all-most
          :outputs '("most" "score")
          :groupings '(1 1))

         ())



;;; end of all-most ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef best ((fn '<) (list '(1 4 2 5 3)))
              "
It returns the best element of LIST, according to the comparison FN.

(best #'< '(1 4 2 5 3))
> 1
(Paul Graham, On Lisp)";;rivedere

              (:class 'fs-tools
               :groupings '(1 1))

              (if (null list)
                  nil
                  (let ((wins (car list)))
                    (dolist (obj (cdr list))
                      (if (funcall fn obj wins)
                          (setq wins obj)))
                    wins)))



;;; nearest ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defclass fs-nearest (fs-tools) ())



(defmethod patch-value ((self fs-nearest) output)
  (let ((pos (position output (pwgl-outputs self))))
    (nth-output-patch-value self pos)))



(defmethod nth-output-patch-value ((self fs-nearest) (out (eql 0)))
  (nearest-values (nth-patch-value self 0) (nth-patch-value self 1)))



(defmethod nth-output-patch-value ((self fs-nearest) (out (eql 1)))
  (nearest-indices (nth-patch-value self 0) (nth-patch-value self 1))) 



(defun nearest-indices (list n)
  (let ((diff-list (pw::g-abs (pw::g- n list))))
    (get-index diff-list (pw::g-min diff-list))))



(defun nearest-values (list n)
  (mapcar #'(lambda (x) (nth x list))
          (nearest-indices list n)))



(PWGLDef nearest ((list '(1 3 5 7)) (n 4))
         "
It chooses the element(s) whose absolute value of the difference to N are the minimum; in other words, it chooses the closest element(s) to N."

         (:class 'fs-nearest :outputs '("values" "indices"))

         ())



;;; end of nearest ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; GROUP & SPLIT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef group-list-ending-with-element ((list '(a b x d x x e))
                                         (element 'x))
         "
It groups LIST creating new subgroups ending with ELEMENT; obviously, if the list does not end with ELEMENT, the last subgroup will not end with ELEMENT. It completes jbs-cmi group functions."

         (:class 'fs-tools
          :groupings '(1 1)
          :w 0.4)

         (labels ((before+element (list element)
                    (cond
                     ((null list) ())
                     ((equalp element (car list)) (list (car list)))
                     (t (cons (car list) (before+element (cdr list) element)))))
                  (after-element (list element)
                    (cond
                     ((null list) ())
                     ((equalp element (car list)) (cdr list))
                     (t (after-element (cdr list) element)))))
           (cond
            ((null list) ())
            (t (cons (before+element list element) (group-list-ending-with-element (after-element list element) element))))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef group-starting-if ((test 'numberp) (list '(a 1 b c 2 3 d 4)))
         "
It groups LIST creating new subgroups starting with every element selected by TEST"

          (:class 'fs-tools
           :groupings '(1 1)
           :w 0.4)

          (labels ((group (list)
                     (cond ((null list) ())
                           ((and (cdr list) (funcall test (cadr list))) (list (car list)))
                           (t (cons (car list) (group (cdr list))))))
                   (after (list)
                     (cond ((null list) ())
                           ((and (cdr list) (funcall test (cadr list))) (cdr list))
                           (t (after (cdr list))))))
            (cond ((null list) ())
                  (t (cons (group list) (group-starting-if test (after list)))))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef group-by-length ((list-of-lists '((a b) (a) (x y) (m n) (x) (a b c))))
         "
It groups sublists by equal length"

         (:class 'fs-tools
          :W 0.4)

         (let (ris)
           (dolist (l (sort-remdups-maplength list-of-lists) ris)
             (push (remove-if #'(lambda (x) (/= (length x) l)) list-of-lists) ris))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; split-if ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defclass fs-split-if (PWGL-box) ())



(defmethod patch-value ((self fs-split-if) output)
  (let ((pos (position output (pwgl-outputs self))))
    (nth-output-patch-value self pos)))



(defmethod nth-output-patch-value ((self fs-split-if) (out (eql 0)))
  (split-if-1 (nth-patch-value self 0) (nth-patch-value self 1)))



(defmethod nth-output-patch-value ((self fs-split-if) (out (eql 1)))
  (split-if-2 (nth-patch-value self 0) (nth-patch-value self 1))) 



(defun split-if-1 (test list)
  (let ((acc nil))
    (do ((src list (cdr src)))
        ((or (null src) (funcall test (car src)))
         (nreverse acc))
      (push (car src) acc))))



(defun split-if-2 (test list)
  (let ((acc nil))
    (do ((src list (cdr src)))
        ((or (null src) (funcall test (car src)))
         src)
      (push (car src) acc))))



(PWGLDef split-if ((test '#'(lambda (x) (> x 4))) (list '(1 2 3 4 5 6 7 8 9 10)));;nel box appare (function (lambda (x) (> x 4))), preferirei #'
         "
It splits LIST on the first element selected by TEST
(Paul Graham, On Lisp)"

         (:class 'fs-tools
          :class 'fs-split-if :outputs '("1" "2")
          :groupings '(1 1))

         ())



;;; end of split-if ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; COUNT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef count-equals ((list '(b a c a a c))
                       &key (test 'equalp))
         "
It counts the recurrences of each different element in LIST and returns a list of lists of whose every sublist is composed by every different element and its recurrence in LIST.
E.g.
(count-equals '(b a c a a c)
> ((b 1) (a 3) (c 2))"

         (:class 'fs-tools
          :w 0.4)

         (mapcar #'(lambda (x) (list x (count x list :test test)))
                 (remove-duplicates list :test test)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;nome non convince, display-repet-scheme, repet-scheme
;;visto che pui scegier il test, dovrebbe essere count-consec-pred
(pwgldef count-consec-equals ((list '(a a b b b c))
                              &key (test 'equalp))
         "
It counts consecutive equal elements in LIST, and returns the list of recurrences.
E.g.
(count-consec-equals '(a a b b b c))
> (2 3 1)
"

         (:class 'fs-tools
          :w 0.4)

         (labels ((cnt (list)
                    (cond ((null list) 0)
                          ((funcall test (car list) (cadr list))
                           (1+ (cnt (cdr list))))
                          (t 1)))
                  (next (list)
                    (cond ((null list) ())
                          ((funcall test (car list) (cadr list))
                           (next (cdr list)))
                          (t (cdr list)))))
           (cond ((null list) ())
                 (t (cons (cnt list) (count-consec-equals (next list)))))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef count-common-items ((list1 '(a b c))
                             (list2 '(c d b))
                             &key (test 'equalp))
         "
Restituisce il numero di elementi comuni tra LIST1 e LIST2.
E.g.
(count-common-items '(a b c) '(b c x y))
< 2

NB: Le liste in ingresso vengono trattate come insiemi, cioè non vengono conteggiate le ripetizioni di uno stesso elemento all'interno di una stessa lista.
E.g.
(count-common-items '(a a a b c) '(a b b x))
< 2 [i.e.'a' and 'b']
"

         (:class 'fs-tools
          :groupings '(1 1)
          :w 0.4)

         (let ((score 0)
               (lst1 (remove-duplicates list1 :test 'equalp))
               (lst2 (remove-duplicates list2 :test 'equalp)))
           (dolist (item lst1 score)
             (mapcar #'(lambda (x) (if (funcall test item x) (incf score))) lst2))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;nome?
(pwgldef item-intervals ((list '(b c a a d c a b))
                         (item 'a)
                         &key (test 'equalp))
         "
It returns the list of intervals between every recurrence of ITEM and the next one, in LIST
E.g.
(item-intervals '(b c a a d c a b) 'a)
> (1 3)
"

         (:class 'fs-tools
          :groupings '(1 1)
          :w 0.4)

         (labels ((rec (list switch int)
                    (cond ((null list) ())
                          ((and switch (funcall test item (car list))) (cons (1+ int) (item-intervals list item)))
                          ((funcall test item (car list)) (rec (cdr list) t int))
                          ((and switch (not (equalp item (car list)))) (rec (cdr list) switch (1+ int)))
                          (t (rec (cdr list) switch int)))))
           (rec list nil 0)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef intrv-betw-equals ((list '(a a b c b a))
                            &key (test 'equalp))
         "
It calculates every interval between every item and its next recurrence, and returns a list of lists in which every sublist is composed by item name and interval between it and its next recurrence.

"

         (:class 'fs-tools
          :w 0.4)

         (labels ((car-intrv (frst rst intv)
                    (cond ((null rst) ())
                          ((funcall test frst (car rst)) (list frst intv))
                          (t (car-intrv frst (cdr rst) (1+ intv)))))
                  (cdr-intrv (list intrv)
                    (cond ((null list) ())
                          (t (remove ;;vorrei modo elegante per evitare remove nil
                              nil
                              (cons (car-intrv (car list) (cdr list) intrv) (cdr-intrv (cdr list) 1))
                              :test test)))))
           (cdr-intrv list 1)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef map-length ((list-of-lists '((a b) (a) (a b c))))
         "
It returns the LIST-OF-LIST sublist length list."

         (:class 'fs-tools
          :w 0.4)

         (mapcar #'length list-of-lists))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; END OF FILE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


