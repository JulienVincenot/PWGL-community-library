(in-package :asdf)(defsystem :supervp-sdif  :serial t  :components  ((:file "package")   (:file "supervp-analysis")   (:file "sdif-reader")    (:file "menus")   ):depends-on (:ompw-utils ))