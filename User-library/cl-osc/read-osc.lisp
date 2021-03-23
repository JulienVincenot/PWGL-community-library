;;; Copyright (c) 2007, Kilian Sprotte. All rights reserved.

;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:

;;;   * Redistributions of source code must retain the above copyright
;;;     notice, this list of conditions and the following disclaimer.

;;;   * Redistributions in binary form must reproduce the above
;;;     copyright notice, this list of conditions and the following
;;;     disclaimer in the documentation and/or other materials
;;;     provided with the distribution.

;;; THIS SOFTWARE IS PROVIDED BY THE AUTHOR 'AS IS' AND ANY EXPRESSED
;;; OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
;;; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
;;; GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
;;; WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

(in-package :cl-osc)

(declaim (inline mod4-pos))
(defun mod4-pos (stream)
  (the fixnum (mod (the fixnum (trs:stream-mess-consumed stream)) 4)))

;; taken from cl-store
(defmacro make-ub32 (a b c d)
  `(the (unsigned-byte 32) (logior (ash ,a 24) (ash ,b 16) (ash ,c 8) ,d)))

(defun read-int32 (buf &optional (signed t))
  "Read a signed or unsigned byte off STREAM."
  (declare (optimize speed (debug 0) (safety 0)))
  (let ((byte1 (read-byte buf))
        (byte2 (read-byte buf))
        (byte3 (read-byte buf))
        (byte4 (read-byte buf)))
    (declare (type (mod 256) byte1 byte2 byte3 byte4))
    (let ((ret (make-ub32 byte1 byte2 byte3 byte4)))
      (if (and signed (> byte1 127))
          (logior (ash -1 32) ret)
          ret))))

(defun read-float32 (stream)
  #+lispworks
  (fli:with-dynamic-foreign-objects ((int :int))
    (setq int (fli:allocate-dynamic-foreign-object
               :type :int
               :initial-element (read-int32 stream)))
    (fli:dereference int :type :float))
  #+openmcl
  (ccl:rlet ((x :int (read-int32 stream)))
    (ccl:pref x :float))
  #-(or lispworks openmcl) (declare (ignore stream))
  #-(or lispworks openmcl)
  (error "read-float32 not yet impl."))

(defun read-float64 (stream)
  #+lispworks
  (let ((high (read-int32 stream))
        (low (read-int32 stream)))
    (fli:with-dynamic-foreign-objects ((long :long))
      (setq long (fli:allocate-dynamic-foreign-object
                  :type :long
                  :initial-element low))
      (setf (fli:dereference long :type :int) high)
      (fli:dereference long :type :double)))
  #+openmcl
  (let ((high (read-int32 stream))
        (low (read-int32 stream)))
    (ccl:rlet ((x :long low))
      (setf (ccl:pref x :int) high)
      (ccl:pref x :double)))
  #-(or lispworks openmcl) (declare (ignore stream))
  #-(or lispworks openmcl)
  (error "read-float32 not yet impl."))

(defun read-until-char (stream char)
  (with-output-to-string (string)
    (iter
      (for ch = (code-char (read-byte stream)))
      (until (char= ch char))
      (write-char ch string))))

(define-compiler-macro read-until-char (&whole form stream char)
  ;; since sbcl might wrap CHAR with (locally (declare ...) char)
  ;; we have to be tolerant here
  (if (eql #\, char)
      ;; here we just would like to consume tha #\,
      ;; of the type tag string. we should be looking
      ;; at it anyway
      `(assert (= (char-code #\,) (read-byte ,stream)))
      form))

(defun read-null-padding (stream)
  (let ((mod4-pos (mod4-pos stream)))
    (unless (zerop mod4-pos)
      (dotimes (i (- 4 mod4-pos))
        (read-byte stream)))))

(defun read-osc-string (stream)
  (prog1
      (read-until-char stream #\Null)
    (read-null-padding stream)))

(defun read-osc-arguments (stream type-tag-string)
  (iter
    (for type-tag in-string type-tag-string)
    (collect
        (ecase type-tag
          (#\i (read-int32 stream))
          (#\f (read-float32 stream))
          (#\d (read-float64 stream))
          (#\s (read-osc-string stream))))))

(defun read-osc-message (stream address-pattern)
  (let* ((type-tag-string (read-osc-string stream))
         (arguments (read-osc-arguments stream type-tag-string)))
    (make-osc-message address-pattern arguments)))

(defun read-time-tag (stream)
  "Returns time relative to *time-origin*."
  (let ((ut (read-int32 stream nil))
        (fract (read-int32 stream nil)))
    (+ (float (- ut *time-origin*) 1d0)
       (* fract (float (/ 1 #xffffffff) 1d0)))))

(defun read-osc-bundle (stream)
  (iter
    (with time = (read-time-tag stream))
    (collect (read-osc stream t) into messages)
    (while (not (zerop (trs:stream-mess-remaining stream))))
    (finally (return (values messages time)))))

(defun read-osc (stream &optional size-p)
  "Read one osc entity (message or bundle) from STREAM and return it.
If SIZE-P is T, expect the message to be prefixed with an integer
specifiying its size, which you should do for tcp and ommit for
udp (use SIZE-P = NIL, which is the default)."
  (when size-p
    (read-int32 stream))
  (let ((first-string (read-osc-string stream)))
    (if (string= first-string "#bundle")
        (read-osc-bundle stream)
        (progn
          (read-until-char stream #\,)
          (read-osc-message stream first-string)))))

(defun process-osc (stream &optional size-p)
  "Process one osc entity (message or bundle) from STREAM and invoke its
corresponding callback(s), if it exists. Regarding SIZE-P see READ-OSC."
  (multiple-value-bind (mess time)
      (read-osc stream size-p)
    (if (listp mess)
        ;; its a bundle
        (iter
          (for m in mess)
          (invoke-callback time m))
        ;; its a message
        (invoke-callback (funcall *time-now-fun*) mess))))
