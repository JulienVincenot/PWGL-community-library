(in-package MC)

(defun access-poly-all-rhythm (rhythmfn layer1 layer2)
  (let* ((nr-of-variables-in-fn (length (system::arglist rhythmfn))))
    (if (/= 1 nr-of-variables-in-fn)
        (progn (system::pwgl-print "ERROR in access-poly-rhythm: rule should have ONE input")
          #'(lambda (indexx x) nil))
      #'(lambda (indexx x) (if (typep x 'rhythmcell)
                               (cond
                                 ((= (get-layer-nr x) layer1)
                                  (let* ((number-of-rhythms-and-pauses-in-this-layer (get-number-of-rhythms-and-pauses-at-index layer1 indexx))
                                         (this-layer-rhythm (get-durations-from-vector layer1 1 (1+ number-of-rhythms-and-pauses-in-this-layer)))
                                         (number-of-rhythms-and-pauses-in-other-layer (get-number-of-rhythms-and-pauses-at-index layer2 indexx))
                                         (other-layer-rhythm (get-durations-from-vector layer2 1 (1+ number-of-rhythms-and-pauses-in-other-layer))))

                                    (if other-layer-rhythm
                                        (apply rhythmfn (list (list this-layer-rhythm other-layer-rhythm)))
                                      t)))
                                 ((= (get-layer-nr x) layer2)
                                  (let* ((number-of-rhythms-and-pauses-in-this-layer (get-number-of-rhythms-and-pauses-at-index layer2 indexx))
                                         (this-layer-rhythm (get-durations-from-vector layer2 1 (1+ number-of-rhythms-and-pauses-in-this-layer)))
                                         (number-of-rhythms-and-pauses-in-other-layer (get-number-of-rhythms-and-pauses-at-index layer1 indexx))
                                         (other-layer-rhythm (get-durations-from-vector layer1 1 (1+ number-of-rhythms-and-pauses-in-other-layer))))

                                    (if other-layer-rhythm
                                        (apply rhythmfn (list (list other-layer-rhythm this-layer-rhythm)))
                                      t)))
                                 (t t))
                             t)))
    ))


(defun access-heuristic-poly-all-rhythm (rhythmfn layer1 layer2)
  (let* ((nr-of-variables-in-fn (length (system::arglist rhythmfn))))
    (if (/= 1 nr-of-variables-in-fn)
        (system::pwgl-print "ERROR in access-poly-rhythm: heuristic-rule should have ONE input")
      #'(lambda (indexx x) (if (typep x 'rhythmcell)
                               (cond
                                ((= (get-layer-nr x) layer1)
                                 (let* ((number-of-rhythms-and-pauses-in-this-layer (get-number-of-rhythms-and-pauses-at-index layer1 indexx))
                                        (this-layer-rhythm (get-durations-from-vector layer1 1 (1+ number-of-rhythms-and-pauses-in-this-layer)))
                                        (number-of-rhythms-and-pauses-in-other-layer (get-number-of-rhythms-and-pauses-at-index layer2 indexx))
                                        (other-layer-rhythm (get-durations-from-vector layer2 1 (1+ number-of-rhythms-and-pauses-in-other-layer))))

                                   (if other-layer-rhythm
                                       (apply rhythmfn (list (list this-layer-rhythm other-layer-rhythm)))
                                     0)))
                                ((= (get-layer-nr x) layer2)
                                 (let* ((number-of-rhythms-and-pauses-in-this-layer (get-number-of-rhythms-and-pauses-at-index layer2 indexx))
                                        (this-layer-rhythm (get-durations-from-vector layer2 1 (1+ number-of-rhythms-and-pauses-in-this-layer)))
                                        (number-of-rhythms-and-pauses-in-other-layer (get-number-of-rhythms-and-pauses-at-index layer1 indexx))
                                        (other-layer-rhythm (get-durations-from-vector layer1 1 (1+ number-of-rhythms-and-pauses-in-other-layer))))

                                   (if other-layer-rhythm
                                       (apply rhythmfn (list (list other-layer-rhythm this-layer-rhythm)))
                                     0)))
                                (t 0))
                             0)))
    ))

;;;;

(defun get-rhythms-with-offset-in-window (layer index starttime stoptime)
  "Time starts at 0"
  (let* ((tot-number-of-dur (get-number-of-rhythms-and-pauses-at-index layer index))
         (start-pointer (get-pointer-for-rhythm-at-or-before-timepoint layer starttime tot-number-of-dur))
         (stop-pointer (1+ (get-pointer-for-rhythm-at-or-before-timepoint layer (- stoptime 1/1000000) tot-number-of-dur)))
         (durations (get-durations-from-vector layer start-pointer stop-pointer))
         (first-onset (1- (abs (aref part-sol-vector layer start-pointer *ONSETTIME*))))
         (offset (- first-onset starttime)))
    (if (and durations (>= (abs (first durations)) (abs offset)))
        (list durations offset)
      nil)))



