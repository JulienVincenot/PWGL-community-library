(defpackage :SA (:use :cl))
(in-package :SA)

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef) :SA))