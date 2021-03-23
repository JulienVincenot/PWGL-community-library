(in-package mc)


(defclass PWGL-box-MCscore (ccl::PWGL-box) ())

(defmethod ccl::patch-value ((self PWGL-box-MCscore) outbox)
  (declare (ignore outbox))
  (let ((solution (ccl::nth-patch-value self "solution"))
        (tempo (ccl::nth-patch-value self "tempo"))
        (pitch? (ccl::box-string (ccl::find-by-nick-name self :pitch?)))
        (rhythm? (ccl::box-string (ccl::find-by-nick-name self :rhythm?)))
        (measure? (ccl::box-string (ccl::find-by-nick-name self :measure?)))
        (exclude-voices (ccl::nth-patch-value self "exclude voices"))
        old-score new-score filtered-solution)
  
    (if exclude-voices (system::pwgl-print "Some layers are set to be filtered by the MC decode box."))
    (setf new-score (ccl::make-score  (mc::decode-pmc3 solution tempo pitch? rhythm? measure? exclude-voices)))
    (setf old-score (ccl::application-window (ccl::find-by-nick-name self :sol-score)))
    (setf (ccl::parts old-score) (ccl::parts new-score))
    (ccl::redraw (ccl::subview (ccl::application-window (ccl::find-by-nick-name self :sol-score))))
    (ccl::application-window (ccl::find-by-nick-name self :sol-score))))


