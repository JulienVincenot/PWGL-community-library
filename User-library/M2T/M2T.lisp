(in-package :M2T)

(defvar *MODULO* nil)

(defun list->freq-weight (freq weight) (loop for i from 1 to (length weight) collect (list (/ freq i) (nth (1- i) weight))))

(defun list->mod-weight (chord-freq weight-list approx)
  (let ((tmp (pw::flat-once (loop for i in chord-freq for j in weight-list collect (list->freq-weight i j)))))
    (loop for n in tmp collect (cons (sys::g-mod (pw::approx-midi (pw::f->m (car n)) approx) *modulo*) (cdr n)))))  

(defun weight-sum (a lst)
  (reduce #'+ (loop for i in lst when (= (car i) a) collect (cadr i))))

(defun to-select (lst)
  (sort (loop for i in (remove-duplicates (pw::g-round (mapcar #'car lst) 3)) collect (list i (weight-sum i lst))) #'< :key #'car))

(defun match-midi (x lst &optional r)
  (loop for i in lst for j from 0 to (1- (length lst)) do (when (= i x) (push j r))) r)

(defun select-chord-notes (sort-list midi-list)
  (loop for i in sort-list when (member (car i) (sort (sys::g-mod midi-list *modulo*) #'<) :test #'equalp) collect i))

(defun add-midi-name (scn midi-chord)
  (loop for i in scn collect (cons (remove-duplicates (pw::posn-match midi-chord (match-midi (car i) (pw::g-round (sys::g-mod midi-chord *modulo*) 3)))) (cdr i))))

(defun conc-cdr (lst)
  (let ((tmp (car lst))	s)
    (loop for i in (cdr lst) do
	 (if (= (cadr i) (cadr tmp))
	     (setf tmp (list (append (car i) (car tmp)) (cadr i)))
	     (progn (push tmp s) (setf tmp i))))
    (cons tmp s)))

(PWGLdef sort-melody ((in nil) (freq-or-mid () (ccl::mk-menu-subview :menu-list '("freqs" "midi") :value 1)) (harm-weight-list nil) (approx-midi 2) &optional (modulo 12))
	 "Allows to prioritize the notes of a chord or a melody depending on their respective weighted harmonics."
	 (:groupings '(2 1 1))
	 (setf *modulo* modulo)
	 (let* ((chord-midi (if (equalp freq-or-mid (read-from-string "freqs")) (pw::approx-midi (pw::f->m in) approx-midi) in))
		(chord-freq (if (equalp freq-or-mid (read-from-string "freqs")) in (pw::m->f in)))
		(tmp (conc-cdr (sort (add-midi-name (select-chord-notes (to-select (list->mod-weight chord-freq harm-weight-list approx-midi)) chord-midi) chord-midi)  #'< :key #'cadr))))
	   (if (loop for i in (mapcar #'car tmp) always (= 1 (length i)))
	       (mapcar #'sys::flat tmp)
	       tmp)))

(PWGLdef harm-profile ((string nil) (n 5) (wind 10) &optional (fund nil))
	 "Allows to evaluate the profile of the weights of <n> harmonics according the first significative peak or according the <fund> frequency as optional argument. The evaluation consists to get the maximum power value inside a window length of <wind> percent (10% by default) of the fundamental frequency."
	 (:groupings '(1 1 1))
	 ;; isik http://stackoverflow.com/questions/745901
	 (labels ((string2list (string)
		    (with-input-from-string (s string)
		      (let ((r nil))
			(do (( line (read s nil 'eof)
				    (read s nil 'eof)))
			    ((eq line 'eof))
			  (push line r))
			(reverse r))))
		  (fact (f wind)
		    (/ (* f wind) 200)))
	   (let* ((tmp (nthcdr 2 (string2list string)))
		  (bw (car (last tmp)))
		  (pf (pw::g-max (butlast tmp)))
		  (f0 (if fund fund
			  (let ((f (* bw (position pf (butlast tmp))))
				(r nil))
			    ;(format t "Fmax = ~S Hz;" f)
			    (loop for i from 0 to 3 ;; three harmonics below f
			       when (and (> (/ f (expt 2 i)) 20) ;; do not search below 20 Hz
					 (> (pw::g-max (subseq (butlast tmp) (floor (/ (- (/ f (expt 2 i)) (fact (/ f (expt 2 i)) wind)) bw)) (ceiling (/ (+ (/ f (expt 2 i)) (fact (/ f (expt 2 i)) wind)) bw)))) (/ pf 2))) ;; power has to be significant.
			       do (push (* bw (position (pw::g-max (subseq (butlast tmp) (floor (/ (- (/ f (expt 2 i)) (fact (/ f (expt 2 i)) wind)) bw)) (ceiling (/ (+ (/ f (expt 2 i)) (fact (/ f (expt 2 i)) wind)) bw)))) (butlast tmp))) r))
			    (car r)))))
	     (format t "Fundamental = ~S Hz.~&" f0)
	     (loop for i from 1 to n collect (pw::g-max (subseq (butlast tmp) (floor (/ (- (* f0 i) (fact f0 wind)) bw)) (ceiling (/ (+ (* f0 i) (fact f0 wind)) bw))))))))   

(ccl::add-PWGL-user-menu 
 '(:menu-component
   ("M2T"
    ((harm-profile sort-melody morphologie::energy-prof-morph-analysis)))))
