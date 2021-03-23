(in-package MC)


(defun check-if-pauses-before (layer index nth-pitch)
  "Returns a list of all imediate preceeding pauses to the nth pitch. If non nil will be returned."
  (let ((local-pointer (get-localpointer-at-nthrhythm layer index nth-pitch))
        pause-before)
    (if (and local-pointer (> local-pointer 1))
        (reverse (loop while (and (> local-pointer 1)
                                  (minusp (setf pause-before (car (get-durations-from-vector layer (1- local-pointer) local-pointer)))))        
                       do (setf local-pointer (1- local-pointer))
                       collect pause-before))
      nil)))


(defun check-if-pauses-after (layer index stop-nth-pitch)
  "This function will output pauses that immediate follow the given nth event (i.e. nth pich/rhythm - not counting pauses. If it is not a pause (or if it is not assigned) nil will be returned."
  (let ((stop-local-pointer (get-localpointer-at-nthrhythm layer index stop-nth-pitch))
        next-rhythm-or-pause)
    (if stop-local-pointer
        (let ((remaining-rhythms-and-pauses (- (get-number-of-rhythms-and-pauses-at-index layer index) stop-local-pointer)))

          (loop for pointer from stop-local-pointer to (1- (get-number-of-rhythms-and-pauses-at-index layer index))
                do (setf next-rhythm-or-pause (get-durations-from-vector layer (1+ pointer) (+ 2 pointer)))
                while (minusp (car next-rhythm-or-pause))
                collect (car next-rhythm-or-pause))))))


(defun insert-0-for-pause (rlist plist)
  "Takes a rhythmlist with pauses (i.e. negative durations) and a pitchlist (with the same number of performed 
durations as the rhythm list) and inserts 0 as pitch for all pauses. If duration is nil (not assigned) the original pitch will be unaffected."
  (let ((m -1))
    (loop for r in rlist
          collect (if (and r (minusp r))
                      0
                    (progn (setf m (1+ m))
                      (nth m plist))))))


(defun strip-selection (list from-nth to-nth)
  "Return selection between from-nth to-nth."
  (loop for n from from-nth to to-nth
        collect (nth n list)))


(defun mc-mattrans (list1 list2)
  (loop for n from 0 to (1- (length list1))
        collect (list (nth n list1) (nth n list2))))

(defun remove-not-assignd-and-rest (pair-list)
  "Filter out all pairs starting with the first that contains nil."
  (loop for n from 0 to (1- (length pair-list))
        while (and (first (nth n pair-list)) (second (nth n pair-list)))
        collect (nth n pair-list)))

