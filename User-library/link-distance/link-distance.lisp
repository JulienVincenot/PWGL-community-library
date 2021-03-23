(in-package #:link-distance)

;; (declaim (optimize (speed 3) (safety 1) (debug 0)))

;;;; * Non screamer part

(defun find-closest (x list)
  "Finds elt in LIST that is closest to X. Returns distance and index
  as a second value."
  (iter
    (for y in list)
    (for i upfrom 0)
    (for distance = (abs (- x y)))
    (finding (list distance i) minimizing distance into res)
    (finally (return (values-list res)))))

(defun link-distance (chord-a chord-b)
  (let (links)
    (labels ((make-link (a b distance kind)
               (push (list a b distance kind) links))
             (linked-p (index chord-index)
               (iter
                 (for (index-a index-b distance) in links)
                 (for relevant-index = (if (zerop chord-index) index-a index-b))
                 (thereis (= index relevant-index)))))
      (iter
        (for a in chord-a)
        (for index-a upfrom 0)
        (alexandria:when-let (index-b (position a chord-b))
          (make-link index-a index-b 0 :equal)))
      (iter
        (for a in chord-a)
        (for index-a upfrom 0)
        (unless (linked-p index-a 0)
          (multiple-value-bind (distance index-b)
              (find-closest a chord-b)
            (make-link index-a index-b distance :link-a))))
      (iter
        (for b in chord-b)
        (for index-b upfrom 0)
        (unless (linked-p index-b 1)
          (multiple-value-bind (distance index-a)
              (find-closest b chord-a)
            (make-link index-a index-b distance :link-b))))
      (values (iter
                (for (index-a index-b distance) in links)
                (summing distance)) links))))

(defun link-distance* (&rest args)
  "ARGS is #a {a}+ #b {b}+"
  (let* ((num-a (first args))
         (a (subseq args 1 (+ 1 num-a)))
         (b (subseq args (+ 2 num-a))))
    (link-distance a b)))

;;;; * Screamer part
(defun solution-default (vars)
  (solution vars (static-ordering #'linear-force)))

(defun estimate-maximum-link-distance (min-a max-a min-b max-b num-a num-b)
  (max
   (link-distance (make-list num-a :initial-element (if (bound? min-a) (value-of min-a) (screamer::variable-lower-bound min-a)))
                  (make-list num-b :initial-element (if (bound? max-b) (value-of max-b) (screamer::variable-upper-bound max-b))))
   (link-distance (make-list num-a :initial-element (if (bound? max-a) (value-of max-a) (screamer::variable-upper-bound max-a)))
                  (make-list num-b :initial-element (if (bound? min-b) (value-of min-b) (screamer::variable-lower-bound min-b))))))

(defun estimate-minimum-link-distance (min-a max-a min-b max-b num-a num-b)
  min-a max-a min-b max-b num-a num-b
  0)

(defun restrict-link-distance! (dist min-a max-a min-b max-b num-a num-b)
  (let ((min (estimate-minimum-link-distance min-a max-a min-b max-b num-a num-b))
        (max (estimate-maximum-link-distance min-a max-a min-b max-b num-a num-b)))
    (assert! (<=v min dist))
    (assert! (<=v dist max))))

(defun link-distance-v (chord-a chord-b)
  (cond
    ((and (every #'bound? chord-a)
          (every #'bound? chord-b))
     (link-distance chord-a chord-b))
    (t (let* ((chord-a (mapcar #'screamer::variablize chord-a))
              (chord-b (mapcar #'screamer::variablize chord-b))
              (min-a (apply #'minv chord-a))
              (max-a (apply #'maxv chord-a))
              (min-b (apply #'minv chord-b))
              (max-b (apply #'maxv chord-b))
              (dist (an-integer-abovev 0 :link-distance))
              (num-a (length chord-a))
              (num-b (length chord-b))
              (lambda (lambda ()
                        (restrict-link-distance! dist min-a max-a min-b max-b num-a num-b))))
         (screamer::attach-noticer! lambda min-a)
         (screamer::attach-noticer! lambda max-a)
         (screamer::attach-noticer! lambda min-b)
         (screamer::attach-noticer! lambda max-b)
         (assert! (=v dist (applyv #'link-distance* (append (list (length chord-a))
                                                            chord-a
                                                            (list (length chord-b))
                                                            chord-b))))
         dist))))

(defun collect-min-max (solutions)
  (let* ((var-num (length (first solutions)))
         (mins (make-array var-num :initial-contents (first solutions)))
         (maxs (make-array var-num :initial-contents (first solutions))))
    (iter
      (for solution in (rest solutions))
      (iter
        (for var in solution)
        (for i upfrom 0)
        (minf (aref mins i) var)
        (maxf (aref maxs i) var))
      (finally (return (iter
                         (for i from 0 below var-num)
                         (collect (list (aref mins i)
                                        (aref maxs i)))))))))

(defun mysolution (all-vars forced-vars force-function)
  "Will apply substitions in ALL-VARS, but only FORCED-VARS will be
passed to FORCE-FUNCTION."
  (screamer::funcall-nondeterministic
   (value-of force-function) (screamer::variables-in (value-of forced-vars)))
  (apply-substitution all-vars))

(defun propagate-bounds (vars &optional (forced-vars vars))
  (let ((solutions (all-values (mysolution vars forced-vars (static-ordering #'linear-force)))))
    (format t "; propagate-bounds: analyzing ~D solutions~%" (length solutions))
    (iter (for var in vars)
          (for (min max) in (collect-min-max solutions))
          (assert! (<=v min var))
          (assert! (<=v var max)))
    vars))

(defun sample-net ()
  (let ((vars (list (an-integer-betweenv 50 53)
                    (an-integer-betweenv 50 53))))
    (assert! (<v (first vars) (second vars)))
    vars))

(defun sample-net2 ()
  (let ((vars (list (an-integer-betweenv 50 53)
                    (an-integer-betweenv 50 53))))
    (assert! (funcallv (lambda (a b) (< a b)) (first vars) (second vars)))
    vars))

(defun sample-net3 (&optional (chord2-min 60) (chord2-max 67))
  (let ((chord1 (list 60 63 67))
        (chord2 (iter
                  (repeat 3)
                  (collect (an-integer-betweenv chord2-min chord2-max))))
        (link-distance (an-integer-abovev 0)))
    (assert! (=v link-distance (applyv #'link-distance* (append (list (length chord1))
                                                                chord1
                                                                (list (length chord2))
                                                                chord2))))
    (append chord1 chord2 (list link-distance))))

(defun sample-net4 ()
  (let ((vars (sample-net3 50 80)))
    (assert! (<v (last-elt vars) 6))
    vars))

(defun maximum-link-distance (number-of-notes ambitus
                              &optional (chords-sorted-p nil)
                              (chords-set-p nil))
  (let ((chord1 (iter
                  (repeat number-of-notes)
                  (collect (an-integer-betweenv 0 ambitus))))
        (chord2 (iter
                  (repeat number-of-notes)
                  (collect (an-integer-betweenv 0 ambitus))))
        (link-distance (an-integer-abovev 0)))
    (when chords-sorted-p
      (assert! (apply #'<v chord1))
      (assert! (apply #'<v chord2)))
    (when chords-set-p
      (assert! (setpv chord1))
      (assert! (setpv chord2)))
    (assert! (=v link-distance (applyv #'link-distance* (append (list (length chord1))
                                                                chord1
                                                                (list (length chord2))
                                                                chord2))))
    (screamer::variable-upper-bound
     (last-elt (propagate-bounds (append chord1 chord2 (list link-distance))
                                 (append chord1 chord2))))))

(defun setpv (list)
  (let ((res t))
    (map-combinations (lambda (args)
                        (destructuring-bind (a b) args
                          (setq res (andv res (/=v a b)))))
                      list :length 2)
    res))

(defun sorted-chord (number-of-notes min max)
  (let ((notes (iter (repeat number-of-notes) (collect (an-integer-betweenv min max :pitch)))))
    (assert! (apply #'<v notes))
    notes))

(defun solutions-for-link-distance (number-of-notes ambitus link-distance
                                    &optional (chords-sorted-p nil)
                                    (chords-set-p nil))
  (let ((chord1 (iter
                  (repeat number-of-notes)
                  (collect (an-integer-betweenv 0 ambitus))))
        (chord2 (iter
                  (repeat number-of-notes)
                  (collect (an-integer-betweenv 0 ambitus)))))
    (when chords-sorted-p
      (assert! (apply #'<v chord1))
      (assert! (apply #'<v chord2)))
    (when chords-set-p
      (assert! (setpv chord1))
      (assert! (setpv chord2)))
    (assert! (=v link-distance (applyv #'link-distance* (append (list (length chord1))
                                                                chord1
                                                                (list (length chord2))
                                                                chord2))))
    (all-values (solution (list chord1 chord2) (static-ordering #'linear-force)))))

(defun print-table ()
  (progn
    (princ
     (with-output-to-string (out)
       (iter
         (for number-of-notes from 1 to 6)
         (format out "------------------------------~%")
         (iter
           (for ambitus from 1 to 10)
           (format out "# ~D amb ~D: ~A~%"
                   number-of-notes ambitus (ignore-errors (maximum-link-distance number-of-notes ambitus t nil)))))))
    nil))

;; (propagate-bounds (sample-net3))

;; (let ((net (sample-net4)))
;;   (propagate-bounds net (butlast net)))


;; (link-distance '(0 1 2 3 4 5) (mapcar (lambda (x) (+ x 0)) '(0 1 2 3 4 5)))


;;;; * Tests

(defsuite* :link-distance-test)

(deftest link-distance.commutativity
  (for-all ((chord-a (gen-list :length (gen-integer :min 1 :max 10)
                               :elements (gen-integer :min 40 :max 80)))
            (chord-b (gen-list :length (gen-integer :min 1 :max 10)
                               :elements (gen-integer :min 40 :max 80))))
    (is (= (link-distance chord-a chord-b)
           (link-distance chord-b chord-a)))))

(deftest link-distance.identical-chords
  (for-all ((chord (gen-list :length (gen-integer :min 1 :max 10)
                             :elements (gen-integer :min 40 :max 80))))
    (is (zerop (link-distance chord chord)))))

;; (assert (run! :link-distance-test))
