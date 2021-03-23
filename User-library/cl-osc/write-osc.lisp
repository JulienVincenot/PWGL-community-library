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

(defconstant +max-arg-length+ 40
  "Max number of arguments an osc message can take.")

(defvar *out-buffer*)
(defvar *out-buffer-len*)
(declaim (type fixnum *out-buffer-len*))
(defvar *force-output* t)

;;; utils

(defun next-4-mult-diff (n)
  (declare (fixnum n)
           (optimize (speed 3) (safety 0) (debug 0) #+lispworks (hcl:fixnum-safety 0)))
  (let ((m (mod n 4)))
    (if (zerop m)
        0
        (- 4 m))))

(defun next-4-mult (n)
  "If N is multiple of 4 N, next bigger multiple of 4."
  (declare (type fixnum n))
  (let ((rem (mod n 4)))
    (declare (type fixnum rem))
    (if (zerop rem)
        n
        (the fixnum (+ 4 (- n rem))))))

;;; write basic types

;; from cl-store (but different byte order)
(declaim (inline write-int32))
(defun write-int32 (obj stream)
  "Write OBJ down STREAM as a 32 bit integer."
  (declare (optimize speed (debug 0) (safety 0))
           (type (signed-byte 32) obj))
  (let ((obj (logand #XFFFFFFFF obj)))
    (write-byte (+ 0 (ldb (byte 8 24) obj)) stream)
    (write-byte (ldb (byte 8 16) obj) stream)
    (write-byte (ldb (byte 8 8) obj) stream)
    (write-byte (ldb (byte 8 0) obj) stream)))

;; (defun printbin (x)
;;   (let ((*print-base* 2))
;;     (print (format nil "~8b" x))
;;     (print "87654321")
;;     x))

(declaim (inline %write-float32))
(defun %write-float32 (float stream)
  (multiple-value-bind (mantissa exponent sign)
      (integer-decode-float float)
    (let ((actual-sign (if (= sign 1) 0 1))
          (exponent (+ exponent 23 127)))
      (write-byte (dpb actual-sign (byte 1 7) (ldb (byte 7 1) exponent)) stream)
      (write-byte (dpb (ldb (byte 1 0) exponent) (byte 1 7) (ldb (byte 7 16) mantissa)) stream)
      (write-byte (ldb (byte 8 8) mantissa) stream)
      (write-byte (ldb (byte 8 0) mantissa) stream))))

(declaim (inline write-float32))
(defun write-float32 (float stream)
  (declare (single-float float))
  ;; we ensure that float is of type single-float like 1.0f0
  #+lispworks
  (fli:with-dynamic-foreign-objects ((float* :float))
    (setq float* (fli:allocate-dynamic-foreign-object
                  :type :float
                  :initial-element (float float 1.0f0)))
    (write-int32 (fli:dereference float* :type :int) stream))
  #+openmcl
  (ccl:rlet ((x :float (float float 1.0f0)))
    (write-int32 (ccl:pref x :int) stream))
  #-(or lispworks openmcl) (%write-float32 float stream))

(defun write-osc-int (int)
  (write-int32 int *out-buffer*)
  (incf *out-buffer-len* 4))

(defun write-osc-float (float)
  (write-float32 float *out-buffer*)
  (incf *out-buffer-len* 4))

(defun write-osc-string (string &optional (stream *out-buffer*))
  (iter
    (for ch in-string string)
    (for len upfrom 1)
    (write-byte (char-code ch) stream)
    (finally
     ;; the string has always to be null-terminated
     (write-byte (char-code #\Null) stream)
     (incf len 1)
     ;; extend to mult of 4
     (let ((diff (next-4-mult-diff len)))
       (incf *out-buffer-len* (+ len diff))
       (dotimes (i diff)
         (write-byte (char-code #\Null) stream))))))

(defun write-osc-blob (vector &optional (stream *out-buffer*))
  (let ((len (length vector)))
    (write-int32 len *out-buffer*)
    (incf *out-buffer-len* 4)
    (iter
      (for byte in-vector vector)
      (write-byte byte stream)
      (finally
       ;; extend to mult of 4
       (let ((diff (next-4-mult-diff len)))
         (incf *out-buffer-len* (+ len diff))
         (dotimes (i diff)
           (write-byte (char-code #\Null) stream)))))))

#|| @section single messages |#

(defun arg-info (arg)
  (etypecase arg
    (integer (values 4 #\i #'write-osc-int))
    (float   (values 4 #\f #'write-osc-float))
    (string  (values
              (next-4-mult (1+ (length arg)))
              #\s #'write-osc-string))
    (vector (values (+ 4 (next-4-mult (length arg)))
                    #\b #'write-osc-blob))))

(defun analyze-args (args)
  (iter
    (with type-tags = (make-array +max-arg-length+ :fill-pointer t :element-type 'base-char))
    (with write-fns = (make-array +max-arg-length+))
    (with byte-len = 0)
    (declare (type fixnum byte-len))
    (initially (setf (aref type-tags 0) #\,))
    (for arg in args)
    (for i upfrom 0)
    (declare (type fixnum i))
    (assert (not (= i +max-arg-length+)) nil
            "The number of arguments exceeds the predefined maximum (see +max-arg-length+).")
    (multiple-value-bind (arg-byte-len type-tag write-fn)
        (arg-info arg)
      (incf byte-len arg-byte-len)            ; byte-len
      (setf (aref type-tags (1+ i)) type-tag  ; type-tags
            (svref write-fns i) write-fn))    ; write-fns
    (finally
     ;; arg len = i + 1
     (incf byte-len (next-4-mult (+ 3 i))) ; byte-len of type-tags string + #\,
     (setf (fill-pointer type-tags) (+ 2 i))
     (return (values byte-len type-tags write-fns)))))

(defun write-osc-message (stream size-p address-pattern &rest args)
  "Write osc message to STREAM, determined by ADDRESS-PATTERN and ARGS.
If SIZE-P is T, prefix the message with an integer specifiying its size,
which you should do for tcp and ommit for udp."
  (declare (dynamic-extent args))
  (let ((*out-buffer* stream)
        (*out-buffer-len* 0))
    (multiple-value-bind (byte-len type-tags write-fns)
        (analyze-args args)
      (declare (fixnum byte-len)
               (base-string type-tags)
               ((array function *) write-fns))
      ;; add byte-len of address-pattern string
      (incf byte-len (next-4-mult (1+ (length address-pattern))))
      (when size-p
        (write-int32 byte-len stream)
        (incf byte-len 4))              ; for writing ourselves
      (write-osc-string address-pattern)
      (write-osc-string type-tags)
      (iter
        (for arg in args)
        (for write-fn in-vector write-fns)
        (funcall write-fn arg))
      (assert (= *out-buffer-len* (if size-p (- byte-len 4) byte-len)) nil
              "the *out-buffer-len* is ~a, but we wanted ~a" *out-buffer-len*
              (if size-p (- byte-len 4) byte-len))
      (when *force-output*
        (force-output stream))
      byte-len)))

#|| @section bundles |#

(defvar *time-origin* nil
  "The absolute time, time-offset relates to. If left nil,
\(get-universal-time) is assumed.") ; FIXME is this true, sholdn't we always use with-time-origin?
;; FIXME make this var unbound by default?

(defvar *time-now-fun* #'get-universal-time)

(defmacro with-time-origin ((&optional (origin '(get-universal-time))) &body body)
  `(let ((*time-origin* ,origin))
     ,@body))

(defun write-time-tag (time-offset origin)
  (if (eql :now time-offset)
      (progn
        (write-int32 0 *out-buffer*)
        (write-int32 1 *out-buffer*))
      (multiple-value-bind (ut fract) (floor time-offset)
        (write-int32 (+ ut origin) *out-buffer*)
        (write-int32 (round (* #xffffffff fract)) *out-buffer*)))
  (incf *out-buffer-len* 8))

(defun write-osc-bundle (stream size-p time-offset messages)
  "FIXME needs more docu

TIME-OFFSET can be :NOW, if it is a number
it relates to *TIME-ORIGIN*."
  (let ((*out-buffer-len* 0)
        (*out-buffer* (if size-p (make-string-output-stream :element-type 'base-char) stream))
        (origin (if *time-origin* *time-origin* (get-universal-time))))
    (write-osc-string "#bundle")
    (write-time-tag time-offset origin)
    (iter
      (with *force-output* = nil)
      (for mess in messages)
      (incf *out-buffer-len*
            (apply #'write-osc-message *out-buffer* t (car mess) (cdr mess))))
    (when size-p
      ;; now we write out everything
      (write-int32 *out-buffer-len* stream)
      (write-sequence (get-output-stream-string *out-buffer*) stream)
      (incf *out-buffer-len* 4))
    (force-output stream)
    *out-buffer-len*))
