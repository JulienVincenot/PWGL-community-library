;;;; Silly emacs, this is -*- Lisp -*-

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

(defpackage :cl-osc-system (:use :asdf :cl))
(in-package :cl-osc-system)

(defsystem :cl-osc
  :name
  "cl-osc"
  :author
  "paul"
  :components
  ((:file "package")
   (:file "address-space" :depends-on ("package"))
   (:file "osc-message" :depends-on ("package"))
   (:file "write-osc" :depends-on ("package" "osc-message"))
   (:file "read-osc" :depends-on ("package" "write-osc" "osc-message")))
  :depends-on
  (:iterate ));;;:trivial-sockets

(defsystem :cl-osc-test
  :name "cl-osc-test"
  :author "paul"
  :components
  ((:module :test
            :components
            ((:file "suite")
             (:file "main" :depends-on ("suite"))
             )))
  :depends-on (:cl-osc :fiveam :flexi-streams)
  :in-order-to ((compile-op (load-op :cl-osc))))

(defmethod perform ((op asdf:test-op) (system (eql (find-system :cl-osc))))
  (asdf:oos 'asdf:load-op :cl-osc-test)
  (funcall (intern "RUN!" "IT.BESE.FIVEAM")
           :cl-osc-test))

(defmethod perform ((op asdf:test-op) (system (eql (find-system :cl-osc-test))))
  (perform op (find-system :cl-osc)))
