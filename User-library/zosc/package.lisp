(defpackage :zosc
  (:documentation "A translation of OM 6 OSCoverUDP file to PWGL")
  (:use :cl :osc :ompw)
  (:export
)
)
(in-package :zosc)

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef) :zosc))
