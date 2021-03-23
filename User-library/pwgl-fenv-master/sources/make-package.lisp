;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; -*-

(defpackage :fenv
  (:nicknames :fe)
  (:use :common-lisp :pw))

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef ccl::patch-value ccl::PWGL-box ccl::nth-patch-value ccl::pwgl-outputs ccl::add-PWGL-user-menu)
	  :fe))

