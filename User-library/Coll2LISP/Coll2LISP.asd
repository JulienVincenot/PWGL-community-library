(in-package :ASDF)

(defsystem "Coll2LISP"

  :description "Turns coll txt files into lists of lists."
  :long-description "Turns coll txt files (from MaxMSP or Pure Data) into lists of lists. This can be pretty useful, even in parallel of OSC or SDIF functions within PWGL."
  :version "0.2"
  :author "J. Vincenot / F. Voisin / K. Sprotte"
  :licence ""
  :maintainer "J. Vincenot"

  ;; :serial t means that each component is only compiled, when the
  ;; predecessors are already loaded
  :serial t
  :components
  (
   (:FILE "package")
   (:FILE "Coll2LISP") 
   (:FILE "menus")
   (:FILE "standard-lisp-code")	
))