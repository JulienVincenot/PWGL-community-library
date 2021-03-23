(in-package :cl-user)

(eval-when (:compile-toplevel :load-toplevel :execute)
  ;; here we should have all the symbols from below
  ;; but as strings (uppercase, please...)
  (dolist (name '("M" "?IF"  "?1" "?2" "?3" "?4" "?5" "?6" "?7"
		  "?8" "?9" "?10" "?11" "?12" "?13" "?14" "?15" "?16" "?17" "?18" "?19" "?20" "?21" "?22" "?23" "?24" "?25" "?26" "?27" "?28" "?29" "?30" "?31" "?32" "?33" "?34" "?35" "?36" "?37" "?38" "?39" "?40" "?41" "?42" "?43" "?44" "?45" "?46" "?47" "?48" "?49" "?50" "?51" "?52" "?53" "?54" "?55" "?56" "?57" "?58" "?59" "?60" "?61" "?62" "?63" "?64" "?65" "?66" "?67" "?68" "?69" "?70" "?71" "?72" "?73" "?74" "?75" "?76" "?77" "?78" "?79" "?80" "?81" "?82" "?83" "?84" "?85" "?86" "?87" "?88" "?89" "?90" "?91" "?92" "?93" "?94" "?95" "?96" "?97" "?98" "?99" "?100" "E" "RL" "L"))
    (intern name (find-package "CCL"))))

(defpackage :jbs-constraints
  (:documentation "This is the jbs-constraints package.")
  (:use :cl :ompw)
  (:import-from :ccl ccl::m ccl::?if CCL::?1 CCL::?2 CCL::?3 CCL::?4 CCL::?5 CCL::?6 CCL::?7 CCL::?8 CCL::?9 CCL::?10 CCL::?11 CCL::?12 CCL::?13 CCL::?14 CCL::?15 CCL::?16 CCL::?17 CCL::?18 CCL::?19 CCL::?20 CCL::?21 CCL::?22 CCL::?23 CCL::?24 CCL::?25 CCL::?26 CCL::?27 CCL::?28 CCL::?29 CCL::?30 CCL::?31 CCL::?32 CCL::?33 CCL::?34 CCL::?35 CCL::?36 CCL::?37 CCL::?38 CCL::?39 CCL::?40 CCL::?41 CCL::?42 CCL::?43 CCL::?44 CCL::?45 CCL::?46 CCL::?47 CCL::?48 CCL::?49 CCL::?50 CCL::?51 CCL::?52 CCL::?53 CCL::?54 CCL::?55 CCL::?56 CCL::?57 CCL::?58 CCL::?59 CCL::?60 CCL::?61 CCL::?62 CCL::?63 CCL::?64 CCL::?65 CCL::?66 CCL::?67 CCL::?68 CCL::?69 CCL::?70 CCL::?71 CCL::?72 CCL::?73 CCL::?74 CCL::?75 CCL::?76 CCL::?77 CCL::?78 CCL::?79 CCL::?80 CCL::?81 CCL::?82 CCL::?83 CCL::?84 CCL::?85 CCL::?86 CCL::?87 CCL::?88 CCL::?89 CCL::?90 CCL::?91 CCL::?92 CCL::?93 CCL::?94 CCL::?95 CCL::?96 CCL::?97 CCL::?98 CCL::?99 CCL::?100 ccl::e ccl::rl ccl::l)
  (:export
   ))


;;;       JBS-CONSTRAINTS for PWGL

;;; Copyright (c) 2009, Jacopo Baboni Schilingi.  All rights reserved.
;;; Copyright (c) 2007, Kilian Sprotte.  All rights reserved.

;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:

;;;   * Redistributions of source code must retain the above copyright
;;;     notice, this list of conditions and the following disclaimer.

;;;   * Redistributions in binary form must reproduce the above
;;;     copyright notice, this list of conditions and the following
;;;     disclaimer in the documentation and/or other materials
;;;     provided with the distribution.

;;; THIS SOFTWARE IS PROVIDED BY THE AUTHOR 'AS IS' AND ANY EXPRESSED
;;; OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
;;; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
;;; GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
;;; WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.