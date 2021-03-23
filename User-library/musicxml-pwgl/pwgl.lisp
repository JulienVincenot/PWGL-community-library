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

(defpackage #:musicxml-pwgl
  (:use #:cl #:ompw
        #:musicxml-pwgl.simple-http
        #:musicxml-pwgl.enp2musicxml
        #:musicxml-pwgl.musicxml)
  (:export #:export-musicxml))

(in-package #:musicxml-pwgl)

(defun decompile* (obj)
  (typecase obj
    (list obj)
    (t (ccl::pwgl-decompile obj))))

(define-menu musicxml-pwgl :print-name "MusicXML-PWGL")
(in-menu musicxml-pwgl)

(defvar *xml-path* (user-homedir-pathname))

(defun prompt-for-xml-path (message)
  (let ((path (capi:prompt-for-file
               message
               :pathname *xml-path*
               :filters '("xml" "*.xml") :operation :save)))
    (when path
      (setq *xml-path* path))))

(defun export-musicxml-to-stream (score out)
  (handler-case
      (let ((enp
             (handler-case
                 (typecase score
                   (cons score)         ;score is enp
                   (t (ccl::enp-score-notation score :exclude nil)))
               (error (c)
                 (send-report-with-env
                  "/musicxml-pwgl/enp-score-notation-error"
                  `(("score" . ,(readably-to-string (decompile* score)))
                    ("error" . ,(error-to-string c))))
                 (error c)))))
        (let ((dom (handler-case
                       (enp2musicxml enp)
                     (error (c)
                       (send-report-with-env "/musicxml-pwgl/enp-musicxml-error"
                                             `(("score" . ,(readably-to-string
                                                            (decompile* score)))
                                               ("enp" . ,(readably-to-string enp))
                                               ("error" . ,(error-to-string c))))
                       (error c)))))
          (handler-case
              (print-musicxml dom :stream out)
            (error (c)
              (send-report-with-env "/musicxml-pwgl/print-musicxml-error"
                                    `(("score" . ,(readably-to-string
                                                   (decompile* score)))
                                      ("enp" . ,(readably-to-string enp))
                                      ("error" . ,(error-to-string c))))
              (error c)))
          (let ((size 50000))
            (send-report-with-env "/musicxml-pwgl/export-musicxml-ok"
                                  `(("score" . ,(limit-string size (readably-to-string (decompile* score))))
                                    ("enp" . ,(limit-string size (readably-to-string enp))))))
          nil))
    (error (c)
      (capi:display-message "Ooops... MusicXML-PWGL was not able to export your score. ~
                            The next dialog will show the error message produced during conversion.")
      (error c))))

(define-box export-musicxml (score &optional path)
  (unless path
    (setq path (prompt-for-xml-path "Export MusicXML to:"))
    (unless path (return-from export-musicxml)))
  (with-open-file (out path :direction :output :if-exists :supersede)
    (export-musicxml-to-stream score out)))

(defun readably-to-string (obj)
  (with-standard-io-syntax
    (let ((*print-readably* nil))
      (write-to-string obj))))

(defun error-to-string (error)
  (with-standard-io-syntax
    (with-output-to-string (out)
      (write error
             :readably nil
             :stream out)
      (write-string " " out)
      (write error
             :readably nil
             :escape nil
             :stream out))))

(install-menu musicxml-pwgl)

;;; version check
(defun parse-version (string)
  (let ((pos (position #\. string)))
    (if pos
        (cons (parse-integer (subseq string 0 pos))
              (parse-version (subseq string (1+ pos))))
        (list (parse-integer string)))))

(defun list< (a b)
  (if (and (null a) (null b))
      nil
      (or (< (car a) (car b))
          (and (= (car a) (car b))
               (list< (cdr a) (cdr b))))))

(defun get-version ()
  (get-request "lisp.homelinux.net" 80 "/musicxml-pwgl/version"))

(defvar *welcome-message-done*
  (merge-pathnames "welcome-message-done"
                   (asdf:component-pathname (asdf:find-system :musicxml-pwgl))))

(defun welcome-message ()
  (let ((welcome-message-done *welcome-message-done*))
    (unless (probe-file welcome-message-done)
      (capi:display-message "Thanks for trying out the MusicXML export. ~
                 A simple demo patch is provided under ~
                 PWGL help... > Library Tutorials.")
      (with-open-file (out welcome-message-done :direction :output)
        (write-line "done" out)))))

;;; upgrade
(defun upgrade ()
  (with-open-file (out "/tmp/f.tgz" :direction :output
                       :if-exists :supersede)
    (write-sequence
     (get-request
      "lisp.homelinux.net" 80
      (format nil "/musicxml-pwgl/tarballs/musicxml-pwgl-~A.tgz"
              (get-version)))
     out))
  (when (probe-file "/tmp/musicxml-pwgl/")
    (cl-fad:delete-directory-and-files "/tmp/musicxml-pwgl/"))
  (asdf:run-shell-command "cd /tmp && tar xfz f.tgz")
  (let ((location (asdf:component-pathname (asdf:find-system :musicxml-pwgl)))
        (message-done (probe-file *welcome-message-done*)))
    (cl-fad:delete-directory-and-files location)
    (asdf:run-shell-command "mv '~A' '~A'"
                            "/tmp/musicxml-pwgl"
                            location)
    (asdf:run-shell-command "touch '~A'" (merge-pathnames "musicxml-pwgl.asd" location))
    (when message-done
      (with-open-file (out *welcome-message-done* :direction :output))))
  (asdf:oos 'asdf:load-op :musicxml-pwgl))

#-mswindows
(defun upgrade-check ()
  (let ((installed-version
         (parse-version (asdf:component-version (asdf:find-system :musicxml-pwgl))))
        (available-version
         (parse-version (get-version))))
    (when (list< installed-version available-version)
      (when (capi:prompt-for-confirmation
             (format nil "MusicXML-PWGL:~%You have version ~{~A~^.~} installed, available is ~{~A~^.~}.~%~
                          Download and install new version now (recommended)?"
                     installed-version available-version)
             :default-button :ok)
        (handler-case
            (progn
              (upgrade)
              (capi:display-message "MusicXML-PWGL upgrade successful.")
              (sys:open-url "http://lisp.homelinux.net/musicxml-pwgl/changes"))
          (error ()
            (capi:display-message "Downloading and installing the new version failed. ~
                                   Consider installing it manually.")))))))

#+mswindows
(defun upgrade-check ()
  (let ((installed-version
         (parse-version (asdf:component-version (asdf:find-system :musicxml-pwgl))))
        (available-version
         (parse-version (get-version))))
    (when (list< installed-version available-version)
      (when (capi:prompt-for-confirmation
             (format nil "MusicXML-PWGL:~%You have version ~{~A~^.~} installed, available is ~{~A~^.~}.~%~
                          Download new version now (recommended)?"
                     installed-version available-version)
             :default-button :ok)
        (sys:open-url "http://lisp.homelinux.net/musicxml-pwgl/latest")))))

(defun send-report (uri parameters)
  (mp:process-run-function
   "send-report" nil
   (lambda () (ignore-errors (post-request "lisp.homelinux.net" 80 uri parameters)))))

(defun send-report-with-env (uri parameters)
  (send-report uri (cons `("env" . ,(readably-to-string (preferences-env)))
                         parameters)))

(defun limit-string (size string)
  (if (>= (length string) size)
      nil
      string))

(defvar *welcome-message-done* nil)
(unless *welcome-message-done*
  (ignore-errors (welcome-message))
  (setq *welcome-message-done* t))

(defvar *upgrade-check-done* nil)
(unless *upgrade-check-done*
  (mp:process-run-function "upgrade-check" nil (lambda () (sleep #+mswindows 2 #-mswindows 0) (ignore-errors (upgrade-check))))
  (setq *upgrade-check-done* t))

;;; export dialog
(in-package :ccl)

(defmethod enp-export-file-extension((self (eql :musicxml-pwgl)))
  "xml")

(defmethod enp-export-name((format (eql :musicxml-pwgl)))
  "Music XML")

(defmethod enp-export-file-extension-to-format((format (eql :musicxml-pwgl)))
  :xml)

(defmethod enp-export((self score) (format (eql :musicxml-pwgl)) (stream T))
  (musicxml-pwgl::export-musicxml-to-stream self stream))

;;; ********************************************************************************

(defmethod enp-import-file-extension((self (eql :musicxml-pwgl)))
  "xml")

(defmethod enp-import((self score) (format (eql :musicxml-pwgl)) (stream T))
  ())
