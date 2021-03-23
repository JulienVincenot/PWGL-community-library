(in-package :ccl)

(defmethod calc-viuhka-current-bpf ((ind symbol) bpfs)
  (if (null ind)
      ()
    (nth (random (length bpfs)) bpfs)))