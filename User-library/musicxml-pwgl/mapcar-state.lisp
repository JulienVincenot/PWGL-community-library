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

(in-package #:musicxml-pwgl.mapcar-state)

(defstruct mapcar-state
  index lastp previous next)

(defun mapcar-state-firstp (state)
  (= 1 (mapcar-state-index state)))

(defun mapcar-state (fn list &key repeat)
  (labels ((rec (fn list index previous)
             (cond ((null list)
                    nil)
                   ((and repeat (> index repeat))
                    nil)
                   (t
                    (let ((value (funcall
                                  fn
                                  (make-mapcar-state
                                   :index index
                                   :lastp (null (cdr list))
                                   :previous previous
                                   :next (cadr list))
                                  (car list))))
                      (cons value
                            (rec fn (cdr list) (1+ index) (car list))))))))
    (rec fn list 1 nil)))

(defun mapcan-state (fn list &key repeat)
  (apply #'nconc (mapcar-state fn list :repeat repeat)))
