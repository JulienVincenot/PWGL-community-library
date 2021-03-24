(defpackage :RSMLIB (:use :cl))
(in-package :RSMLIB)

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef) :RSMLIB))