
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                    ;;;
;;;                        FS-TOOLS for PWGL                           ;;;
;;;                                                                    ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                    ;;;
;;;                                                                    ;;;
;;; Copyright (c) 2016, Filippo Saya. All rights reserved.             ;;;
;;;                                                                    ;;;
;;; Redistribution and use in source and binary forms, with or without ;;;
;;; modification, are permitted provided that the following conditions ;;;
;;; are met:                                                           ;;;
;;;                                                                    ;;;
;;;   * Redistributions of source code must retain the above copyright ;;;
;;;     notice, this list of conditions and the following disclaimer.  ;;;
;;;                                                                    ;;;
;;;   * Redistributions in binary form must reproduce the above        ;;;
;;;     copyright notice, this list of conditions and the following    ;;;
;;;     disclaimer in the documentation and/or other materials         ;;;
;;;     provided with the distribution.                                ;;;
;;;                                                                    ;;;
;;; THIS SOFTWARE IS PROVIDED BY THE AUTHOR 'AS IS' AND ANY EXPRESSED  ;;;
;;; OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED  ;;;
;;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ;;;
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY    ;;;
;;; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL ;;;
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE  ;;;
;;; GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS      ;;;
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,       ;;;
;;; WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING          ;;;
;;; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS ;;;
;;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.       ;;;
;;;                                                                    ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                    ;;;;;;;;;;;;;;;;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ARITHMETIC ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                    ;;;;;;;;;;;;;;;;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(in-package :fs-tools)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; round&remainder ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defclass fs-round&remainder (fs-tools) ())



(defmethod patch-value ((self fs-round&remainder) output)
  (let ((pos (position output (pwgl-outputs self))))
    (nth-output-patch-value self pos)))



(defmethod nth-output-patch-value ((self fs-round&remainder) (out (eql 0)))
  (round&remainder-result (nth-patch-value self 0)
                      (nth-patch-value self 1)
                      (nth-patch-value self 2)
                      (nth-patch-value self 3)))



(defmethod nth-output-patch-value ((self fs-round&remainder) (out (eql 1)))
  (round&remainder-remainder (nth-patch-value self 0)
                         (nth-patch-value self 1)
                         (nth-patch-value self 2)
                         (nth-patch-value self 3)))



;; ragionare su possibile formula più elegante, e cmq risolvere il problema del remainder sporco
(defun round&remainder-result (x round-fn decimals y)
  (let ((places (expt 10 decimals)))
    (if (zerop decimals)
        (system::g/ (funcall round-fn
                             (system::g*
                              places
                              (system::g/ x y)))
                    places)
        (deep-mapcar #'float
                     (system::g/ (funcall round-fn
                                          (system::g*
                                           places
                                           (system::g/ x y)))
                                 places)))))



(defun round&remainder-remainder  (x round-fn decimals y)
    (pw::g- x (round&remainder-result x round-fn decimals y)))



(pwgldef round&remainder ((x '(1.1 (3 9.99 (1.5))))
                         (round-fn () (ccl::mk-menu-subview :menu-list
                                                            '(("round" pw::g-round)
                                                              ("floor" pw::g-floor)
                                                              ("ceiling" pw::g-ceiling))))
                         (decimals 0)
                         (y 1))
         "
It combines the various rounding functions and returns both X rounding result (divided by Y) according to ROUND-FN, and the remainder.
With DECIMALS you can choose the number of decimal places of the result.
X and Y can be number, number list or number tree."

         (:class 'fs-round&remainder
          :outputs '("result" "remainder")
          :groupings '(1 1 2)
          :w 0.5)

         ())



;;; end of round&remainder ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef list-lcm ((integer-list (list 2 4 3)))
         "
It returns the Least Common Multiple of all numbers of LIST."

         (:class 'fs-tools)

         (cond ((null integer-list) nil)
               ((single integer-list) (car integer-list))
               (t (lcm (car integer-list) (list-lcm (cdr integer-list))))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(pwgldef list-gcd ((integer-list (list 4 6)))
         "
It returns the Greatest Common Divisor of all numbers of LIST."

         (:class 'fs-tools)

         (cond ((null integer-list) nil)
               ((single integer-list) (car integer-list))
               (t (gcd (car integer-list) (list-gcd (cdr integer-list))))))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; END OF FILE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


