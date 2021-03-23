;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-

(asdf:defsystem pwgl-fenv
  :description "This library defines ways to use numerical functions as envelopes. It provides a rich set of functions to generate, combine and transform these envelopes." 
  :author "Torsten Anders"
  :version "0.1"
  :serial t ;; the dependencies are linear.
  :components ((:file "sources/make-package")
	       ;; (:file "sources/macros") -- these macros are not needed in visual language
	       (:file "sources/fenv")
	       ;; (:file "sources/random-distribution")
	       ;; (:file "sources/plot")
	       ;; (:file "sources/in-cm")
	       (:file "sources/export") 
	       (:file "sources/menus"))
  :depends-on (; "gnuplot" 
	       ))

