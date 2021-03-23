(in-package :asdf)

(defsystem :hanstools
  :serial t
  :components
  ((:file "package")
   (:file "hanstools"))
  :depends-on (:ompw :ompw-utils))



