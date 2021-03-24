(defpackage :K-LIB (:use :cl :ompw))
(in-package :K-LIB)

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef) :K-LIB))