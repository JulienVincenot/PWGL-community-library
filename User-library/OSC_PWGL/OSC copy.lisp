(in-package :ccl)

;;; (asdf:oos 'asdf:compile-op :cl-osc :force T)

(defclass OSC-player (play-device::midi-play-device) ())

(add-playback-device 'OSC-player "OSC-player")

(defvar *osc* NIL)

(def-pwgl-library-preference *OSC-player-port* 57120 :osc :editor-type :integer)
(def-pwgl-library-preference *OSC-control-rate* 0.1 :osc :editor-type :float)

;********************************************************************************

(defun add-playback-events (score events)
  (write-key score :extra-playback-events (append (read-key score :extra-playback-events) events)))

;********************************************************************************

(defvar *osc-controls-cache* (make-hash-table))

(defun osc-controls-cache (key &optional val)
  (case key
    (:init (clrhash *osc-controls-cache*))
    (:get (gethash val *osc-controls-cache*))
    (:set (setf (gethash val *osc-controls-cache*) val))
    (:exists-p (gethash val *osc-controls-cache*))))

;********************************************************************************

;;; (read-key score :extra-playback-events)

(defmethod play-device::prepare-playback*((output OSC-player) score)
  (unless *osc*
    (setq *osc* (comm-ext:open-udp-stream "localhost" *OSC-player-port* "0.0.0.0" 0 :io '(unsigned-byte 8))))
  (osc-controls-cache :init)
  (write-key score :extra-playback-events ())
  (dolist (expression (collect-all-expressions score))
    (add-playback-events score (osc-control-rate-message expression))))

#+NIL
(defmethod send-playback-event ((output OSC-player) note midi-info &optional vel?)
  (when *osc*
    (let ((chan (read-key midi-info :chan))
          (midi (read-key midi-info :midi))
          (vel (read-key midi-info :vel)))
      (if (zerop vel)
          (cl-osc:write-osc-message *osc* nil "/noteOff" midi chan)
        (cl-osc:write-osc-message *osc* nil "/noteOn" midi vel chan)))))

;;; (cl-osc:write-osc-message *osc* nil "/list" #(1 2 3 4))

(defmethod play-device::send-playback-event ((output OSC-player) note midi-info &optional vel?)
  (when *osc*
    (unless (zerop (read-key midi-info :vel))
      (let ((chord (super-notation-object note)))
        (osc-message note)
        (dolist (expression (expressions note))
          (osc-message expression))
        (dolist (expression (expressions chord))
          (osc-message expression))))))

;********************************************************************************

(defmethod osc-message ((self T))
  ())

(defmethod osc-message((self plain-text))
  (let ((stuff (read-all-from-string (print-symbol self))))
    (apply #'cl-osc:write-osc-message *osc* nil (car stuff) (mapcar #'read-from-string (cdr stuff)))))

;********************************************************************************

(defmethod duration ((self expression))
  (apply #'+ (mapcar #'real-duration (notation-objects self))))

(defmethod start-time ((self expression))
  (start-time (car (notation-objects self))))

;********************************************************************************

(defmethod osc-control-rate-message ((self T))
  ())

(defmethod osc-control-rate-message ((self bpf))
  (unless (osc-controls-cache :exists-p self)
    (osc-controls-cache :set self)
    (let ((kr (* 10 3)))
      (loop for breakpoint-function in (break-point-functions self)
            append
            (let ((name (name breakpoint-function)))
              (loop for val in (print (pwgl-sample breakpoint-function kr))
                    for time from (start-time self) to (+ (start-time self) (duration self))
                    by (/ (+ (start-time self) (duration self)) kr)
                    collect (list :callback 
                                  (/ (* 1000 (enp-float time)) 1000.0) 
                                  'send-enp-osc-message 
                                  (format () "/~a" name) 
                                  (/ (* 1000 (enp-float val)) 1000.0))))))))

;********************************************************************************
; THE MAIN SENDER
;********************************************************************************

(defun send-enp-osc-message (score name &rest vals)
  (declare (ignore score))
  (apply #'cl-osc:write-osc-message *osc* nil name vals))