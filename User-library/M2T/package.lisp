(defpackage :M2T (:use :cl))
(in-package :M2T)

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef) :M2T))