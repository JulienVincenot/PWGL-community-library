(defpackage :jv-components (:use :cl :ompw :iterate))
(in-package :jv-components)

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef) ::jv-components))

(in-package :jv-components)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;               EXPLORATION             ;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun test (a b)
       (list (+ a b) (* a b)))


























;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;               DEVELOPMENT             ;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;; NUMERICAL PROFILES INTERPOLATION ;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;; GROUPINGS & INDEXES ;;;;;;;;;;;;;;;


(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef ccl::patch-value ccl::PWGL-box ccl::nth-patch-value ccl::pwgl-outputs) :jv-components))
  
(in-package :jv-components)

(defclass my-groupings (PWGL-box) ())

(defmethod patch-value ((self my-groupings) output)
  (let ((pos (position output (pwgl-outputs self))))
    (nth-output-patch-value self pos)))

(defmethod nth-output-patch-value ((self my-groupings) (out (eql 0)))
  (groupings-1 (nth-patch-value self 0) (nth-patch-value self 1)))
; groupings

(defmethod nth-output-patch-value ((self my-groupings) (out (eql 1)))
  (groupings-2 (nth-patch-value self 0) (nth-patch-value self 1))) 
; indexes

(defun groupings-1 (x y)
  (jbs-cmi::group-list (first y) (pw::x->dx (pw::g-round (pw::g-scaling/max (sort (second x) #'<) (length (first y))))) :stop))

(defun groupings-2 (x y)
  (mapcar #'list (pw::arithm-ser 0 1 (1- (length (pw::x->dx (pw::g-round (pw::g-scaling/max (sort (second x) #'<) (length (first y))))))))))


(PWGLDef groupings ((x 'nil) (y 'nil))
  "Cut a BPF into smaller BPFSs according to segmentation points (additionnal BPF) or markers on the second plan."
  (:class 'my-groupings :outputs '("groupings" "indexes"))
  ())


;(add-box-type :yes-maybe-mbox 
;  `(mk-menu-subview :menu-list ,(add-menu-list-keyword :yes-no-list '(":t" ":nil" ":maybe")) :value 1))

;(PWGLDef abc2 ((a 1) (b 2) (c () :yes-maybe-mbox))    ;; <name>  <args> 
;  "PWGLDef abc2"                                       ;; <documentation>
; ()                                                    ;; <keyword-args>
; (cond ((eq c :maybe) "maybe")                         ;; <body>
;       ((eq c :nil) ())
;       (t (+ a b))))












;;;;;;;; METAMORPHER - INT ;;;;;;;;;

(in-package :jv-components)


(PWGLDef metamorpher ((profile1 'nil) (profile2 'nil) (steps '10) (curve '1))
  "Metamorpher : Supervized Interpolation of Numerical Intensity Profiles."
()
  (let* ((prof1 (mapcar #'system::flat profile1))
         (prof2 (mapcar #'system::flat profile2)))
                                              (mapcar #'system::flat 
                                                      (pw::mat-trans 
                                                       (iter (for x in prof1)
                                                             (for y in prof2)
                                                             
                                                             (let ((lenx (length x))
                                                                   (leny (length y)))
                                                               
                                                               (collect 
                                                                (iter
                                                                 (for a in (system::flat (pw::g-round 
                                                                                          (pw::interpolation lenx leny steps curve))))
                                                                 
                                                                 (for b in (pw::interpolation (if (= lenx leny)
                                                                                                x
                                                                                                (if (> lenx leny)
                                                                                                  x
                                                                                                  (system::flat (system::pwgl-sample 
                                                                                                                 (system::mk2D-object :bpf (list (pw::arithm-ser 0 1 (- lenx 1)) x)) 
                                                                                                                 leny))))
                                                                                              
                                                                                              (if (= lenx leny)
                                                                                                y
                                                                                                (if (> lenx leny)
                                                                                                  (system::flat (system::pwgl-sample 
                                                                                                                 (system::mk2D-object :bpf (list (pw::arithm-ser 0 1 (- leny 1)) y)) 
                                                                                                                 lenx)) 
                                                                                                  y))
                                                                                              steps
                                                                                              curve))
                                                                 
                                                               
                                                                 (collect (system::pwgl-sample (system::mk2D-object :bpf (list (pw::arithm-ser 0 1 (- (length b) 1)) b)) a)))) 

                                                               )
                                                             
                                                             )))))




;;;;;;;; MORPHOGENETIC SCHEMES - INT ;;;;;;;;;

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef ccl::patch-value ccl::PWGL-box ccl::nth-patch-value ccl::pwgl-outputs) :jv-components))
  
(in-package :jv-components)

(defclass my-morphogenetic-schemes (PWGL-box) ())

(defmethod patch-value ((self my-morphogenetic-schemes) output)
  (let ((pos (position output (pwgl-outputs self))))
    (nth-output-patch-value self pos)))

(defmethod nth-output-patch-value ((self my-morphogenetic-schemes) (out (eql 0)))
  (morphogenetic-scheme-1 (nth-patch-value self 0) (nth-patch-value self 1) (nth-patch-value self 2)(nth-patch-value self 3) (nth-patch-value self 4)))
; original

(defmethod nth-output-patch-value ((self my-morphogenetic-schemes) (out (eql 1)))
  (morphogenetic-scheme-2 (nth-patch-value self 0) (nth-patch-value self 1) (nth-patch-value self 2)(nth-patch-value self 3) (nth-patch-value self 4))) ; norma-sized


(PWGLDef morphogenetic-schemes ((profile1 'nil) (profile2 'nil) (steps '10) (curve '1) (shift '1.2))
  "Explicit visualization of metamorphosis process."
  (:class 'my-morphogenetic-schemes :outputs '("original" "norma-sized"))
  ())


(defun morphogenetic-scheme-1 (profile1 profile2 steps curve shift)
  (let* (
         (interp-finale (jv-components::metamorpher profile1 profile2 steps curve))

         (interp-before (iter 
                          (for x in (mapcar #'pw::flat profile1)) 
                          (for y in (mapcar #'pw::flat profile2))

                          (let ((lenx (length x))
                                (leny (length y)))

                            (collect (iter 
                                      (for a in (system::flat (pw::g-round (pw::interpolation lenx leny steps curve))))
                                      (for b in (pw::interpolation (if (= lenx leny)
                                                                     x
                                                                     (if (> lenx leny)
                                                                       x
                                                                       (system::flat (system::pwgl-sample 
                                                                                      (system::mk2D-object :bpf (list (pw::arithm-ser 0 1 (- lenx 1)) x)) 
                                                                                      leny))))
                                                                   (if (= lenx leny)
                                                                     y
                                                                     (if (> lenx leny)
                                                                       (system::flat (system::pwgl-sample 
                                                                                      (system::mk2D-object :bpf (list (pw::arithm-ser 0 1 (- leny 1)) y)) 
                                                                                      lenx)) 
                                                                       y)) steps curve))
                                      (collect (system::pwgl-sample (system::mk2D-object :bpf (list (pw::arithm-ser 0 1 (- (length b) 1)) b)) a))))
                            )
                          
                          
                          ))

         (interp-intervals (iter 
                             (for x in (mapcar #'pw::flat profile1))
                             (for y in (mapcar #'pw::flat profile2))
                             (collect (system::flat (pw::g-round (pw::interpolation (length x) (length y) steps curve)))))))


    (append 
          (pw::flat (iterate
            (for bpf in (iterate 
                          (for a in (system::g* (* -1 shift) (pw::arithm-ser 0 1 (1- (length interp-finale)))))
                          (for b in interp-finale)
                          (collect (system::g+ a b))))
            (collect (system::mk2D-object :bpf 
                                 (list (pw::arithm-ser 0 1 (- (length bpf) 1)) bpf)))))

                        
            (list (system::mk2D-object :scrap 
                                 (list (iter (for x in 
                                            (iter 
                                              (for when in (pw::mat-trans 
                                                            (mapcar #'butlast 
                                                                    (mapcar #'rest 
                                                                            (iter 
                                                                             (for xxx in (pw::g-round (pw::mat-trans interp-intervals)))
                                                                             (collect (pw::dx->x 0 xxx)))))))





                                              (for where in (pw::mat-trans (iter 
                                                                             (for xx in (iter (for xxx in (pw::g-round (pw::mat-trans interp-intervals)))
                                                                                              (collect (pw::dx->x 0 xxx))))
                                                                             (for yy in (pw::mat-trans interp-before))
                                                                             (collect (rest (remove 'nil (pw::posn-match (pw::flat yy) xx)))))))

                                              (collect (pw::mat-trans (list when (system::g+ where (system::g* (* -1 shift) (pw::arithm-ser 0 1 (1- (length when)))))))))

                                            )
                                   (collect (pw::x-append x (reverse (butlast x))))))


                                 )))))



(defun morphogenetic-scheme-2 (profile1 profile2 steps curve shift)
  (let* (
         (interp-finale (jv-components::metamorpher profile1 profile2 steps curve))

         (interp-before (iter 
                          (for x in (mapcar #'pw::flat profile1)) 
                          (for y in (mapcar #'pw::flat profile2))

                          (let ((lenx (length x))
                                (leny (length y)))


                          (collect (iter (for a in (system::flat (pw::g-round (pw::interpolation lenx leny steps curve))))
                                         (for b in (pw::interpolation (if (= lenx leny)
                                                                        x
                                                                        (if (> lenx leny)
                                                                          x
                                                                          (system::flat (system::pwgl-sample 
                                                                                         (system::mk2D-object :bpf (list (pw::arithm-ser 0 1 (- lenx 1)) x)) 
                                                                                         leny))))
                                                                      (if (= lenx leny)
                                                                        y
                                                                        (if (> lenx leny)
                                                                          (system::flat (system::pwgl-sample 
                                                                                         (system::mk2D-object :bpf (list (pw::arithm-ser 0 1 (- leny 1)) y)) 
                                                                                         lenx)) 
                                                                          y)) steps curve))
                                         (collect (system::pwgl-sample (system::mk2D-object :bpf (list (pw::arithm-ser 0 1 (- (length b) 1)) b)) a))))
                            )

                            ))
         
         (interp-intervals (iter 
                            (for x in (mapcar #'pw::flat profile1))
                            (for y in (mapcar #'pw::flat profile2))
                            (collect (system::flat (pw::g-round (pw::interpolation (length x) (length y) steps curve))))))

         (iter_through_interp_finale (iterate (for int in interp-finale)
                                              (collect (first (system::pwgl-sample 
                                                               (system::mk2D-object :bpf (list (pw::arithm-ser 0 1 (- (length int) 1)) int)) 
                                                               (pw::g-max (mapcar #'length interp-finale)))))) )
         
         )
    
    
    (append 
     (pw::flat (iterate
                   (for bpf in 
                        (iterate 
                            (for a in (system::g* (* -1 shift) (pw::arithm-ser 0 1 (1- (length iter_through_interp_finale)))))
                            (for b in iter_through_interp_finale)
                          (collect (system::g+ a b))))
                   (collect (system::mk2D-object :bpf 
                                                 (list (pw::arithm-ser 0 1 (- (length bpf) 1)) bpf)))))
     
     
     
     
     (list (system::mk2D-object :scrap 
                                (list (iter (for x in 
                                                 (iter 
                                                  (for when in (pw::mat-trans 
                                                                (mapcar #'butlast 
                                                                        (mapcar #'rest 
                                                                                (iter (for xxx in (pw::g-round 
                                                                                                   
                                                                                                   
                                                                                                   (pw::g-scaling/sum (pw::g-round (pw::mat-trans interp-intervals))
                                                                                                                      (pw::g-max (iter (for m in (pw::g-round (pw::mat-trans interp-intervals)))
                                                                                                                                       (collect (apply #'+ m)))))))
                                                                                      
                                                                                      
                                                                                      
                                                                                      
                                                                                      (collect (pw::dx->x 0 xxx)))))))
                                                  




                                              (for where in (pw::mat-trans (iter 
                                                                             (for xx in (iter (for xxx in (pw::g-round (pw::mat-trans interp-intervals)))
                                                                                              (collect (pw::dx->x 0 xxx))))
                                                                             (for yy in (pw::mat-trans interp-before))
                                                                             (collect (rest (remove 'nil (pw::posn-match (pw::flat yy) xx)))))))

                                              (collect (pw::mat-trans (list when (system::g+ where (system::g* (* -1 shift) (pw::arithm-ser 0 1 (1- (length when)))))))))

                                            )
                                   (collect (pw::x-append x (reverse (butlast x))))))


                                 )))))












;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SYMBOLIC INTERPOLATION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;; SYMBOLIC INTERPOLATION FOR DUMMIES ;;;;;;;;;;;;;;;;;;


(defun simple-interp-sym-diff-lengths1 (a b)
(let* ((difflengths (system::g- (length a) (length b)))
       (minuspe (minusp difflengths)))
  (pw::x-append a
                (if (if minuspe (system::g-abs difflengths) nil)
                    (iter (repeat (if minuspe (system::g-abs difflengths) nil)) (collect '+))
                    nil))))
      
(defun simple-interp-sym-diff-lengths2 (a b)
(let* ((difflengths (system::g- (length a) (length b)))
       (minuspe (minusp difflengths)))
  (pw::x-append b
                (if (if minuspe nil difflengths)
                    (iter (repeat (if minuspe nil difflengths)) (collect '+))
                    nil))))

(defun simp-interp-sym-deeper-loop (biggerloop diff-lengths1 diff-lengths2)
  (iter (for x in biggerloop)
        (for y in diff-lengths1)
        (for z in diff-lengths2)
        (if (= 0 x) (collect y) (collect z))))

(defun simp-inter-sym-big-abs-1 (diff-lengths1 &optional out_random_distrib)
  (let* ((until-const  (if (null out_random_distrib)
                            (pw::permut-random (pw::arithm-ser 1 1 (length diff-lengths1)))
                           (mapcar #'(lambda (x) (+ 1 x)) out_random_distrib)))

         (firstloop (iterate
                        (for h in until-const)
                        (collect (iterate (for j in (pw::arithm-ser 1 1 (length until-const)))
                                          (if (= h j) (collect 1) (collect 0))))))
         (secondloop (iterate
                         (for k in (pw::arithm-ser 1 1 (length firstloop)))
                         (collect (iterate (for l in (pw::mat-trans (reverse (last (reverse firstloop) k))))
                                           (collect (apply #'+ l)))))))
    secondloop))


             






(PWGLDef s-interp-naive ((a '(- - - - - - -)) (b '(a b c d e f g h)) (distrib 'nil))
"This function performs a naive version of symbolic interpolation. 
By default it will substitute randomly the elements from list A to list B. 
If distrib input is non-NIL, and a list of indexes (starting from 0), 
these indexes specify the order by which the elements will be substituted."

()
(fv-morphologie::filt-local-rep
  (iter
  (for zboob in (pw::x-append (list (simple-interp-sym-diff-lengths1 a b))
                              
                              (iter (for big in (simp-inter-sym-big-abs-1 (simple-interp-sym-diff-lengths1 a b) distrib))
                                    (collect (simp-interp-sym-deeper-loop big 
                                                                          (simple-interp-sym-diff-lengths1 a b)
                                                                          (simple-interp-sym-diff-lengths2 a b))))))
  (collect (remove '+ zboob)))
  :delete #'equalp))












;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEVENSHTEIN & S-INTERPOLATION by Fred VOISIN (obsolete) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun levenshtein-damerau (s1 s2 &amp &key (test #'equalp))  ; 'eql
 (let* ((width (1+ (length s1)))
	 (height (1+ (length s2)))
	 (d (make-array (list height width)
                       :element-type 'fixnum))
        (s1 (coerce s1 'vector))
        (s2 (coerce s2 'vector)))
   (dotimes (x width)
     (setf (aref d 0 x) x))
   (dotimes (y height)
     (setf (aref d y 0) y))
   (dotimes (x (length s1))
     (dotimes (y (length s2))
       (let ((cost (if (funcall test (aref s1 x) (aref s2 y)) 0 1)))
         (setf (aref d (1+ y) (1+ x))
               (min (1+ (aref d y (1+ x)))
                    (1+ (aref d (1+ y) x))
                    (+ (aref d y x)
                       cost)))
         (when (and (array-in-bounds-p d (1+ x) (1+ y))
                    (array-in-bounds-p d (1- x) (1- y))
                    (funcall test (aref s1 x)
                             (aref s2 (1- y)))
                    (funcall test (aref s1 (1- x))
                           (aref s2 y)))
           (setf (aref d (1+ x) (1+ y))
                 (min (+ cost (aref d (1- x) (1- y)))
                      (aref d (1+ x) (1+ y))))))))
   (aref d (1- height) (1- width))))


(defun levenshtein (s1 s2 &key (test #'eql))
 (let* ((width (1+ (length s1)))
	 (height (1+ (length s2)))
	 (d (make-array (list height width)
                       :element-type 'fixnum))
        (s1 (coerce s1 'vector))
        (s2 (coerce s2 'vector)))
   (dotimes (x width)
     (setf (aref d 0 x) x))
   (dotimes (y height)
     (setf (aref d y 0) y))
   (dotimes (x (length s1))
     (dotimes (y (length s2))
       (let ((cost (if (funcall test (aref s1 x) (aref s2 y)) 0 1)))
         (setf (aref d (1+ y) (1+ x))
               (min (1+ (aref d y (1+ x)))
                    (1+ (aref d (1+ y) x))
                    (+ (aref d y x)
                       cost)))
         )))
   (aref d (1- height) (1- width))))


;(defun m-levenshtein (s1 s2 &key (test #'equalp)) ; eql
; (let* ((width (1+ (length s1)))
;	 (height (1+ (length s2)))
;	 (d (make-array (list height width)
;                       :element-type 'fixnum))
;        (s1 (coerce s1 'vector))
;        (s2 (coerce s2 'vector)))
;   (dotimes (x width)
;     (setf (aref d 0 x) x))
;   (dotimes (y height)
;     (setf (aref d y 0) y))
;   (dotimes (x (length s1))
;     (dotimes (y (length s2))
;       (let ((cost (if (funcall test (aref s1 x) (aref s2 y)) 0 1)))
;         (setf (aref d (1+ y) (1+ x))
;               (min (1+ (aref d y (1+ x)))
;                    (1+ (aref d (1+ y) x))
;                    (+ (aref d y x)
;                       cost)))
;         )))
;   (values d)))

;(defun ins (a b x y)
;  (let ((a1 (subseq a 0 (1+ x)))
;        (a2 (subseq a (1+ x))))
;    (append a1 (list (nth y b)) a2)))

;(ins '(p o r a) '(a m p h o r a) 0 3)

;(defun sup (a b x y)
;  (declare (ignore b) (ignore y))
;  (append (subseq a 0 x) (subseq a (1+ x))))

;(sup '(p o u l e a) '(a m p h o r a) 4 5)
;(sup '(p o u r a) '(a m p h o r a) 2 4)

;(defun sub (a b x y)
;  (let ((a1 (subseq a 0 x))
;        (a2 (subseq a (1+ x))))
;    (append a1 (list (nth y b)) a2)))

;(sub '(p o u l e t) '(a m p h o r a) 5 6)
;(sub '(p o u l a) '(a m p h o r a) 3 5)
;(sub '(p o r a) '(a m p h o r a) 1 4)

;(defun s-interpolation (a b &key (test 'equalp)) ;; 'eql
;  (let ((m (m-levenshtein b a :test test))  ; matrice
;        (p (list (list (length b) (length a)))) ; positions
;        (r (list b)) ; resultat
;        (o nil)) ; operation
;    (loop until (eval `(and .,(mapcar #'zerop (car p))))
;          do
;          (let* ((x (caar p))
;                 (y (cadar p))
;                 (v (aref m y x))
;                (np nil)

;                 (coutsvoisins (if (zerop x)
;                                   (if (zerop y)
;                                       (progn (print 'error) (abort))
;                                     (list (list x (1- y) (aref m (- y 1) x))))
;                                 (if (zerop y)                                            ;;;;; externaliser celle ci
;                                     (list (list (1- x) y (aref m y (- x 1))))
;                                   (list (list (1- x) (1- y) (aref m (- y 1) (- x 1)))
;                                         (list (1- x) y (aref m y (- x 1)))
;                                         (list x (1- y) (aref m (- y 1) x))))))
;
;                 (min (apply #'min (mapcar #'third coutsvoisins))))
;            (setf coutsvoisins (remove-if-not #'(lambda (x) (= min (caddr x))) coutsvoisins))
;            (if (= 1 (length coutsvoisins))
;                (setf np (car coutsvoisins))

;              (setf np (nth (random (length coutsvoisins)) coutsvoisins))) ;;;; <==== ICI PROBL�ME DE CHOIX DE PARCOURS


;            (setf o (if (= x (car np))
;                        (if (= y (cadr np))
;                            (prog (print 'error) (abort))
;                          (setf o #'ins))
;                      (if (= y (cadr np))
;                          (setf o #'sup)
;                        (setf o #'sub))))
;            (if (equalp #'ins o)
;                (push (funcall o (car r) a (1- x) (1- y)) r)
;                (push (funcall o (car r) a (1- x) (1- y)) r))
;            (push (butlast np) p)))
;    (values r)))

;(s-interpolation '(a m p h o r a) '(p o u l e t))

;; Fred Voisin, 2013




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEVENSHTEIN TRACE (Jean-Paul Davalan) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun leven_trace (a b)
"Calcule la matrice de l'algorithme de distance de Levenstein, et explicite le trajet d'une liste de symboles � une autre. 
Le r�sultat du trajet peut-�tre al�atoire, pour un nombre identique de s�quences interm�diaires. 
Fonction traduite en LISP � partir du code Javascript de Jean-Paul Davalan. http://jeux-et-mathematiques.davalan.org/ "  


  (defvar result_trace '())
  (defvar ch '())
  (defvar chm '())
  (defvar car '())
  (defvar x '())
  (defvar y '())  

  (let* ((n (length a))
         (m (length b))
         (matrice '())
         (modif '())
         (mcols '()))
    
    (setf matrice (make-array (list (+ 1 n) (+ 1 m)))) 
    (setf modif (make-array (list (+ 1 n) (+ 1 m))))   
    (setf mcols (make-array (list (+ 1 n) (+ 1 m))))
    
    (loop for i from 0 to n by 1
      do   (setf (aref matrice i 0)  '())
      (setf (aref modif i 0)    '())
      (setf (aref mcols i 0)    '())
      (setf (aref matrice i 0)  i)
      (setf (aref modif i 0)  'h)  
      (setf (aref mcols i 0)   0))
    
    (loop for j from 0 to m by 1
      do
      (setf (aref matrice 0 j)   j)
      (setf (aref modif 0 j)   'g)   
      (setf (aref mcols 0 j)     0))
    
    (defvar mode '())
    
    (loop for i from 1 to n by 1
      do 
      (loop for j from 1 to m by 1 
        do
        
        (setf (aref mcols i j) 0)
        
        (let* ((cout (if (equalp (nth (- i 1) a) (nth (- j 1) b)) 
                       0 
                       1))
               (u (+ 1 (aref matrice i (- j 1))))  ; ici enlever + 1??
               (v (+ 1 (aref matrice (- i 1) j)))
               (w (+ cout (aref matrice (- i 1) (- j 1))))   )
          
          (setf (aref matrice i j) 
                (if (< u v)
                  (if (< u w) u w)
                  (if (< v w) v w)))
          
          
          
          (cond ((and (< w u) (< w v)) (setf mode "w"))
                ((and (= w u) (< w v)) (setf mode (if (< (random 1.0) 0.5) 
                                                    "w" "u")))
                ((and (= w v) (< w u)) (setf mode (if (< (random 1.0) 0.5) 
                                                    "w" "v")))
                ((and (= u v) (< u w)) (setf mode (if (< (random 1.0) 0.5) 
                                                    "u" "v")))
                ((and (= u v) (= v w)) 
                 (let ((mr (random 1.0)))
                   (setf mode (if (< mr 1/3) "u"
                                (if (< mr 2/3) "v"
                                  "w")))))
                (T (setf mode (if (< u v)
                                (if (< u w) "u" "w")
                                (if (< v w) "v" "w")))))
          
          (setf (aref modif i j) (if (equalp mode "u") 'g
                                   (if (equalp mode "v") 'h
                                     (if (= cout 0) '0 '1))))
          )))
    
    (setf ch '())
    (setf chm '())
    
    (setf x n)
    (setf y m)
    
    
    (loop while (or (> x 0) (> y 0))
      do
      
      (setf (aref mcols x y) 1)
      
      (let* ((md (aref modif x y))
             (mm (aref matrice x y)))
        (push md ch)
        (push mm chm)
        
        (cond ((equalp md 'g) (decf y)) 
              ((equalp md 'h) (decf x))
              (T (progn (decf x) (decf y))))
        
        (if (and (>= x 0) (>= y 0))
          (setf (aref mcols x y) 1)))
      )
    
    
    (decf x)
    (decf y)
    
    
    (loop while (>= x 0)
      do (setf (aref mcols x y) 1)
      (decf x))
    
    (loop while (>= y 0)
      do (setf (aref mcols x y) 1)
      (decf y))
    
    
    
    (setf x 0)
    (setf y 0)
    
    
    (setq result_trace '())
    
    (let* ((mo 0)
           (z '())
           (ccur a)
           (tabmots '()))
      (push a tabmots)
      
      (loop for i from 0 to (- (length ch) 1) by 1
        do 
        (setq car (nth i ch))
        
        
        (cond ((equalp 0 car) (progn 
                                (incf x) 
                                (incf y) 
                                (incf mo) )) ;; no change
              ((equalp 1 car) (progn (setq z (pw:x-append (system::list! (subseq ccur 0 mo))      ;; change
                                                          (system::list! (nth y b))
                                                          (system::list! (subseq ccur (+ 1 mo)))))
                                (setq ccur z)
                                (push ccur tabmots)
                                (incf x)
                                (incf y)
                                (incf mo)
                                ))
              ((equalp 'g car) (progn (setq z (pw:x-append (system::list! (subseq ccur 0 mo))  ;; ajout
                                                           (system::list! (nth y b))
                                                           (system::list! (subseq ccur mo))))
                                 
                                 (incf y)
                                 (incf mo)
                                 (setq ccur z)
                                 (push ccur tabmots)
                                 ))
              ((equalp 'h car) (progn (setq z (pw:x-append (system::list! (subseq ccur 0 mo))  ;; suppr
                                                           (system::list! (subseq ccur (+ mo 1)))))
                                 (setq ccur z)
                                 (push ccur tabmots)
                                 (incf x)))
              (T 'error))
        
        (setf result_trace (reverse tabmots))
        )))  
  
  result_trace)


(defun s-interpolation (a b) ;;;; ORIGINAL
  (leven_trace a b))

;;;;;; corriger ici avec le pur contraste

(defun s-interpolation (a b)
  (let* ((both_a_b (pw::x-append a b))
         (all_order (mapcar #'(lambda (x) (- x 1)) (jbs-cmi::identity-index both_a_b)))
         (all_assoced (remove-duplicates (loop for i from 0 to (1- (length both_a_b))
                                           collect (list (nth i all_order) (nth i both_a_b)))
                                         :test #'(lambda (a b) (equalp (car a) (car b)))
                                         :from-end t))

         (a_order (jbs-cmi::first-n all_order (length a)))
         (b_order (jbs-cmi::last-n all_order (length b)))
         
         (result (leven_trace a_order b_order))
         (res_assoced (loop for i in result
                        collect 
                        (loop for j in i
                          collect (second (assoc j all_assoced)))))
         )

  #|  (print a)
    (print b)
    (print both_a_b)
    (print all_order)
    (print all_assoced)
    (print a_order)
    (print b_order)
    (print result)
    (print res_assoced) |#

    res_assoced
 ; (pw::posn-match both_a_b result)

))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SYMBOLIC-INTERPOLATION-FORMS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef ccl::patch-value ccl::PWGL-box ccl::nth-patch-value ccl::pwgl-outputs) :jv-components))
  
(in-package :jv-components)

(defclass my-symbolic-interpolation-forms (PWGL-box) ())

(defmethod patch-value ((self my-symbolic-interpolation-forms) output)
  (let ((pos (position output (pwgl-outputs self))))
    (nth-output-patch-value self pos)))

(defmethod nth-output-patch-value ((self my-symbolic-interpolation-forms) (out (eql 0)))
  (s-interp-form1 (nth-patch-value self 0) (nth-patch-value self 1) (nth-patch-value self 2) (nth-patch-value self 3) )) ;;;;
; interp-form-1

(defmethod nth-output-patch-value ((self my-symbolic-interpolation-forms) (out (eql 1)))
  (s-interp-form2 (nth-patch-value self 0) (nth-patch-value self 1) (nth-patch-value self 2)  (nth-patch-value self 3) )) ;;;;
; interp-form-2

(defmethod nth-output-patch-value ((self my-symbolic-interpolation-forms) (out (eql 2)))
  (s-interp-form3 (nth-patch-value self 0) (nth-patch-value self 1) (nth-patch-value self 2)  (nth-patch-value self 3) )) ;;;;
; interp-form-3

(defmethod nth-output-patch-value ((self my-symbolic-interpolation-forms) (out (eql 3)))
  (s-interp-form4 (nth-patch-value self 0) (nth-patch-value self 1) (nth-patch-value self 2)  (nth-patch-value self 3) )) ;;;;
; interp-form-4

(system::add-box-type :comprehensive-mbox 
  `(system::mk-menu-subview :menu-list ,(system::add-menu-list-keyword :comprehensive-list '(":random" ":all")) :value 0))



(PWGLDef s-interp-forms ((a '(a m o r p h a)) (b '(a m p h o r a)) (output-mode () :comprehensive-mbox) (loop-for-all 1000))

"This function performs four different forms of basic symbolic interpolation, between two symbolic sequences, using
the s-interpolation function written by Jean-Paul Davalan (http://jeux-et-mathematiques.davalan.org/). 

It is based on the Levensthein distance algorithm, which calculates the distance between two sequences
in terms of how many operations are needed to turn one into another. Allowed operations are : insertion, deletion and substitution.
The s-interpolation function written purpose is precisely to explicit the process by showing the successive steps
of the distance measured.

Since there can be various way to achieve this smallest path from one sequence to another, each result is computed randomly,
yet it will always be of the same length. The :all mode tries to produce all the smallest paths, without duplicates.
In order to do that, we need to loop for the evaluation many times (as defined with loop-for-all variable, 1000 times by default)
then remove-duplicates. This is why, in some cases, it may be useful to increase the loop length.

The four different forms of this interpolation are different ways of using and reading it. 
The computation of s-interpolation is essentially 'beginning-oriented', this means it has a tendency
to modify first the symbols at the beginning of sequences instead of ones in the middle or the tail.

The four forms, for interpolating between a and b sequences :
-original interpolation between a and b
-reversed interpolation between b and a (so the result between a and b becomes 'tail-oriented')
-original interpolation between b and a
-reversed interpolation between a and b (so the result between b and a becomes 'tail-oriented')."

  (:groupings '(2 2)
  :class 'my-symbolic-interpolation-forms :outputs '("original-a->b" "reverse-b->a" "original-b->a" "reverse-a->b"))
    ())

(defun s-interp-form1 (a b output-mode loop-for)
  (case output-mode
    (:random (s-interpolation a b))
    (:all (remove-duplicates 
           (loop for i from 1 to loop-for 
             collect (s-interpolation a b)) :from-end t :test #'equalp))))

(defun s-interp-form2 (a b output-mode loop-for)
  (case output-mode
    (:random (reverse (s-interpolation b a)))
    (:all (remove-duplicates 
           (loop for i from 1 to loop-for 
             collect (reverse (s-interpolation b a))) :from-end t :test #'equalp))))

(defun s-interp-form3 (a b output-mode loop-for)
   (case output-mode
    (:random (s-interpolation b a))
    (:all (remove-duplicates 
           (loop for i from 1 to loop-for 
             collect (s-interpolation b a)) :from-end t :test #'equalp))))

(defun s-interp-form4 (a b output-mode loop-for)
   (case output-mode
    (:random (reverse (s-interpolation a b)))
    (:all (remove-duplicates 
           (loop for i from 1 to loop-for 
             collect (reverse (s-interpolation a b))) :from-end t :test #'equalp))))


;;; OLD versions (Fred Voisin's s-interp)
;(defun s-interp-optimize (list)
;  (first (sort (remove-duplicates (iter (repeat 200) (collect (fv-morphologie::filt-local-rep list :delete #'equalp))) :test #'equalp)
;               #'(lambda (x y) (< (length x) (length y))))))

;(defun s-interp-form1 (a b) (s-interp-optimize (s-interpolation a b)))

;(defun s-interp-form2 (a b) (reverse (s-interp-optimize (s-interpolation b a))))

;(defun s-interp-form3 (a b) (s-interp-optimize (s-interpolation b a)))

;(defun s-interp-form4 (a b) (reverse (s-interp-optimize (s-interpolation a b))))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SYM-METAMORPHER ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;; AVANT D'AVANCER, FINIR DE COMPARER LES DEUX VERSIONS DU CODE DE S-INTERPOLATE


;;;;;;;;;;;       AU BOULOT !!!!!!!!!!         J'AI TOUS LES �L�MENTS !!!!           ;;;;;;


;; en plus de finir le metamorpher , je dois m'occuper de la partie optimisation par contraintes
;; en utilisation la fonction s-interp en mode exhaustif !






























;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;               CONTENTS                ;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun test3 (a b)
         (list (+ a b) (* a b)))








































;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;                 TOOLS                 ;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package :jv-components)



;;;;;;;;;;; bpf-norma-sizes ;;;;;;;;;;;;;


(PWGLDef bpf-norma-sizes ((bpfs 'nil))
         "This function takes a list of lists of numerical values (bpfs like) and re-samples them to the length of the longest one."
         ()
  (iterate (for a in bpfs)
           (collect (first (system::pwgl-sample 
                            (system::mk2D-object :bpf (list (pw::arithm-ser 0 1 (- (length a) 1)) a)) 
                            (pw::g-max (mapcar #'length bpfs)))))))



;;;;;;;;;;; bpf-explicit-process ;;;;;;;;;;;;;


(PWGLDef bpf-explicit-process ((bpfs 'nil) &optional (shift '1.2))
  "This function takes a list of lists of numerical values (bpfs like) and shifts their values by a constant value, in order to display them vertically in a 2D-Editor."
  ()
 (iterate (for a in (system::g* (* shift -1) (pw::arithm-ser 0 1 (1- (length bpfs)))))
         (for b in bpfs)
         (collect (system::g+ a b))))


;;;;;;;;;;; bpf-cropping ;;;;;;;;;;;;;

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef ccl::patch-value ccl::PWGL-box ccl::nth-patch-value ccl::pwgl-outputs) :jv-components))
  
(in-package :jv-components)

(defclass my-bpf-cropping (PWGL-box) ())

(defmethod patch-value ((self my-bpf-cropping) output)
  (let ((pos (position output (pwgl-outputs self))))
    (nth-output-patch-value self pos)))

(defmethod nth-output-patch-value ((self my-bpf-cropping) (out (eql 0)))
  (my-bpf-crop1 (nth-patch-value self 0) (nth-patch-value self 1)))
; cropped

(defmethod nth-output-patch-value ((self my-bpf-cropping) (out (eql 1)))
  (my-bpf-crop2 (nth-patch-value self 0) (nth-patch-value self 1))) 
; visualize


(PWGLDef bpf-cropping ((bpf 'nil) (intervals '(1000 2999)))
  "This function takes a list of numerical values (bpfs like) and segments it according to a given interval (or list of intervals). The second
output shows a display of the whole bpf with cropping points."
  (:class 'my-bpf-cropping :outputs '("cropped" "visualize"))
  ())

(defun my-bpf-crop1 (bpf intervals)
  (iterate
      (for a in (if (listp (first intervals)) intervals (list intervals)))
      (collect (pw::posn-match bpf (pw::arithm-ser (first a) 1 (second a))))))

(defun my-bpf-crop2 (bpf intervals)
  (pw::x-append 
   (system::mk2D-object :bpf (list (pw::arithm-ser 0 1 (- (length bpf) 1)) bpf))
   (iterate (for a in (if (listp (first intervals)) intervals (list intervals)))  
     (collect (system::mk2D-object :marker (list a))))))

 
;;;;;;;;;;;;;;;;;;; bpf-reduce-structure ;;;;;;;;;;;;;;;;;;;;;;

(PWGLDef bpf-reduce-structure ((complex '(4 16 34 25 12 4)))
         "This function takes a list of numerical values (bpf like). 
  Its structure is rescaled by making the smallest value equal to 1. The other values are rounded to the closest integer, so the overall shape would be a little damaged, yet globally perserved."
()
  

    (pw::g-round (g-scaling/min complex)))

    

(defun g-scaling/min (complex)
   (mapcar #'float (system::g/ complex (system::g-min complex))))



;;;;;;;;;;; coll2LISP ;;;;;;;;;;;;;

(PWGLdef coll2lisp ()
         "Evaluate the coll2lisp function to prompt to any coll .txt file. The coll format will be translated, line by line, into lists of values."
         ()         
         (mapcar (lambda (line) (mapcar #'read-from-string (segment-words line)))
                 (read-file-lines (car (capi:prompt-for-files ())))))

;;; (car (capi:prompt-for-files ()))
;;;   this could be also: (capi:prompt-for-file ())
;;; note: if you add the box to the path (double-click), use:
;;; coll2lisp::coll2lisp-box



;;;;;;;;;;; pwgl-unpack ;;;;;;;;;;;;;

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef ccl::patch-value ccl::PWGL-box ccl::nth-patch-value ccl::pwgl-outputs) :jv-components))
  
(in-package :jv-components)

(defclass my-nth-unpack (PWGL-box) ())

(defmethod patch-value ((self my-nth-unpack) output)
  (let ((pos (position output (pwgl-outputs self))))
    (nth-output-patch-value self pos)))

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 0)))
  (nth 0 (nth-patch-value self 0)))
; 1st

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 1)))
  (nth 1 (nth-patch-value self 0))) 
; 2nd

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 2)))
  (nth 2 (nth-patch-value self 0)))
; 3rd

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 3)))
  (nth 3 (nth-patch-value self 0))) 
; 4th

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 4)))
  (nth 4 (nth-patch-value self 0)))
; 5th

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 5)))
  (nth 5 (nth-patch-value self 0))) 
; 6th

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 6)))
  (nth 6 (nth-patch-value self 0)))
; 7th

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 7)))
  (nth 7 (nth-patch-value self 0))) 
; 8th

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 8)))
  (nth 8 (nth-patch-value self 0)))
; 9th

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 9)))
  (nth 9 (nth-patch-value self 0))) 
; 10th

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 10)))
  (nth 10 (nth-patch-value self 0)))
; 11st

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 11)))
  (nth 11 (nth-patch-value self 0))) 
; 12th

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 12)))
  (nth 12 (nth-patch-value self 0)))
; 13th

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 13)))
  (nth 13 (nth-patch-value self 0))) 
; 14th

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 14)))
  (nth 14 (nth-patch-value self 0)))
; 15th

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 15)))
  (nth 15 (nth-patch-value self 0))) 
; 16th

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 16)))
  (nth 16 (nth-patch-value self 0)))
; 17th

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 17)))
  (nth 17 (nth-patch-value self 0))) 
; 18th

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 18)))
  (nth 18 (nth-patch-value self 0)))
; 19th

(defmethod nth-output-patch-value ((self my-nth-unpack) (out (eql 19)))
  (nth 19 (nth-patch-value self 0))) 
; 20th


(PWGLDef pwgl-unpack ((list '(a b c d e f g h i j k l m n o p q r s t)))
  "This function is very similar to MaxMSP unpack function. It takes out individually the different values of a given list, through its different outputs.
The only limitation for now is the amount of outputs which is limited to 20. 
Future enhancement would allow to update the box dynamically according to a given value."
  (:class 'my-nth-unpack :outputs '("1st" "2nd" "3rd" "4th" "5th" "" "" "" "" "10th" "" "" "" "" "15th" "" "" "" "" "20th"))
  ())



;;;;;;;;;;; pwgl-urn ;;;;;;;;;;;;;

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef ccl::patch-value ccl::PWGL-box ccl::nth-patch-value ccl::pwgl-outputs) :jv-components))
  
(in-package :jv-components)

(defclass my-pwgl-urn (PWGL-box) ())

(defmethod patch-value ((self my-pwgl-urn) output)
  (let ((pos (position output (pwgl-outputs self))))
    (nth-output-patch-value self pos)))

(defmethod nth-output-patch-value ((self my-pwgl-urn) (out (eql 0)))
  (my-pwgl-urn-1 (nth-patch-value self 0) (nth-patch-value self 1)))
; flat

(defmethod nth-output-patch-value ((self my-pwgl-urn) (out (eql 1)))
  (my-pwgl-urn-2 (nth-patch-value self 0) (nth-patch-value self 1))) 
; windowed


(PWGLDef pwgl-urn ((length '21) (random-space '(0_2)))
  "This function generates a series of random values from a given search space, without duplicates. 
In the same way that urn MaxMSP object, the whole search space has to be exposed once before any value can be chosen again."
  (:class 'my-pwgl-urn :outputs '("flat" "windowed"))
  ())

(defun my-pwgl-urn-1 (length random-space)
  (first (system::pmc (pw::create-list length random-space)
                      (iter (for a in (system::group-lst (jbs-constraints::make-i1 (pw::arithm-ser 1 1 length))
                                                         (length (remove-duplicates random-space))))
                            (collect (let* ((variab a))
                              `(,@variab (?IF (if (= (length (list ,@variab)) (length (remove-duplicates (list ,@variab) :test 'equalp))) t))))))
                      :rnd? 'T
                      :sols-mode '1)))

(defun my-pwgl-urn-2 (length random-space)
  (system::group-lst (my-pwgl-urn-1 length random-space)
                     (length (remove-duplicates random-space))))


;;;;;;;;; scale-list ;;;;;;;;;;;;



(ccl::add-box-type :scale-list-types-scroll 
  `(ccl::mk-menu-subview :menu-list ,(ccl::add-menu-list-keyword :scale-list-types '("start" "middle" "end" "outside")) :value 0))

(PWGLDef scale-list ((structure '((1 1 1) 1 (1 1))) (values '(101 13 41)) (direction-mode start :scale-list-types-scroll))
   "This function takes a list of values that must be dispatched inside a given list structure (one level of nesting maximum for now). 
If an element of the structure is an atom, the corresponding value will come out as itself. If it is a list of n elements (ex : (1 1 1 1)),
the corresponding value will be divided into a list of n values in an optimal descending way (ex: value = (101 13), structure : ((1 1 1 1) 1) -> ((26 26 25 24) 13)"
()
(my-scale-list-new structure values direction-mode))

(defun append-my-package (in)
(read-from-string (format nil "JV-COMPONENTS::~a" in)))

;ceci permet de transformer le nom du symbole (start par exemple) en symbole qui fasse partie de la librairie
; de cette mani�re il est possible d'indiquer uniquement des symboles sans quote et hors liste dans les bo�tes du patch

; pour l'avenir : (read-from-string (format nil "~a~a~a" in in2 in3)) -> inin2in3


(defun my-scale-list-new (structure values direction-mode)
  (let* ((direct-mode (jv-components::append-my-package direction-mode))  
         (dir-mode (cond ((equalp direct-mode 'start) '((0 1 2)(1 0.5 0)))
                         ((equalp direct-mode 'middle) '((0 1 2) (0.4 1 0)))
                         ((equalp direct-mode 'end) '((0 1 2)(0 0.5 1)))
                         ((equalp direct-mode 'outside) '((0 1 2)(1 0 1)))
                         )))
    (iterate (for a in (system::list! structure))
             (for b in (system::list! values))
      (let ((bpf (car (system::mk2D-object :bpf dir-mode))))
        (if (atom a)
            (collect b)
          (collect (first (system::pmc (pw::create-list (length a) (remove-duplicates (sort (pw::x-append  (jbs-cmi::arithm-ser-stop (pw::g-round (system::g/ b (length a)))
                                                                                                                                     1 
                                                                                                                                     (1+ (pw::g-mod b (length a))))
                                                                                                           (jbs-cmi::arithm-ser-stop (pw::g-round (system::g/ b (length a)))
                                                                                                                                     -1 (1+ (pw::g-mod b (length a))))) #'<) :from-end t))
                                       `((* (ccl::?IF (IF (= ccl::LEN (ccl::CUR-SLEN)) (= (APPLY (QUOTE +) ccl::L) ',b) T))) 
                                         (* ?1 ?2 (ccl::?IF (MEMBER (ABS (- ?2 ?1)) (QUOTE (0 1))))) 
                                         )
                                       :heuristic-rules
                                       `(,(rest (jbs-constraints::mk-profile-rule 
                                                 (pw::g-min 
                                                                                   (pw::flat 
                                                                                    (pw::create-list (length a) 
                                                                                                     (remove-duplicates (sort (pw::x-append  (jbs-cmi::arithm-ser-stop 
                                                                                                                                              (pw::g-round (system::g/ b (length a)))
                                                                                                                                              1 
                                                                                                                                              (1+ (pw::g-mod b (length a))))
                                                                                                                                             (jbs-cmi::arithm-ser-stop 
                                                                                                                                              (pw::g-round (system::g/ b (length a)))
                                                                                                                                              -1 (1+ (pw::g-mod b (length a))))) #'<) :from-end t)))) 
                                                                                  
                                                 (pw::g-max 
                                                                                   (pw::flat 
                                                                                    (pw::create-list (length a) (remove-duplicates 
                                                                                                                 (sort (pw::x-append  (jbs-cmi::arithm-ser-stop (pw::g-round (system::g/ b (length a)))
                                                                                                                                                                1 
                                                                                                                                                                (1+ (pw::g-mod b (length a))))
                                                                                                                                      (jbs-cmi::arithm-ser-stop (pw::g-round (system::g/ b (length a)))
                                                                                                                                                                -1 (1+ (pw::g-mod b (length a))))) #'<) :from-end t))))  
                                                                                  
                                                 (length 
                                                                                   (pw::create-list (length a) (remove-duplicates 
                                                                                                                (sort (pw::x-append  (jbs-cmi::arithm-ser-stop (pw::g-round (system::g/ b (length a)))
                                                                                                                                                               1 
                                                                                                                                                               (1+ (pw::g-mod b (length a))))
                                                                                                                                     (jbs-cmi::arithm-ser-stop (pw::g-round (system::g/ b (length a)))
                                                                                                                                                               -1 (1+ (pw::g-mod b (length a))))) #'<) :from-end t))) 

                                                                                  
                                                 bpf  0 :heuristic 3900)))
                                       :rnd? 'NIL
                                       :sols-mode '1))))))))



;(defun my-scale-list-old (structure values)
;  (iterate (for a in (system::list! structure))
;           (for b in (system::list! values))
;    (if (atom a)
;        (collect b)
;        (collect (first (system::pmc (pw::create-list (length a) (remove-duplicates (pw::x-append (jbs-cmi::arithm-ser-stop (pw::g-round (system::g/ b (length a)))
 ;                                                                                                                  1 10)
  ;                                                                                       (jbs-cmi::arithm-ser-stop (pw::g-round (system::g/ b (length a)))
   ;                                                                                                                -1 10))))
    ;                       `((* (ccl::?IF (IF (= ccl::LEN (ccl::CUR-SLEN)) (= (APPLY (QUOTE +) ccl::L) ',b) T))) 
     ;                        (* ?1 ?2 (ccl::?IF (MEMBER (ABS (- ?2 ?1)) (QUOTE (0 1))))) 
      ;                       (* (?IF (APPLY (QUOTE >=) ccl::L))))
       ;                     :rnd? 'NIL
        ;                    :sols-mode '1))))))


;;;;;;;;;  short-filter ;;;;;;;;;;;

(PWGLDef bpf-short-filter ((bpf 'nil) (treshold '5))
"This function is a very simple filter of locally repeated values. If the group of repeated values is too short (below the given treshold)
this group is erased and its length is added to previous groups. It may be useful to add several short-filters one after another, in order to filter properly remaining undesired values."

()
(system::flat 
(let* ((list-input (jbs-cmi::group-equals bpf))
       (thres treshold)
       (lista (rest (mapcar #'length list-input)))
       (listb (rest (mapcar #'first list-input)))
       (listc (butlast (mapcar #'first list-input))))
(jbs-cmi::group-equals 
 (system::flat 
  (pw::x-append 
   (list (first list-input))
   (iter (for a in lista)
         (for b in listb)
         (for c in listc)
         (if (< thres a) (collect (pw::create-list a b)) (collect (pw::create-list a c))))


       ))))))




;;;;;;;;;;;;;;;;; SYMBOLIC-RESAMPLER ;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun symb_resampler (list steps &optional (flated? T))
  (if (>= (length list) steps)
    (if flated?
      list
      (mapcar #'list list))

    (let* 
        ((lenlist (length list))      
         (div (floor (/ steps lenlist)))
         (rem (multiple-value-bind (div rem) (floor (/ steps lenlist)) (values (* rem lenlist) div)))     
         (init_list (loop for i in list 
                      collect (make-list div :initial-element i)))
         (reste rem)
         (start 0)
         (end (- lenlist 1))
         (sens T)
         (next nil))
      (loop while (< 0 reste)
        do
        (cond (sens             
               (setf next start)
               (push (car (nth next init_list)) (nth next init_list))
               (incf start))
              (T 
               (setf next end)
               (push (car (nth next init_list)) (nth next init_list))
               (decf end)))
        (decf reste)
        (setf sens (not sens)))
     
      (if flated?
        (system::flat init_list)
        init_list))))


(PWGLDef symbolic-resampler ((list '(a b c d)) (steps '17))
"This function takes a list of symbols, and adjust its length by repeating symbols locally when needed.
This is done by privelegiating external symbols over internal ones, so that the distribution of symbols repetitions is as balanced as possible.
Note that this function works only for oversampling, if you specify a 'steps' value smaller than the length of the list, you'll get the list unchanged."
()
         (symb_resampler list steps))



;;   OLD version

(PWGLDef old-symbolic-resampler ((list '(a b c d)) (steps '17))
"This function takes a list of symbols, and adjust its length by repeating symbols locally when needed.
 This is done in a linear manner, with the help of an arithmetic series, so that the distribution of symbols repetitions is as balanced as possible."
()
         (pw::posn-match list (pw::g-round (pw::g-scaling/max (pw::arithm-ser 0 1 (1- steps)) (1- (length list))))))

;;|#




























;;;;;;;;; morphological predicates ;;;;;;;;;;;;

; category-p

(PWGLDef category-p ((a 'tralala) (b 'tro) 
                  (database '((ABA BABA BIBI BOOM) (TRO TRALALA TROLA) (YIPPIE) (SOONE SOCOOL SOHOT) (SHIRT VIRGO BOB))))
"This function is a predicate, so it will render T or NIL if the conditions it expects are verified or not.

This predicates verifies if two given atoms, a and b, belong to a same list (or category) in a given database."
()
(my-table-p database a b))

(defun my-table-p (db a b)
  (first (remove-duplicates (remove nil 
                                    (iterate (for z in (pw::posn-match db (remove nil (iterate
                                                                                          (for x in db)
                                                                                          (for y in (pw::arithm-ser 0 1 (1- (length db))))
                                                                                        (if (member a x) (collect y) (collect nil))))))
                                             (if (member b z) (collect t) (collect nil)))))))

; dist-euclid-p

(PWGLDef dist-euclid-p ((a '(0 0 0)) (b '(1 0 10)) (treshold '13))
"This function is a predicate, so it will render T or NIL if the conditions it expects are verified or not.

This predicates verifies if between two given sets of coordinates in any euclidian space, a and b, the distance is below a given threshold.
In a way, the two points described will be considered equal or similar, in the same 'family'.

This function relies on fv-morphologie function dist-euclid, by Fr�d�ric Voisin."
()
(my-dist-euclid-p treshold a b))

(defun my-dist-euclid-p (tresh a b)
  (if (> tresh (fv-morphologie::dist-euclidian a b)) t nil))


; close-p

(PWGLDef close-p ((a '(a a a b b a y a)) (b '(a a b a y a b b b b)) (treshold '7) &optional (sub '1) (ins '1) (del '1) (uncom '0))
"This function is a predicate, so it will render T or NIL if the conditions it expects are verified or not.

This predicates verifies if between two given sequences of symbols, a and b, the editing distance (or Levenshtein distance) is below a given threshold.
In a way, the two sequences described will be considered equal or similar, in the same 'family'.

Since editing distance is related to how many operations you need to turn one sequence of symbols into another,
it is also possible to define separetely the weights for each operation :
-substitute (one symbol by another)
-insert
-delete
-uncommon (extra cost for symbols that appear only inside one sequence)

This function relies on FV-MORPHOLOGIE library's function DIST-EDIT, by Fr�d�ric Voisin."
()
(if (> treshold (fv-morphologie::dist-edit a b :sub sub :ins ins :del del :uncom uncom)) t nil))



; contrast-close-p

(PWGLDef contrast-close-p ((a '(a b d a c d e f b a)) (b '(y h e z z e g g z v h y)) (treshold '4) 
                           &optional (sub '1) (ins '1) (del '1) (uncom '0))
"This function is a predicate, so it will render T or NIL if the conditions it expects are verified or not.

This predicate is a variation of previous predicate CLOSE-P, introducing the notion of contrast, or order of appearence.

Between two very different sequences like 
(A B C) and (X H Y) the editing distance is necessarily of 3, because of totally different 'vocabulary'. 
But if you consider the order of appearance of the symbols, with IDENTITY-INDEX function, you will see that in both cases the structure is (1 2 3).

This is why between very different sequences of symbols such as (A B D A C D E F B A) and (Y H E ZZ E G G Z V H Y), 
the final distance would be of only 3.

Since editing distance is related to how many operations you need to turn one sequence of symbols into another,
it is also possible to define separetely the weights for each operation. See CLOSE-P tutorial for further details.

This function relies on FV-MORPHOLOGIE library's function DIST-EDIT, by Fr�d�ric Voisin, and JBS-CMI library's function IDENTITY-INDEX, by Jacopo Baboni Schilingi. "
()
(if (> treshold (fv-morphologie::dist-edit (jbs-cmi::identity-index a) 
                                           (jbs-cmi::identity-index b)
                                           :sub sub :ins ins :del del :uncom uncom)) t nil))




;;;;;;;;; time sig 2 duration -> duration 2 time sig ;;;;;;;;;;;;


(PWGLDef duration2tempo ((numerator '2) (denominator '4) (duration '1.0))
    "Finds a tempo according to a given couple of time signature and duration."
    ()
  (pw::g-round (system::g/ (system::g* numerator (system::g* (system::g* (system::g/ 1 denominator) 60) 4)) duration) 2))


(PWGLDef timesig2duration ((numerator '2) (denominator '4) (tempo '120))
    "Finds a duration according to a given couple of time signature and tempo."
    ()
  (float (system::g/ (system::g* numerator (system::g* 4 (system::g* 60 (system::g/ 1 denominator)))) tempo)))


(PWGLDef duration2timesig ((tempo '120)(duration '1.0) &key (numerator 'nil) (denominator 'nil))
    "Finds the appropriate time signature according to a given tempo et duration.
     The function needs an additional information, which is either the numerator (beat) or denominator of
     the target time signature. If the exact solution is not possible, approximation will be made to get a closest result."
()
  (cond ((not (null numerator)) 
         (let* ((finaltimesig (car (last 
                                    (remove-if #'(lambda (x) (or (system::ratiop (first x)) (system::ratiop (second x))))
                                               (iterate
                                                 (for a in (pw::arithm-ser 1 1 100))
                                                 (collect (system::g/ 
                                                           (list numerator (pw::g-round
                                                                            (system::g/ 1 (system::g/ (system::g/ (system::g/ (system::g* tempo duration) numerator) 4) 60) )))

                                                           a))))))))
           (list finaltimesig
                 (jv-components::timesig2duration (car finaltimesig)
                                                  (second finaltimesig)
                                                  tempo))))

        ((not (null denominator)) 
         (let* ((finaltimesig (car (last (remove-if #'(lambda (x) (or (system::ratiop (first x)) (system::ratiop (second x))))
                                                    (iterate
                                                      (for a in (pw::arithm-ser 1 1 100))
                                                      (collect (system::g/
                                                                (list (pw::g-round (system::g/ (system::g* tempo duration)
                                                                                               (system::g* 4 (system::g* 60 (system::g/ 1 denominator)))))
                                                                     denominator)
                                                                      a))))))))
                                                                

           (list finaltimesig
                 (jv-components::timesig2duration (car finaltimesig)
                                                  (second finaltimesig)
                                                  tempo))))




        ((and (null numerator) (null denominator)) "Write at least one value between numerator and denominator. If you write both, well... this function is useless! Anyway numerator will be used in priority over denominator for the calculation.")))




;(add-box-type :staff-types-scroll 
;  `(mk-menu-subview :menu-list ,(add-menu-list-keyword :staff-types '("'treble-staff" "'alto-staff" "'tenor-staff" "'bass-staff" "'percussion-staff" "'piano-staff")) :value 1))

;(PWGLDef change-staff-keys ((staff () :staff-types-scroll) &rest (staffs () :staff-types-scroll))
;"Change the key of successive staves."
;()
;(let* ((keys (system::flat (list staff staffs))))
;keys))






;(add-box-type :yes-maybe-mbox 
;  `(mk-menu-subview :menu-list ,(add-menu-list-keyword :yes-no-list '(":t" ":nil" ":maybe")) :value 1))

;(PWGLDef abc2 ((a 1) (b 2) (c () :yes-maybe-mbox))    ;; <name>  <args> 
;  "PWGLDef abc2"                                       ;; <documentation>
; ()                                                    ;; <keyword-args>
; (cond ((eq c :maybe) "maybe")                         ;; <body>
;       ((eq c :nil) ())
;       (t (+ a b))))



;;;;;;;;;;;;;;;;; CHANGE-STAFF-KEY ;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(in-package :jv-components)

(ccl::add-box-type :staff-types-scroll 
  `(ccl::mk-menu-subview :menu-list ,(ccl::add-menu-list-keyword :staff-types '("'treble-staff" "'alto-staff" "'tenor-staff" "'bass-staff" "'percussion-staff" "'piano-staff")) :value 0))

(PWGLDef change-staff-keys ((score '()) (key 'treble-staff :staff-types-scroll) &rest (keys 'treble-staff :staff-types-scroll))
    "Change the key of successive staves by extending and scrolling menus."
    (:groupings '(1 1) :extension-pattern '(1 1))
  (let* ((keys (remove 'quote (remove nil (system::flat (list key keys))))))
    (system::enp-script score               
                        (iterate (for key in keys)
                          (for index in (pw::arithm-ser 1 1 (length keys)))

                          (collect
                           `(* ?1 :partnum (list ,index)
                               (ccl::?if 
                                (setf (ccl::staff (ccl::read-key ?1 :part)) (ccl::make-instance ',key)))))) '())))

(in-package :jv-components)

(defun group-equals (list)
  (let ((little_tmp nil) 
        (big_tmp nil))
    (loop for x in list   
          if (equalp (first little_tmp) x)
          do (push x little_tmp)
          else
          do (push (reverse little_tmp) big_tmp)
           (setf little_tmp nil)
           (push x little_tmp))
   (remove nil (append (reverse big_tmp) (list little_tmp)))))

