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

(defpackage #:musicxml-pwgl.simple-http
  (:use #:cl)
  (:export #:get-request
           #:post-request))

(in-package #:musicxml-pwgl.simple-http)

(defun get-request (host port uri)
  (http-request :get host port uri))

(defun post-request (host port uri parameters)
  (http-request :post host port uri parameters))

(defun http-request (type host port uri &optional parameters)
  (declare ((member type :get :post) type))
  (case type (:get (assert (null parameters))))
  (let* ((socket (open-socket host port))
         (stream (socket-stream socket)))
    (unwind-protect
         (progn
           (case type
             (:get (send-get-request stream uri host))
             (:post (send-post-request parameters stream uri host)))
           (destructuring-bind (start-line . headers)
               (loop for line = (read-line-crlf stream)
                  until (zerop (length line))
                  collect line)
             (unless (string= start-line "HTTP/1.1 200 OK")
               (error "start-line is ~a" start-line))
             (let ((content-length
                    (parse-integer
                     (find "Content-Length" headers
                           :test (lambda (a b) (string= a b :end2 (length a))))
                     :start 15)))
               (with-output-to-string (out)
                 (loop repeat content-length
                    do (write-char (read-char stream) out))))))
      (close stream)
      (close-socket socket))))

(defconstant +crlf+
  (if (boundp '+crlf+)
      (symbol-value '+crlf+)
      (concatenate 'string
                   (string (code-char 13))
                   (string (code-char 10)))))

(defun send-get-request (stream uri host)
  (format stream "GET ~A HTTP/1.1~AHost: ~AConnection: close~A~A~A"
          uri +crlf+ host +crlf+ +crlf+ +crlf+)
  (force-output stream))

(defun send-post-request (parameters stream uri host)
  (let ((encoded-parameters (encode-parameters parameters)))
    (format stream "POST ~A HTTP/1.1~A~
                           Host: ~A~A~
                           Content-Type: application/x-www-form-urlencoded~A~
                           Content-Length: ~A~A~
                           ~A~
                           ~A"
            uri +crlf+
            host +crlf+
            +crlf+
            (length encoded-parameters) +crlf+
            +crlf+
            encoded-parameters)
    (force-output stream)))

(defun open-socket (host port)
  #+sbcl (usocket:socket-connect host port :element-type '(unsigned-byte 8))
  #-sbcl (comm:open-tcp-stream host port :errorp t))

(defun close-socket (socket)
  #+sbcl (usocket:socket-close socket)
  #-sbcl socket)

(defun socket-stream (socket)
  #+sbcl (flexi-streams:make-flexi-stream (usocket:socket-stream socket))
  #-sbcl socket)

(defun read-line-crlf (stream)
  (prog1
      (with-output-to-string (out)
        (loop for ch = (read-char stream)
           until (char= ch #.(code-char 13))
           do (write-char ch out)))
    (read-char stream)))

(defun write-url-encoded (string stream)
  (dotimes (i (length string))
    (let ((char (char string i)))
      (cond ((alphanumericp char)
             (write-char char stream))
            ((char= char #\space)
             (write-char #\+ stream))
            (t
             (format stream "%~2,'0x" (char-code char)))))))

;;; not correct, but works with Hunchentoot
(defun encode-parameters (parameters)
  (with-output-to-string (out)
    (loop for parameter-tail on parameters
       for parameter = (car parameter-tail)
       for (key . value) = parameter
       do (format out "~A=" key)
       do (write-url-encoded value out)
       when (cdr parameter-tail)
       do (write-char #\& out))))
