(defpackage :FDSDB_XXTH_CT (:use :cl :ksquant :iterate))
(in-package :FDSDB_XXTH_CT)

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef) :FDSDB_XXTH_CT))