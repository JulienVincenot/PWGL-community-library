(in-package :ASDF)

(defsystem :sa
	:name "sa"
  :depends-on (:sdif)
  :description "An interface to supervp and pm2 analysis engines"
  :long-description "An interface to supervp and pm2 analysis engines. Requires that the user has an access to the sound analysis kernels supervp and pm2 distributed by IRCAM."
  :version "1.0"
  :author "Mika Kuuskankare"
  :licence ""
  :maintainer "Mika Kuuskankare"

  ;; :serial t means that each component is only compiled, when the
  ;; predecessors are already loaded
  :serial t
  :components
  (
   (:FILE "package")
   (:FILE "SA")
   (:FILE "menu")))