;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Coding:utf-8 -*-

(in-package #:common-lisp-user)

(defun input-files ()
  (directory "shell-tests/*.lisp"))

(defun read-input-file (path)
  (with-open-file (in path)
    (values (read in) (read in))))

(defun run-test (data expected)
  (with-open-file (out "tmp" :direction :output :if-exists :supersede)
    ;; (with-standard-io-syntax
    ;;   (write data :stream out))
    (prin1 data out))
  (and (not (run-shell-command "./main <tmp >out"))
       (equal expected (with-open-file (in "out") (read in)))))

(defun report-on-file (path)
  (multiple-value-bind (data expected)
      (read-input-file path)
    (let ((success (run-test data expected)))
      (format t "~A~50T~A~%" (file-namestring path) success)
      success)))

(let ((success (every #'identity (mapcar 'report-on-file (input-files)))))
  (finish-output)
  (exit (if success 0 1)))
