(in-package :MATRIX)

;******************************************************************
;******************************************************************
;                      COMBINATORIAL MATRICES
;******************************************************************
;******************************************************************

;   Author:  Pablo Cetta
;   Version: 1.0 (07/2012) 


;******************************************************************
;                       main functions
;******************************************************************


;------------------------------------------------------------------
;                              PCS
;------------------------------------------------------------------


(PWGLdef s-info ((chain '(0 4 A B)))
  "Remueve nils, dups, negativos y hace modulo 12 antes de calcular la forma prima.
   Si no encuentra en la tabla de Forte, invierte y busca de nuevo"
  ()
  (let ((name nil))
    (setf chain (remove-if #'minusp(remove-duplicates(mod12(AB-replace (flat chain))))))
    (setf name (pf chain))
    (if (equal name nil) (pf (inv_m12_ch chain)) name) 
  ))


(PWGLdef n-info ((name '4-Z15))
    "Dado el nombre del conjunto devuelve sus caracteristicas"
    ()
  (let ((result nil))
    (setf name (string name))
    (dolist (v table result) (if (equal (string (first v)) name) (return v)))
    )
  )

(PWGLdef s-invar((chain '(1 B 5 3 9 7)))
  "Calcula invariantes de un conjunto"
  ()
  (let ((chain_o)(chain_i)(result nil))
    (setf chain (remove-duplicates(mod12 (remove-if #'minusp (AB-replace (flat chain))))))
    (setf chain_o (sort chain #'<))
    (setf chain_i (inv_m12_ch chain))
    (dotimes (a 11 result)(if (equal (sort (tr_ch chain (+ a 1)) #'<) chain_o)(push (format nil "T~d" (+ a 1)) result))) 
    (dotimes (a 12 result)(if (equal (sort (tr_ch chain_i a) #'<) chain_o)(push (format nil "T~dI" a) result)))
    (reverse result)
  ))

(PWGLdef s-transform ((chain'(1 (2 3 A) 5))                       
                      (tr () (ccl::mk-menu-subview :menu-list '("T0" "T1" "T2" "T3" 
                        "T4" "T5" "T6" "T7" "T8" "T9" "TA" "TB" "T0I" "T1I" "T2I" "T3I" 
                        "T4I" "T5I" "T6I" "T7I" "T8I" "T9I" "TAI" "TBI") :value 1)))
  "Transforma un conjunto segun un indice de transformacion"
  ()
  (if (too-many-levels chain) (return-from s-transform))
  (setf chain(AB-replace chain))
  (first (s-transform-list chain (list (string tr))))
)

(PWGLdef closed-chains ((set '(0 1 2 7 9)))
    "Genera todas las cadenas cerradas posibles de las particiones validas de un set"
    ()
 (let((m)(p)(result nil))
    (setf set (remove-duplicates(mod12 (remove-if #'minusp (AB-replace (flat set))))))
    (setf p (partitions-pairs set))
    (dolist (m p result)
      (push (gen-chain m) result))
    (remove nil(reverse result))
))

;------------------------------------------------------------------
;                            MATRICES GEN
;------------------------------------------------------------------

(PWGLdef cm-roman((chain '((1 2) 3 (4 5 6 7) nil)))
  "Genera una matriz combinatoria tipo cuadrado romano"
  ()
  (if (too-many-levels chain) (return-from cm-roman))
  (setf chain (AB-replace chain))
  (let((result nil)(temp(copy-list chain)))
    (dolist(e chain (reverse result))
      (push temp result)
      (setf temp (circ_perm temp))
    )))

(PWGLdef cm-type1a((chain '(2 0 8 5)))
  "Genera una matriz combinatoria tipo 1a"
  ()
  (setf chain (AB-replace chain))
  (setf chain(flat chain))
  (let((res1 nil)(res2 nil))
    (dolist(e chain (reverse res1))
      (progn
        (setf res2 nil)
        (push (dolist(v chain (reverse res2))
          (push (mod (+ e v) 12) res2)) res1)
      )))) 

(PWGLdef cm-type1b((chain '(2 0 8 5)))
  "Genera una matriz combinatoria tipo 1b"
  ()
  (setf chain (AB-replace chain))
  (setf chain(flat chain))
  (let((res1 nil)(res2 nil))
    (dolist(e chain (reverse res1))
      (progn
        (setf res2 nil)
        (push (dolist(v chain (reverse res2))
          (push (mod (+ (- 12 e) v) 12) res2)) res1)
      ))))

(PWGLdef cm-type2((chain1 '(1 9 B)) (chain2 '(2 A 4 5)))
  "Genera una matriz combinatoria tipo 2"
  ()
  (setf chain1(AB-replace (flat chain1)) chain2(AB-replace(flat chain2)))
  (let((res1 nil)(res2 nil))
    (dolist(e chain2 (reverse res1))
      (progn
        (setf res2 nil)
        (push (dolist(v chain1 (reverse res2))
        (push (mod (+ e v) 12) res2)) res1)
      ))))

(PWGLdef cm-op-cycles ((chain '((1 7 A B)))  
                       (tni () (ccl::mk-menu-subview :menu-list '("T0" "T1" "T2" "T3" 
                        "T4" "T5" "T6" "T7" "T8" "T9" "TA" "TB" "T0I" "T1I" "T2I" "T3I" 
                        "T4I" "T5I" "T6I" "T7I" "T8I" "T9I" "TAI" "TBI") :value 2)))
  "Genera una matriz por ciclos de operadores. T6-TnI produce matrices de 2x2; T4-T8 de 3x3; T3-T9 de 4x4 y T2-TA de 6x6."
  ()
 (setf chain (AB-replace chain))
 (if (too-many-levels chain) (return-from cm-op-cycles))
 (let ((ind 0)(li)(dimen 0)(temp)(matriz)(x 0)(y 0)(len 0)(result nil))
    (setf tni (string tni))
    (setf li '("T0" "T1" "T2" "T3" "T4" "T5" "T6" "T7" "T8" "T9" "TA" "TB" "T0I" "T1I" "T2I" "T3I" 
                        "T4I" "T5I" "T6I" "T7I" "T8I" "T9I" "TAI" "TBI"))
    (setf ind (position tni li :test #'equal))
    (setf dimen (cond ((> ind 23) 0)    ((> ind 11) 2)    ((equal ind 6) 2)
                    ((equal ind 4) 3) ((equal ind 8) 3) ((equal ind 3) 4)
                    ((equal ind 9) 4) ((equal ind 2) 6) ((equal ind 10) 6)
                    (t 0)))
   
    (if (> (length chain) dimen)(progn(print "ERROR: Set too large. Please change TnI.")(return-from cm-op-cycles)))

    (setf temp (copy-list chain)) 
    (setf matriz (make-array (list dimen dimen) :initial-element nil))

    (dotimes (e dimen (reverse result))
      (push temp result)
      (if (> ind 11)(setf temp (inv_m12_ch temp)))
      (setf temp (tr_ch  temp (mod ind 12)))      
    )
    (setf result (reverse result) len (1- dimen))
    (dolist (e result)
      (setf x y)
      (dolist (a e)
        (setf (aref matriz y x) a)
        (setf x (1+ x))
        (if (> x len)(setf x 0))
      )
      (setf y (1+ y))
    )
    (setf result (mat2list matriz))
  ))


(PWGLdef cm-chains ((set '(0 1 2 6 8)))
    "Genera todas las matrices por cadenas posibles. Una lista de matrices combinatorias."
    ()
  (let((row)(col)(par)(matriz)(dimen 1)(result nil)(cadena)(subcad))
    (setf set (remove-duplicates(mod12 (remove-if #'minusp (AB-replace (flat set))))))  
    (setf cadena (closed-chains set))
    (setf matriz (make-array (list dimen dimen) :adjustable t))
    (dotimes (i (length cadena))
      (setf subcad (butlast(nth i cadena)) row 0 col 0 par 0)
      (setf dimen (/ (length subcad) 2))
      (adjust-array matriz (list dimen dimen) :initial-element nil)
      (dolist (e subcad)
        (setf par (1+ par))
        (if (> col (1- dimen))(setf col 0))
        (setf (aref matriz row col) e) 
        (if (= par 2)(setf par 0 row (1+ row))(setf col (1+ col))))
      (push (mat2list matriz) result))
    (princ "Number of valid CMs: ")(princ (length result))
    (reverse result))
    )

;------------------------------------------------------------------
;                            MATRICES TRANSFORMS
;------------------------------------------------------------------


(PWGLdef cm-rot-diag ((mat '(((0 1) (2 6 8) NIL NIL) (NIL (0 7) (1 5 11) NIL) (NIL NIL (6 7) (0 2 8)) ((5 7 11) NIL NIL (1 6)))
) 
                      (diag () (ccl::mk-menu-subview :menu-list '("Diag1" "Diag2") :value 0)))
  "Rota la matriz por sus diagonales (Diag1 y Diag2)"
  ()
  (let* ((matres)(len (number_r_c mat))(i 0)(j 0))
(print diag)
(print (string diag))
    (if(string= (string diag) "DIAG1")(setf diag -1) (setf diag 1))
(print diag)
    (cond((plusp diag) (setf i (1-(second len)) j (1-(first len))))
         (t (setf j 0 i 0)))
    (setf matres (make-array (reverse len) :initial-element nil))
    (dolist (m mat)
      (dolist (n m)
        (setf (aref matres i j) n)
        (cond((plusp diag) (setf i(1- i)))
             (t (setf i(1+ i))))
      )
    (cond((plusp diag) (setf j(1- j) i (1- (second len))))
          (t (setf j(1+ j) i 0)))
    )
    (mat2list matres)))


(PWGLdef cm-rot-90 ((mat '(((0 1) (2 6 8) NIL NIL) (NIL (0 7) (1 5 11) NIL) (NIL NIL (6 7) (0 2 8)) ((5 7 11) NIL NIL (1 6)))
) 
                    (dir () (ccl::mk-menu-subview :menu-list '("Left" "Right") :value 1)))
  "Rota 90 grados la matriz, a izquierda o derecha."
  ()
  (let*((matres)(i)(j)(len (number_r_c mat))(lenc (1- (first len)))(lenr (1- (second len))))
    (if(string= (string dir) "LEFT")(setf dir -1) (setf dir 1))
    (cond((plusp dir)(setf j lenc i 0))
         ((minusp dir)(setf j 0 i lenr))
          (t (setf dir 1 j lenc i 0)))
    (setf matres (make-array (reverse len) :initial-element nil)) 
    (dolist (m mat)
      (dolist (n m)
        (setf (aref matres i j) n)
        (cond((plusp dir)(setf i(1+ i)))
              ((minusp dir)(setf i(1- i))))
      )
      (cond((plusp dir)(setf j(1- j) i 0))
         ((minusp dir)(setf j(1+ j) i lenr)))
    )
    (mat2list matres)))


(PWGLdef cm-swap-rows((mat '(((0 1) (2 6 8) NIL NIL) (NIL (0 7) (1 5 11) NIL) (NIL NIL (6 7) (0 2 8)) ((5 7 11) NIL NIL (1 6)))) (r1 1) (r2 2))
  "Intercambia filas de una CM"
  ()
  (let((val1)(val2)(len (number_r_c mat)))
    (if (or(> r1 (first len))(> r2 (first len)))(progn(print "ERROR: row number is wrong")(return-from cm-swap-rows)))
    (if (or(< r1 1)(< r2 1))(progn(print "ERROR: row number is wrong")(return-from cm-swap-rows)))
    (setf mat(list2mat mat) r1 (1- r1) r2 (1- r2))
    (dotimes (i (second len))
      (setf val1 (aref mat r1 i))
      (setf val2 (aref mat r2 i))
      (setf (aref mat r2 i) val1)
      (setf (aref mat r1 i) val2)
    )
    (setf mat(mat2list mat))))


(PWGLdef cm-swap-columns((mat '(((0 1) (2 6 8) NIL NIL) (NIL (0 7) (1 5 11) NIL) (NIL NIL (6 7) (0 2 8)) ((5 7 11) NIL NIL (1 6)))) (c1 1) (c2 2))
  "Intercambia columnas de una CM"
  ()
  (let((val1)(val2)(len (number_r_c mat)))
    (if (or(> c1 (second len))(> c2 (second len)))(progn(print "ERROR: column number is wrong")(return-from cm-swap-columns)))
    (if (or(< c1 1)(< c2 1))(progn(print "ERROR: column number is wrong")(return-from cm-swap-columns)))
    (setf mat(list2mat mat) c1 (1- c1) c2 (1- c2))
    (dotimes (i (first len))
      (setf val1 (aref mat i c1))
      (setf val2 (aref mat i c2))
      (setf (aref mat i c2) val1)
      (setf (aref mat i c1) val2)
    )
    (setf mat(mat2list mat))))


(PWGLdef cm-tni((mat '(((0 1) (2 6 8) NIL NIL) (NIL (0 7) (1 5 11) NIL) (NIL NIL (6 7) (0 2 8)) ((5 7 11) NIL NIL (1 6))))
                       (tni () (ccl::mk-menu-subview :menu-list '("T0" "T1" "T2" "T3" 
                        "T4" "T5" "T6" "T7" "T8" "T9" "TA" "TB" "T0I" "T1I" "T2I" "T3I" 
                        "T4I" "T5I" "T6I" "T7I" "T8I" "T9I" "TAI" "TBI") :value 1)))
  "Transforma una CM por TnI"
  ()
  (let((result nil))
    (setf tni (string tni))
    (dolist (n mat (reverse result))
      (push(first(s-transform-list n (list tni))) result)
    )))

(PWGLdef cm-invar-position((mat '((4 2 10 7) (2 0 8 5) (10 8 4 1) (7 5 1 10))) (r 1) (c 1))
  "Mantiene invariente una posicion de una CM. Devuelve todas las matrices 
   posibles, de acuerdo a la lista de invariancias obtenida. Por el momento solo funciona
   con matrices de un elemento por posicion"
  ()
  (let((result nil)(result2 nil)(inv))
    (setf mat (list2mat mat))
    (setf inv(s-invar (list(aref mat (1- r) (1- c)))))
    (setf mat(mat2list mat))
    (dolist (i inv (reverse result))
      (setf result2 nil)
      (dolist (m mat result2)
        (push (first(s-transform-list m (list i))) result2)
      )
      (push (reverse result2) result))
  (princ "Number of CMs generated: ")
  (princ (length result))
  result))


(PWGLdef cm-invar-row((mat ' ((1 3 5) (2 4 6) (3 5 7) (4 6 8) (5 7 9))) (row 1))
  "Mantiene invariente una fila de una CM. Devuelve todas las matrices 
   posibles, de acuerdo a la lista de invariancias obtenida. Por el momento solo funciona
   con matrices de un elemento por posicion"
  ()
  (let((result nil)(result2 nil))
    (if (too-many-levels mat)(progn(princ "  .Only one element per position")(return-from cm-invar-row)))
    (if (> row (length mat))(progn(print "ERROR: row number is wrong")(return-from cm-invar-row)))
    (if (< row 1)(progn(print "ERROR: row number is wrong")(return-from cm-invar-row)))
    (dolist (i (s-invar(nth (1- row) mat)) (reverse result))
      (setf result2 nil)
      (dolist (m mat result2)
        (push  (first(s-transform-list m (list i))) result2)
      )
      (push (reverse result2) result))
  (princ "Number of CMs generated: ")
  (princ (length result))
  result))


(PWGLdef cm-invar-column((mat ' ((1 3 5) (2 4 6) (3 5 7))) (col 1))
  "Mantiene invariente una columna de una CM. Devuelve todas las matrices 
   posibles, de acuerdo a la lista de invariancias obtenida. Por el momento solo funciona
   con matrices de un elemento por posicion"
  ()
  (let((result nil) (result2 nil) (inv nil))
    (if (too-many-levels mat)(progn(princ "  .Only one element per position")(return-from cm-invar-column)))
    (if (> col (second (number_r_c mat)))(progn(print "ERROR: column number is wrong")(return-from cm-invar-column)))
    (if (< col 1)(progn(print "ERROR: column number is wrong")(return-from cm-invar-column)))
    (dolist (m mat inv)(push (nth (1- col) m) inv))
    (setf inv (s-invar inv))
    (dolist (i inv (reverse result))
      (setf result2 nil)
      (dolist (m mat result2)
        (push (first(s-transform-list m (list i))) result2)
      )
      (push (reverse result2) result))
  (princ "Number of CMs generated: ")
  (princ (length result))
  result))

;Arreglar. Solo coteja primera fila y primera columna y hay que hacerlo para todas
(PWGLdef cm-invar-matrix((mat '((2 3 4) (3 4 5) (4 5 6) (5 6 7) (6 7 8))))
  "Mantiene invariente una CM. Devuelve todas las matrices 
   posibles, de acuerdo a la lista de invariancias obtenida"
  ()
  (let((result nil)(result2 nil)(inv nil)(h)(v)(norm (cm-norm mat)))
    (setf h (s-invar(second(n-info(first norm)))) v (s-invar(second(n-info(second norm)))))
    (setf inv (intersection h v :test #'equal))
    (if(equal inv nil)(progn(format t "There are not invariance for this matrix")(return-from cm-invar-matrix))) 
    (format t "~%Invariance: ~d  ~%" inv)
    (dolist (i inv (reverse result))
      (setf result2 nil)
      (dolist (m mat result2)
        (push (first(s-transform-list m (list i))) result2)
      )
      (push (reverse result2) result))
  (princ "Number of CMs generated: ")
  (princ (length result))
  result))


(PWGLdef cm-swap-elem((mat '(((1 2 3 4 5) NIL NIL NIL NIL NIL) (NIL (3 4 5 6 7) NIL NIL NIL NIL) (NIL NIL (5 6 7 8 9) NIL NIL NIL) (NIL NIL NIL (7 8 9 10 11) NIL NIL) (NIL NIL NIL NIL (0 1 9 10 11) NIL) (NIL NIL NIL NIL NIL (0 1 2 3 11))) ) (e 1) (r1 1) (c1 1) (r2 6) (c2 6))
  "Intercambia elementos entre  posiciones de una CM"
  ()
  (let((e1)(e2))
    (if (or (equal c1 c2)(equal r1 r2))(return-from cm-swap-elem))
    (setf r1(1- r1) r2(1- r2) c1(1- c1) c2(1- c2))
    (setf mat(list2mat mat) e1 (aref mat r1 c1) e2 (aref mat r2 c2))

    (cond((and(listp e1)(listp e2))(if (not(and (subsetp (flat(list e)) e1)(subsetp (flat(list e)) e2))) (return-from cm-swap-elem))) 
         ((and(listp e1)(atom e2))(if (not(and (member e e1)(equal e e2))) (return-from cm-swap-elem)))
         ((and(atom e1)(listp e2))(if (not(and (equal e e1)(member e e2))) (return-from cm-swap-elem)))
         ((and (atom e1)(atom e2))(if (not(equal e1 e2))(return-from cm-swap-elem))))

    (remove-from-matrix mat e r1 c1)   
    (remove-from-matrix mat e r2 c2) 
    (insert-in-matrix mat e r1 c2)
    (insert-in-matrix mat e r2 c1)
    (mat2list mat)))

(PWGLdef cm-swap-all((mat '(((1 2 3 4 5) NIL NIL NIL NIL NIL) (NIL (3 4 5 6 7) NIL NIL NIL NIL) (NIL NIL (5 6 7 8 9) NIL NIL NIL) (NIL NIL NIL (7 8 9 10 11) NIL NIL) (NIL NIL NIL NIL (0 1 9 10 11) NIL) (NIL NIL NIL NIL NIL (0 1 2 3 11))) ))
  "Genera todos los swappings posibles. Devuelve la ultima CM generada"
  ()
  (let((temp mat)(pitches (flat mat)))
   (dolist (pitch pitches temp)
      (dotimes (n 5)
        (setf mat (auto-swap-pc temp pitch))
        (cond ((not(equal mat nil))(setf temp mat))
              (t (return)))))))


(PWGLdef cm-swap-all-seq((mat '(((1 2 3 4 5) NIL NIL NIL NIL NIL) (NIL (3 4 5 6 7) NIL NIL NIL NIL) (NIL NIL (5 6 7 8 9) NIL NIL NIL) (NIL NIL NIL (7 8 9 10 11) NIL NIL) (NIL NIL NIL NIL (0 1 9 10 11) NIL) (NIL NIL NIL NIL NIL (0 1 2 3 11))) ))
  "Genera todos los swappings posibles. Devuelve todas las CM generadas en una lista"
  ()
  (let((result nil)(temp mat)(pitches (flat mat)))
    (dolist (pitch pitches result)
      (dotimes (n 5)
        (setf mat (auto-swap-pc temp pitch))
        (cond ((not(equal mat nil))(setf temp mat))
              (t (return)))
        (push temp result)))        
  (princ "Number of CMs generated: ")
  (princ (length result))
  (reverse result)))


(PWGLdef cm-add ((mat1) (mat2) &optional (mat3) (mat4) (mat5) (mat6) (mat7) (mat8) (mat9))
  "Suma matrices combinatorias"
  ()
  (let((filas nil)(cols nil))

(if (not(equal mat1 nil))(progn(push (first(number_r_c mat1)) filas)(push (second(number_r_c mat1)) cols))(setf mat1 'Z))
(if (not(equal mat2 nil))(progn(push (first(number_r_c mat2)) filas)(push (second(number_r_c mat2)) cols))(setf mat2 'Z))
(if (not(equal mat3 nil))(progn(push (first(number_r_c mat3)) filas)(push (second(number_r_c mat3)) cols))(setf mat3 'Z))
(if (not(equal mat4 nil))(progn(push (first(number_r_c mat4)) filas)(push (second(number_r_c mat4)) cols))(setf mat4 'Z))
(if (not(equal mat5 nil))(progn(push (first(number_r_c mat5)) filas)(push (second(number_r_c mat5)) cols))(setf mat5 'Z))
(if (not(equal mat6 nil))(progn(push (first(number_r_c mat6)) filas)(push (second(number_r_c mat6)) cols))(setf mat6 'Z))
(if (not(equal mat7 nil))(progn(push (first(number_r_c mat7)) filas)(push (second(number_r_c mat7)) cols))(setf mat7 'Z))
(if (not(equal mat8 nil))(progn(push (first(number_r_c mat8)) filas)(push (second(number_r_c mat8)) cols))(setf mat8 'Z))
(if (not(equal mat9 nil))(progn(push (first(number_r_c mat9)) filas)(push (second(number_r_c mat9)) cols))(setf mat9 'Z))
(dolist (e filas) (if (not(=(first filas) e))(progn(print "Number of rows must be identical.") (return-from cm-add))))
(dolist (e cols) (if (not(=(first cols) e))(progn(print "Number of columns must be identical.") (return-from cm-add))))
(remove 'Z(append (list mat1)(list mat2)(list mat3)(list mat4)(list mat5)(list mat6)(list mat7)(list mat8)(list mat9)))
))

;------------------------------------------------------------------
;                            PRINTING
;------------------------------------------------------------------


(PWGLdef cm-print ((cm '((2 3 4) (3 4 5) (4 5 6) (5 6 7) (6 7 8))))
  "Imprime una matriz combinatoria"
  ()
  (cond((< (depth cm) 4)(printcm cm))
       (t (cm-group-print cm))))


(PWGLdef print-partitions((chain '(0 1 2 6 8)))
  "Imprime las particiones de un conjunto y sus propiedades"
  ()
  (let ((len 0)(parts nil)(e1 nil)(e2 nil)(condition nil))
    (setf parts (partitions chain) len (length parts))
    (setf condition (p-condition parts))
    (dotimes (a (/ len 2))
      (setf e1 (nth (* a 2) parts) e2 (nth (+ (* a 2) 1) parts))
      (format t "~%~d]~T~d~T~d~T~d~T~d   ~T~d" a e1 e2 (first(s-info e1)) (first(s-info e2))(nth a condition)))))


(PWGLdef cm-score ((mats '(((1 2) 3 (4 5 6 7) NIL) (3 (4 5 6 7) NIL (1 2)) ((4 5 6 7) NIL (1 2) 3) (NIL (1 2) 3 (4 5 6 7)))))
  "Genera partitura de una matriz combinatoria"
  ()

  (let((nrows 0) (ncols 0)(texto1) (texto2) (texto22) (texto3) (texto33) (result nil) (result2 nil) (result3 nil) (result4 nil) (t1 nil)(t2 nil)(tr nil)(tc nil)(reg 84))

    (setf texto2 '(1(Y)) ) 
    (setf texto22 '(1 Y) )                              
    (setf texto3 '(1 :notes (Z)) )
    (setf texto33 '(-1 :notes (Z)) )
    (setf nrows (first (number_r_c mats)))
    (cond ((<= nrows 4)(setf reg 84))
          ((>= nrows 5)(setf reg 96)))
    (if (< (depth mats) 4)(progn
    (dolist (e mats result3)
      (setf reg (- reg 12))
      (if (< reg 60)(setf texto1'(:staff :bass-staff (X))) (setf texto1'(:staff :treble-staff (X))))
      (dolist (f e result)
        (if (listp f)
            (if (< (length f) 1)(push(subst (subst 60 'Z texto33) 'Y texto2) result)
            (progn
              (setf result2 nil)
              (dolist (g f result2)
                (push (subst (+ reg g) 'Z texto3) result2)
                )
              (push (subst (reverse result2) 'Y texto22) result)
              ))
          (push  (subst (subst (+ reg f) 'Z texto3) 'Y texto2) result)
         )
        )
      (setf result  (subst (reverse result) 'X texto1))
      (push result result3) 
      (setf result nil)
      )
    (reverse result3))

    (progn
    (dolist (m mats)
      (push (first  (number_r_c m)) tr)
      (push (second (number_r_c m)) tc)
      )
    (dolist (e tr) (if (not(=(first tr) e))(progn(print "Number of rows must be identical.") (return-from cm-score))))
    (dolist (e tc) (if (not(=(first tc) e))(progn(print "Number of columns must be identical.") (return-from cm-score))))
    (setf nrows (first tr))
    (setf ncols (first tc))
    (dotimes (count ncols t1)
      (dolist (m mats t2)
        (push (nth count m) t2)
        )
      (push (reverse t2) t1)
      (setf t2 nil)
      )
    (cond ((<= nrows 4)(setf reg 84))
          ((>= nrows 5)(setf reg 96)))
    (setf t1 (reverse t1))
    (setf result3 nil)
    (dolist (d t1 result4)
      (setf result3 nil)   
      (setf reg (- reg 12))
      (if (< reg 60)(setf texto1'(:staff :bass-staff X)) (setf texto1'(:staff :treble-staff X)))
      (dolist (e d result3)
        (dolist (f e result)  ;;Bucle compas
          (if (listp f)
              (if (< (length f) 1)(push(subst (subst 60 'Z texto33) 'Y texto2) result)
                (progn
                  (setf result2 nil)
                  (dolist (g f result2)
                    (push (subst (+ reg g) 'Z texto3) result2)
                    )
                  (push (subst (reverse result2) 'Y texto22) result)
                  ))
            (push  (subst (subst (+ reg f) 'Z texto3) 'Y texto2) result)
            )
          )                 ;; Fin Bucle compas
        
        (push (reverse result) result3) 
        (setf result nil)
        )
      (push (subst (reverse result3) 'X texto1) result4)
      (setf result3 nil))
      (reverse result4)))

))
          


(PWGLdef cm-norm-print((mat '((2 6 7 0) (10 2 3 8) (11 3 4 9))))
  "Imprime la norma horizontal y vertical de una matriz"
  ()
  (format t "~%Horizontal norm: ~d~T   Vertical norm: ~d" (first (cm-norm mat)) (second (cm-norm mat)))
)


;******************************************************************
;                     PCS TABLE
;******************************************************************

(defvar table '(
(1-1 (0) (0 0 0 0 0 0)) (2-1 (0 1) (1 0 0 0 0 0)) (2-2 (0 2) (0 1 0 0 0 0)) (2-3 (0 3) (0 0 1 0 0 0)) (2-4 (0 4) (0 0 0 1 0 0)) (2-5 (0 5) (0 0 0 0 1 0)) (2-6 (0 6) (0 0 0 0 0 1)) (3-1 (0 1 2) (2 1 0 0 0 0)) (3-2 (0 1 3) (1 1 1 0 0 0)) (3-3 (0 1 4) (1 0 1 1 0 0)) (3-4 (0 1 5) (1 0 0 1 1 0)) (3-5 (0 1 6) (1 0 0 0 1 1)) (3-6 (0 2 4) (0 2 0 1 0 0)) (3-7 (0 2 5) (0 1 1 0 1 0)) (3-8 (0 2 6)(0 1 0 1 0 1)) (3-9 (0 2 7) (0 1 0 0 2 0)) (3-10 (0 3 6) (0 0 2 0 0 1)) (3-11 (0 3 7) (0 0 1 1 1 0)) 
(3-12 (0 4 8) (0 0 0 3 0 0)) (4-1 (0 1 2 3) (3 2 1 0 0 0)) (4-2 (0 1 2 4) (2 2 1 1 0 0)) (4-3 (0 1 3 4) (2 1 2 1 0 0))
(4-4 (0 1 2 5) (2 1 1 1 1 0))  (4-5 (0 1 2 6) (2 1 0 1 1 1)) (4-6 (0 1 2 7) (2 1 0 0 2 1)) (4-7 (0 1 4 5) (2 0 1 2 1 0))
(4-8 (0 1 5 6) (2 0 0 1 2 1))  (4-9 (0 1 6 7) (2 0 0 0 2 2)) (4-10 (0 2 3 5) (1 2 2 0 1 0)) (4-11 (0 1 3 5) (1 2 1 1 1 0))
(4-12 (0 2 3 6) (1 1 2 1 0 1)) (4-13 (0 1 3 6) (1 1 2 0 1 1)) (4-14 (0 2 3 7) (1 1 1 1 2 0)) (4-Z15 (0 1 4 6) (1 1 1 1 1 1)) (4-16 (0 1 5 7) (1 1 0 1 2 1)) (4-17 (0 3 4 7) (1 0 2 2 1 0)) (4-18 (0 1 4 7) (1 0 2 1 1 1)) (4-19 (0 1 4 8) (1 0 1 3 1 0)) (4-20 (0 1 5 8) (1 0 1 2 2 0)) (4-21 (0 2 4 6) (0 3 0 2 0 1)) (4-22 (0 2 4 7) (0 2 1 1 2 0)) (4-23 (0 2 5 7) (0 2 1 0 3 0)) (4-24 (0 2 4 8) (0 2 0 3 0 1)) (4-25 (0 2 6 8) (0 2 0 2 0 2)) (4-26 (0 3 5 8) (0 1 2 1 2 0)) (4-27 (0 2 5 8) (0 1 2 1 1 1)) (4-28 (0 3 6 9) (0 0 4 0 0 2)) (4-Z29 (0 1 3 7) (1 1 1 1 1 1)) (5-1 (0 1 2 3 4) (4 3 2 1 0 0)) (5-2 (0 1 2 3 5) (3 3 2 1 1 0)) (5-3 (0 1 2 4 5) (3 2 2 2 1 0)) (5-4 (0 1 2 3 6) (3 2 2 1 1 1)) (5-5 (0 1 2 3 7) (3 2 1 1 2 1)) (5-6 (0 1 2 5 6) (3 1 1 2 2 1)) (5-7 (0 1 2 6 7) (3 1 0 1 3 2)) (5-8 (0 2 3 4 6) (2 3 2 2 0 1)) (5-9 (0 1 2 4 6) (2 3 1 2 1 1))
(5-10 (0 1 3 4 6) (2 2 3 1 1 1)) (5-11 (0 2 3 4 7) (2 2 2 2 2 0)) (5-Z12 (0 1 3 5 6) (2 2 2 1 2 1)) (5-13 (0 1 2 4 8) (2 2 1 3 1 1)) (5-14 (0 1 2 5 7) (2 2 1 1 3 1)) (5-15 (0 1 2 6 8) (2 2 0 2 2 2)) (5-16 (0 1 3 4 7) (2 1 3 2 1 1))
(5-Z17 (0 1 3 4 8) (2 1 2 3 2 0)) (5-Z18 (0 1 4 5 7) (2 1 2 2 2 1)) (5-Z18B (0 2 3 6 7) (2 1 2 2 2 1)) (5-19  (0 1 3 6 7) (2 1 2 1 2 2)) (5-20 (0 1 3 7 8) (2 1 1 2 3 1)) (5-21 (0 1 4 5 8) (2 0 2 4 2 0)) (5-22 (0 1 4 7 8) (2 0 2 3 2 1))
(5-23 (0 2 3 5 7) (1 3 2 1 3 0)) (5-24 (0 1 3 5 7) (1 3 1 2 2 1)) (5-25 (0 2 3 5 8) (1 2 3 1 2 1)) (5-26 (0 2 4 5 8) (1 2 2 3 1 1)) (5-27 (0 1 3 5 8) (1 2 2 2 3 0)) (5-28 (0 2 3 6 8) (1 2 2 2 1 2)) (5-29 (0 1 3 6 8) (1 2 2 1 3 1)) (5-30 (0 1 4 6 8) (1 2 1 3 2 1)) (5-31 (0 1 3 6 9) (1 1 4 1 1 2)) (5-32 (0 1 4 6 9) (1 1 3 2 2 1)) (5-33 (0 2 4 6 8) (0 4 0 4 0 2))
(5-34 (0 2 4 6 9) (0 3 2 2 2 1)) (5-35 (0 2 4 7 9) (0 3 2 1 4 0)) (5-Z36 (0 1 2 4 7) (2 2 2 1 2 1)) (5-Z37 (0 3 4 5 8) (2 1 2 3 2 0)) (5-Z38 (0 1 2 5 8) (2 1 2 2 2 1)) (6-1 (0 1 2 3 4 5) (5 4 3 2 1 0)) (6-2 (0 1 2 3 4 6) (4 4 3 2 1 1))
(6-Z3 (0 1 2 3 5 6) (4 3 3 2 2 1)) (6-Z4 (0 1 2 4 5 6) (4 3 2 3 2 1)) (6-5 (0 1 2 3 6 7) (4 2 2 2 3 2)) (6-Z6 (0 1 2 5 6 7) (4 2 1 2 4 2)) (6-7 (0 1 2 6 7 8) (4 2 0 2 4 3)) (6-8 (0 2 3 4 5 7) (3 4 3 2 3 0)) (6-9 (0 1 2 3 5 7) (3 4 2 2 3 1))
(6-Z10 (0 1 3 4 5 7) (3 3 3 3 2 1)) (6-Z11 (0 1 2 4 5 7) (3 3 3 2 3 1)) (6-Z12 (0 1 2 4 6 7) (3 3 2 2 3 2)) 	
(6-Z13 (0 1 3 4 6 7) (3 2 4 2 2 2)) (6-14 (0 1 3 4 5 8) (3 2 3 4 3 0)) (6-15 (0 1 2 4 5 8) (3 2 3 4 2 1))
(6-16 (0 1 4 5 6 8) (3 2 2 4 3 1)) (6-Z17 (0 1 2 4 7 8) (3 2 2 3 3 2)) 	(6-18 (0 1 2 5 7 8) (3 2 2 2 4 2))
(6-Z19 (0 1 3 4 7 8) (3 1 3 4 3 1)) (6-20 (0 1 4 5 8 9) (3 0 3 6 3 0)) (6-21 (0 2 3 4 6 8) (2 4 2 4 1 2))
(6-22 (0 1 2 4 6 8) (2 4 1 4 2 2)) (6-Z23 (0 2 3 5 6 8) (2 3 4 2 2 2)) (6-Z24 (0 1 3 4 6 8) (2 3 3 3 3 1)) 	
(6-Z25 (0 1 3 5 6 8) (2 3 3 2 4 1)) (6-Z26 (0 1 3 5 7 8) (2 3 2 3 4 1)) (6-27 (0 1 3 4 6 9) (2 2 5 2 2 2))
(6-Z28 (0 1 3 5 6 9) (2 2 4 3 2 2)) (6-Z29 (0 1 3 6 8 9) (2 2 4 2 3 2)) (6-30 (0 1 3 6 7 9) (2 2 4 2 2 3))
(6-31 (0 1 3 5 8 9) (2 2 3 4 3 1)) (6-32 (0 2 4 5 7 9) (1 4 3 2 5 0)) (6-33 (0 2 3 5 7 9) (1 4 3 2 4 1))
(6-34 (0 1 3 5 7 9) (1 4 2 4 2 2)) (6-35 (0 2 4 6 8 A) (0 6 0 6 0 3)) (6-Z36 (0 1 2 3 4 7) (4 3 3 2 2 1)) 	
(6-Z37 (0 1 2 3 4 8) (4 3 2 3 2 1)) (6-Z38 (0 1 2 3 7 8) (4 2 1 2 4 2)) (6-Z39 (0 2 3 4 5 8) (3 3 3 3 2 1))	
(6-Z40 (0 1 2 3 5 8) (3 3 3 2 3 1)) (6-Z41 (0 1 2 3 6 8) (3 3 2 2 3 2))	(6-Z42 (0 1 2 3 6 9) (3 2 4 2 2 2))
(6-Z43 (0 1 2 5 6 8) (3 2 2 3 3 2)) (6-Z44 (0 1 2 5 6 9) (3 1 3 4 3 1)) (6-Z45 (0 2 3 4 6 9) (2 3 4 2 2 2))
(6-Z46 (0 1 2 4 6 9) (2 3 3 3 3 1)) (6Z47 (0 1 2 4 7 9) (2 3 3 2 4 1)) 	(6-Z48 (0 1 2 5 7 9) (2 3 2 3 4 1))
(6-Z49 (0 1 3 4 7 9) (2 2 4 3 2 2)) (6-Z50 (0 1 4 6 7 9) (2 2 4 2 3 2)) (7-1 (0 1 2 3 4 5 6) (6 5 4 3 2 1))
(7-2 (0 1 2 3 4 5 7) (5 5 4 3 3 1)) (7-3 (0 1 2 3 4 5 8) (5 4 4 4 3 1)) (7-4 (0 1 2 3 4 6 7) (5 4 4 3 3 2)) 	
(7-5 (0 1 2 3 5 6 7) (5 4 3 3 4 2)) (7-6 (0 1 2 3 4 7 8) (5 3 3 4 4 2)) (7-7 (0 1 2 3 6 7 8) (5 3 2 3 5 3))	
(7-8 (0 2 3 4 5 6 8) (4 5 4 4 2 2)) (7-9 (0 1 2 3 4 6 8) (4 5 3 4 3 2)) (7-10 (0 1 2 3 4 6 9) (4 4 5 3 3 2)) 	
(7-11 (0 1 3 4 5 6 8) (4 4 4 4 4 1)) (7-Z12 (0 1 2 3 4 7 9) (4 4 4 3 4 2)) (7-13 (0 1 2 4 5 6 8) (4 4 3 5 3 2)) 	
(7-14 (0 1 2 3 5 7 8) (4 4 3 3 5 2)) (7-15 (0 1 2 4 6 7 8) (4 4 2 4 4 3)) (7-16 (0 1 2 3 5 6 9) (4 3 5 4 3 2)) 	
(7-Z17 (0 1 2 4 5 6 9) (4 3 4 5 4 1)) (7-Z18 (0 1 2 3 5 8 9) (4 3 4 4 4 2)) (7-19 (0 1 2 3 6 7 9) (4 3 4 3 4 3)) 
(7-20 (0 1 2 4 7 8 9) (4 3 3 4 5 2)) (7-21 (0 1 2 4 5 8 9) (4 2 4 6 4 1)) (7-22 (0 1 2 5 6 8 9) (4 2 4 5 4 2))
(7-23 (0 2 3 4 5 7 9) (3 5 4 3 5 1)) (7-24 (0 1 2 3 5 7 9) (3 5 3 4 4 2)) (7-25 (0 2 3 4 6 7 9) (3 4 5 3 4 2)) 	
(7-26 (0 1 3 4 5 7 9) (3 4 4 5 3 2)) (7-27 (0 1 2 4 5 7 9) (3 4 4 4 5 1)) (7-28 (0 1 3 5 6 7 9) (3 4 4 4 3 3)) 	
(7-29 (0 1 2 4 6 7 9) (3 4 4 3 5 2)) (7-30 (0 1 2 4 6 8 9) (3 4 3 5 4 2)) (7-31 (0 1 3 4 6 7 9) (3 3 6 3 3 3))
(7-32 (0 1 3 4 6 8 9) (3 3 5 4 4 2)) (7-33 (0 1 2 4 6 8 A) (2 6 2 6 2 3)) (7-34 (0 1 3 4 6 8 A) (2 5 4 4 4 2))
(7-35 (0 1 3 5 6 8 A) (2 5 4 3 6 1)) (7-Z36 (0 1 2 3 5 6 8) (4 4 4 3 4 2)) (7-Z37 (0 1 3 4 5 7 8) (4 3 4 5 4 1)) 	
(7-Z38 (0 1 2 4 5 7 8) (4 3 4 4 4 2)) (8-1 (0 1 2 3 4 5 6 7) (7 6 5 4 4 2)) (8-2 (0 1 2 3 4 5 6 8) (6 6 5 5 4 2)) 	
(8-3 (0 1 2 3 4 5 6 9) (6 5 6 5 4 2)) (8-4 (0 1 2 3 4 5 7 8) (6 5 5 5 5 2)) (8-5 (0 1 2 3 4 6 7 8) (6 5 4 5 5 3)) 	
(8-6 (0 1 2 3 5 6 7 8) (6 5 4 4 6 3)) (8-7 (0 1 2 3 4 5 8 9) (6 4 5 6 5 2)) (8-8 (0 1 2 3 4 7 8 9) (6 4 4 5 6 3)) 	
(8-9 (0 1 2 3 6 7 8 9) (6 4 4 4 6 4)) (8-10 (0 2 3 4 5 6 7 9) (5 6 6 4 5 2)) (8-11 (0 1 2 3 4 5 7 9) (5 6 5 5 5 2)) 	
(8-12 (0 1 3 4 5 6 7 9) (5 5 6 5 4 3)) (8-13 (0 1 2 3 4 6 7 9) (5 5 6 4 5 3)) (8-14 (0 1 2 4 5 6 7 9) (5 5 5 5 6 2)) 	
(8-Z15 (0 1 2 3 4 6 8 9) (5 5 5 5 5 3)) (8-16 (0 1 2 3 5 7 8 9) (5 5 4 5 6 3)) 	(8-17 (0 1 3 4 5 6 8 9) (5 4 6 6 5 2)) 	
(8-18 (0 1 2 3 5 6 8 9) (5 4 6 5 5 3)) (8-19 (0 1 2 4 5 6 8 9) (5 4 5 7 5 2)) (8-20 (0 1 2 4 5 7 8 9) (5 4 5 6 6 2)) 	
(8-21 (0 1 2 3 4 6 8 A) (4 7 4 6 4 3)) (8-22 (0 1 2 3 5 6 8 A) (4 6 5 5 6 2)) (8-23 (0 1 2 3 5 7 8 A) (4 6 5 4 7 2))
(8-24 (0 1 2 4 5 6 8 A) (4 6 4 7 4 3))	(8-25 (0 1 2 4 6 7 8 A) (4 6 4 6 4 4)) (8-26 (0 1 2 4 5 7 9 A) (4 5 6 5 6 2))
(8-27 (0 1 2 4 5 7 8 A) (4 5 6 5 5 3)) 	(8-28 (0 1 3 4 6 7 9 A) (4 4 8 4 4 4)) (8-Z29 (0 1 2 3 5 6 7 9) (5 5 5 5 5 3)) 	
(9-1 (0 1 2 3 4 5 6 7 8) (8 7 6 6 6 3)) (9-2 (0 1 2 3 4 5 6 7 9) (7 7 7 6 6 3)) (9-3 (0 1 2 3 4 5 6 8 9) (7 6 7 7 6 3))	
(9-4 (0 1 2 3 4 5 7 8 9) (7 6 6 7 7 3)) (9-5 (0 1 2 3 4 6 7 8 9) (7 6 6 6 7 4)) (9-6 (0 1 2 3 4 5 6 8 A) (6 8 6 7 6 3)) 
(9-7 (0 1 2 3 4 5 7 8 A) (6 7 7 6 7 3)) (9-8 (0 1 2 3 4 6 7 8 A) (6 7 6 7 6 4)) (9-9 (0 1 2 3 5 6 7 8 A) (6 7 6 6 8 3))
(9-10 (0 1 2 3 4 6 7 9 A) (6 6 8 6 6 4)) (9-11 (0 1 2 3 5 6 7 9 A) (6 6 7 7 7 3)) (9-12 (0 1 2 4 5 6 8 9 A) (6 6 6 9 6 3))
(10-1 (0 1 2 3 4 5 6 7 8 9) (9 8 8 8 8 4)) (10-2 (0 1 2 3 4 5 6 7 8 A) (8 9 8 8 8 4)) (10-3 (0 1 2 3 4 5 6 7 9 A) (8 8 9 8 8 4)) (10-4 (0 1 2 3 4 5 6 8 9 A) (8 8 8 9 8 4)) (10-5 (0 1 2 3 4 5 7 8 9 A) (8 8 8 8 9 4)) (10-6 (0 1 2 3 4 6 7 8 9 A) (8 8 8 8 8 5)) (11-1 (0 1 2 3 4 5 6 7 8 9 A) (10 10 10 10 10 5)) (12-1 (0 1 2 3 4 5 6 7 8 9 A B) (12 12 12 12 12 6))
))

;******************************************************************
;                       other functions
;******************************************************************

;------------------------------------------------------------------
;                   OPERATIONS WITH PCS
;------------------------------------------------------------------

(defun pf(chain)
   "Calcula la forma prime de un conjunto"
   (let((len (length chain)) (temp (copy-list chain)) (tlist nil) (clist) (min 100) (name nil)) 
      (sort temp #'<)
      (dotimes (a len tlist)
         (push temp tlist)
         (setf temp (circ_perm_12 temp))
      )                                                                                     
      (setf temp nil)
      (dolist (a (reverse tlist) clist)(push (abs (- (first a) (nth (- len 1) a))) clist))                                       
      (setf min (minimo clist))                                                                                                     
      (dotimes (n len temp)(if (equal (nth n clist) min) (push (nth n tlist)  temp)))     
      (dolist (a temp name)
         (dolist (v table) (if (equal (second v)(tr_pc_ch a 0)) (return (setf name v))))
      )))

(defun pcs_S (chain)
  "Remueve nils, dups, negativos y hace modulo 12 antes de calcular la forma prima.
   Para tabla de Strauss"
    (pf (remove-duplicates(mod12 (remove-if #'minusp (AB-replace (flat chain))))))
)

(defun tr_ch (chain ti)
    "Transporta el conjunto al indice ti (number). Puede haber una sublista dentro de la lista recibida"
  (let((result nil)(res2 nil))
    (dolist(e chain (reverse result))
      (cond((numberp e)(push (mod (+ e ti) 12) result))
        ((listp e)
          (setf res2 nil)
          (dolist (a e res2) (push (mod (+ a ti) 12) res2))
          (push (sort  res2 #'<) result)
        )))))

(defun inv_m12_ch(chain)
  "Invierte modulo 12. Puede haber una sublista dentro de la lista dada
    y esa sublista es ordenada de menor a mayor"
  (let((result nil)(res2 nil))
    (dolist(e chain (reverse result))
      (cond((numberp e)(push (mod (- 12 e) 12) result))
        ((listp e)
           (setf res2 nil)
           (dolist (a e res2) (push (mod (- 12 a) 12) res2))
           (push (sort res2 #'<) result)
        )))))

(defun tr_pc_ch(chain ti)
  "Transporta un conjunto sobre un grado dado t"
  (let((tr (- ti (first chain))))
    (if (< tr 0) (setf tr (+ 12 tr)) tr)
    (tr_ch chain tr)
    ))

(defun inv_ch(chain)  
  "Invierte un conjunto con la primera nota como eje"
  (tr_pc_ch (inv_m12_ch chain) (first chain))
)

(defun circ_perm(chain)
  "Realiza una permutacion circular"
  (let((result (cdr chain)))
  (append result (list (first chain))))
)

(defun circ_perm_12(chain)
  "Permuta ciclicamente y suma 12 al ultimo termino"
  (let((result (cdr chain)))
  (append result (list (+ 12 (first chain)))))
)

(defun circ_perm_n(chain n)
  "Realiza n permutaciones circulares"
  (let((temp (copy-list chain)))
    (dotimes (i n) (setf temp (circ_perm temp)))
    temp
  )
)

(defun maximo (l)
  "Maximo de una lista"
  (apply #'max l)
)

(defun minimo (l)
  "Minimo de una lista"
  (apply #'min l)
)

(defun mod12 (chain)
  "Aplica modulo 12 a una lista"
  (mapcar #'(lambda(n) (if (> n 0) (mod n 12) n)) chain)
)

(defun invar2(chain2 chain1)
  "Calcula indices para transformar el primer conjunto en el segundo"
  (let ((chain_o)(chain_i)(result nil))
    (setf chain_o (sort chain1 #'<))
    (setf chain_i (inv_m12_ch chain2))
    (dotimes (a 12 result)(if (equal (sort (tr_ch chain2 a) #'<) chain_o)(push (format nil "T~d" a) result))) 
    (dotimes (a 12 result)(if (equal (sort (tr_ch chain_i a) #'<) chain_o)(push (format nil "T~dI" a) result)))
    (reverse result)
  ))

(defun s-transform-list (chain tr)
  "Transforma un conjunto segun una lista recibida de indices de transformacion"
  (let ((ind 0)(li)(temp)(result nil))
    (setf li '("T0" "T1" "T2" "T3" "T4" "T5" "T6" "T7" "T8" "T9" "TA" "TB" 
              "T0I" "T1I" "T2I" "T3I" "T4I" "T5I" "T6I" "T7I" "T8I" "T9I" "TAI" "TBI"))
    (dolist (tni tr (reverse result))
      (dotimes (e (length li))
        (setf temp (copy-list chain)) 
        (if (equal (nth e li) tni) (return (setf ind e)))
      )
      (if (> ind 11)(setf temp (inv_m12_ch chain)))
      (push (tr_ch  temp (mod ind 12)) result)
    )))

;------------------------------------------------------------------
;                             PARTITIONS
;------------------------------------------------------------------

(defun partitions(chain)
  "Calcula las particiones de un conjunto"
  (let ((result nil)(temp(copy-list chain))(temp2 nil))
    (dolist(e chain (reverse result))
      (push (list e) result)
      (push (sort(set-difference chain (list e))#'<) result)
    ) 
    (setf temp (copy-list chain))
    (dolist(e (butlast chain) result)
      (pop temp)
      (dolist(v temp)
        (setf temp2 (list e (first temp)))
        (push temp2  result)
        (push (sort(set-difference chain temp2)#'<) result)
        (setf temp (circ_perm temp))    
      )
    )   
    (if (> (length chain) 5)
      (progn
        (setf temp '((0 1 2)(0 1 3)(0 1 4)(0 1 5)(0 2 3)(0 2 4)(0 2 5)(0 3 4)(0 3 5)(0 4 5)))
        (dolist(e temp (reverse result))
          (setf temp2 (list (nth (first e) chain) (nth (second e) chain)(nth (third e) chain)))
          (push temp2 result)
          (push (sort(set-difference chain temp2)#'<) result)))
      (reverse result))))

(defun p-condition(parts)
  "Calcula el tipo de particion y sus propiedades"
  (let((len)(e1)(e2)(pfe1)(pfe2)(e3)(e4)(in)(in1)(in2)(result nil)(names nil)(flag 0))
    (setf len (length parts))
    (setf in (s-invar(append (first parts)(second parts))))
    (dotimes (a (/ len 2) result)
      (setf e1 (nth (* a 2) parts) e2 (nth (+ (* a 2) 1) parts) in1 (s-invar e1) in2 (s-invar e2))
      (setf pfe1 (first(s-info e1)) pfe2 (first(s-info e2)))
      (dotimes (e (/ (length names) 2))
        (setf e3 (nth (* e 2) names) e4 (nth (+ (* e 2) 1) names))
        (cond((and (equal e3 pfe1)(equal e4 pfe2)) (setf flag 1))
             ((and (equal e4 pfe1)(equal e3 pfe2)) (setf flag 1))
        )
      )
      (push pfe1 names)
      (push pfe2 names)         
      (cond ((> flag 0) (push "*" result))
            ((not (equal (set-difference (invar2 e2 e1) in :test #'equal) nil)) (push "3" result))
            ((and(and(not(equal in1 nil))(not(equal (set-difference in1 in :test #'equal) nil)))
                 (and(not(equal in2 nil))(not(equal (set-difference in2 in :test #'equal) nil))))(push "12" result))
            ((and(not(equal in1 nil))(not(equal (set-difference in1 in :test #'equal) nil)))(push "1" result))
            ((and(not(equal in2 nil))(not(equal (set-difference in2 in :test #'equal) nil)))(push "2" result))
            (t (push "-" result)))
     (setf flag 0))
    (reverse result)))
   

(defun sel-valid-partitions(parts condition)
  "Descarta las particiones redundantes o inutiles para formar cadenas"
  (let ((result nil))
    (dotimes (n (length condition) (reverse result))
      (cond((equal (nth n condition) "-") nil)
         ((equal (nth n condition) "*") nil)
         (t (push (list (nth (* n 2)  parts)(nth (+ (* n 2) 1)  parts)) result))))))

(defun partitions-pairs (set)
  "Devuelve pares de particiones validas con un set en comun, para formar cadenas"
  (let* ((result nil)(a nil)(parts (partitions set))(valid (sel-valid-partitions parts (p-condition parts))))
    (dolist (i valid (reverse result))
      (setf a (pop valid))
      (dolist (e valid) 
        (cond ((equal (first(s-info (first e))) (first(s-info (first a))))(push (list (reverse a) e) result))
              ((equal (first(s-info (first e))) (first(s-info (second a))))(push (list (reverse a) (reverse e)) result))
              ((equal (first(s-info (second e))) (first(s-info (first a))))(push (list a e) result))
              ((equal (first(s-info (second e))) (first(s-info (second a))))(push (list a (reverse e)) result)))))))

(defun gen-chain(m)
    "Genera una cadena cerrada, que no tenga posiciones repetidas"
  (let((result nil)(count 0)(a)(b)(c)(d)(e)(f)(flag)(invariantes)(len_invars))
    (setf a (first m) b (second m) f (copy-list a))
    (push (second a) result)     
    (dotimes (j 5)
      (setf invariantes (invar2 (first b)(second f)))
      (setf len_invars (length invariantes))
      (setf flag t)
      (dotimes (n len_invars)
        (setf count 0)
        (setf c  (first (circ_perm_n (s-transform-list b invariantes) (+ n 1))))
        (dolist (r result) (if (equal r (second c))(setf count (1+ count))))
        ;(format t "~% count: ~d c: ~d invar: ~d" count c invariantes)
        (if (= count 0)(progn(push (second c) result)(setf flag nil)(return))))
      (if (equal (first a) (second c))(return-from gen-chain (append (list(first a)) (reverse result))))
      (if (equal flag t)(return-from gen-chain nil))

      (setf invariantes (invar2 (second b)(second c)))
      (setf len_invars (length invariantes))
      (setf flag t)
      (dotimes (n len_invars)
        (setf count 0)
        (setf d  (first (circ_perm_n (s-transform-list (reverse b) invariantes) (+ n 1))))
        (dolist (r result) (if (equal r (second d))(setf count (1+ count))))
        ;(format t "~% count: ~d d: ~d invar: ~d" count d invariantes)
        (if (= count 0)(progn(push (second d) result)(setf flag nil)(return))))
      (if (equal (first a) (second d))(return-from gen-chain (append (list(first a)) (reverse result))))
      (if (equal flag t)(return-from gen-chain nil))

      (setf invariantes (invar2 (second a)(second d)))
      (setf len_invars (length invariantes)) 
      (setf flag t)
      (dotimes (n len_invars)
        (setf count 0)
        (setf e (first (circ_perm_n (s-transform-list (reverse a) invariantes) (+ n 1))))
        (dolist (r result) (if (equal r (second e))(setf count (1+ count))))
        ;(format t "~% count: ~d e: ~d invar: ~d" count e invariantes)
        (if (= count 0)(progn(push (second e) result)(setf flag nil)(return))))
      (if (equal (first a) (second e))(return-from gen-chain (append (list(first a)) (reverse result))))
      (if (equal flag t)(return-from gen-chain nil))

      (setf invariantes (invar2 (first a)(second e)))
      (setf len_invars (length invariantes))
      (setf flag t)
      (dotimes (n len_invars)
        (setf count 0)
        (setf f (first (circ_perm_n (s-transform-list a invariantes) (+ n 1))))
        (dolist (r result) (if (equal r (second f))(setf count (1+ count))))
        ;(format t "~% count: ~d f: ~d invar: ~d" count f invariantes)
        (if (= count 0)(progn(push (second f) result)(setf flag nil)(return))))
      (if (equal (first a) (second f))(return-from gen-chain (append (list (first a)) (reverse result))))  
      (if (equal flag t)(return-from gen-chain nil))     
 )))


;------------------------------------------------------------------
;                       MATRICES GENERATORS
;------------------------------------------------------------------

;------------------------------------------------------------------
;                       MATRICES TRANSFORMS
;------------------------------------------------------------------

     
(defun auto-swap-pc(mat pc)
  "Genera un intercambio de elementos automatico, dado el PC"
  (let*((cm_array (list2mat mat))(matdens (cm-density cm_array))(maxd (max-density matdens))(hidens)(r1)(c1)(r2)(c2)(res nil))
    (setf hidens (sort-hi-density (search-pc cm_array pc) matdens maxd))
    (if(< (length hidens) 2)(return-from auto-swap-pc))
    (dotimes (h (1- (length  hidens)))
      (setf r1 (first(first hidens)) c1 (second (first hidens)) r2 (first(nth (1+ h) hidens)) c2 (second(nth (1+ h) hidens)))
      (if (< (+ (aref matdens r2 c1)(aref matdens r1 c2) 2) (+ (aref matdens r1 c1)(aref matdens r2 c2)))
        (progn(setf res (cm-swap-elem mat pc (1+ r1) (1+ c1) (1+ r2) (1+ c2)))(return))))
    res))
 

;------------------------------------------------------------------
;                             PRINTING
;------------------------------------------------------------------

(defun printcm(cm)
  "Imprime una matriz combinatoria"
  (let ((len 1)(tlen 1) (cad nil) (flag nil))
    (dolist(a cm nil)
      (dolist(b a nil)
        (if (listp b)
            (if (> (length b) len) (setf len (1+ (length b))))
        )
      )
    )
    (dolist(a cm nil)
      (setf flag nil)
      (if (equal (depth a) 1) (setf cad  (number2AB a)) (setf flag t))
      (if (equal flag t)
       (dolist(b a nil)
        (if (listp b) (setf cad(append cad (list(list2sym b))))(setf cad(append cad (list (number2AB b)))))))
      (format t "~%")
      (dotimes (k (length cad))
      (format t "~T~va " 12 (nth k cad)))
      (setf cad nil)

)
  (princ cad)(terpri)(terpri)))

(defun printcm-copy(cm)
  "Imprime una matriz combinatoria"
  (let ((len 1)(tlen 1) (cad nil) (flag nil))
    (dolist(a cm nil)
      (dolist(b a nil)
        (if (listp b)
            (if (> (length b) len) (setf len (+ (length b) 10)))
        )
      )
    )
    (dolist(a cm nil)
      (setf flag nil)
      (if (equal (depth a) 1) (setf cad  (number2AB a)) (setf flag t))
      (if (equal flag t)
       (dolist(b a nil)
        (if (listp b) (setf cad(append cad (list(list2sym b))))(setf cad(append cad (list (number2AB b)))))))
      (format t "~%")
      (dotimes (k (length cad))
      (format t "~v@a " len (nth k cad)))
      (setf cad nil))
    (terpri)(terpri)))

(defun cm-group-print(group) 
  "Imprime un grupo de matrices combinatorias, una a continuacion de otra"
  (dolist (g group)
    (format t "~%")
    (printcm g)))

;------------------------------------------------------------------
;                        misc functions
;------------------------------------------------------------------

(defun mat2list (a &optional (dims (array-dimensions a)) (start 0))
"Convierte una CM en forma de matriz a una CM en forma de lista"
  (if (not dims)
      (row-major-aref a start)
      (let ((dim1 (first dims)) (more-dims (rest dims)))
        (loop repeat dim1
              for j from start by (apply #'* more-dims)
              collect (mat2list a more-dims j)))))


(defun list2mat(lista)
"Convierte una CM en forma de lista a una CM en forma de matriz"
 (let*((matres)(i 0)(j 0)(len (number_r_c lista)))
    (setf matres (make-array len :initial-element nil))
    (dolist (m lista matres)
      (dolist (n m)  
        (setf (aref matres j i) n)
        (setf i(1+ i))
      )
    (setf j(1+ j) i 0)  )))

(defun depth (lst)
  "Devuelve el numero de niveles de un arbol"
  (if (atom lst) 0
    (1+ (apply #'max (mapcar #'depth lst)))))

(defun tune-set(chain)
  (cond ((numberp chain)(progn(print "ERROR: a list was expected")(return-from tune-set))) 
        ((listp chain)(dolist (a chain)(if (listp a)(dolist (b a)(if (listp b)(progn(print "ERROR: only one level of sublists is allowed")(return-from tune-set)))))))
  ))

(defun AB-replace (chain)
  "Reemplaza A y B por 10 y 11, respectivamente."
  (setf chain (subst 10 'system::A chain :test #' equal))
  (setf chain (subst 11 'system::B chain :test #' equal))
)

(defun too-many-levels (chain)
"Si el árbol tiene más de dos niveles devuelve error."
 (let ((levels (depth chain)))
 (if (> levels 2)
   (progn
     (format t "ERROR: ~d levels in tree. Max. number of levels is 2" levels)
     t)
     nil )))

(defun number_r_c(mat)
"Devuelve numero de columnas y filas"
  (list (length mat) (length (first mat))))

(defun cm-norm(mat)
  "Devuelve la norma horizontal y vertical de una CM"
  (let((result nil)(h nil)(v nil))
    (dolist (e mat result)(print(push (first e) result)))
    (setf h  (string(first(s-info(first mat)))) v  (string(first(s-info (flat result)))))
    ;(format t "~%Horizontal norm: ~d   Vertical norm: ~d  ~d~%" h v)
    (list h v)))

(defun position-len (mat r c)
  "Devuelve la cantidad de elementos de una posicion de la CM"
  (let ((e nil))
    (setf mat(list2mat mat) e (aref mat (1- r) (1- c)))
    (cond((listp e)(setf e (length e)))
         (t (setf e 1)))))

(defun insert-in-matrix (matrix element r c)
  "Inserta un elemento (numero o lista) en una CM en forma de array. Ojo, R y C de 0 a n-1"
  (let((cont))
    (setf cont (aref matrix r c))
    (cond ((and(atom element)(listp cont))(progn(setf cont (flat(list element cont)))(sort cont #'<)))
          ((and(atom element)(atom cont))(progn(setf cont (flat(list element cont)))(sort cont #'<)))
          ((listp element) (progn(setf cont (flat(list cont element)))(sort cont #'<))))
    (setf (aref matrix r c) cont)
    matrix))
  
(defun remove-from-matrix (matrix element r c)
  "Quita un elemento (numero o lista) de una CM en forma de array. Ojo, R y C de 0 a n-1"
  (let((cont)(temp nil))
    (setf cont (aref matrix r c))
    (cond ((and(atom element)(listp cont))(setf cont (remove element cont)))
          ((and(atom element)(atom cont))(setf cont nil))
          ((listp element) (dolist (e element temp)(setf cont (remove e cont)))))
    (setf (aref matrix r c) cont)
    matrix))

(defun cm-density (cm_array)
  "calcula la densidad de las posiciones de una CM en forma de array. Devuelve una matriz de densidad"
  (let((matres))
    (setf matres (make-array (list (array-dimension cm_array 0)(array-dimension cm_array 1)) :initial-element 0))
  
    (loop for j from 0 to (1- (array-dimension cm_array 0)) do
      (loop for i from 0 to (1- (array-dimension cm_array 1)) do
        (cond((numberp (aref cm_array j i))(setf (aref matres j i) 1))
             ((equal (aref cm_array j i) nil)(setf (aref matres j i) 0))
             ((listp (aref cm_array j i))(setf (aref matres j i) (length (aref cm_array j i)))))))
  matres))

(defun max-density (matdens)
  "Calcula la densidad maxima de todas las posiciones de una CM"
  (let((maxi 0)(temp 0))
    (setf matdens (mat2list matdens))
    (dolist (e matdens maxi)
      (cond((listp e)(setf temp (maximo e)))
           ((numberp e)(setf temp 1)))
      (if(> temp maxi)(setf maxi temp)))))

(defun sort-hi-density (pcpos matdens maxdens)
  "Ordena una lista de posiciones de un mismo PC segun densidad decreciente"
  (let((result nil)(cc))
    (dotimes (c (1+ maxdens) result)
      (setf cc (- maxdens c))
        (dolist (p pcpos result)
          (if (equal cc (aref matdens (first p) (second p)))(push p result))))
    (reverse result)))


(defun search-pc (cm_array pc)
  "Busca un pc dentro de una CM en forma de array y devuelve lista con listas de subindices de la posicion de cada pc encontrado"
  (let((result nil))
    (loop for j from 0 to (1- (array-dimension cm_array 0)) do
      (loop for i from 0 to (1- (array-dimension cm_array 1)) do
        (cond((numberp (aref cm_array j i))(if(equal pc (aref cm_array j i))(push (list j i) result)))
             ((listp (aref cm_array j i))(dolist (p (aref cm_array j i)) (if(equal pc p)(push (list j i) result)))))
      )
    )
    (reverse result)))

(defun flat (struct)
  "Elimina parentesis y NILs y genera una unica lista"
  (cond ((null struct) nil)
        ((atom struct) `(,struct))
        (t (mapcan #'flat struct))))

(defun list2sym (lista)
 "Convierte una lista simple en un simbolo"
       (let ( (a-string "" ) (start 0) (end (1- (length lista))))
       (do ((i start (+ i 1)))
           ((> i end) a-string)
         (setf a-string (concatenate 'string  a-string (princ-to-string (number2AB (nth i lista))))))
       (make-symbol a-string)))


(defun number2AB (data)
"Reemplaza 10 y 11 por A y B, respectivamente."
(let ((result nil))
(if (listp data)
    (dolist (e data (reverse result))
      (cond ((equal e 10) (push 'A result))
            ((equal e 11) (push 'B result))
            (t (push e result))))
  (cond ((equal data 10) 'A)
        ((equal data 11) 'B)
        (t data)))))




;--------------------------------------------------------------------
;--------------------------------------------------------------------