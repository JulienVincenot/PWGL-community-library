(in-package :ASDF)

(defsystem "pwgl2bach"

  :description "a bridge between PWGL and the MaxMSP bach externals"
  :long-description "pwgl2bach is PWGL user-library that provides a collection of boxes and functionality to interact with the MaxMSP bach externals. bach is a completely independent project by composers Andrea Agostini and Daniele Ghisi. It's an automated composer's helper comprising of a cross-platform set of patches and externals for Max, aimed to bring the richness of computer-aided composition into the real-time world.
 
bach is distributed as freeware (see, http://www.bachproject.net/)"
  :version "0.4 28/5/2012"
  :author "Mika Kuuskankare and Daniele Ghisi"
  :licence ""
  :maintainer "Mika Kuuskankare"

  ;; :serial t means that each component is only compiled, when the
  ;; predecessors are already loaded
  :serial t
  :components
  ((:FILE "package")
   (:FILE "pwgl2bach")
   (:FILE "menus")))