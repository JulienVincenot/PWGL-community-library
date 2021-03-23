(in-package :asdf)

(defsystem :zosc
  ;; :serial t means that each component is only compiled, when the
  ;; predecessors are already loaded
  :serial t
  :author "josé henrique padovani"
  :maintainer "http://zpadovani.info"
  :description "A lib based on OpenMusic 6.1 solution to create OSC connections. Requires cl-osc, lispworks-udp and has a modified version of OM 6.1 file oscoverudp.lisp. In other words: you can connect PWGL with other applications and languages (SuperCollider, PD, Processing, etc.) over OSC."
  :version "0.31"
  :license "copyleft/GNU-GPL"
  :components
  ((:static-file "zosc.asd")
   (:file "package")
   (:file "oscoverudp")(:file "zoscthings")(:file "menus"))
  :depends-on (:osc :lispworks-udp :ompw))

