;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Coding:utf-8 -*-

;;; This file is part of MusicXML-PWGL.

;;; Copyright (c) 2010 - 2011, Kilian Sprotte. All rights reserved.

;;; This program is free software: you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation, either version 3 of the License, or
;;; (at your option) any later version.

;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.

;;; You should have received a copy of the GNU General Public License
;;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(in-package #:musicxml-pwgl.pprint-xml)

(defparameter *pprint-xml-table* (copy-pprint-dispatch nil))

(defun pprint-redispatch (obj stream)
  (funcall (pprint-dispatch obj) stream obj))

(defun group-in-pairs (list)
  (loop for tail on list by #'cddr
        collect (list (first tail) (second tail))))

(set-pprint-dispatch
 '(cons (cons symbol t) t)
 (lambda (stream obj)
   (destructuring-bind ((elt &rest attributes) &rest elts)
       obj
     (pprint-logical-block (stream nil)
       (pprint-logical-block (stream nil :prefix "<" :suffix ">")
         (write-string (string elt) stream)
         (dolist (pair (group-in-pairs attributes))
           (write-char #\space stream)
           (pprint-newline :fill stream)
           (write-string (string (first pair)) stream)
           (write-string "='" stream)
           (write-string (second pair) stream)
           (write-string "'" stream))
         (pprint-newline :linear stream))
       (format stream "~{~W~}" elts)
       (write-string "</" stream)
       (write-string (string elt) stream)
       (pprint-indent :block -1 stream)
       (pprint-newline :linear stream)
       (write-string ">" stream))))
 0 *pprint-xml-table*)

(set-pprint-dispatch
 '(cons symbol t)
 (lambda (stream obj)
   (pprint-redispatch (cons (list (car obj)) (cdr obj)) stream))
 0 *pprint-xml-table*)

(set-pprint-dispatch
 'symbol
 (lambda (stream obj)
   (write-string "<" stream)
   (write-string (string obj) stream)
   (pprint-newline :linear stream)
   (write-string "/>" stream))
 0 *pprint-xml-table*)

(set-pprint-dispatch
 'null
 (lambda (stream obj)
   (declare (ignore stream obj)))
 1 *pprint-xml-table*)

(set-pprint-dispatch
 'string
 (lambda (stream obj)
   (write-string obj stream))
 0 *pprint-xml-table*)

(defun pprint-xml (dom &key (stream t))
  (let ((*print-pprint-dispatch* *pprint-xml-table*))
    (pprint dom stream)))

(defun remove-whitespace (dom)
  "Remove any text elements that contain only whitespace."
  ;; TODO really remove them
  (flet ((whitespace-p (char)
           (member char '(#\space #\page #\newline #\return #\tab))))
    (subst-if "" (lambda (obj) (and (stringp obj) (every #'whitespace-p obj)))
              dom)))
