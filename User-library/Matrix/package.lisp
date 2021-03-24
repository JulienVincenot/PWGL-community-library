(defpackage :MATRIX  (:use "COMMON-LISP"))
(in-package :MATRIX)

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef) :MATRIX))