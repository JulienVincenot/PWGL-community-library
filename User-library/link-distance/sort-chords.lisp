(in-package :LINK-DISTANCE)

(defun arrange-by-closeness(ref c &optional rules)
  (let ((minp (- (apply #'min ref) 12))
        (maxp (+ (apply #'max ref) 12)))
    (let (all-combs
          (s-space (iter (for p2 in c)
                     (collect
                      (iter (for p3 from minp to maxp)
                        (when (= (mod p3 12) (mod p2 12))
                          (collect p3)))))))
      
      (setq all-combs
            (mapcar #'(lambda(x) (sort x '<))
                    (ccl::pmc s-space
                              rules
                              :sols-mode :all)))

      ;; (print (mapcar #'length s-space))
      (sort 
       (iter (for comb in all-combs)
         (collect
          (multiple-value-bind (distance links) (link-distance ref comb)
            (list distance comb links))))
       '<
       :key #'car))))