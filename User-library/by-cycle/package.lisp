(defpackage :BY-CYCLE (:use :cl :ompw))
(in-package :BY-CYCLE)

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef) :BY-CYCLE))