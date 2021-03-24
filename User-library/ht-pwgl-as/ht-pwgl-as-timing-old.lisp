;;;================================================================================================================;;; SuperVP Sound Processing;;; Hans Tutschku 2008;;;================================================================================================================(in-package :ht-pwgl-as)  (in-menu util);********************************************************************************************(define-box HT-PWGL-AS::randserie ((rand1min 0.2)                                    (rand1max 0.5)                                   (rand2min 0.5)                                   (rand2max 1.0)                                   (rand3min 1.0)                                   (rand3max 20)                                   (repetitions 4))   "creates three random lists"  :non-generic t  (flat   (loop for i to (- repetitions 1)         collect         (list                  (round                   (pw::g-random rand1min rand1max)           2)          (round                   (pw::g-random rand2min rand2max)           2)          (round                   (pw::g-random rand3min rand3max)           2)))));********************************************************************************************(define-box HT-PWGL-AS::timeline ((soundlength 3.0)                                   (steps 20))  "calculates the timeline - soundlength devidet by number of steps as stepsize for the arithmetic serie from 0.0 to soundlenght"  :non-generic t  (pw::g-round (pw::arithm-ser 0 (pw::g/ soundlength steps) soundlength) 3)  );********************************************************************************************(define-box time-onsets ((times (1.0 2.0 3.0 4.0)) (facts (2 1.2 1 2)))" "  :non-generic t  (loop for i to (- (length times) 2)        collect  (/ (* (- (nth (1+ i) times)                          (nth     i  times))                       (+ (nth (1+ i) facts)                          (nth     i  facts))) 2)));********************************************************************************************(define-box find-dur  ((times  (1 2 3 3.3))                            (facts  (2.0 3.3 4.4 1.0)))    "calculate duration from of <times> and <facts>"                   :non-generic t  (apply '+ (time-onsets times facts))  );********************************************************************************************(define-box find-coefs ((times  (1 2 3 3.3))                            (facts  (2.0 3.3 4.4 1.0))                            (dur    10.0))   "calculate coefficients from a <tlist> and <facts> to fit with a desired <dur>"                   :non-generic t  (pw::g* facts (pw::g/ dur (find-dur times facts)))  )  ;********************************************************************************************(in-menu time-stretch)(define-box HT-PWGL-AS::stretch-dyn-exact  ((soundlength 3.4)                                             (steps 20)                                            (newlength 5.5)                                            (filename "stretch.par"))   "creates parameterfile for random-timestretch"  :non-generic t  (let ((newfaktoren nil)(final nil)(mytimeline nil) (timeleng nil)(faktoren nil))    (setf mytimeline (pw::rem-dups                      (pw::sort-list                          (pw::g-round                            (pw::g-scaling                             (flat                          (loop for i to (- (* steps 3) 1)                                collect                                (pw::g-random 0 1000000)))                         0.0 soundlength)                        4)                       )                      '= 1))    (setf timeleng (length mytimeline))    (setf faktoren (ompw-utils::x-append (pw::firstn (pw::g- timeleng 2) (HT-PWGL-AS::randserie 0.2 0.5 0.5 1 1 20 steps)) 1 1))    ;in case that not enough timevalues without repetition could be    ;calculatet, just as many stretchvalues are taken    ;(print parampath)     (setf newfaktoren           (pw::g-round           (HT-PWGL-AS::find-coefs             mytimeline            faktoren            newlength)           4))       (setf final (mat-trans                 (list                    mytimeline                   newfaktoren)))        ;(HT-PWGL-AS::save-or-not final filename)        final    ))#|;********************************************************************************************(define-box HT-PWGL-AS::timeline-melodie ((LDUR list))    :initvals '(500 1000 500)  :indoc '("durations")  :icon 999   :doc"calculates the timeline from a list of durations"    (butlast       (rest    (pw::g-round          (om::sort.          (ompw-utils::x-append           (om::om- (om::om/ (om::dx->x 0 LDUR) 1000.0) 0.001)       (om::om/ (om::dx->x 0 LDUR) 1000.0)))     3)))  );(HT-PWGL-AS::timeline-melodie '(500 1000 500));********************************************************************************************(define-box HT-PWGL-AS::timeline-irr ((soundlength number) ;irregular timeline                                  (steps number))  :initvals '(3.0 20)  :indoc '("soundlength" "steps" )  :icon 999   :doc"calculates the timeline which has irregular intervals"      (om::remove-dup   (pw::g-round      (pw::g-scaling         (om::dx->x 0.0                   (loop for i to (- steps 2)                      collect                      (om::nth-random                        (list                         (pw::g-random 0.01 0.05)                        (pw::g-random 0.05 1)                        (pw::g-random 1.0 5)                        (pw::g-random 5.0 20)))                      )                          )               0.0 soundlength)    3)   '= 1)  );(HT-PWGL-AS::timeline-irr 3.0 10);********************************************************************************************(define-box find-coefs ((times  t)                            (facts  t)                            (dur    number))     :initvals '(nil nil nil)  :indoc '("times" "facts" "dur")  :icon 999   :doc"calculate coefficients from a <tlist> and <facts> to fit with a desired <dur>"                   (pw::g* facts (/ dur (find-dur times facts)))  )  ;(HT-PWGL-AS::find-coefs '(1 2 3 3.3) '(2.0 3.3 4.4 1.0) 10.0);********************************************************************************************(define-box HT-PWGL-AS::stretch-dyn-random2  ((soundlength number) ; ohne Fileselector                                          (steps integer)                                          (filename string)                                          (saveflag string))   :initvals '(3.4 10 "stretch.par" "save")  :indoc '("soundlength" "steps" "filename" "saveflag")  :menuins '( (3 (("save" "save") ("don't save" "don't save"))))  :icon 999  :doc"creates parameterfile for random-timestretch"  (let* ((final nil)         (faktoren (om::remove-dup                    (om::sort.                        (pw::g-round                          (pw::g-scaling                           (om::flat                        (loop for i to (- (* steps 3) 1)                              collect                              (pw::g-random 0 1000000)))                       0.0 soundlength)                      3)                     )                    '= 1))         (faktleng (length faktoren)))            (setf final (mat-trans                 (list                  faktoren                  (pw::firstn (HT-PWGL-AS::randserie 0.2 0.6 0.6 1 1 30 steps) faktleng)                  ;in case that not enough timevalues without repetition could be                  ;calculatet, just as many stretchvalues are taken                  )))        (if (string=  "don't save" saveflag)      final      (progn ()                   (HT-PWGL-AS::write-lists3 final filename)             '("saved")             ))        )  );(HT-PWGL-AS::stretch-dyn-random 3.4 10 1 );(pw::firstn (HT-PWGL-AS::randserie 0.2 0.5 0.5 1 1 20 30) 3);********************************************************************************************(define-box HT-PWGL-AS::stretch-dyn-random3  ((soundlength number) ; ohne Fileselector                                          (steps integer)                                          (filename string)                                          (saveflag string))   :initvals '(3.4 10 "stretch.par" "save")  :indoc '("soundlength" "steps" "filename" "saveflag")  :menuins '( (3 (("save" "save") ("don't save" "don't save"))))  :icon 999  :doc"creates parameterfile for random-timestretch"  (let* ((final nil)         (faktoren (om::remove-dup                    (om::sort.                        (pw::g-round                          (pw::g-scaling                           (om::flat                        (loop for i to (- (* steps 3) 1)                              collect                              (pw::g-random 0 1000000)))                       0.0 soundlength)                      3)                     )                    '= 1))         (faktleng (length faktoren)))            (setf final (mat-trans                 (list                  faktoren                  (pw::firstn (HT-PWGL-AS::randserie 0.2 0.6 0.6 1 1 30 steps) faktleng)                  ;in case that not enough timevalues without repetition could be                  ;calculatet, just as many stretchvalues are taken                  )))        (if (string=  "don't save" saveflag)      final      (progn ()                   (HT-PWGL-AS::write-lists3 final filename)             '("saved")             ))        )  );(HT-PWGL-AS::stretch-dyn-random 3.4 10 1 );(pw::firstn (HT-PWGL-AS::randserie 0.2 0.5 0.5 1 1 20 30) 3);(HT-PWGL-AS::stretch-dyn-exact 3.4 3 5.5 1 );********************************************************************************************(define-box HT-PWGL-AS::stretch-dyn-exact-loop  ((steps number)                                             (stretchfact number)                                             (filename string)                                             (soundpath string)                                              (soundname t))   :initvals '(20.0 2.0 "stretch.par" "G3-Daten02" "toto")  :indoc '("number" "number" "string" "string" "string")  :icon 999  :doc"creates parameterfile for random-timestretch"  (let* ((newfaktoren nil)(final nil)         (newsoundname (format nil "~A:~A" soundpath soundname))         (soundlength (HT-PWGL-AS::check-soundlength newsoundname))         (steps (+ 1 (* steps soundlength)))         (timeline (om::remove-dup                    (om::sort.                        (pw::g-round                          (pw::g-scaling                           (om::flat                        (loop for i to (- (* steps 3) 1)                              collect                              (pw::g-random 0 1000000)))                       0.0 soundlength)                      4)                     )                    '= 1))         (timeleng (length timeline))         (faktoren (ompw-utils::x-append (pw::firstn (HT-PWGL-AS::randserie 0.2 0.5 0.5 1 1 20 steps) (- timeleng 2)) 1 1)))    ;in case that not enough timevalues without repetition could be    ;calculatet, just as many stretchvalues are taken    (print soundlength)    (setf newfaktoren           (pw::g-round           (HT-PWGL-AS::find-coefs             timeline            faktoren            (* soundlength stretchfact))           4))        (setf final (mat-trans                 (list                    timeline                   newfaktoren)))            (let (fichier)       (delete-file filename)      (when filename)      (with-open-file  (fd filename                           :direction :output :if-exists :supersede                            :if-does-not-exist :create)        (dotimes (n (length final))          (dotimes (j (length (nth n final)))            (format fd "~D "(nth j (nth n final))))          (format fd "~%"))        ))                ));(HT-PWGL-AS::stretch-dyn-exact 3.4 3 5.5 1 );********************************************************************************************(define-box HT-PWGL-AS::marker-stretch  ((markers list)                                      (zone number)                                     (factor number)                                     (soundlength number)                                     (filename string)                                     (saveflag string)                                     )   :initvals '(( MARKERS 5 0.5 1.1 1.8 2.4 3.7) 0.1 5.0 6.0 "stretch.par" "save")  :indoc '("marker" "zone" "factor" "soundlength" "filename" "saveflag")  :menuins '( (5 (("save" "save") ("don't save" "don't save"))))  :icon 999  :doc"this patch is creating a parameterfile for Audiosculpt timestretch. Starting from a markerfile - which represents the attacks to keep untouched during stretch"    (let* ((faktoren nil)(final nil)                  (markers           (om::rest (om::rest (flat markers))))         (number (length markers))                           (vor (om::om- markers (om::om/ zone 2.0)))         (nach (om::om+ markers (om::om/ zone 2.0)))         (vorvor (om::om- vor 0.005))                  (timeline (ompw-utils::x-append 0.0                                     (pw::g-round                                      (om::rest                                   (om::sort.                                         (flat                                     (list vor nach vorvor))))                                  3)                                 soundlength)))    (setf faktoren (ompw-utils::x-append 1.0                                 (flat                                  (mat-trans                                       (list                                        (om::repeat-n 1.0 number)                                    (om::repeat-n 1.0 number)                                    (om::repeat-n factor number))))))        (setf final (mat-trans                 (list                  timeline faktoren)))    (HT-PWGL-AS::save-or-not final filename saveflag)        ))|#