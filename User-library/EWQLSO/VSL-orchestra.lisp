
(in-package :ccl)

;********************************************************************************
; PLAYER
;********************************************************************************

(defclass EWQLSO-player (play-device::midi-play-device) ())

(add-playback-device 'EWQLSO-player "EWQLSO-player")
(defparameter *force-symbolic-dynamics-p* t)

(defmethod play-device::calc-dynamics-value-list ((output T) (ins T) note (exp (eql :crescendo)))
  (list (case (initial-dynamics (e note exp)) (:ppp 10) (:pp 30) (:p 50) (:mp 70) (:f 90) (:ff 110) (:fff 127) (T 60))
        (case (end-dynamics (e note exp)) (:ppp 10) (:pp 30) (:p 50) (:mp 70) (:f 90) (:ff 110) (:fff 127) (T 100))))

(defmethod play-device::calc-dynamics-value-list ((output T) (ins T) note (exp (eql :diminuendo)))
  (list (case (initial-dynamics (e note exp)) (:ppp 10) (:pp 30) (:p 50) (:mp 70) (:f 90) (:ff 110) (:fff 127) (T 100))
        (case (end-dynamics (e note exp)) (:ppp 10) (:pp 30) (:p 50) (:mp 70) (:f 90) (:ff 110) (:fff 127) (T 60))))

(defmethod play-device::calc-playback-vel* ((device EWQLSO-player) (self note))
  (alexandria:if-let (symbolic-dynamics (expression? self #'fixed-dynamics-curve-p))
    (default-expression-velocity symbolic-dynamics)
    (if *force-symbolic-dynamics-p*
        (alexandria:if-let (prev-note (prev-item self))
          (play-device::calc-playback-vel* device prev-note)
          (vel self))
      (vel self))))

(create-expression solo (auto-cancellation)
  ()
  (:default-initargs 
   :print-symbol "solo" :standard-cancellation-mark "tutti"))

;;
;; the problem here: the order of the expressions!!
;;

(defun sort-nkis-for-playback(instrument expressions)
  (when expressions
    (let ((nkis (iter (for expression in expressions)
                  (cond
                   ;;; ((dynamics-p expression) ())
                   ((crescendo-diminuendo-p expression) ())
                   (T
                    (typecase expression  
                      (muta-in ())
                      (T (when-let (nki (nki instrument t expression))
                           (collect (cons nki expression))))))))))
      (sort nkis ;;; (remove-duplicates nkis :test #'equalp :key #'first)
            '>
            :key #'(lambda(x) (let ((namestring (pathname-directory (car x))))
                                (cond
                                 ((member "1 Long" namestring :test #'equalp) -1)
                                 (T 0))))))))

(defun most-significant-nki-for-playback(instrument expression)
  (let ((nki-info (car (sort-nkis-for-playback instrument expression))))
    (when nki-info
      (destructuring-bind (nki . exp) nki-info
        (values nki exp)))))

;********************************************************************************

(defmethod omit-the-beginning-of-the-group-p((self t))
  ())

(defmethod omit-the-beginning-of-the-group-p((self slur))
  ())

;********************************************************************************

(defmethod solo-instrument-p ((self t) note)
  ())

(defmethod solo-instrument-p ((self instrument) note)
  (print (or (e note :solo)
             (search "solo" (score-name self) :test #'equalp))))

;;; (search "solo" "Violin SOlo" :test #'equalp)

(defmethod play-device::prepare-playback*((output EWQLSO-player) score)
  "For EWQLSO-player the setup method looks through the score and loads all the necessary samples"
  (with-message-dialog "Loading nki's"
    (dolist (part (parts score))
      (dolist (voice (voice-list part))
        (dolist (note (collect-enp-objects voice :note))
          (unless (rest-p note)
            (let ((default-instrument (read-key note :current-instrument))
                  current-instrument)
              (let ((solo-p (solo-instrument-p default-instrument note)))
                (write-key default-instrument :solo-p solo-p))
              (write-key note :ewqlso-chan (load-nki-instrument (nki default-instrument t t)))
              (let ((muta-in (e note :muta-in)))
                (when muta-in
                  (setq current-instrument (find-instrument (instrument muta-in)))
                  (let ((solo-p (solo-instrument-p current-instrument note)))
                    (write-key current-instrument :solo-p solo-p))
                  (write-key note :ewqlso-chan (load-nki-instrument (nki current-instrument t t))))
                (let ((expressions (append (expressions (super-notation-object note)) (expressions note))))
                  (multiple-value-bind (nki exp) (most-significant-nki-for-playback (if muta-in current-instrument default-instrument) expressions)
                    (when nki
                      (unless (and (omit-the-beginning-of-the-group-p exp)
                                   (e note exp :FIRST?))
                        (when-let (chan (load-nki-instrument nki))
                          (write-key note :ewqlso-chan chan))))))))))))
    (redraw score)))

(defmethod play-device::calc-playback-chan/midi* ((output EWQLSO-player) (self note))
  (values (or (read-key self :ewqlso-chan) (chan self)) (truncate (sounding-pitch self))))

(defmethod play-device::setup-playback*((output EWQLSO-player) score) ())

;********************************************************************************
; draw-note plug-in
;********************************************************************************

(defadvice ((METHOD DRAW-NOTE :AFTER (NOTE T T T T T))
            after-draw-note :after)
    (self kind x Staff-Position clef note-head &optional extra-symbols)
  (unless (rest-p self)
    (let ((chan (read-key self :ewqlso-chan)))
      (un-selectable
          (with-GL-color (if chan :blue :red)
            (txprint self (+ (x self) 1.1) (y self) 0.0 0.06 0.0 :times (format () "~a" (or chan "x")) t))))))

;(lw-tools::generic-function-method-dspecs #'draw-note)