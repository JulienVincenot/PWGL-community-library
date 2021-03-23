(in-package MC)

;;;hack for package problem FROM MORPHOLOGIE;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ptrn-smooth (list)
  "It returns the list LIST without local repetitions.
	     For example : list equal to (a a b c a b b c d c c)
	     it reurns (a b c a b c d c))"
  (let ((l nil))
    (loop for x from 0 to (1- (length list))
       do (when (not (equal (nth (+ x 1) list) (nth x list)))
	    (push (nth x list) l)))
    (reverse l)))


(defun sig (x) (cond ((= 0 x) 0) ((plusp x) 1) (t -1)))

(defun dx (list)
  (let ((r 'nil))
    (dotimes (n (1- (length list)) (reverse r))
      (push (- (nth (1+ n) list) (nth n list)) r))))

(defun derivees-locales (list) (mapcar #'sig (dx list)))

(defun match-prim (list)
  (let ((new-list (ptrn-smooth list)))
    (cond ((or (equalp (list 1 0 -1) new-list) (equalp (list 1 -1) new-list))
	   "max")
	  ((or (equalp (list -1 0 1) new-list) (equalp (list -1 1) new-list))
	   "min")
	  ((equalp (list -1 0 -1) new-list) "flex")
	  ((equalp (list 1 0 1) new-list) "flex")
	  ((equalp (list 0 -1 0) new-list) "sig-")
	  ((equalp (list 0 1 0) new-list) "sig+")
	  (t nil))))

(defun find-primitives (list)
  (let ((derivees (derivees-locales list)) (r 'nil))
    (loop for i from 0
       until (> (+ 2 i) (length derivees))
       do (let ((seq 'nil))
	    (loop for j from 0 to (- (length derivees) i 1)
	       until (stringp (match-prim seq))
	       do (setf seq (append seq (list (nth (+ i j) derivees))))
	       finally (return (push (list
				      i
				      (+ i (1- j))
				      (match-prim seq))
				     r)))))
    (setf r
	  (mapcar #'(lambda (x)
		      (list (third x)
			    (second x)
			    (abs (- (car x) (cadr x)))))
		  (remove nil r :key #'third)))
    (reverse (remove-duplicates r :key #'cadr))))

;;;end from morphologie;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun remove-first-dup (seq)
  "Removes initial duplicat values from a list. Duplicates inside a list are unaffected."
  (let ((pos
         (loop for n from 0 to (1- (length seq))
               when (/= (nth n seq) (first seq))
               return (1- n))))
    (if pos (nthcdr pos seq)
      (last seq))
    ))


(defun filter-sig (list)
  (remove nil (mapcar #'(lambda (x) (if (or (equal (first x) "sig-")
                                            (equal (first x) "sig+"))
                                        nil
                                      x))
                      list)))


(defun format-vals-rule (layers vals)
  (if (not (typep layers 'list)) (setf layers (list layers)))
  (loop for n from 0 to (1- (length layers))
        collect (let ((layer (nth n layers)))
                  #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                                           (let ((pitch-seq (get-pitches-upto-index layer indexx)))
                                             (test-vals pitch-seq vals))
                                         t)))))



(defun test-vals (seq vals-in)
  "If the sequence of primitives are of different lengths, the shortest will be checked. After
this point, the function does not test anything. Prim-max-length is the maximum length of any prim 
segment, also after the given sequence prim is tested.
"
  (let* ((vals (filter-sig vals-in))
         (this-seq-primitives (filter-sig (find-primitives seq)))
         (this-seq-vals (mapcar #'(lambda (p) (list (first p) (nth (second p) seq) (third p)))
                                this-seq-primitives))
         (this-seq-last-prim-pos (if this-seq-primitives 
                                     (second (car (last this-seq-primitives)))
                                   0)) ;0 for 1st vals
         (endptr (min (1- (length this-seq-vals)) (1- (length vals)))))
    
    (if (> (length seq) 1)  
        (eval (append '(and)
                      (loop for n from 0 to endptr
                            collect (equal (nth n this-seq-vals) (nth n vals)))
                      (list
                       (if (nth (1+ endptr) vals)
                           (let* ((reverse-seq (reverse seq))
                                  (last-dx (- (first reverse-seq) (second reverse-seq)))
                                  (next-prim-length (third (nth (1+ endptr) vals)))
                                  (next-pitch (second (nth (1+ endptr) vals))))
                             (or (>= (length this-seq-vals) (length vals))
                                 (and (or (<= (1- (- (length seq) this-seq-last-prim-pos)) next-prim-length)
                                          (and (not this-seq-vals) (<= (1- (length (remove-first-dup seq))) next-prim-length)));special case first value repeated
                                      (cond 
                                       ((equal (first (nth (1+ endptr) vals)) "max") 
                                        (or (and (<= (first reverse-seq) next-pitch)
                                                 (plusp last-dx)) 
                                            (and (= 0 last-dx) (= (first reverse-seq) next-pitch))
                                            (and (= 0 last-dx) (not this-seq-vals) (= (first reverse-seq) (first seq)))));or equal if first in sequencwe
                                       ((equal (first (nth (1+ endptr) vals)) "min") 
                                        (or (and (>= (first reverse-seq) next-pitch)
                                                 (minusp last-dx))
                                            (and (= 0 last-dx) (= (first reverse-seq) next-pitch))
                                            (and (= 0 last-dx) (not this-seq-vals) (= (first reverse-seq) (first seq)))));or equal if first in sequencwe

                                       (t (if (/= endptr -1)
                                              (cond
                                               ((equal (first (nth endptr vals)) "max") 
                                                (>= (first reverse-seq) next-pitch)) 
                                               ((equal (first (nth endptr vals)) "min") 
                                                (<= (first reverse-seq) next-pitch)) 
                                               (t (if (/= endptr 0)
                                                      (cond
                                                       ((equal (first (nth (1- endptr) vals)) "max") 
                                                        (>= (first reverse-seq) next-pitch)) 
                                                       ((equal (first (nth (1- endptr) vals)) "min") 
                                                        (<= (first reverse-seq) next-pitch))
                                                       (t t))
                                                    (if (nth (+ 2 endptr) vals) ; if 2 flex in a row and first value is flex, check next instead
                                                        (cond
                                                         ((equal (first (nth (+ 2 endptr) vals)) "max") 
                                                          (<= (first reverse-seq) next-pitch)) ;;;
                                                         ((equal (first (nth (+ 2 endptr) vals)) "min") 
                                                          (>= (first reverse-seq) next-pitch)) ;;;
                                                         (t t))
                                                      t)))) 
                                            (if (nth (+ 2 endptr) vals) ; if first vals is flex
                                                (cond
                                                 ((equal (first (nth (+ 2 endptr) vals)) "max") 
                                                  (<= (first reverse-seq) next-pitch)) ;;;
                                                 ((equal (first (nth (+ 2 endptr) vals)) "min") 
                                                  (>= (first reverse-seq) next-pitch)) ;;;
                                                 (t (if (nth (+ 3 endptr) vals)
                                                        (cond
                                                         ((equal (first (nth (+ 3 endptr) vals)) "max") 
                                                          (<= (first reverse-seq) next-pitch)) ;;;
                                                         ((equal (first (nth (+ 3 endptr) vals)) "min") 
                                                          (>= (first reverse-seq) next-pitch)) ;;;
                                                         (t t))
                                                      t)))
                                              t)))) 
                                      )))
                         t))
                      ))

      ;;special case first value in seq
      (cond
       ((equal (first (first vals)) "max") 
        (< (first seq) (second (first vals)))) 
       ((equal (first (first vals)) "min") 
        (> (first seq) (second (first vals)))) 
       (t (if (second vals)
              (cond
               ((equal (first (second vals)) "max") 
                (< (first seq) (second (first vals)))) ;;;
               ((equal (first (second vals)) "min") 
                (> (first seq) (second (first vals)))) ;;;
               (t (if (third vals)
                      (cond
                       ((equal (first (third vals)) "max") 
                        (< (first seq) (second (first vals)))) ;;;
                       ((equal (first (third vals)) "min") 
                        (> (first seq) (second (first vals)))) ;;;
                       (t t))
                    t)))
               t))))
    ))

(defun vals-remove-value (vals)
  (loop for x in vals
        collect (list (first x) (third x))))


(defun format-vals-no-values-rule (layers vals)
  (if (not (typep layers 'list)) (setf layers (list layers)))
  (loop for n from 0 to (1- (length layers))
        collect (let ((layer (nth n layers)))
                  #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                                           (let ((pitch-seq (get-pitches-upto-index layer indexx)))
                                             (test-vals-no-values pitch-seq (vals-remove-value (filter-sig vals))))
                                         t)))))


(defun test-vals-no-values (seq vals-no-values)
  "If the sequence of primitives are of different lengths, the shortest will be checked. After
this point, the function does not test anything. Prim-max-length is the maximum length of any prim 
segment, also after the given sequence prim is tested.
"
  (let* ((this-seq-primitives (filter-sig (find-primitives seq)))
         (this-seq-vals-no-values (mapcar #'(lambda (p) (list (first p) (third p)))
                                this-seq-primitives))
         (this-seq-last-prim-pos (if this-seq-primitives 
                                     (second (car (last this-seq-primitives)))
                                   0)) ;0 for 1st vals
         (endptr (min (1- (length this-seq-vals-no-values)) (1- (length vals-no-values)))))
    
    (if (> (length seq) 1)  
        (eval (append '(and)
                      (loop for n from 0 to endptr
                            collect (equal (nth n this-seq-vals-no-values) (nth n vals-no-values)))

                      (list
                       (if (nth (1+ endptr) vals-no-values)
                           (let* ((reverse-seq (reverse seq))
                                  (last-dx (- (first reverse-seq) (second reverse-seq)))
                                  (next-prim-length (second (nth (1+ endptr) vals-no-values)))
                                  )
                             (or (>= (length this-seq-vals-no-values) (length vals-no-values))
                                 (and (or (<= (1- (- (length seq) this-seq-last-prim-pos)) next-prim-length)
                                          (and (not this-seq-vals-no-values) (<= (1- (length (remove-first-dup seq))) next-prim-length)));special case first value repeated
                                      (cond 
                                       ((equal (first (nth (1+ endptr) vals-no-values)) "max") 
                                        (or (and 
                                                 (plusp last-dx)) 
                                            (and (= 0 last-dx) (> (first reverse-seq) (nth this-seq-last-prim-pos seq)))
                                            (and (= 0 last-dx) (not this-seq-vals-no-values) (= (first reverse-seq) (first seq)))));or equal if first in sequence
                                       ((equal (first (nth (1+ endptr) vals-no-values)) "min") 
                                        (or (and 
                                                 (minusp last-dx))
                                            (and (= 0 last-dx) (< (first reverse-seq) (nth this-seq-last-prim-pos seq)))
                                            (and (= 0 last-dx) (not this-seq-vals-no-values) (= (first reverse-seq) (first seq)))));or equal if first in sequence
                                       (t (if (/= endptr -1)
                                              (cond
                                               ((equal (first (nth endptr vals-no-values)) "max") 
                                                (>= 0 last-dx)) ;ok
                                               ((equal (first (nth endptr vals-no-values)) "min") 
                                                (<= 0 last-dx)) ;ok
                                                (t (if (/= endptr 0)
                                                      (cond
                                                       ((equal (first (nth (1- endptr) vals-no-values)) "max") 
                                                        (>= 0 last-dx)) ;ok
                                                       ((equal (first (nth (1- endptr) vals-no-values)) "min") 
                                                        (<= 0 last-dx)) ;ok
                                                       (t t))

                                                    (if (nth (+ 2 endptr) vals-no-values) ; if 2 flex in a row and first value is flex, check next instead
                                                        (cond
                                                         ((equal (first (nth (+ 2 endptr) vals-no-values)) "max") 
                                                          (<= 0 last-dx)) ;;;
                                                         ((equal (first (nth (+ 2 endptr) vals-no-values)) "min") 
                                                          (>= 0 last-dx)) ;;;
                                                         (t t))
                                                      t)))) 
                                            (if (nth (+ 2 endptr) vals-no-values) ; if first vals is flex
                                                (cond
                                                 ((equal (first (nth (+ 2 endptr) vals-no-values)) "max") 
                                                  (<= 0 last-dx)) ;;;
                                                 ((equal (first (nth (+ 2 endptr) vals-no-values)) "min") 
                                                  (>= 0 last-dx)) ;;;
                                                 (t (if (nth (+ 3 endptr) vals-no-values)
                                                        (cond
                                                         ((equal (first (nth (+ 3 endptr) vals-no-values)) "max") 
                                                          (<= 0 last-dx)) ;;;
                                                         ((equal (first (nth (+ 3 endptr) vals-no-values)) "min") 
                                                          (>= 0 last-dx)) ;;;
                                                         (t t))
                                                      t)))
                                              t)))) 
                                      )))
                         t))
                      ))

      ;;special case first value in seq
      t)
    ))



;;;;;;

(defun vals-remove-length (vals)
  (loop for x in vals
        collect (list (first x) (second x))))

(defun test-vals-no-length (seq vals-no-length max-length)
  "If the sequence of primitives are of different lengths, the shortest will be checked. After
this point, the function does not test anything. Prim-max-length is the maximum length of any prim 
segment, also after the given sequence prim is tested.
"
  (let* ((this-seq-primitives (filter-sig (find-primitives seq)))
         (this-seq-vals-no-length (mapcar #'(lambda (p) (list (first p) (nth (second p) seq)))
                                this-seq-primitives))
         (this-seq-last-prim-pos (if this-seq-primitives 
                                     (second (car (last this-seq-primitives)))
                                   0)) ;0 for 1st vals
         (endptr (min (1- (length this-seq-vals-no-length)) (1- (length vals-no-length)))))
    
    (if (> (length seq) 1)  
        (eval (append '(and)
                      (loop for n from 0 to endptr
                            collect (equal (nth n this-seq-vals-no-length) (nth n vals-no-length)))
                      (list
                       (if (nth (1+ endptr) vals-no-length)
                           (let* ((reverse-seq (reverse seq))
                                  (last-dx (- (first reverse-seq) (second reverse-seq)))
                                  (next-prim-length max-length)
                                  (next-pitch (second (nth (1+ endptr) vals-no-length))))
                             (or (>= (length this-seq-vals-no-length) (length vals-no-length))
                                 (and (or (<= (1- (- (length seq) this-seq-last-prim-pos)) next-prim-length)
                                          (and (not this-seq-vals-no-length) (<= (1- (length (remove-first-dup seq))) next-prim-length)));special case first value repeated
                                      (cond 
                                       ((equal (first (nth (1+ endptr) vals-no-length)) "max") 
                                        (or (and (<= (first reverse-seq) next-pitch)
                                                 (plusp last-dx)) 
                                            (and (= 0 last-dx) (= (first reverse-seq) next-pitch))
                                            (and (= 0 last-dx) (not this-seq-vals-no-length) (= (first reverse-seq) (first seq)))));or equal if first in sequencwe
                                       ((equal (first (nth (1+ endptr) vals-no-length)) "min") 
                                        (or (and (>= (first reverse-seq) next-pitch)
                                                 (minusp last-dx))
                                            (and (= 0 last-dx) (= (first reverse-seq) next-pitch))
                                            (and (= 0 last-dx) (not this-seq-vals-no-length) (= (first reverse-seq) (first seq)))));or equal if first in sequencwe

                                       (t (if (/= endptr -1)
                                              (cond
                                               ((equal (first (nth endptr vals-no-length)) "max") 
                                                (>= (first reverse-seq) next-pitch)) 
                                               ((equal (first (nth endptr vals-no-length)) "min") 
                                                (<= (first reverse-seq) next-pitch)) 
                                               (t (if (/= endptr 0)
                                                      (cond
                                                       ((equal (first (nth (1- endptr) vals-no-length)) "max") 
                                                        (>= (first reverse-seq) next-pitch)) 
                                                       ((equal (first (nth (1- endptr) vals-no-length)) "min") 
                                                        (<= (first reverse-seq) next-pitch))
                                                       (t t))
                                                    (if (nth (+ 2 endptr) vals-no-length) ; if 2 flex in a row and first value is flex, check next instead
                                                        (cond
                                                         ((equal (first (nth (+ 2 endptr) vals-no-length)) "max") 
                                                          (<= (first reverse-seq) next-pitch)) ;;;
                                                         ((equal (first (nth (+ 2 endptr) vals-no-length)) "min") 
                                                          (>= (first reverse-seq) next-pitch)) ;;;
                                                         (t t))
                                                      t)))) 
                                            (if (nth (+ 2 endptr) vals-no-length) ; if first vals is flex
                                                (cond
                                                 ((equal (first (nth (+ 2 endptr) vals-no-length)) "max") 
                                                  (<= (first reverse-seq) next-pitch)) ;;;
                                                 ((equal (first (nth (+ 2 endptr) vals-no-length)) "min") 
                                                  (>= (first reverse-seq) next-pitch)) ;;;
                                                 (t (if (nth (+ 3 endptr) vals-no-length)
                                                        (cond
                                                         ((equal (first (nth (+ 3 endptr) vals-no-length)) "max") 
                                                          (<= (first reverse-seq) next-pitch)) ;;;
                                                         ((equal (first (nth (+ 3 endptr) vals-no-length)) "min") 
                                                          (>= (first reverse-seq) next-pitch)) ;;;
                                                         (t t))
                                                      t)))
                                              t)))) 
                                      )))
                         t))
                      ))

      ;;special case first value in seq
      (cond
       ((equal (first (first vals-no-length)) "max") 
        (< (first seq) (second (first vals-no-length)))) 
       ((equal (first (first vals-no-length)) "min") 
        (> (first seq) (second (first vals-no-length)))) 
       (t (if (second vals-no-length)
              (cond
               ((equal (first (second vals-no-length)) "max") 
                (< (first seq) (second (first vals-no-length)))) ;;;
               ((equal (first (second vals-no-length)) "min") 
                (> (first seq) (second (first vals-no-length)))) ;;;
               (t (if (third vals-no-length)
                      (cond
                       ((equal (first (third vals-no-length)) "max") 
                        (< (first seq) (second (first vals-no-length)))) ;;;
                       ((equal (first (third vals-no-length)) "min") 
                        (> (first seq) (second (first vals-no-length)))) ;;;
                       (t t))
                    t)))
               t))))
    ))


(defun format-vals-no-length-rule (layers vals max-length)
  (if (not (typep layers 'list)) (setf layers (list layers)))
  (loop for n from 0 to (1- (length layers))
        collect (let ((layer (nth n layers)))
                  #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                                           (let ((pitch-seq (get-pitches-upto-index layer indexx)))
                                             (test-vals-no-length pitch-seq (vals-remove-length (filter-sig vals)) max-length))
                                         t)))))


;;;;;

(defun vals-to-prim  (vals)
  (loop for x in vals
        collect (list (first x))))

(defun test-prim (seq prim max-length)
  "If the sequence of primitives are of different lengths, the shortest will be checked. After
this point, the function does not test anything. Prim-max-length is the maximum length of any prim 
segment, also after the given sequence prim is tested.
"
  (let* ((this-seq-primitives (filter-sig (find-primitives seq)))
         (this-seq-prim (mapcar #'(lambda (p) (list (first p)))
                                this-seq-primitives))
         (this-seq-last-prim-pos (if this-seq-primitives 
                                     (second (car (last this-seq-primitives)))
                                   0)) ;0 for 1st prim
         (endptr (min (1- (length this-seq-prim)) (1- (length prim)))))
    
    (if (> (length seq) 1)  
        (eval (append '(and)
                      (loop for n from 0 to endptr
                            collect (equal (nth n this-seq-prim) (nth n prim)))

                      (list
                       (if (nth (1+ endptr) prim)
                           (let* ((reverse-seq (reverse seq))
                                  (last-dx (- (first reverse-seq) (second reverse-seq)))
                                  (next-prim-length max-length)
                                  )


                             (or (>= (length this-seq-prim) (length prim))
                                 (and (or (<= (1- (- (length seq) this-seq-last-prim-pos)) next-prim-length)
                                          (and (not this-seq-prim) (<= (1- (length (remove-first-dup seq))) next-prim-length)));special case first value repeated
                                      (cond 
                                       ((equal (first (nth (1+ endptr) prim)) "max") 
                                        (or (and (plusp last-dx)) 
                                            (and (= 0 last-dx) (> (first reverse-seq) (nth this-seq-last-prim-pos seq)))
                                            (and (= 0 last-dx) (not this-seq-prim) (= (first reverse-seq) (first seq)))));or equal if first in sequence
                                       ((equal (first (nth (1+ endptr) prim)) "min") 
                                        (or (and (minusp last-dx))
                                            (and (= 0 last-dx) (< (first reverse-seq) (nth this-seq-last-prim-pos seq)))
                                            (and (= 0 last-dx) (not this-seq-prim) (= (first reverse-seq) (first seq)))));or equal if first in sequence
                                       (t (if (/= endptr -1)
                                              (cond
                                               ((equal (first (nth endptr prim)) "max") 
                                                (>= 0 last-dx)) ;ok
                                               ((equal (first (nth endptr prim)) "min") 
                                                (<= 0 last-dx)) ;ok
                                                (t (if (/= endptr 0)
                                                      (cond
                                                       ((equal (first (nth (1- endptr) prim)) "max") 
                                                        (>= 0 last-dx)) ;ok
                                                       ((equal (first (nth (1- endptr) prim)) "min") 
                                                        (<= 0 last-dx)) ;ok
                                                       (t t))

                                                    (if (nth (+ 2 endptr) prim) ; if 2 flex in a row and first value is flex, check next instead
                                                        (cond
                                                         ((equal (first (nth (+ 2 endptr) prim)) "max") 
                                                          (<= 0 last-dx)) ;;;
                                                         ((equal (first (nth (+ 2 endptr) prim)) "min") 
                                                          (>= 0 last-dx)) ;;;
                                                         (t t))
                                                      t)))) 
                                            (if (nth (+ 2 endptr) prim) ; if first vals is flex
                                                (cond
                                                 ((equal (first (nth (+ 2 endptr) prim)) "max") 
                                                  (<= 0 last-dx)) ;;;
                                                 ((equal (first (nth (+ 2 endptr) prim)) "min") 
                                                  (>= 0 last-dx)) ;;;
                                                 (t (if (nth (+ 3 endptr) prim)
                                                        (cond
                                                         ((equal (first (nth (+ 3 endptr) prim)) "max") 
                                                          (<= 0 last-dx)) ;;;
                                                         ((equal (first (nth (+ 3 endptr) prim)) "min") 
                                                          (>= 0 last-dx)) ;;;
                                                         (t t))
                                                      t)))
                                              t)))) 
                                      )))
                         t))
                      ))

      ;;special case first value in seq
      t)
    ))


(defun format-prim-rule (layers vals max-length)
  (if (not (typep layers 'list)) (setf layers (list layers)))
  (loop for n from 0 to (1- (length layers))
        collect (let ((layer (nth n layers)))
                  #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                                           (let ((pitch-seq (get-pitches-upto-index layer indexx)))
                                             (test-prim pitch-seq (vals-to-prim (filter-sig vals)) max-length))
                                         t)))))