(defgeneric MCdecode ()  (:documentation "This box decodes the output from the multi-pmc and displays it as a score. 
It is possible to set the tempo in the displayed score (this does not affect 
the search process in any way).

Three buttons change the behaviour of the score:

all pitches/pitches with rhythms: sets if only pitches with their durations 
should be displayed, or if pitches that have no duration should be included. 
In the latter case, these pitches will be printed last, in an extra bar, as 
whole notes.

all durations/rhythm with pitch: sets if only durations with their pitches
should be displayed, or if durations that have no pitch should be included.
In the latter case, these will be displayed with x-noteheads.

fill sequence/bars from pmc: sets if only music inside bars that where found
by the pmc should be printed, or if the display should provide default 
time signatures for the music.

The exclude-voices input gives the option to list layernrs for layers that
should not be printed in the score. If this inpt is nil, all layers
will be included."))


(defun button-pitch-setting (b)
    (setf (ccl::box-string b) (if (equalp (ccl::box-string b) "all pitches") "pitch w. rhythm" "all pitches")))

(defun button-rhythm-setting (b)
    (setf (ccl::box-string b) (if (equalp (ccl::box-string b) "all durations")
"rhythm w. pitch" "all durations")))

(defun button-measures-setting (b)
    (setf (ccl::box-string b) (if (equalp (ccl::box-string b) "full sequence")
"bars from pmc" "full sequence")))



(defmethod ccl::mk-box-function ((self (eql 'MCdecode)) x y)
  (ccl::mk-PW-box   'PWGL-box-MCscore 'MCdecode "MC decode" x y 1.5 0.5
               (list 
                (ccl::mk-value-subview :value nil :doc-string "solution")
                (ccl::mk-value-subview :value 96 :doc-string "tempo")
                (ccl::mk-button-subview :box-string"all pitches"  :r 0.7 :g 0.75 :b 0.7 :pwgl-action-function 'button-pitch-setting :pwgl-nick-name :pitch?)
                (ccl::mk-button-subview :box-string"all durations"  :r 0.7 :g 0.75 :b 0.7 :pwgl-action-function 'button-rhythm-setting :pwgl-nick-name :rhythm?)
                (ccl::mk-button-subview :box-string"full sequence"  :r 0.7 :g 0.75 :b 0.7 :pwgl-action-function 'button-measures-setting :pwgl-nick-name :measure?) 
                (ccl::mk-value-subview :value nil :doc-string "exclude voices")

                (ccl::mk-score-subview :application-window (ccl::make-enp-application-window '(((()))))  :doc-string "" :pwgl-nick-name :sol-score) 
                )
               :groupings '(6 1)
               :x-proportions '((1 1 2 2 2 1) (1))
               :y-proportions '((:fix 0.06) 10)
               :r 0.5 :g 0.6 :b 0.6
               ))

(defmethod ccl::playable-box? ((self PWGL-box-MCscore)) t)
(defmethod ccl::play-PWGL-box ((self PWGL-box-MCscore))
  (let ((score (ccl::application-window (ccl::find-by-nick-name self :sol-score))))
    (ccl::ENP-play/stop-midi-notes score)))

;;

(defclass PWGL-box-MCdebug (ccl::PWGL-box) ())


(defmethod ccl::patch-value ((self PWGL-box-MCdebug) outbox)
  (declare (ignore outbox))
   (ccl::application-window (ccl::find-by-nick-name self :sol-score)))



(defgeneric MCdebug ()  (:documentation "This is a tool to display what happend during the last search. The inputs 
should not be connected.

The main control is the slider on the top. By dragging the slider to the 
left, you step back in history from the final solution (or where you 
interrupted the last search). When you move the slider, the history index 
displays how far back you are from the found solution (max 100 steps).

The pmc-index shows how far the search process had reached at the displayed
point.

The score diplays the temporary solution at the history-index. By double 
clicking the score, you can open a bigger score and set the display the 
usual way (see the PWGL manual). "))

(defun history-slider (slider)
  (let* ((container (ccl::pwgl-view-container slider))
         old-score new-score)  
    (ccl::set-curval (ccl::find-by-nick-name container :history-index) (format nil "~A" (ccl::curval slider)))
    (ccl::set-curval (ccl::find-by-nick-name container :pmc-index) (format nil "~A" (get-pmcindex-at-historyindex (ccl::curval slider))))
    (setf new-score (ccl::make-score  (mc::read-historic-solution (ccl::curval slider) 96)))
    (if new-score
        (progn
          (setf old-score (ccl::application-window (ccl::find-by-nick-name container :sol-score)))
          (setf (ccl::parts old-score) (ccl::parts new-score))
          (ccl::redraw (ccl::subview (ccl::application-window (ccl::find-by-nick-name container :sol-score))))))
    ))


(defun history-value (value)
  (let* ((container (ccl::pwgl-view-container value))) 
    (ccl::set-curval (ccl::find-by-nick-name container :history-index2) (ccl::curval value))
    (ccl::set-curval (ccl::find-by-nick-name container :pmc-index) (format nil "~A" (get-pmcindex-at-historyindex (ccl::curval value))))
    (setf new-score (ccl::make-score  (mc::read-historic-solution (ccl::curval value) 96)))
    (if new-score
        (progn
          (setf old-score (ccl::application-window (ccl::find-by-nick-name container :sol-score)))
          (setf (ccl::parts old-score) (ccl::parts new-score))
          (ccl::redraw (ccl::subview (ccl::application-window (ccl::find-by-nick-name container :sol-score))))))))

;(redraw (subview xxxx))  xxxx = application-window

(defmethod ccl::mk-box-function ((self (eql 'MCdebug)) x y)
  (ccl::mk-PW-box   'PWGL-box-MCdebug 'MCdebug "MC debug" x y 1.5 0.5
               (list 
                (ccl::mk-value-subview :value 1 :minval 1 :stepval 1  :doc-string "pmc-index" :pwgl-nick-name :pmc-index)
                (ccl::mk-value-subview :value -1 :minval -99 :maxval -1 :stepval 1  :doc-string "history-index" :pwgl-nick-name :history-index :pwgl-action-function 'history-value)
                (ccl::mk-slider-subview :value -1 :minval -99 :maxval -1 :number-of-decimals 0 :horizontal t :grid t :pwgl-nick-name :history-index2 :pwgl-action-function 'history-slider)

                (ccl::mk-score-subview :application-window (ccl::make-enp-application-window '(((()))))  :doc-string "" :pwgl-nick-name :sol-score)
                )
               :groupings '(3 1)
               :x-proportions '((0.8 0.8 10)(1))
               :y-proportions '((:fix 0.06) 10)
               :r 0.5 :g 0.6 :b 0.6
               ))


(defmethod ccl::playable-box? ((self PWGL-box-MCdebug)) t)
(defmethod ccl::play-PWGL-box ((self PWGL-box-MCdebug))
  (let ((score (ccl::application-window (ccl::find-by-nick-name self :sol-score))))
    (ccl::ENP-play/stop-midi-notes score)))

;;;;;;;;;

;(aref *debug-vector* (1- (- history-index)) 1)
;get-pmcindex-at-historyindex