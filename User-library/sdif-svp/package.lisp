(cl::defpackage  :SDIF-SVP
  (:use :cl))
(in-package :SDIF-SVP)

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef) :SDIF-SVP))