(defun access-poly-window-rhythm (rhythmfn layer1 layer2 windowsize)
  "Windowsize = windowstep"
  (let* ((nr-of-variables-in-fn (length (system::arglist rhythmfn))))
    (if (/= 1 nr-of-variables-in-fn)
        (error "ERROR in access-poly-rhythm: rule should have ONE input only.")
      #'(lambda (indexx x) (if (typep x 'rhythmcell)
                               (cond
                                ((= (get-layer-nr x) layer1)
                                 (let* ((start-this-cell (get-total-duration-rhythms-at-index layer1 (1- indexx)))
                                        (stop-this-cell (get-total-duration-rhythms-at-index layer1 indexx))
                                        (stop-other-layer (get-total-duration-rhythms-at-index layer2 indexx))
                                        (cell-size (- stop-this-cell start-this-cell))
                                        (cellsize-to-window-ratio (/ cell-size windowsize))
                                        (loop-start-time (* (truncate start-this-cell windowsize) windowsize))
                                        )
                                 
                                   (eval (append '(and)
                                                 (loop for timepoint from loop-start-time to (- stop-this-cell 1/1000000) by windowsize
                                                       collect (if (< timepoint stop-other-layer)
                                                                   (apply rhythmfn (list (list (get-rhythms-with-offset-in-window layer1 indexx timepoint (+ timepoint windowsize))
                                                                                               (get-rhythms-with-offset-in-window layer2 indexx timepoint (+ timepoint windowsize)))))
                                                                 t))))))
                                ((= (get-layer-nr x) layer2) 
                                 (let* ((start-this-cell (get-total-duration-rhythms-at-index layer2 (1- indexx)))
                                        (stop-this-cell (get-total-duration-rhythms-at-index layer2 indexx))
                                        (stop-other-layer (get-total-duration-rhythms-at-index layer1 indexx))
                                        (cell-size (- stop-this-cell start-this-cell))
                                        (cellsize-to-window-ratio (/ cell-size windowsize))
                                        (loop-start-time (* (truncate start-this-cell windowsize) windowsize))
                                        )
                                 
                                   (eval (append '(and)
                                                 (loop for timepoint from loop-start-time to (- stop-this-cell 1/1000000) by windowsize
                                                       collect (if (< timepoint stop-other-layer)
                                                                   (apply rhythmfn (list (list (get-rhythms-with-offset-in-window layer1 indexx timepoint (+ timepoint windowsize))
                                                                                               (get-rhythms-with-offset-in-window layer2 indexx timepoint (+ timepoint windowsize)))))
                                                                 t))))))
                                (t t))
                             t)))))






(defun access-heuristic-poly-window-rhythm (rhythmfn layer1 layer2 windowsize)
  "Windowsize = windowstep"
  (let* ((nr-of-variables-in-fn (length (system::arglist rhythmfn))))
    (if (/= 1 nr-of-variables-in-fn)
        (progn (system::pwgl-print "ERROR in access-poly-rhythm: rule should have ONE input")
          #'(lambda (indexx x) nil))
      #'(lambda (indexx x) (if (typep x 'rhythmcell)
                               (cond
                                ((= (get-layer-nr x) layer1)
                                 (let* ((start-this-cell (get-total-duration-rhythms-at-index layer1 (1- indexx)))
                                        (stop-this-cell (get-total-duration-rhythms-at-index layer1 indexx))
                                        (stop-other-layer (get-total-duration-rhythms-at-index layer2 indexx))
                                        (cell-size (- stop-this-cell start-this-cell))
                                        (cellsize-to-window-ratio (/ cell-size windowsize))
                                        (loop-start-time (* (truncate start-this-cell windowsize) windowsize))
                                        )
                                   
                                   (apply '+
                                          (loop for timepoint from loop-start-time to (- stop-this-cell 1/1000000) by windowsize
                                                collect (if (< timepoint stop-other-layer)
                                                            (apply rhythmfn (list (list (get-rhythms-with-offset-in-window layer1 indexx timepoint (+ timepoint windowsize))
                                                                                        (get-rhythms-with-offset-in-window layer2 indexx timepoint (+ timepoint windowsize)))))
                                                          0)))))
                                ((= (get-layer-nr x) layer2) 
                                 (let* ((start-this-cell (get-total-duration-rhythms-at-index layer2 (1- indexx)))
                                        (stop-this-cell (get-total-duration-rhythms-at-index layer2 indexx))
                                        (stop-other-layer (get-total-duration-rhythms-at-index layer1 indexx))
                                        (cell-size (- stop-this-cell start-this-cell))
                                        (cellsize-to-window-ratio (/ cell-size windowsize))
                                        (loop-start-time (* (truncate start-this-cell windowsize) windowsize))
                                        )
                                   (apply '+
                                          (loop for timepoint from loop-start-time to (- stop-this-cell 1/1000000) by windowsize
                                                collect (if (< timepoint stop-other-layer)
                                                            (apply rhythmfn (list (list (get-rhythms-with-offset-in-window layer1 indexx timepoint (+ timepoint windowsize))
                                                                                        (get-rhythms-with-offset-in-window layer2 indexx timepoint (+ timepoint windowsize)))))
                                                          0)))))
                                (t 0))
                             0)))))