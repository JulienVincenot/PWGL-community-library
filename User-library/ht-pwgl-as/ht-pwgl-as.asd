(in-package :asdf)

(defsystem :ht-pwgl-as
  :name "ht-pwgl-as"
  :description "ht-pwgl-as"
  :author "Hans Tutschku"
  :version "0.8"
  :serial t
  :components
  ((:file "package")
   (:file "ht-pwgl-as-menu")
   (:file "set-path")
   (:file "ht-pwgl-as-timing")
   (:file "ht-pwgl-as-processing")
   (:file "ht-pwgl-as-partials")
   (:file "ht-pwgl-as-util")
   (:file "ht-pwgl-as-transpose")
   (:file "ht-pwgl-as-install-menu")
   )
  :depends-on (:ompw :ompw-utils :sdif-svp))



