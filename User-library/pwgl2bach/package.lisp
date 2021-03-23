(defpackage :PWGL2BACH (:use :cl))
(in-package :PWGL2BACH)

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef) :PWGL2BACH))