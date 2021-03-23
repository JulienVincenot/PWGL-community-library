(in-package :jbs-constraints)

(defclass pmc-box (ccl::PWGL-box) ())
(defclass score-pmc-box (ccl::PWGL-box) ())

(defmethod ccl::special-info-string ((self pmc-box)) "pmc")
(defmethod ccl::special-info-string ((self score-pmc-box)) "S-pmc")

