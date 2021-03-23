(defpackage :GENETICALGORITHM (:use :cl))
(in-package :GENETICALGORITHM)

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef) :GENETICALGORITHM))