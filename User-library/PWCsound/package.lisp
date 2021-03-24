(defpackage :PWCSOUND (:use :cl))
(in-package :PWCSOUND)

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef ccl::patch-value ccl::PWGL-box ccl::nth-patch-value ccl::pwgl-outputs ccl::add-PWGL-user-menu) :PWCSOUND))





