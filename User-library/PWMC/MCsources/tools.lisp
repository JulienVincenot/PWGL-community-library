(in-package MC)


(defun get-nr-of-events-including-this ()
  (typecase *this-variable*
      (rhythmcell (get-number-of-rhythms-and-pauses-at-index (get-layer-nr *this-variable*)  (ccl::cur-index)))
      (pitchcell (get-number-of-pitches-at-index (get-layer-nr *this-variable*) (ccl::cur-index)))
      (timesign (length (get-timesigns-upto-index (ccl::cur-index))))))
  

