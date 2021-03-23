(defpackage :coll2lisp (:use :cl))
(in-package :coll2lisp)

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef) ::coll2lisp))