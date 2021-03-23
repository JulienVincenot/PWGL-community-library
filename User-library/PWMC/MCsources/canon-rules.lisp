(in-package MC)

(defun fast-band-filter-w-pauses (low high list)
  (member high (reverse (member low list :test #'(lambda (x y) (<= x (abs y))))) :test #'(lambda (x y) (>= x (abs y)))))

(defun fast-lp-filter-w-pauses (high list)
  (member high (reverse list)  :test #'(lambda (x y) (>= x (abs y)))))

(defun fast-lp-filter-w-pauses-not-equal (high list)
  "as fast-lp-filter-w-pauses but limit is not included in answer"
  (member high (reverse list)  :test #'(lambda (x y) (>= x (abs y)))))




(defun rcanon-rule (layercomes layerdux offset) 
  

   #'(lambda (indexx x)
(if (typep x 'pitchcell) t
       (let ((this-layer-nr (get-layer-nr x)))
         
         (cond ((= this-layer-nr layercomes)
                (let* ((start-this-cell (1+ (get-total-duration-rhythms-at-index  layercomes (1- indexx))))
                       (stop-this-cell (+ start-this-cell (get-variabledur x)))
                       (dux-onset-times (fast-band-filter-w-pauses (- start-this-cell offset) (- stop-this-cell offset) (get-one-rhythmlayer-at-index layerdux indexx)))
                       (comes-onset-times (ratios-to-onsets-with-offset (- start-this-cell offset) (get-rhythmcell x)))
                       (total-dur-dux (1+ (get-total-duration-rhythms-at-index layerdux indexx))))
	
                  (if (equal (first dux-onset-times) (-  (car (last comes-onset-times)))) ;first dux since it is reversed (side effect of filter)
                      (setf dux-onset-times (append (last comes-onset-times) (cdr dux-onset-times)))) ; reverse list
                  (setf comes-onset-times (fast-lp-filter-w-pauses total-dur-dux comes-onset-times)) ;remove values that do not exist in dux
        
                  (if (< start-this-cell (1+ offset))
                      t
                    (equal dux-onset-times comes-onset-times))))

         ((= this-layer-nr layerdux)
          (let* ((start-this-cell (1+ (get-total-duration-rhythms-at-index  layerdux (1- indexx))))
                 (stop-this-cell (+ start-this-cell (get-variabledur x)))
                 (comes-onset-times (fast-band-filter-w-pauses (+ start-this-cell offset) (+ stop-this-cell offset) (get-one-rhythmlayer-at-index layercomes indexx)))
                 (dux-onset-times (ratios-to-onsets-with-offset (+ start-this-cell offset) (get-rhythmcell x)))
                 (total-dur-comes (1+ (get-total-duration-rhythms-at-index layercomes indexx))))
	
            (if (equal (first comes-onset-times) (-  (car (last dux-onset-times)))) ;first dux since it is reversed (side effect of filter)
                (setf comes-onset-times (append (last dux-onset-times) (cdr comes-onset-times)))) ;reverse list
            
            (setf dux-onset-times (fast-lp-filter-w-pauses total-dur-comes dux-onset-times)) ;remove values that do not exist in comes
            (equal dux-onset-times comes-onset-times)))
           (t t))
         ))))


(defun rcanon-rule-pausestart (layercomes layerdux offset) 


   #'(lambda (indexx x)
(if (typep x 'pitchcell) t
       (let ((this-layer-nr (get-layer-nr x)))
         
         (cond ((= this-layer-nr layercomes)
                (let* ((start-this-cell (1+ (get-total-duration-rhythms-at-index  layercomes (1- indexx))))
                       (stop-this-cell (+ start-this-cell (get-variabledur x)))
                       (dux-onset-times (fast-band-filter-w-pauses (- start-this-cell offset) (- stop-this-cell offset) (get-one-rhythmlayer-at-index layerdux indexx)))
                       (comes-onset-times (ratios-to-onsets-with-offset (- start-this-cell offset) (get-rhythmcell x)))
                       (total-dur-dux (1+ (get-total-duration-rhythms-at-index layerdux indexx))))
	
                  (if (equal (first dux-onset-times) (-  (car (last comes-onset-times)))) ;first dux since it is reversed (side effect of filter)
                      (setf dux-onset-times (append (last comes-onset-times) (cdr dux-onset-times)))) ; reverse list
                  (setf comes-onset-times (fast-lp-filter-w-pauses total-dur-dux comes-onset-times)) ;remove values that do not exist in dux
        
                  (if (< start-this-cell (1+ offset));below test is the only difference from the rule above. The test will force events before offset to be pauses
                      (find 0
                            (fast-lp-filter-w-pauses-not-equal (1+ offset) (ratios-to-onsets-with-offset start-this-cell (get-rhythmcell x)))
                            :test '>)
                    (equal dux-onset-times comes-onset-times))))

         ((= this-layer-nr layerdux)
          (let* ((start-this-cell (1+ (get-total-duration-rhythms-at-index  layerdux (1- indexx))))
                 (stop-this-cell (+ start-this-cell (get-variabledur x)))
                 (comes-onset-times (fast-band-filter-w-pauses (+ start-this-cell offset) (+ stop-this-cell offset) (get-one-rhythmlayer-at-index layercomes indexx)))
                 (dux-onset-times (ratios-to-onsets-with-offset (+ start-this-cell offset) (get-rhythmcell x)))
                 (total-dur-comes (1+ (get-total-duration-rhythms-at-index layercomes indexx))))
	
            (if (equal (first comes-onset-times) (-  (car (last dux-onset-times)))) ;first dux since it is reversed (side effect of filter)
                (setf comes-onset-times (append (last dux-onset-times) (cdr comes-onset-times)))) ;reverse list
            
            (setf dux-onset-times (fast-lp-filter-w-pauses total-dur-comes dux-onset-times)) ;remove values that do not exist in comes
            (equal dux-onset-times comes-onset-times)))
           (t t))
         ))))

;;;-----
(defun scale-rhythmlayer-start-at-1 (onsets factor)
  "1 must be the reference point from where the scaling starts (not necessary included)"
      (mapcar #'(lambda (onset)  (if (minusp onset) (1- (* factor (1+ onset))) (1+ (* factor (1- onset)))))  onsets))

(defun shift-rhythmlayer (onsets offset)
  (mapcar #'(lambda (onset)  (if (minusp onset) (- onset offset) (+ onset offset))) onsets))


(defun r-timescaled-canon-rule (layercomes layerdux offset factor) 
  "Factor is how many times slower comes is than dux"

(if (= factor 0) (progn (ccl::pwgl-print "WARNING: Factor in canon rule can not be 0")
                   #'(lambda (xx x) nil))

   #'(lambda (indexx x)
       (let ((this-layer-nr (get-layer-nr x)))
         
(if (typep x 'pitchcell) t
         (cond ((= this-layer-nr layercomes);
                (let* ((start-this-cell (1+ (get-total-duration-rhythms-at-index  layercomes (1- indexx))))
                       (stop-this-cell (+ start-this-cell (get-variabledur x)))
                       (dux-onset-times (fast-band-filter-w-pauses (- start-this-cell offset) (- stop-this-cell offset) (scale-rhythmlayer-start-at-1 (get-one-rhythmlayer-at-index layerdux indexx) factor)))
                       (comes-onset-times (ratios-to-onsets-with-offset (- start-this-cell offset) (get-rhythmcell x)))
                       (total-dur-dux (get-total-duration-rhythms-at-index layerdux indexx))) ; start at 0!!
	
                  (if (equal (first dux-onset-times) (-  (car (last comes-onset-times)))) ;first dux since it is reversed (side effect of filter)
                      (setf dux-onset-times (append (last comes-onset-times) (cdr dux-onset-times)))) ; reverse list
                  (setf comes-onset-times (fast-lp-filter-w-pauses (1+ (* total-dur-dux factor)) comes-onset-times)) ;remove values that do not exist in dux
                 
                  
                  (if (< start-this-cell (1+ offset))
                      t
                    (equal dux-onset-times comes-onset-times))))

         ((= this-layer-nr layerdux);
          (let* ((start-this-cell (1+ (get-total-duration-rhythms-at-index  layerdux (1- indexx))))
                 (stop-this-cell (+ start-this-cell (get-variabledur x)))
                 (comes-onset-times (fast-band-filter-w-pauses (+ (1+ (* (1- start-this-cell) factor)) offset) 
                                                               (+ (1+ (* (1- stop-this-cell) factor)) offset) 
                                                               (get-one-rhythmlayer-at-index layercomes indexx)))
                 (dux-onset-times (shift-rhythmlayer
                                   (scale-rhythmlayer-start-at-1 
                                    (ratios-to-onsets-with-offset start-this-cell (get-rhythmcell x)) 
                                    factor)
                                   offset))
                 (total-dur-comes (1+ (get-total-duration-rhythms-at-index layercomes indexx))))
	
            (if (equal (first comes-onset-times) (-  (car (last dux-onset-times)))) ;first dux since it is reversed (side effect of filter)
                (setf comes-onset-times (append (last dux-onset-times) (cdr comes-onset-times)))) ;reverse list
             
            (setf dux-onset-times (fast-lp-filter-w-pauses total-dur-comes dux-onset-times)) ;remove values that do not exist in comes
             
            
            (equal dux-onset-times comes-onset-times)))
           (t t))
         )))))


(defun r-timescaled-canon-rule-pausestart (layercomes layerdux offset factor) 
  "Factor is how many times slower comes is than dux"

(if (= factor 0) (progn (ccl::pwgl-print "WARNING: Factor in canon rule can not be 0")
                   #'(lambda (xx x) nil))

   #'(lambda (indexx x)
       (let ((this-layer-nr (get-layer-nr x)))
         
(if (typep x 'pitchcell) t
         (cond ((= this-layer-nr layercomes);
                (let* ((start-this-cell (1+ (get-total-duration-rhythms-at-index  layercomes (1- indexx))))
                       (stop-this-cell (+ start-this-cell (get-variabledur x)))
                       (dux-onset-times (fast-band-filter-w-pauses (- start-this-cell offset) (- stop-this-cell offset) (scale-rhythmlayer-start-at-1 (get-one-rhythmlayer-at-index layerdux indexx) factor)))
                       (comes-onset-times (ratios-to-onsets-with-offset (- start-this-cell offset) (get-rhythmcell x)))
                       (total-dur-dux (get-total-duration-rhythms-at-index layerdux indexx))) ; start at 0!!
	
                  (if (equal (first dux-onset-times) (-  (car (last comes-onset-times)))) ;first dux since it is reversed (side effect of filter)
                      (setf dux-onset-times (append (last comes-onset-times) (cdr dux-onset-times)))) ; reverse list
                  (setf comes-onset-times (fast-lp-filter-w-pauses (1+ (* total-dur-dux factor)) comes-onset-times)) ;remove values that do not exist in dux
                 
                  
                  (if (< start-this-cell (1+ offset));below test is the only difference from the rule above. The test will force events before offset to be pauses
                      (find 0
                            (fast-lp-filter-w-pauses-not-equal (1+ offset) (ratios-to-onsets-with-offset start-this-cell (get-rhythmcell x)))
                            :test '>)
                    (equal dux-onset-times comes-onset-times))))

         ((= this-layer-nr layerdux);
          (let* ((start-this-cell (1+ (get-total-duration-rhythms-at-index  layerdux (1- indexx))))
                 (stop-this-cell (+ start-this-cell (get-variabledur x)))
                 (comes-onset-times (fast-band-filter-w-pauses (+ (1+ (* (1- start-this-cell) factor)) offset) 
                                                               (+ (1+ (* (1- stop-this-cell) factor)) offset) 
                                                               (get-one-rhythmlayer-at-index layercomes indexx)))
                 (dux-onset-times (shift-rhythmlayer
                                   (scale-rhythmlayer-start-at-1 
                                    (ratios-to-onsets-with-offset start-this-cell (get-rhythmcell x)) 
                                    factor)
                                   offset))
                 (total-dur-comes (1+ (get-total-duration-rhythms-at-index layercomes indexx))))
	
            (if (equal (first comes-onset-times) (-  (car (last dux-onset-times)))) ;first dux since it is reversed (side effect of filter)
                (setf comes-onset-times (append (last dux-onset-times) (cdr comes-onset-times)))) ;reverse list
             
            (setf dux-onset-times (fast-lp-filter-w-pauses total-dur-comes dux-onset-times)) ;remove values that do not exist in comes
             
            
            (equal dux-onset-times comes-onset-times)))
           (t t))
         )))))