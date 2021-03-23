(defpackage :MOTIFEXTRACTION (:use :cl))
(in-package :MOTIFEXTRACTION)

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef) :MOTIFEXTRACTION))