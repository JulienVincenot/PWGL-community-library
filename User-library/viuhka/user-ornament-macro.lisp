(in-package :ccl)

(defparameter *user-viuhka-ornaments* ())

(defmacro mk-user-viuhka-ornament (keyword doc body) 
  `(progn 
     (when (member ,keyword *user-viuhka-ornaments* :key #'first)
       (setf *user-viuhka-ornaments* (remove ,keyword *user-viuhka-ornaments* :key #'first)))
     (setf *user-viuhka-ornaments* (append (list (list ,keyword ,doc)) *user-viuhka-ornaments*))
     (defmethod mk-user-ornament ((x (eql ,keyword)) time dur amp current-bpf other-bpfs &optional no rest)
       ,body)))

(defmethod mk-user-ornament ((x T) time dur amp current-bpf other-bpfs &optional no rest)
  (error  (format () "~A - unknown user ornament!" x)))

(mk-user-viuhka-ornament :octave "a two-note chord foming an octave"
  (let ((midi (bpf-out current-bpf time)))
               (mk-viuhka-chord time  (list (mk-ornament-note midi dur 0 amp 1 (mk-ornament-ins no rest))
                                            (mk-ornament-note (+ midi 12) dur 0 amp 1 (mk-ornament-ins no rest))))))

(mk-user-viuhka-ornament :chroma "a rapid upward one-octave scale"
                         (mk-viuhka-chord time 
                          (iterate (for m from 0 to 12)
                            (for offset from 0 to dur by 0.05)
                            (collect
                             (mk-ornament-note   (+ m (bpf-out current-bpf time)) dur offset amp 1
                                                 (mk-ornament-ins no rest))))))

#|
(mk-user-ornament :octave 0 1 100 (mk-bpf '(0 1) '(60 100))())
(mk-user-ornament :chroma 0 1 100 (mk-bpf '(0 1) '(60 100))())
(mk-user-ornament :xplr 0 1 100 (mk-bpf '(0 1) '(60 100))())
|#

(defun peek-bpfs (bpfs bpfindexes times ornaments artics amps ins-params &optional key-flags)
  "" 
  (setq bpfindexes (mk-circ-list bpfindexes))
  (setq ornaments (mk-circ-list ornaments))
  (setq artics (mk-circ-list artics))
  (setq amps (mk-circ-list amps))
  (let (chords curr-ornament v-chords)
    (dowhile (cdr times)
      (let ((index (pop-circ bpfindexes))
            (time (pop times))
            (next-time (car times)))
        ;;;  special Viuhka global variables ;;;;;;;;;;;;;;;;;;;;
        (setf cl-user::gtime time)
        (setf cl-user::viuhka-bpfs bpfs)
        ;;;
        (let ((current-bpf (current-bpf index bpfs time)) other-bpfs)
          (when (and current-bpf     ; if not rest
                     (if (atom  current-bpf)
                         (if (second (first (member :no-pitch-rept key-flags :key #'car))) ;; only flag and flag = t?
                             (if (and (numberp index) (> index 1))
                                 (if (= (bpf-out current-bpf time) ;;cl-user::mypitch
                                        (bpf-out (nth (1- index) bpfs) time)) ;;pitch read from "prev" bpf
                                     nil
                                   t)
                               t)
                           t)
                       T))
            (setq other-bpfs (remove current-bpf bpfs))
            ;;;  special Viuhka global variables ;;;;;;;;;;;;;;;;;;;;
            (setf cl-user::mybpf current-bpf)
            (when (atom current-bpf) (setf cl-user::mygrad (float (bpf-gradient current-bpf time))))
            ;; defined in scaler-time-box-interpol3 (setf cl-user::mytime-till-next-bp (- (pw::next-bp-time current-bpf time) time))
            (setf cl-user::myother-bpfs other-bpfs)
            ;;;  special Viuhka global variables ;;;;;;;;;;;;;;;;;;;;
            (let* ((dur (- next-time time))
                   (real-dur (calc-artic-value dur (give-timed-value (pop-circ artics) time)))
                   ins-params-values)
              (setf *cur-bpfindexes* bpfindexes)
              (setf *cur-bpfs* bpfs)
              ;;;  special Viuhka global variables ;;;;;;;;;;;;;;;;;;;;
              (setf cl-user::mydtime dur)
              (setf cl-user::mydur real-dur)
              (setf cl-user::myindex index) ; Added 15.10.96
              (setf cl-user::mypitch (if (listp current-bpf) (mapcar #'(lambda (bpf) (bpf-out bpf time)) current-bpf) (bpf-out current-bpf time)))
              (setf cl-user::mychord (mapcar #'(lambda (bf) (bpf-out bf time)) bpfs))
              ;;;
              (setq ins-params-values  (mapcar #'give-timed-value ins-params (pw::cirlist time))) ;;10.01.05
              (setf cl-user::mycsndparams ins-params-values) ;; ML 17.996
              (setq curr-ornament (pop-circ ornaments))
              (if (keywordp curr-ornament)
                  (push (list (mk-user-ornament curr-ornament
                                                time real-dur (give-timed-value (pop-circ amps) cl-user::gtime)
                                                current-bpf other-bpfs
                                                (ins-number ins-params-values)
                                                (ins-rest ins-params-values)))
                        chords)
                (if (symbolp curr-ornament)
                    (push (list (mk-ornament (map-ornaments curr-ornament)
                                             time real-dur (give-timed-value (pop-circ amps) cl-user::gtime)
                                             current-bpf other-bpfs
                                             (ins-number ins-params-values)
                                             (ins-rest ins-params-values)))
                          chords)
                  (progn (setq v-chords
                               (pwgl-apply #'append (mapcar #'chords (patch-value  curr-ornament ()))))
                    (mapc #'(lambda (ch) (setf (start-time ch) (+ time (start-time ch)))) v-chords)
                    (push v-chords chords)))))))))
    (nreverse (pwgl-apply #'append chords))))

#|
(defmethod goo ((x (eql :v)) num) num)
(defmethod goo ((x (eql :b)) num) (1+ num))

(goo :b 5)

(keywordp :cv)
(keywordp 'vb)
|#