(defun filter-remove-pauses (pair-list)
  (remove 0 pair-list :test #'(lambda (value n) (if (and (first n) (= (first n) value)) t))))

(defun filter-keep-all (pair-list)
  pair-list)

;(get-number-of-pitches-at-index 0 7)
;(1+ (- 1 1 2))

(defun pitch-and-rhythm-rule (rulefn layers filter-fn)
  (let* ((nr-of-variables-in-fn (length (system::arglist rulefn))))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (= (get-layer-nr x) layer)
                                             (typecase x
                                               (pitchcell (let* ((number-of-events-in-cell (get-nr-of-events x))
                                                                 (number-of-pitches-in-layer (get-number-of-pitches-at-index layer indexx))
                                                                 (start-nth-pitch (1+ (- number-of-pitches-in-layer number-of-events-in-cell nr-of-variables-in-fn)));include events before this cell
                                                                 )
                                                            (if (minusp start-nth-pitch) (let ((nr-of-pauses+1 (get-localpointer-at-nthrhythm layer indexx 0)))
                                                                                           (if (and nr-of-pauses+1 (>= (1- nr-of-pauses+1) (abs start-nth-pitch)))  (setf start-nth-pitch 0))))
                                                            (if (>= start-nth-pitch 0)
                                                                (let* ((stop-nth-pitch (1- number-of-pitches-in-layer))
                                                                       (preceeding-pauses (check-if-pauses-before layer indexx start-nth-pitch))
                                                                       (following-pauses (check-if-pauses-after layer indexx stop-nth-pitch))
                                                                       (rhythms-and-pauses-this-cell (append preceeding-pauses
                                                                                                             (get-rhythm-for-pitches-include-nil layer indexx start-nth-pitch stop-nth-pitch)
                                                                                                             following-pauses))
                                                                       (pitches-this-cell-no-pause (get-pitches-between-nths-when-all-exist layer indexx 
                                                                                                                                            start-nth-pitch 
                                                                                                                                            stop-nth-pitch))
                                                                       (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                       (pitch-and-dur-pairs (remove-not-assignd-and-rest 
                                                                                             (apply filter-fn (list
                                                                                                               (mc-mattrans pitches-this-cell rhythms-and-pauses-this-cell))))))
                                                          
                                                        
                                                                  (eval (append '(and)
                                                                                (loop for n from 0 to (- (length pitch-and-dur-pairs) nr-of-variables-in-fn) 
                                                                                      collect (if (apply rulefn (strip-selection pitch-and-dur-pairs n (+ n (1- nr-of-variables-in-fn)))) t)))))

                                                              t)))


                                               (rhythmcell (let* ((first-pitch-in-cell (get-number-of-rhythms-at-index layer (1- indexx)))
                                                                  (number-of-needed-pitches-in-layer (get-number-of-rhythms-at-index layer indexx))
                                                                  (first-rhythm-or-pause-in-cell (get-number-of-rhythms-and-pauses-at-index layer (1- indexx)))
                                                                  (number-of-rhythm-and-pause (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                  (start-nth-rhythm-or-pause (1+ (- first-rhythm-or-pause-in-cell nr-of-variables-in-fn))))
                                                             (if (minusp start-nth-rhythm-or-pause) (setf start-nth-rhythm-or-pause 0))
                                                             (if (>= number-of-rhythm-and-pause nr-of-variables-in-fn)
                                                                 (let* ((start-pitch-pointer (1+ (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer start-nth-rhythm-or-pause))) ;nth+1
                                                                        (stop-pitch-pointer (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer number-of-rhythm-and-pause))     ;nth+1
                                                                        (pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer start-pitch-pointer stop-pitch-pointer indexx))
                                                                        (rhythms-and-pauses-this-cell (get-durations-from-vector layer (1+ start-nth-rhythm-or-pause) (1+ number-of-rhythm-and-pause)))
                                                                        (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                        (pitch-and-dur-pairs (remove-not-assignd-and-rest 
                                                                                              (apply filter-fn (list
                                                                                                                (mc-mattrans pitches-this-cell rhythms-and-pauses-this-cell))))))

                                                                   (eval (append '(and)
                                                                                 (loop for n from 0 to (- (length pitch-and-dur-pairs) nr-of-variables-in-fn) 
                                                                                       collect (if (apply rulefn (strip-selection pitch-and-dur-pairs n (+ n (1- nr-of-variables-in-fn)))) t)))))
                                                              
                                                   
                                                               t)))
                                               (t t)
                                               )
                                           t)
                        )))))




(defun pitch-and-rhythm-include-not-assigned-rule (rulefn layers filter-fn)
  (let* ((nr-of-variables-in-fn (length (system::arglist rulefn))))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (= (get-layer-nr x) layer)
                                             (typecase x
                                               (pitchcell (let* ((number-of-events-in-cell (get-nr-of-events x))
                                                                 (number-of-pitches-in-layer (get-number-of-pitches-at-index layer indexx))
                                                                 (start-nth-pitch (1+ (- number-of-pitches-in-layer number-of-events-in-cell nr-of-variables-in-fn)));include events before this cell
                                                                 preceeding-notassigned-nils)
                                                            (if (< start-nth-pitch 0) (progn 
                                                                                        (setf preceeding-notassigned-nils (make-list (abs start-nth-pitch) :initial-element '(nil nil)))
                                                                                        (setf start-nth-pitch 0)))
                                                            (let* ((stop-nth-pitch (1- number-of-pitches-in-layer))
                                                                   (preceeding-pauses (check-if-pauses-before layer indexx start-nth-pitch))
                                                                   (following-pauses (check-if-pauses-after layer indexx stop-nth-pitch))
                                                                   (rhythms-and-pauses-this-cell (append preceeding-pauses
                                                                                                         (get-rhythm-for-pitches-include-nil layer indexx start-nth-pitch stop-nth-pitch)
                                                                                                         following-pauses))
                                                                   (pitches-this-cell-no-pause (get-pitches-between-nths-when-all-exist layer indexx 
                                                                                                                                        start-nth-pitch 
                                                                                                                                        stop-nth-pitch))
                                                                   (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                   (pitch-and-dur-pairs (append preceeding-notassigned-nils
                                                                                                (remove-not-assignd-and-rest 
                                                                                                 (apply filter-fn (list
                                                                                                                   (mc-mattrans pitches-this-cell rhythms-and-pauses-this-cell)))))))
                                                          
                                                        
                                                              (eval (append '(and)
                                                                            (loop for n from 0 to (- (length pitch-and-dur-pairs) nr-of-variables-in-fn) 
                                                                                  collect (if (apply rulefn (strip-selection pitch-and-dur-pairs n (+ n (1- nr-of-variables-in-fn)))) t)))))

                                                            ))

                                               (rhythmcell (let* ((first-pitch-in-cell (get-number-of-rhythms-at-index layer (1- indexx)))
                                                                  (number-of-needed-pitches-in-layer (get-number-of-rhythms-at-index layer indexx))
                                                                  (first-rhythm-or-pause-in-cell (get-number-of-rhythms-and-pauses-at-index layer (1- indexx)))
                                                                  (number-of-rhythm-and-pause (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                  (start-nth-rhythm-or-pause (1+ (- first-rhythm-or-pause-in-cell nr-of-variables-in-fn)))
                                                                  preceeding-notassigned-nils)
                                                             (if (< start-nth-rhythm-or-pause 0) (progn 
                                                                                                   (setf preceeding-notassigned-nils (make-list (abs start-nth-rhythm-or-pause) :initial-element '(nil nil)))
                                                                                                   (setf start-nth-rhythm-or-pause 0)))
                                                             (let* ((start-pitch-pointer (1+ (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer start-nth-rhythm-or-pause))) ;nth+1
                                                                    (stop-pitch-pointer (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer number-of-rhythm-and-pause))     ;nth+1
                                                                    (pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer start-pitch-pointer stop-pitch-pointer indexx))
                                                                    (rhythms-and-pauses-this-cell (get-durations-from-vector layer (1+ start-nth-rhythm-or-pause) (1+ number-of-rhythm-and-pause)))
                                                                    (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                    (pitch-and-dur-pairs (append preceeding-notassigned-nils
                                                                                                 (remove-not-assignd-and-rest 
                                                                                                  (apply filter-fn (list
                                                                                                                    (mc-mattrans pitches-this-cell rhythms-and-pauses-this-cell)))))))

                                                               (eval (append '(and)
                                                                             (loop for n from 0 to (- (length pitch-and-dur-pairs) nr-of-variables-in-fn) 
                                                                                   collect (if (apply rulefn (strip-selection pitch-and-dur-pairs n (+ n (1- nr-of-variables-in-fn)))) t)))))
                                                              
                                                   
                                                             ))
                                               (t t)
                                               )
                                           t)
                        )))))




           
      

(defun pitch-and-rhythm-heuristic-rule (rulefn layers filter-fn)
  (let* ((nr-of-variables-in-fn (length (system::arglist rulefn))))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (= (get-layer-nr x) layer)
                                             (typecase x
                                               (pitchcell (let* ((number-of-events-in-cell (get-nr-of-events x))
                                                                 (number-of-pitches-in-layer (get-number-of-pitches-at-index layer indexx))
                                                                 (start-nth-pitch (1+ (- number-of-pitches-in-layer number-of-events-in-cell nr-of-variables-in-fn)));include events before this cell
                                                                 )
                                                            (if (minusp start-nth-pitch) (let ((nr-of-pauses+1 (get-localpointer-at-nthrhythm layer indexx 0)))
                                                                                           (if (and nr-of-pauses+1 (>= (1- nr-of-pauses+1) (abs start-nth-pitch)))  (setf start-nth-pitch 0))))
                                                            (if (>= start-nth-pitch 0)
                                                                (let* ((stop-nth-pitch (1- number-of-pitches-in-layer))
                                                                       (preceeding-pauses (check-if-pauses-before layer indexx start-nth-pitch))
                                                                       (following-pauses (check-if-pauses-after layer indexx stop-nth-pitch))
                                                                       (rhythms-and-pauses-this-cell (append preceeding-pauses
                                                                                                             (get-rhythm-for-pitches-include-nil layer indexx start-nth-pitch stop-nth-pitch)
                                                                                                             following-pauses))
                                                                       (pitches-this-cell-no-pause (get-pitches-between-nths-when-all-exist layer indexx 
                                                                                                                                            start-nth-pitch 
                                                                                                                                            stop-nth-pitch))
                                                                       (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                       (pitch-and-dur-pairs (remove-not-assignd-and-rest 
                                                                                             (apply filter-fn (list
                                                                                                               (mc-mattrans pitches-this-cell rhythms-and-pauses-this-cell))))))
                                                          
                                                        
                                                                  (apply '+ (loop for n from 0 to (- (length pitch-and-dur-pairs) nr-of-variables-in-fn) 
                                                                                  collect (apply rulefn (strip-selection pitch-and-dur-pairs n (+ n (1- nr-of-variables-in-fn)))))))

                                                              0)))

                                               (rhythmcell (let* ((first-pitch-in-cell (get-number-of-rhythms-at-index layer (1- indexx)))
                                                                  (number-of-needed-pitches-in-layer (get-number-of-rhythms-at-index layer indexx))
                                                                  (first-rhythm-or-pause-in-cell (get-number-of-rhythms-and-pauses-at-index layer (1- indexx)))
                                                                  (number-of-rhythm-and-pause (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                  (start-nth-rhythm-or-pause (1+ (- first-rhythm-or-pause-in-cell nr-of-variables-in-fn))))
                                                             (if (minusp start-nth-rhythm-or-pause) (setf start-nth-rhythm-or-pause 0))
                                                             (if (>= number-of-rhythm-and-pause nr-of-variables-in-fn)
                                                                 (let* ((start-pitch-pointer (1+ (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer start-nth-rhythm-or-pause))) ;nth+1
                                                                        (stop-pitch-pointer (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer number-of-rhythm-and-pause))     ;nth+1
                                                                        (pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer start-pitch-pointer stop-pitch-pointer indexx))
                                                                        (rhythms-and-pauses-this-cell (get-durations-from-vector layer (1+ start-nth-rhythm-or-pause) (1+ number-of-rhythm-and-pause)))
                                                                        (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                        (pitch-and-dur-pairs (remove-not-assignd-and-rest 
                                                                                              (apply filter-fn (list
                                                                                                                (mc-mattrans pitches-this-cell rhythms-and-pauses-this-cell))))))

                                                                   (apply '+ (loop for n from 0 to (- (length pitch-and-dur-pairs) nr-of-variables-in-fn) 
                                                                                   collect (apply rulefn (strip-selection pitch-and-dur-pairs n (+ n (1- nr-of-variables-in-fn)))))))
                                                              
                                                   
                                                               0)))
                                               (t 0)
                                               )
                                           0)
                        )))))


(defun pitch-and-rhythm-include-not-assigned-heuristic-rule (rulefn layers filter-fn)
  (let* ((nr-of-variables-in-fn (length (system::arglist rulefn))))
    (if (not (typep layers 'list)) (setf layers (list layers)))
    (loop for n from 0 to (1- (length layers))
          collect (let ((layer (nth n layers)))
                    #'(lambda (indexx x) (if (= (get-layer-nr x) layer)
                                             (typecase x
                                               (pitchcell (let* ((number-of-events-in-cell (get-nr-of-events x))
                                                                 (number-of-pitches-in-layer (get-number-of-pitches-at-index layer indexx))
                                                                 (start-nth-pitch (1+ (- number-of-pitches-in-layer number-of-events-in-cell nr-of-variables-in-fn)));include events before this cell
                                                                 preceeding-notassigned-nils)
                                                            (if (< start-nth-pitch 0) (progn 
                                                                                        (setf preceeding-notassigned-nils (make-list (abs start-nth-pitch) :initial-element '(nil nil)))
                                                                                        (setf start-nth-pitch 0)))
                                                            (let* ((stop-nth-pitch (1- number-of-pitches-in-layer))
                                                                   (preceeding-pauses (check-if-pauses-before layer indexx start-nth-pitch))
                                                                   (following-pauses (check-if-pauses-after layer indexx stop-nth-pitch))
                                                                   (rhythms-and-pauses-this-cell (append preceeding-pauses
                                                                                                         (get-rhythm-for-pitches-include-nil layer indexx start-nth-pitch stop-nth-pitch)
                                                                                                         following-pauses))
                                                                   (pitches-this-cell-no-pause (get-pitches-between-nths-when-all-exist layer indexx 
                                                                                                                                        start-nth-pitch 
                                                                                                                                        stop-nth-pitch))
                                                                   (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                   (pitch-and-dur-pairs (append preceeding-notassigned-nils
                                                                                                (remove-not-assignd-and-rest 
                                                                                                 (apply filter-fn (list
                                                                                                                   (mc-mattrans pitches-this-cell rhythms-and-pauses-this-cell)))))))
                                                          
                                                        
                                                              (apply '+ (loop for n from 0 to (- (length pitch-and-dur-pairs) nr-of-variables-in-fn) 
                                                                              collect (apply rulefn (strip-selection pitch-and-dur-pairs n (+ n (1- nr-of-variables-in-fn)))))))))

                                                            

                                               (rhythmcell (let* ((first-pitch-in-cell (get-number-of-rhythms-at-index layer (1- indexx)))
                                                                  (number-of-needed-pitches-in-layer (get-number-of-rhythms-at-index layer indexx))
                                                                  (first-rhythm-or-pause-in-cell (get-number-of-rhythms-and-pauses-at-index layer (1- indexx)))
                                                                  (number-of-rhythm-and-pause (get-number-of-rhythms-and-pauses-at-index layer indexx))
                                                                  (start-nth-rhythm-or-pause (1+ (- first-rhythm-or-pause-in-cell nr-of-variables-in-fn)))
                                                                  preceeding-notassigned-nils)
                                                             (if (< start-nth-rhythm-or-pause 0) (progn 
                                                                                                   (setf preceeding-notassigned-nils (make-list (abs start-nth-rhythm-or-pause) :initial-element '(nil nil)))
                                                                                                   (setf start-nth-rhythm-or-pause 0)))
                                                             (let* ((start-pitch-pointer (1+ (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer start-nth-rhythm-or-pause))) ;nth+1
                                                                    (stop-pitch-pointer (get-nr-of-pitches-at-pointer-for-rhythms-and-pauses layer number-of-rhythm-and-pause))     ;nth+1
                                                                    (pitches-this-cell-no-pause (get-pitches-from-vector-include-nil layer start-pitch-pointer stop-pitch-pointer indexx))
                                                                    (rhythms-and-pauses-this-cell (get-durations-from-vector layer (1+ start-nth-rhythm-or-pause) (1+ number-of-rhythm-and-pause)))
                                                                    (pitches-this-cell (insert-0-for-pause rhythms-and-pauses-this-cell pitches-this-cell-no-pause))
                                                                    (pitch-and-dur-pairs (append preceeding-notassigned-nils
                                                                                                 (remove-not-assignd-and-rest 
                                                                                                  (apply filter-fn (list
                                                                                                                    (mc-mattrans pitches-this-cell rhythms-and-pauses-this-cell)))))))

                                                               (apply '+ (loop for n from 0 to (- (length pitch-and-dur-pairs) nr-of-variables-in-fn) 
                                                                               collect (apply rulefn (strip-selection pitch-and-dur-pairs n (+ n (1- nr-of-variables-in-fn)))))))))
                                                              
                                                   
                                                        
                                               (t 0)
                                               )
                                           0)
                        )))))