(in-package MC)


;filters with the side effect that it reverses the result
;input list has to be in order
(defun fast-band-filter (low high list)
  (member high (reverse (member low list :test '<=)) :test '>=))
(defun fast-lp-filter (high list)
  (member high (reverse list)  :test '>=))



;;;RULES 
(defun hierarchy-between-layers-rule (layerhigh layerlow) 

   #'(lambda (indexx x)
       (if (typep x 'rhythmcell)
           (let* ((this-layer-nr (get-layer-nr x))
                  (start-this-cell (1+ (get-total-duration-rhythms-at-index  this-layer-nr (1- indexx)))) ;1+ to compensate for global offset 
                  (stop-this-cell (1+ (get-total-duration-rhythms-at-index  this-layer-nr indexx))) ;1+ to compensate for global offset
                  this-global-cell
                  other-layer-onset-times)
         
         (cond ((= this-layer-nr layerlow)  ;check hierarchy towards higher layer
                (setf other-layer-onset-times (get-one-rhythmlayer-at-index layerhigh indexx))
                (setf other-layer-onset-times (remove-duplicates (remove nil (mapcar #'(lambda (time) (if (minusp time) nil time)) other-layer-onset-times)))); remove pauses
                (setf this-global-cell (remove-duplicates (mapcar #'(lambda (x) (+ start-this-cell x)) (butlast (get-local-onset-without-pauses x)))))
                (subsetp 
                 (fast-band-filter start-this-cell (- stop-this-cell 1/1000) other-layer-onset-times)
                 this-global-cell)
                )
               ((= this-layer-nr layerhigh)  ;check hierarchy towards lower layer
                (setf other-layer-onset-times (get-one-rhythmlayer-at-index layerlow indexx))  
                (setf other-layer-onset-times (remove-duplicates (remove nil (mapcar #'(lambda (time) (if (minusp time) nil time)) other-layer-onset-times)))); remove pauses
                (setf this-global-cell (remove-duplicates (mapcar #'(lambda (x) (+ start-this-cell x)) (butlast (get-local-onset-without-pauses x)))))
                (subsetp 
                 (fast-lp-filter (- (1+ (get-total-duration-rhythms-at-index layerlow indexx)) 1/1000) this-global-cell) ;1+ to compensate for global offset, 1/1000 to allow optional pauses at the first position in the NEXT cell.
                 other-layer-onset-times)
                )
               (t t))                                ;the layer the variable belongs to is not included in this rule: bypass rule
         )
         t)))

(defun dx->x-keep-sign+1 (ratios)
  "Standard dx->x"
  (cons (if (minusp (car ratios))
                    -1 1)
                (loop for dx in ratios
                      for sign in (append (cdr ratios) '(1))
                      sum (abs dx) into thesum
                      collect (if (minusp sign) (- -1 thesum) (1+ thesum)))))

(dx->x-keep-sign+1 '(-1/4 1/4 1/4 -1/4))


(defun dx->x-remove-sign (ratios)
  "Standard dx->x"
  (cons 0 (loop for dx in ratios
        sum (abs dx) into thesum
        collect thesum)))

(defun dx->x-remove-negative (ratios)
  ""
  (remove nil  
          (cons (if (minusp (car ratios))
                    nil 0)
                (loop for dx in ratios
                      for sign in (append (cdr ratios) '(1))
                      sum (abs dx) into thesum
                      collect (if (minusp sign) nil thesum)))))

(defun dx->x-remove-positive (ratios)
  "Returns positions for rests (as positive values)."
  (remove nil  
          (cons (if (minusp (car ratios))
                    0 nil)
                (loop for dx in ratios
                      for sign in (cdr ratios)
                      sum (abs dx) into thesum
                      collect (if (minusp sign) thesum nil)))))

;;;;;;not ready
(defun hierarchy-between-layers-only-rests-no-gracenotes-rule (layerhigh layerlow) 
  "Only check events in lower layer towards rest onsets in higher layer."
  #'(lambda (indexx x)
      (if (typep x 'rhythmcell)
          (let* ((this-layer-nr (get-layer-nr x))
                 (start-this-cell (1+ (get-total-duration-rhythms-at-index  this-layer-nr (1- indexx)))) ;1+ to compensate for global offset 
                 (stop-this-cell (1+ (get-total-duration-rhythms-at-index  this-layer-nr indexx))) ;1+ to compensate for global offset
                 this-global-cell
                 other-layer-onset-times)
         
            (cond ((= this-layer-nr layerlow)  ;check hierarchy towards higher layer
                   (setf other-layer-onset-times (get-one-rhythmlayer-at-index layerhigh indexx))
                   (setf other-layer-onset-times (remove-duplicates (remove nil (mapcar #'(lambda (time) (if (minusp time) (- time) nil)) other-layer-onset-times)))); remove pauses
                   (setf this-global-cell (mapcar #'(lambda (x) (if (minusp x) nil (+ start-this-cell (1- x)))) (butlast (remove-duplicates (dx->x-keep-sign+1 (get-rhythmcell x)) :test #'(lambda (a b) (= (abs a) (abs b)))))))
                   (subsetp 
                    (fast-band-filter start-this-cell (- stop-this-cell 1/1000) other-layer-onset-times)
                    this-global-cell)
                   )
                  ((= this-layer-nr layerhigh)  ;check hierarchy towards lower layer
                   (setf other-layer-onset-times (remove-duplicates (get-one-rhythmlayer-at-index layerlow indexx) :test #'(lambda (a b) (= (abs a) (abs b)) ))) 
                   (setf other-layer-onset-times (remove nil (mapcar #'(lambda (time) (if (minusp time) nil time)) other-layer-onset-times))); remove pauses
                   (setf this-global-cell (mapcar #'(lambda (x) (+ start-this-cell x)) (dx->x-remove-positive (get-rhythmcell x))))
                   (subsetp 
                    (fast-lp-filter (- (1+ (get-total-duration-rhythms-at-index layerlow indexx)) 1/1000) this-global-cell) ;1+ to compensate for global offset, 1/1000 to allow optional pauses at the first position in the NEXT cell.
                    other-layer-onset-times)
                   )
                  (t t))                                ;the layer the variable belongs to is not included in this rule: bypass rule
            )
        t)))

;(remove-duplicates '(1 1 1 -1 2 2 3 -3 4 -5 6) :test #'(lambda (a b) (= (abs a) (abs b))))
;;;;;;


(defun hierarchy-between-layers-only-rests-rule (layerhigh layerlow) 
  "Only check events in lower layer towards rest onsets in higher layer."
  #'(lambda (indexx x)
      (if (typep x 'rhythmcell)
          (let* ((this-layer-nr (get-layer-nr x))
                 (start-this-cell (1+ (get-total-duration-rhythms-at-index  this-layer-nr (1- indexx)))) ;1+ to compensate for global offset 
                 (stop-this-cell (1+ (get-total-duration-rhythms-at-index  this-layer-nr indexx))) ;1+ to compensate for global offset
                 this-global-cell
                 other-layer-onset-times)
         
            (cond ((= this-layer-nr layerlow)  ;check hierarchy towards higher layer
                   (setf other-layer-onset-times (get-one-rhythmlayer-at-index layerhigh indexx))
                   (setf other-layer-onset-times (remove-duplicates (remove nil (mapcar #'(lambda (time) (if (minusp time) (- time) nil)) other-layer-onset-times)))); remove pauses
                   (setf this-global-cell (remove-duplicates (mapcar #'(lambda (x) (+ start-this-cell x)) (butlast (get-local-onset-without-pauses x)))))
                   (subsetp 
                    (fast-band-filter start-this-cell (- stop-this-cell 1/1000) other-layer-onset-times)
                    this-global-cell)
                   )
                  ((= this-layer-nr layerhigh)  ;check hierarchy towards lower layer
                   (setf other-layer-onset-times (get-one-rhythmlayer-at-index layerlow indexx))  
                   (setf other-layer-onset-times (remove-duplicates (remove nil (mapcar #'(lambda (time) (if (minusp time) nil time)) other-layer-onset-times)))); remove pauses
                   (setf this-global-cell (remove-duplicates (mapcar #'(lambda (x) (+ start-this-cell x)) (dx->x-remove-positive (get-rhythmcell x)))))
                   (subsetp 
                    (fast-lp-filter (- (1+ (get-total-duration-rhythms-at-index layerlow indexx)) 1/1000) this-global-cell) ;1+ to compensate for global offset, 1/1000 to allow optional pauses at the first position in the NEXT cell.
                    other-layer-onset-times)
                   )
                  (t t))                                ;the layer the variable belongs to is not included in this rule: bypass rule
            )
        t)))

(defun hierarchy-between-layers-include-rests-rule (layerhigh layerlow) 
   #'(lambda (indexx x)
       (if (typep x 'rhythmcell)
           (let* ((this-layer-nr (get-layer-nr x))
                  (start-this-cell (1+ (get-total-duration-rhythms-at-index  this-layer-nr (1- indexx)))) ;1+ to compensate for global offset 
                  (stop-this-cell (1+ (get-total-duration-rhythms-at-index  this-layer-nr indexx))) ;1+ to compensate for global offset
                  this-global-cell
                  other-layer-onset-times)
         (cond ((= this-layer-nr layerlow)  ;check hierarchy towards higher layer
                (setf other-layer-onset-times (get-one-rhythmlayer-at-index layerhigh indexx))
                
                (setf other-layer-onset-times (remove-duplicates (mapcar #'(lambda (time) (if (minusp time) (- time) time)) other-layer-onset-times))); remove pauses
                (setf this-global-cell (remove-duplicates (mapcar #'(lambda (x) (+ start-this-cell x)) (butlast (dx->x-remove-sign (get-rhythmcell x))))))
                (subsetp 
                 (fast-band-filter start-this-cell (- stop-this-cell 1/1000) other-layer-onset-times)
                 this-global-cell)
                )
               ((= this-layer-nr layerhigh)  ;check hierarchy towards lower layer
                (setf other-layer-onset-times (get-one-rhythmlayer-at-index layerlow indexx))  
                (setf other-layer-onset-times (remove-duplicates (mapcar #'(lambda (time) (if (minusp time) (- time) time)) other-layer-onset-times))); remove pauses
                (setf this-global-cell (remove-duplicates (mapcar #'(lambda (x) (+ start-this-cell x)) (butlast (dx->x-remove-sign (get-rhythmcell x))))))
                (subsetp 
                 (fast-lp-filter (- (1+ (get-total-duration-rhythms-at-index layerlow indexx)) 1/1000) this-global-cell) ;1+ to compensate for global offset, 1/1000 to allow optional pauses at the first position in the NEXT cell.
                 other-layer-onset-times)
                )
               (t t))                                ;the layer the variable belongs to is not included in this rule: bypass rule
         )
         t)))


(defun hierarchy-between-layers-rhythmcell-rule (layerhigh layerlow) 
  "Starttime for rhythmcell in layerlow are checked. Pauses are removed!
High layer might have less events than low layer."
  #'(lambda (indexx x)
      (if (typep x 'rhythmcell)
          (let* ((this-layer-nr (get-layer-nr x))
                 (start-this-cell (1+ (get-total-duration-rhythms-at-index  this-layer-nr (1- indexx)))) ;1+ to compensate for global offset 
                 (stop-this-cell (1+ (get-total-duration-rhythms-at-index  this-layer-nr indexx))) ;1+ to compensate for global offset
                 this-global-cell
                 other-layer-onset-times)
         
            (cond ((= this-layer-nr layerlow)  ;check hierarchy towards higher layer
                   (setf other-layer-onset-times (get-one-rhythmlayer-at-index layerhigh indexx))
                   (setf other-layer-onset-times (remove-duplicates (remove nil (mapcar #'(lambda (time) (if (minusp time) nil time)) other-layer-onset-times)))); remove pauses
                   ;(system::pwgl-print (get-local-onset-without-pauses x))
                   (if (= 0 (car (get-local-onset-without-pauses x)));if cell starts with pause - don't check
                       (subsetp 
                        (fast-band-filter start-this-cell (- stop-this-cell 1/1000) other-layer-onset-times);high layer
                        (list start-this-cell))
                     (not (fast-band-filter start-this-cell (- stop-this-cell 1/1000) other-layer-onset-times)));only true if other layer between timepoints is empty
                   )
                  ((= this-layer-nr layerhigh)  ;check hierarchy towards lower layer
                   (setf other-layer-onset-times (get-startpoint-all-rhythmcells layerlow indexx))  
                   (setf other-layer-onset-times (remove-duplicates (remove nil (mapcar #'(lambda (time) (if (minusp time) nil time)) other-layer-onset-times)))); remove pauses
                   (setf this-global-cell (remove-duplicates (mapcar #'(lambda (x) (+ start-this-cell x)) (butlast (get-local-onset-without-pauses x)))))
                  ;(system::pwgl-print (list this-global-cell other-layer-onset-times))
                   (subsetp 
                    (fast-lp-filter (- (1+ (get-total-duration-rhythms-at-index layerlow indexx)) 1/1000) this-global-cell) ;1+ to compensate for global offset, 1/1000 to allow optional pauses at the first position in the NEXT cell.
                    other-layer-onset-times)
                   )
                  (t t))                                ;the layer the variable belongs to is not included in this rule: bypass rule
            )
        t)))

;get-startpoint-all-rhythmcells (layer index)
;;;;;;;;;;Measure hierarchy - order to grid


(defun create-1beat-grid (allowed-subdivisions beatvalue)
  (let* ((beat-list (mapcar #'(lambda (x) (ratios-to-onsets-with-offset  0 (make-list x :initial-element (/ 1 beatvalue x))))
                            allowed-subdivisions))
         (grid (remove-duplicates (sort (apply 'append beat-list) '<))))
    (list beatvalue grid)))


(defun set-timesign-grids (list-of-allowed-subdivisions beatvalues)
  (let ((grids (mapcar 'create-1beat-grid list-of-allowed-subdivisions beatvalues)))
    (setf *grid-definitions-for-timesign* grids)))


;;; one rule


(defun measure-rule (rhythm-layer-nr allowed-subdivisions beatvalue)

      #'(lambda (indexx x)
          (let* ((this-layer-nr (get-layer-nr x)))
            (if (typep x 'pitchcell) t
              (cond ((typep x 'timesign)                             ;check new grid towards rhythms
                     (if (= beatvalue (cadr (get-timesign x)))       ;but only if this is the beat value the rule is for
                         (let*
                             ((start-this-measure (1+ (get-total-duration-timesigns-at-index (1- indexx))))
                              (stop-this-measure (+ start-this-measure (get-variabledur x)))
                              (local-beatlist-grid (get-onemeasure-grid (get-timesign x)))
                              (this-global-grid-abstime (mapcar #'(lambda (x) (+ x start-this-measure)) local-beatlist-grid))
                              (rhythm-layer-onset-times (get-one-rhythmlayer-at-index rhythm-layer-nr indexx)))

                           (setf rhythm-layer-onset-times (remove nil (mapcar #'(lambda (time) (if (minusp time) nil time)) rhythm-layer-onset-times))) ;remove pauses
                           (subsetp 
                            (fast-band-filter start-this-measure stop-this-measure rhythm-layer-onset-times)
                            this-global-grid-abstime))
                       t))                
                    ((= this-layer-nr rhythm-layer-nr)                     ;check new rhythm towards grid
                     (let* ((start-this-cell (1+ (get-total-duration-rhythms-at-index  this-layer-nr (1- indexx))))
                            (global-grid (get-timegrid-layer indexx))
                            (this-global-onset-time (mapcar #'(lambda (x) (+ start-this-cell x)) (get-local-onset-without-pauses x)))
                            (stop-measure-layer (1+ (get-total-duration-timesigns-at-index indexx)))) ;no pauses included


                       (subsetp 
                        (fast-lp-filter stop-measure-layer this-global-onset-time)
                        global-grid)))
                    (t t)) ;the layer the variable belongs to is not included in this rule
              ))))


;;;All rules (in loop below)

(defun measure-rules (rhythm-layer-nr allowed-subdivisions beatvalues)

;START TO SET GRID IN VARIABLE *grid-definitions-for-timesign*, THEN RULE
  (set-timesign-grids allowed-subdivisions beatvalues)
;Collect rules
  (loop for n from 0 to (1- (length beatvalues))
        collect  (measure-rule rhythm-layer-nr (nth n allowed-subdivisions) (nth n beatvalues))))

