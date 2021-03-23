(in-package MC)

(defun filter-elements-from-start-to-nth (list nth)
  (setf nth (1+ nth))
       (loop for n from 0
             for l in list
             until (= n nth)
             collect (nth n list)))

(defun lock-timesign-rule (predefined-timesign-seq)
 #'(lambda (indexx x) (if (= (get-layer-nr x) *TIMESIGNLAYER*)
                          (let* ((timesigns-in-sol (get-timesigns-upto-index indexx))
                                 (nr-of-measures (length timesigns-in-sol))
                                 (nr-of-predefind-measures (length predefined-timesign-seq))
                                 (predefined-timesig-to-test (filter-elements-from-start-to-nth predefined-timesign-seq (1- nr-of-measures))))
                            
                            (if (<= nr-of-measures nr-of-predefind-measures)
                                (equal predefined-timesig-to-test timesigns-in-sol)
                              t))
                        t)))


;;;

(defun access-timesigns-rule (fn)
  (let* ((nr-of-variables-in-fn (length (system::arglist fn))))
 #'(lambda (indexx x) (if (= (get-layer-nr x) *TIMESIGNLAYER*)
                          (let* ((timesigns-in-sol (get-timesigns-upto-index indexx))
                                 (nr-of-measures (length timesigns-in-sol)))
                            (if (>= nr-of-measures nr-of-variables-in-fn)
                                (apply fn (nthcdr (- nr-of-measures nr-of-variables-in-fn) timesigns-in-sol))
                              t))
                        t))))


(defun access-timesigns-heuristic-rule (fn)
  (let* ((nr-of-variables-in-fn (length (system::arglist fn))))
 #'(lambda (indexx x) (if (= (get-layer-nr x) *TIMESIGNLAYER*)
                          (let* ((timesigns-in-sol (get-timesigns-upto-index indexx))
                                 (nr-of-measures (length timesigns-in-sol)))
                            (if (>= nr-of-measures nr-of-variables-in-fn)
                                (apply fn (nthcdr (- nr-of-measures nr-of-variables-in-fn) timesigns-in-sol))
                              0))
                        0))))




(defun fix-nr-of-measures (nr-of-measures)
  "This rule fixes the number of measures to a predefined number. All timesigns have to be calculated before anything else.
There is a risk for contradictins in connection with other rules."
  #'(lambda (indexx x) (let ((nr-of-measures-in-sol (length (remove nil (get-timesigns-upto-index indexx)))))
                         (if (> nr-of-measures nr-of-measures-in-sol) 
                             (= (get-layer-nr x) *TIMESIGNLAYER*)
                           (if (= nr-of-measures nr-of-measures-in-sol) ;special case - either a timesign fills ot, or the timesignlayer is ready
                               t
                             (/= (get-layer-nr x) *TIMESIGNLAYER*))
                           ))
      ))
  


