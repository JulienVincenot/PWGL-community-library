(in-package :ASDF)

(defsystem "link-distance"
  :description "A library that calculates the distance between two chords"
  :long-description "A library that calculates the distance between two chords"
  :version "0.1"
  :author "Kilian Sprotte"
  :licence "PWGL licence"
  :maintainer "Kilian Sprotte"
  :serial t
  :components
  ((:FILE "package")
   (:FILE "link-distance")
   (:FILE "sort-chords"))
  :depends-on (:iterate :alexandria :screamer :myam))