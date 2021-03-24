(in-package :FDSDB_XXTH_CT)

;;; just write as much plain lisp as you want

;;; you can also define macros

;; just make sure that this file
;; is listed before the file where
;; those macros are actually used
;; in the ASDF system definition file

;;;;;;;;;;;;;;;;;;;;;;;
;;funzione fattoriale;;
;;;;;;;;;;;;;;;;;;;;;;;

(defun fac (n) (cond ((= n 0) 1) (t (* n (fac (- n 1))))))