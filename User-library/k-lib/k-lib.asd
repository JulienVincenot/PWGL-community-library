(in-package :ASDF)

(defsystem "k-lib"

  :description "Utils for morphological analysis"
  :long-description "Supplementary tools even complementary in the continuity of the fv-morphologie library"
  :version "1.0"
  :author "yann ics"
  :licence ""
  :maintainer "yann ics"

  ;; :serial t means that each component is only compiled, when the
  ;; predecessors are already loaded
  :serial t
  :components
  (
   (:FILE "package")
   (:FILE "utils")
   (:FILE "k-lib")
  )
  :depends-on (:ompw :by-cycle :jbs-cmi :fv-morphologie)
  )