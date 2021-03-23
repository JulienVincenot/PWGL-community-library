(cl::defpackage  :SDIF
  (:use :cl))
(in-package :SDIF)

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef) :SDIF))
