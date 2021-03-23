;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Coding:utf-8 -*-

(defpackage #:ksquant2-test
  (:use #:cl #:ksquant2 #:regression-test))

(in-package #:ksquant2-test)

(rem-all-tests)

(deftest dummy
  (+ 1 2)
  3)

(deftest simple.1
  (ccl:enp-score-notation (simple2score '(0 1 2 3)) :include nil)
  (((((1 (1)) (1 (1)) (1 (1)) (1 (-1)))))))

(defun invoke-with-tmp-dir-stub (thunk)
  (let* ((tmp-dir (merge-pathnames
		   (make-pathname :directory `(:relative ,(princ-to-string (random 1000000))))
		   (ksquant2::tmp-dir)))
	 (stub (lambda () tmp-dir))
	 (orig (symbol-function 'ksquant2::tmp-dir)))
    (assert (not (probe-file tmp-dir)))
    (unwind-protect
	 (progn
	   (ensure-directories-exist tmp-dir)
	   (setf (symbol-function 'ksquant2::tmp-dir) stub)
	   (funcall thunk))
      (setf (symbol-function 'ksquant2::tmp-dir) orig)
      (cl-fad:delete-directory-and-files tmp-dir))))

(defmacro with-tmp-dir-stub (&body body)
  "Ensure that KSQUANT2::TMP-DIR returns a fresh and empty dir that
  exists only for BODY's dynamic extent."
  `(invoke-with-tmp-dir-stub (lambda () ,@body)))

(deftest tmp-dir-internal.1
  (with-tmp-dir-stub
    (directory (merge-pathnames (make-pathname :name :wild :type :wild)
				(ksquant2::tmp-dir))))
  nil)

(deftest tmp-dir-internal.2
  (with-tmp-dir-stub
    (not (probe-file (ksquant2::tmp-dir))))
  nil)

(deftest tmp-dir-internal.3
  (let ((tmp-dir (with-tmp-dir-stub (ksquant2::tmp-dir))))
    (not (probe-file tmp-dir)))
  t)

(deftest tmp-dir-internal.4
  (let ((tmp-dir (with-tmp-dir-stub
		   (with-open-file (*standard-output*
				    (merge-pathnames "foo" (ksquant2::tmp-dir))
				    :direction :output)
		     (print "foo"))
		   (ksquant2::tmp-dir))))
    (not (probe-file tmp-dir)))
  t)

(deftest tmp-dir.1
  (with-tmp-dir-stub
    (simple2score '(0 1 2 3))
    (directory (merge-pathnames (make-pathname :name :wild :type :wild)
				(ksquant2::tmp-dir))))
  nil)
