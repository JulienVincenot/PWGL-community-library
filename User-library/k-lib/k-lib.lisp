(in-package :K-LIB)

(defun ed-vert (e mat-dist &optional (sorter #'<))
  (sort (loop for i in mat-dist when (member e (butlast i) :test #'equalp) collect i) sorter :key #'caddr))

(defun bor (mat-dist sorter)
  (remove-duplicates (loop for i from 0 to (reduce #'max (mapcar #'(lambda (x) (apply #'max (butlast x))) mat-dist)) collect (car (ed-vert i mat-dist sorter))) :test #'(lambda (a b) (equalp (butlast a) (butlast b)))))

(defun bmst (mt sorter &optional r s)
  (if (= 1 (length r)) s
    (let ((uf r)
          (ret s)
          (it (bor mt sorter))
          (mtt mt)) 
      (loop for i in it do  (unless (uf-connected i uf) (push i ret) (setf uf (union-find i uf))))
      (loop for k in it do (setf mtt (remove k mtt :test #'(lambda (a b) (equalp (butlast a) (butlast b))))))
      (bmst mtt sorter uf ret))))

(defun mean (lst)
  (float (/ (apply #'+ lst) (length lst))))

(defun std-deviation (lst)
  (sqrt (/ (apply #'+ (mapcar #'(lambda (x) (expt (- x (mean lst)) 2)) lst)) (length lst))))

(defgeneric dsd (a b))

(defmethod dsd ((a list) (b list))
  (assert (and (loop for i in a always (numberp i))
	       (loop for j in b always (numberp j))))
  (abs (- (std-deviation a) (std-deviation b))))

(defmethod dsd ((a list) (b null))
  (assert (loop for k in a always (listp k)))
  (let ((r (list)))
    (dotimes (i (length a) (nreverse r))
      (loop for j from (1+ i) to (1- (length a)) do
	 (push (list i j (dsd (nth i a) (nth j a))) r)))))
  
(defun get-max-expt (a lst)
  (apply #'max (loop for i in lst collect (length (loop for j in i when (= j a) collect j)))))

(defun ppcm-c (lst)
  (let* ((c (mapcar #'length (by-cycle::perm-cycl lst)))
         (cc (mapcar #'(lambda (x) (if (null x) '(1) x)) (loop for i in c collect (by-cycle::factor i))))
         (d (sort (remove-duplicates (pw::flat (copy-list cc))) #'<)))
    (apply #'* (mapcar #'* d (loop for i in d collect (get-max-expt i cc))))))
    
(defgeneric dpo (a b))

(defmethod dpo ((a list) (b list))
  (abs (- (ppcm-c a) (ppcm-c b))))

(defmethod dpo ((a list) (b null))
  (assert (loop for k in a always (listp k)))
  (let ((r (list)))
    (dotimes (i (length a) (nreverse r))
      (loop for j from (1+ i) to (1- (length a)) do
	 (push (list i j (dpo (nth i a) (nth j a))) r)))))

(defun subseq-thres (seq1 seq2 thres)
  "seq = (pw::dx->x 0 (pw::g-scaling/sum duration-list 1.0))"
  (remove nil (loop for i in seq1
		 collect (loop for j in seq2 when (<= (abs (- j i)) thres)
			    collect j))))

(defun filternoway (lst)
  (let ((r (list (car lst))))
    (loop for i in (cdr lst)
       do
	 (let ((tmp (member (caar r) i)))
	   (if tmp
	       (unless (null (cdr tmp)) 
                 (if (= (car (last tmp)) (car (last (car r))))
                     (let ((ir (butlast (car r))))
                       (setf r (cdr r)) 
                       (push ir r)
                       (push (cdr tmp) r))
                   (push (cdr tmp) r)))
             (push i r))))
    (reverse r)))

(defun prim (a)
  (if (zerop a) a (/ (abs a) a)))

;;================================================
;;                       DEFINE BOXES AND ADD MENU

(defclass k-box (ccl::PWGL-box) ())
(defmethod ccl::special-info-string ((self k-box)) "k-lib")
(ccl::write-key 'k-box :code-compile t)
(define-menu k-lib :print-name "k-lib")

(in-menu k-lib)

(define-box kruskal ((mat-dist nil) &optional (sort :min))
            "Built a minimal or maximal spanning tree using Kruskal's algorithm."
            :menu (sort (:min "minimal") (:max "maximal"))
            :non-generic t
            :class k-box
            (case sort
              (:min (k-lib::mst mat-dist #'sorter-third))
              (:max (k-lib::mst mat-dist #'rsorter-third))))

(define-box boruvka ((mat-dist) &optional (sort :min))
            "Built a minimal or maximal spanning tree using Boruvka's algorithm."
            :menu (sort (:min "minimal") (:max "maximal"))
            :non-generic t
            :class k-box
            (case sort
              (:min (k-lib::bmst mat-dist #'<))
              (:max (k-lib::bmst mat-dist #'>))))

(menu-separator)

(define-box differential-vector ((xs/l1 nil) (xs/l2 nil) (result :norm) (opt :mean) (thres 1) &optional (ended :last) (tolerance :no))
            "Returns in term of distance the normalized norm of the vector or its coordinates defined by:
x as percentage of the timing concordances according the three following options:
 - <opt :max> number of concordances divided by the maximal cardinal between the two sequences;
 - <opt :min> number of concordances divided by the minimal cardinal between the two sequences; 
 - <opt :mean> number of concordances divided by the average of cardinals of the two sequences,
and a threshold expressed in percentage that is to say a value between 0 and 100;
y as percentage of the profile resemblance relative to the events concordances defined in x. This is computed from the primitives of durations and in this way, the last primitive has to be set according the repetition of the last level <ended :last> -- that is to say primitive equal to zero --, or according a kind of cyclicity by the repetition of the first level <ended :first>.
The key tolerance concerns the primitive concordance as 1 = 0 and -1 = 0.
 
The input xs/l has to be a list of durations and its respective profile level as follow: 
((dur1 dur2 ... durn) (lev1 lev2 ...levn))
Note that each list of durations is scaled such as sum of durations is equal to 1"
            :menu (result (:norm "norm") (:coord "coord"))
            :menu (opt (:max "max") (:min "min") (:mean "mean"))
            :menu (ended (:first "first") (:last "last"))
            :menu (tolerance (:yes "yes") (:no "no"))
            :non-generic t
            :class k-box
(if (null xs/l2)
    (let ((r (list)))
      (dotimes (i (length xs/l1) (nreverse r))
	(loop for j from (1+ i) to (1- (length xs/l1)) do
	     (push (list i j (differential-vector (nth i xs/l1) (nth j xs/l1) result opt thres ended tolerance)) r))))
    (let* ((l1 (list (pw::g-scaling (pw::dx->x 0 (car xs/l1)) 0 1.0) (append (cadr xs/l1) (case ended (:first (list (car (cadr xs/l1)))) (:last (last (cadr xs/l1)))))))
	   (l2 (list (pw::g-scaling (pw::dx->x 0 (car xs/l2)) 0 1.0) (append (cadr xs/l2) (case ended (:first (list (car (cadr xs/l2)))) (:last (last (cadr xs/l2)))))))
	   (lx1 (filternoway (subseq-thres (car l1) (car l2) (/ thres 100))))
	   (lx2 (filternoway (subseq-thres (car l2) (car l1) (/ thres 100))))
	   (p1 (mapcar #'(lambda (x) (mean (loop for i in x collect (cadr (assoc i (pw::mat-trans l2)))))) lx1))
	   (p2 (mapcar #'(lambda (x) (mean (loop for i in x collect (cadr (assoc i (pw::mat-trans l1)))))) lx2))
	   (seqsort (sort (list (car xs/l1) (car xs/l2)) #'< :key (lambda (p) (length p))))
	   (x (case opt
		(:min (float (/ (1- (length lx1)) (length (car seqsort)))))
		(:max (float (/ (1- (length lx1)) (length (cadr seqsort)))))
		(:mean (/ (1- (length lx1)) (mean (mapcar #'length seqsort))))))
	   (y (pw::g-average (mapcar #'(lambda (a b)
					 (case tolerance
					   (:no (if (= (prim a) (prim b)) 0 1))
					   (:yes (if (or (= 1 (abs (+ (prim a) (prim b)))) (= (prim a) (prim b))) 0 1))))
				     (pw::x->dx p1) (pw::x->dx p2)) 1.0)))
      (case result
	(:norm (/ (sqrt (+ (expt (- 1 x) 2) (expt y 2))) (sqrt 2)))
	(:coord (list (- 1 x) y))))))

(define-box dist-pcy-order ((seq1 nil) (seq2 nil))
            "Absolute value of the difference of the least common multique of the cardinal of the cycle decomposition of the permutation sigma of seq1 and seq2."
            :non-generic t
            :class k-box
            (dpo seq1 seq2))

(define-box dist-std-deviat ((seq1 nil) (seq2 nil))
            "Absolute value of the difference of standart deviation of seq1 and seq2."
            :non-generic t
            :class k-box
            (dsd seq1 seq2))

(install-menu k-lib)

;-------------------------------------------------

