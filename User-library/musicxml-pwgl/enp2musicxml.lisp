;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Coding:utf-8 -*-

;;; This file is part of MusicXML-PWGL.

;;; Copyright (c) 2010 - 2011, Kilian Sprotte. All rights reserved.

;;; This program is free software: you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation, either version 3 of the License, or
;;; (at your option) any later version.

;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.

;;; You should have received a copy of the GNU General Public License
;;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(in-package #:musicxml-pwgl.enp2musicxml)

;;;# specials
(defvar *accidental-store*)
(defvar *tuplet-store*)
(defvar *slur-store*)
(defvar *wedge-store*)
(defvar *dynamic-store*)

;;;# preferences
#-pwgl(defvar *tuplet-show-bracket* t)
#+pwgl(ccl::def-pwgl-library-preference *tuplet-show-bracket* t
        :musicxml-pwgl :editor-type :boolean)

#-pwgl(defvar *eighth-tone-encoding* nil)
#+pwgl(ccl::def-pwgl-library-preference *eighth-tone-encoding* nil
        :musicxml-pwgl :editor-type :boolean)

(defun preferences-env ()
  `(*tuplet-show-bracket*
    ,*tuplet-show-bracket*
    *eighth-tone-encoding*
    ,*eighth-tone-encoding*))

;;;# enp2musicxml
(defun accidental-alter (accidental)
  (if (and *eighth-tone-encoding* (rationalp accidental))
      (* 2 accidental)
      (if *eighth-tone-encoding*
          (ecase accidental
            (quarter-sharp 1/2)
            (three-quarters-sharp 3/2)
            (quarter-flat -1/2)
            (three-quarters-flat -3/2)
            (sharp 1)
            (flat -1)
            (natural 0))
          (ecase accidental
            (quarter-sharp 0.5)
            (three-quarters-sharp 1.5)
            (quarter-flat -0.5)
            (three-quarters-flat -1.5)
            (sharp 1)
            (flat -1)
            (natural 0)))))

(defun decode-midi (midi enharmonic)
  (declare (type (or accidental ratio) enharmonic))
  (let ((diatonic-pitch (truncate (- midi (accidental-alter enharmonic)))))
    (values (ecase (mod diatonic-pitch 12)
              (0 'c) (2 'd) (4 'e)
              (5 'f) (7 'g) (9 'a) (11 'b))
            (if *eighth-tone-encoding*
                (* 4 (accidental-alter enharmonic))
                (accidental-alter enharmonic))
            (1- (floor diatonic-pitch 12)))))

(defun decode-note (note)
  (declare (type note* note))
  (decode-midi
   (note-pitch note)
   (enp-note-accidental note)))

(defun convert-note2pitch (note)
  (multiple-value-bind (step alter octave)
      (decode-note note)
    (pitch step alter octave)))

(defun enp-note-accidental (note)
  (labels ((compute-acc (note enharmonic)
             (let ((pitch (note-pitch note)))
               (when *eighth-tone-encoding*
                 (assert (rationalp pitch)))
               (cond ((diatonic-pitch-p pitch) :natural)
                     ((integerp pitch)
                      (or enharmonic :sharp))
                     ((diatonic-pitch-p (- pitch (* 2 1/8)))
                      (case enharmonic
                        (:flat -7/8)
                        (t 1/8)))
                     ((diatonic-pitch-p (- pitch (* 2 3/8)))
                      (case enharmonic
                        (:flat -5/8)
                        (t 3/8)))
                     ((diatonic-pitch-p (- pitch (* 2 5/8)))
                      (case enharmonic
                        (:flat -3/8)
                        (t 5/8)))
                     ((diatonic-pitch-p (- pitch (* 2 7/8)))
                      (case enharmonic
                        (:flat -1/8)
                        (t 7/8)))
                     ((and (diatonic-pitch-p (truncate (+ pitch 0.5)))
                           (eql enharmonic :flat))
                      :quarter-flat)
                     ((diatonic-pitch-p (truncate (- pitch 0.5)))
                      (case enharmonic
                        (:flat :three-quarters-flat)
                        (t :quarter-sharp)))
                     ((diatonic-pitch-p (truncate (- pitch 1.5)))
                      :three-quarters-sharp)
                     (t (error "cannot determine default accidental for ~S"
                               note)))))
           (diatonic-pitch-p (midi)
             (and (integerp midi)
                  (member (mod midi 12)
                          '(0 2 4 5 7 9 11)))))
    (let ((acc)
          (enharmonic (and (consp note)
                           (getf (cdr note) :enharmonic))))
      (setq acc
            (case (setq acc (compute-acc note enharmonic))
              (:natural 'natural)
              (:sharp 'sharp)
              (:quarter-sharp 'quarter-sharp)
              (:quarter-flat 'quarter-flat)
              (:three-quarters-sharp 'three-quarters-sharp)
              (:three-quarters-flat 'three-quarters-flat)
              (:flat 'flat)
              (t acc)))
      (multiple-value-bind (integer epsilon)
          (round (- (note-pitch note) (accidental-alter acc)))
        (assert (< (abs epsilon) 0.001d0))
        (assert (diatonic-pitch-p integer)))
      acc)))

(defun register-note (note)
  (multiple-value-bind (step alter octave)
      (decode-note note)
    (register-accidental *accidental-store*
                         step octave alter)))

(defun beam-begin-continue-end (info)
  (let ((beam-continue (1-to-n (apply #'min (info-beaming info)))))
    (values (set-difference
             (1-to-n (second (info-beaming info)))
             beam-continue)
            beam-continue
            (set-difference
             (1-to-n (first (info-beaming info)))
             beam-continue))))

(defun convert-note (info unit-dur chord &optional next-chord state note)
  "A single function for creating a rest or an individual note of a chord."
  (let ((not-rest note)
        (time-modification (info-cumulative-tuplet-ratio info))
        (abs-dur (info-abs-dur info)))
    (multiple-value-bind (type dots)
        (abs-dur-name (* time-modification abs-dur))
      (multiple-value-bind (beam-begin beam-continue beam-end)
          (beam-begin-continue-end info)
        (let ((duration (/ abs-dur unit-dur))
              (time-modification*
                (unless (= 1 time-modification)
                  (time-modification (numerator time-modification)
                                     (denominator time-modification)
                                     nil)))
              (notations
                `(,@(mapcar (lambda (tuplet)
                              (tuplet 'stop
                                      (tuplet-number *tuplet-store*
                                                     (tuplet-key tuplet))))
                            (info-ending-tuplets info))
                  ,@(mapcar (lambda (tuplet)
                              (register-tuplet *tuplet-store*
                                               (tuplet-key tuplet))
                              (let* ((tuplet-ratio
                                       (tuplet-tuplet-ratio tuplet))
                                     (tuplet-type (tuplet-type tuplet))
                                     (tuplet-type-if-different
                                       (if (eql tuplet-type type)
                                           nil
                                           tuplet-type)))
                                (tuplet 'start
                                        (tuplet-number *tuplet-store*
                                                       (tuplet-key tuplet))
                                        (first tuplet-ratio)
                                        tuplet-type-if-different
                                        (second tuplet-ratio)
                                        tuplet-type-if-different
                                        (if *tuplet-show-bracket*
                                            'yes 'no))))
                            (info-starting-tuplets info))
                  ,@(convert-expressions chord next-chord))))
          (note (if not-rest
                    (convert-note2pitch note)
                    (rest*))
                duration
                type
                dots
                (when (and not-rest (register-note note))
                  (if *eighth-tone-encoding*
                      'unspecific
                      (enp-note-accidental note)))
                :time-modification time-modification*
                :beam-continue beam-continue
                :beam-end beam-end
                :beam-begin beam-begin
                :notations notations
                ;; not-rest
                :chordp (when not-rest (not (mapcar-state-firstp state)))
                :tie-stop
                (and not-rest
                     (chord-tied-p chord)
                     (not (note-attack-p note)))
                :tie-start
                (when (and not-rest next-chord)
                  (and (chord-tied-p next-chord)
                       (let ((chord-note (find-note-in-chord note next-chord)))
                         (and chord-note
                              (not (note-attack-p chord-note))))))))))))

(defun convert-grace-note (chord next-chord)
  (lambda (state note)
    (note (convert-note2pitch note)
          nil
          'eighth
          0
          (when (register-note note) (enp-note-accidental note))
          :gracep t
          :chordp (not (mapcar-state-firstp state))
          :notations `(,@(convert-expressions chord next-chord)))))

(defun convert-expressions (chord next-chord)
  (declare (type chord chord))
  (labels ((convert-articulation (expression)
             (list
              (case (atom-or-first expression)
                (:accent        :|accent|)
                (:accent-grave  :|strong-accent|)
                (:staccato      :|staccato|)
                (:tenuto        :|tenuto|)
                (:staccatissimo :|staccatissimo|)
                (:breath-mark   :|breath-mark|)
                (t (return-from convert-articulation)))))
           (convert-articulations (chord)
             (let ((list (mapcan #'convert-articulation
                                 (chord-expressions chord))))
               (and list `((:|articulations| ,@list)))))
           (slur-p (keyword)
             (eql :slur (keyword-without-id keyword)))
           (slur-expressions (chord)
             (remove-if-not #'slur-p
                            (mapcar #'atom-or-first
                                    (chord-expressions chord))))
           (make-slur (number type)
             `((:|slur| :|number| ,(ts number) :|type| ,type)))
           (convert-slurs (chord)
             (mapcan (lambda (slur)
                       (if (and next-chord
                                (member slur (slur-expressions next-chord)))
                           ;; we know that is starts or continues
                           (let ((number (register-slur *slur-store* slur)))
                             (and number
                                  (list (make-slur number "start"))))
                           ;; we know that we have to stop it
                           (list
                            (make-slur
                             (unregister-slur *slur-store* slur) "stop"))))
                     (slur-expressions chord))))
    (append (convert-slurs chord)
            (convert-articulations chord))))

(defun convert-dynamics (chord next-chord)
  (declare (type chord chord))
  (labels ((make-wedge (number type)
             (direction-type
              (list `((:|wedge| :|number| ,(ts number)
                        :|type| ,type))))))
    (let* ((dynamics (chord-dynamics chord))
           (wedges (chord-wedges chord))
           (direction-content
             (append
              (mapcan (lambda (wedge)
                        (if (and next-chord
                                 (member wedge (chord-wedges next-chord)))
                            ;; we know that is starts or continues
                            (let ((number (register-wedge *wedge-store* wedge)))
                              (and number
                                   (list
                                    (make-wedge
                                     number
                                     (string-downcase
                                      (symbol-name
                                       (keyword-without-id wedge)))))))
                            ;; we know that we have to stop it
                            (list
                             (make-wedge
                              (unregister-wedge *wedge-store* wedge) "stop"))))
                      wedges)
              (mapcar (lambda (dynamic)
                        (direction-type
                         (list (dynamic (keyword-without-id dynamic)))))
                      (register-dynamics *dynamic-store* dynamics)))))
      (when direction-content
        (list (direction direction-content))))))

(defun convert-chord (unit-dur)
  (lambda (state info)
    (let ((chord (info-chord info))
          (next-chord (when (mapcar-state-next state)
                        (info-chord (mapcar-state-next state)))))
      (append
       (convert-dynamics chord next-chord)
       (cond ((info-grace-p info)
              (mapcar-state (convert-grace-note chord next-chord)
                            (chord-notes chord)))
             ((chord-rest-p chord)
              (list (convert-note info unit-dur chord)))
             (t
              (mapcar-state
               (lambda (state note)
                 (convert-note info unit-dur chord next-chord state note))
               (chord-notes chord))))))))

(defun convert-measure (clefs)
  (lambda (state measure)
    (declare (type mapcar-state state)
             (type measure measure))
    (labels ((previous ()
               (mapcar-state-previous state))
             (when-changed (reader)
               (when (or (null (previous))
                         (not (equal (funcall reader (previous))
                                     (funcall reader measure))))
                 (funcall reader measure))))
      (if (measure-full-rest-p measure)
          ;; full rest
          (destructuring-bind (numer denom)
              (measure-time-signature measure)
            (let ((division (measure-quarter-division measure)))
              `((:|measure| :|number| ,(ts (mapcar-state-index state)))
                ,(attributes
                  :divisions (when-changed (lambda (m) m division))
                  :time (when-changed #'measure-time-signature)
                  :clefs (when (mapcar-state-firstp state) clefs)
                  :staves (length clefs))
                ,(note (rest*) numer
                       (when (equal (list numer denom) '(4 4))
                         'whole)
                       0 nil)
                ,@(when (mapcar-state-lastp state)
                    '((:|barline| (:|bar-style| "light-heavy")))))))
          ;; normal measure
          (let* ((*accidental-store* (make-accidental-store))
                 (*tuplet-store* (make-tuplet-store))
                 (division (measure-quarter-division measure))
                 (unit-dur (/ 1/4 division))
                 (infos (measure-infos measure))
                 (next-measure (mapcar-state-next state)))
            `((:|measure| :|number| ,(ts (mapcar-state-index state)))
              ,(attributes :divisions (when-changed #'measure-quarter-division)
                           :time (when-changed #'measure-time-signature)
                           :clefs (when (mapcar-state-firstp state) clefs)
                           :staves (length clefs))
              ,@(validate-beaming
                 (mapcan-state (convert-chord unit-dur)
                               (append
                                infos
                                (when next-measure
                                  (list (measure-first-info next-measure))))
                               :repeat (length infos)))
              ,@(when (mapcar-state-lastp state)
                  '((:|barline| (:|bar-style| "light-heavy"))))))))))

(defun convert-part (state part)
  (labels ((preprocess (measures)
             (mapcar (lambda (m)
                       (if (measure-full-rest-p m)
                           m
                           (measure-split-not-notable-durs
                            (measure-normalize-singleton-divs m))))
                     measures)))
    (let ((*slur-store* (make-slur-store))
          (*wedge-store* (make-wedge-store))
          (*dynamic-store* (make-dynamic-store)))
      `((:|part| :|id| ,(format nil "P~A" (mapcar-state-index state)))
        ,@(mapcar-state (convert-measure (part-initial-clefs part))
                        (preprocess (part-measures part)))))))

(defun part2score-part (state part)
  `((:|score-part| :|id| ,(format nil "P~A" (mapcar-state-index state)))
    (:|part-name|
      ,(let ((name (part-instrument part)))
         (if name
             (string-capitalize (string name))
             "")))))

(defun encoding-date ()
  (multiple-value-bind (second minute hour date month year)
      (decode-universal-time (get-universal-time))
    (declare (ignore second minute hour))
    (format nil "~4,'0D-~2,'0D-~2,'0D"
            year month date)))

(defun enp2musicxml (enp)
  `((:|score-partwise| #+nil :|version| #+nil "2.0")
    (:|identification|
      (:|encoding| (:|encoding-date| ,(encoding-date))
        (:|software|
          #.(format nil "MusicXML-PWGL v~A"
                    (asdf:component-version
                     (asdf:find-system :musicxml-pwgl))))))
    (:|part-list| ,@(mapcar-state #'part2score-part (enp-parts enp)))
    ,@(mapcar-state #'convert-part (enp-parts enp))))

(defun abs-dur-name (abs-dur)
  "The musicxml name of ABS-DUR and the number of dots."
  (flet ((lookup (dur)
           (ecase dur
             (1/256 '256th)
             (1/128 '128th)
             (1/64 '64th)
             (1/32 '32nd)
             (1/16 '16th)
             (1/8 'eighth)
             (1/4 'quarter)
             (1/2 'half)
             (1 'whole)
             (2 'breve)
             (4 'long))))
    (ecase (numerator abs-dur)
      ((1 2 4) (values (lookup abs-dur) 0))
      (3 (values (lookup (/ abs-dur 3/2)) 1))
      (7 (values (lookup (/ abs-dur 7/4)) 2))
      (15 (values (lookup (/ abs-dur 15/8)) 3)))))

;;;# enp access
(defun enp-parts (enp)
  (nth-value 1 (split-plist-list enp)))

(defun part-initial-clefs (part)
  (multiple-value-bind (list plist)
      (split-list-plist part)
    (declare (ignore list))
    (ecase (getf plist :staff :treble-staff)
      (:treble-staff (list (list 'g 2)))
      (:alto-staff (list (list 'c 3)))
      (:bass-staff (list (list 'f 4)))
      (:piano-staff (list (list 'g 2)
                          (list 'f 4)))
      (:organ-staff (list (list 'g 2)
                          (list 'f 4)
                          (list 'f 4))))))

(defun part-instrument (part)
  (multiple-value-bind (list plist)
      (split-list-plist part)
    (declare (ignore list))
    (getf plist :instrument 'violin)))

(defun part-measures (part) (first part))

(defun measure-time-signature (measure &optional (errorp t))
  (multiple-value-bind (list plist)
      (split-list-plist measure)
    (declare (ignore list))
    (or (getf plist :time-signature)
        (when errorp
          (error "Expected to find a :TIME-SIGNATURE in this measure:~%~S"
                 measure)))))

(defun measure-beats (measure)
  (multiple-value-bind (list plist)
      (split-list-plist measure)
    (declare (ignore plist))
    list))

(defun measure-full-rest-p (measure)
  "Determines whether MEASURE contains only a single rest."
  (declare (type measure measure))
  (multiple-value-bind (beats plist)
      (split-list-plist measure)
    (declare (ignore plist))
    (and (= 1 (length beats))
         (let ((beat (first beats)))
           (and (= 1 (length (div-items beat)))
                (let ((chord (first (div-items beat))))
                  (and (typep chord 'chord)
                       (chord-rest-p chord))))))))

(defun minimal-quarter-division (abs-dur)
  "Minimal division of a quarter note that is needed to represent
ABS-DUR. If ABS-DUR is greater than a quarter note a suitable division
is returned so that a sequence of quarter notes equivally divided
establish a grid that allows to represent ABS-DUR, which starts on a
grid point. This is always the case, because we never leave the grid."
  (let ((x (/ 1/4 abs-dur)))
    (* x (denominator x))))

(defun measure-quarter-division (measure)
  "Minimal division of a quarter note that is needed to represent all
\(absolute) durations within MEASURE."
  (if (measure-full-rest-p measure)
      (destructuring-bind (numer denom)
          (measure-time-signature measure)
        (/ denom 4))
      (reduce #'lcm
              (remove nil (measure-abs-durs measure))
              :key #'minimal-quarter-division)))

(defun %chordp (enp)
  (and (second enp)
       (atom (second enp))
       (plistp (cdr enp))
       (getf (cdr enp) :notes)))

(defun %divp (enp) (not (%chordp enp)))

(defun %notep (enp)
  (and (plistp (cdr enp))
       (every (lambda (key)
                (member key '(:enharmonic
                              :attack-p
                              :note-head
                              :vel
                              :clef-number
                              :expressions
                              :offset-time
                              :chan)))
              (plist-keys (cdr enp)))))

(defun %measurep (enp)
  (measure-time-signature enp nil))

(defun %grace-beat-p (enp)
  (eql :grace-beat (getf (cddr enp) :class)))

(deftype chord () '(and cons (satisfies %chordp)))
(deftype div () '(and cons (satisfies %divp)))
(deftype grace-div () '(and div (satisfies %grace-beat-p)))
(deftype standard-div () '(and div (not (satisfies %grace-beat-p))))
(deftype note* () '(or (real 0)
                    (and (cons (real 0) cons)
                     (satisfies %notep))))
(deftype measure () '(and cons (satisfies %measurep)))

(defun grace-div-p (enp)
  (typep enp 'grace-div))

(defun div-dur (enp)
  (declare (div enp))
  ;; rational for time-signatures, which we introduce here when we
  ;; wrap the beats
  (the (rational (0)) (first enp)))

(defun div-items (enp)
  (declare (div enp))
  (second enp))

(defun div-items-no-grace (enp)
  (remove-if #'grace-div-p (div-items enp)))

(defun enp-dur (enp)
  (if (typep enp 'div)
      (div-dur enp)
      (chord-dur enp)))

(defun div-items-sum (enp)
  (the (integer 1)
       (reduce #'+ (div-items-no-grace enp) :key #'enp-dur)))

(defun tuplet-ratio (enp)
  (declare (div enp))
  (let ((dur (div-dur enp))
        (sum (div-items-sum enp)))
    (list (the (integer 1) sum)
          (the (integer 1)
               (cond ((= sum 1)
                      sum)
                     ((<= sum dur)
                      dur)
                     (t
                      (* dur (expt 2 (truncate (log (/ sum dur) 2))))))))))

(defun chord-dur (enp)
  (declare (chord enp))
  (the (integer 1) (truncate (abs (first enp)))))

(defun chord-rest-p (enp)
  (declare (chord enp))
  (minusp (car enp)))

(defun chord-tied-p (enp)
  (declare (chord enp))
  (floatp (car enp)))

(defun chord-notes (enp)
  (declare (chord enp))
  (getf (cdr enp) :notes))

(defun chord-expressions (enp)
  (declare (chord enp))
  (getf (cdr enp) :expressions))

(defun chord-dynamics (enp)
  (flet ((dynamic-keywordp (x)
           (and (keywordp x)
                (null
                 (set-difference
                  (coerce
                   (string-downcase
                    (symbol-name (keyword-without-id x)))
                   'list)
                  '(#\f #\p #\m #\z #\s)))) ))
    (mapcar #'atom-or-first
            (remove-if-not
             (lambda (x) (or (and (consp x)
                                  (dynamic-keywordp (car x)))
                             (dynamic-keywordp x)))
             (chord-expressions enp)))))

(defun chord-wedges (enp)
  (labels ((wedge-p (x)
             (member (keyword-without-id x)
                     '(:crescendo :diminuendo))))
    (remove-if-not #'wedge-p
                   (mapcar #'atom-or-first
                           (chord-expressions enp)))))

(defun find-note-in-chord (note chord)
  (declare (type note* note)
           (type chord chord))
  (find-if (lambda (chord-note)
             (= (note-pitch note)
                (note-pitch chord-note)))
           (chord-notes chord)))

(defun chord-change-dur (chord dur &key tied)
  (declare (type chord chord))
  `(,(cond ((chord-rest-p chord)
            (- dur))
           ((or (chord-tied-p chord) tied)
            (float dur))
           (t
            dur))
    ,@(rest chord)))

(defun note-pitch (note)
  (declare (type note* note))
  (let ((pitch (if (atom note) note (car note))))
    (typecase pitch
      (float (multiple-value-bind (integer epsilon)
                 (round pitch)
               (if (<= (abs epsilon) 0.01)
                   integer
                   pitch)))
      (t pitch))))

(defun note-attack-p (note)
  (declare (type note* note))
  (and (consp note)
       (getf (cdr note) :attack-p)))

(defun measure-abs-durs (measure)
  (mapcar #'info-abs-dur (measure-infos measure)))

(defstruct (info (:print-object print-info))
  abs-durs path pointers beaming grace-p)

(defun print-info (obj stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "~@<abs-durs ~W ~_~
                    notated-durs ~W ~_~
                    path ~W ~_~
                    chord ~W ~_~
                    tuplet-ratios ~W ~_~
                    beat start ~W end ~W ~_~
                    grace ~W~:>"
            (info-abs-durs obj)
            (info-notated-durs obj)
            (info-path obj)
            (info-chord obj)
            (info-tuplet-ratios obj)
            (info-beat-start-p obj)
            (info-beat-end-p obj)
            (info-grace-p obj))))

(defun info-abs-dur (info)
  (car (info-abs-durs info)))

(defun info-notated-dur (info)
  (car (info-notated-durs info)))

(defun info-chord (info)
  (car (info-pointers info)))

(defun info-tuplet-ratios (info)
  (mapcar #'tuplet-ratio (cdr (info-pointers info))))

(defun info-notated-durs (info)
  (mapcar #'*
          (info-abs-durs info)
          (info-cumulative-tuplet-ratios info)))

(defun info-cumulative-tuplet-ratio (info)
  (let ((former-code (reduce #'* (info-tuplet-ratios info)
                             :key #'list2ratio))
        (new-code (car (info-cumulative-tuplet-ratios info))))
    (assert (= former-code new-code))
    new-code))

(defun info-cumulative-tuplet-ratios (info)
  (reduce (lambda (a b) (cons (* a (first b)) b))
          (info-tuplet-ratios info)
          :key #'list2ratio
          :initial-value '(1)
          :from-end t))

(defun info-beat-start-p (info)
  (every (lambda (index div)
           (or (zerop index)
               (every (lambda (x)
                        (typep x 'grace-div))
                      (subseq (div-items div) 0 index))))
         (butlast (info-path info))
         (rest (info-pointers info))))

(defun info-beat-end-p (info)
  (flet ((one-smaller (x y)
           (= 1 (- y x))))
    (every* #'one-smaller
            (butlast (info-path info))
            (mapcar (lambda (div) (length (div-items div)))
                    (rest (butlast (info-pointers info)))))))

(defun info-beat (info)
  (car (last (info-pointers info) 2)))

;;;# tuplet
(defun tuplet-key (tuplet)
  (first tuplet))

(defun tuplet-tuplet-ratio (tuplet)
  (second tuplet))

(defun tuplet-type (tuplet)
  (third tuplet))

(defun tuplet-eql (a b)
  (eql (tuplet-key a)
       (tuplet-key b)))

(defun info-starting-tuplets (info)
  (loop for div in (rest (info-pointers info))
        for pos in (info-path info)
        for tuplet-ratio in (info-tuplet-ratios info)
        for notated-dur in (rest (info-notated-durs info))
        while (or (zerop pos)
                  (every #'grace-div-p (subseq (div-items div) 0 pos)))
        when (/= 1 (list2ratio tuplet-ratio))
          collect (list div
                        tuplet-ratio
                        ;; tuplet-type
                        (abs-dur-name (/ notated-dur (second tuplet-ratio))))))

(defun info-ending-tuplets (info)
  (loop for div in (rest (info-pointers info))
        for pos in (info-path info)
        for tuplet-ratio in (info-tuplet-ratios info)
        while (= (1+ pos) (length (div-items div)))
        when (/= 1 (list2ratio tuplet-ratio))
          collect (list div tuplet-ratio)))

(defun measure-infos (measure)
  (declare (type measure measure))
  (labels ((rec (unit tree path pointers abs-durs)
             (cond ((typep tree 'chord)
                    ;; chord
                    (list (make-info :abs-durs (cons (* unit (chord-dur tree))
                                                     abs-durs)
                                     :path path
                                     :pointers pointers)))
                   ((typep tree 'grace-div)
                    (mapcar (lambda (item)
                              (make-info
                               :grace-p t
                               :pointers (list item)))
                            (div-items tree)))
                   (t
                    ;; div
                    (let* ((sum (div-items-sum tree))
                           (unit (/ (* unit (abs (div-dur tree)))
                                    sum)))
                      (mapcan-state
                       (lambda (state tree)
                         (let ((path (cons (1- (mapcar-state-index state))
                                           path))
                               (pointers (cons tree pointers)))
                           (rec unit tree path
                                pointers
                                (cons (* unit sum)
                                      abs-durs))))
                       (div-items tree)))))))
    (multiple-value-bind (beats plist)
        (split-list-plist measure)
      (let* ((tree (list (list2ratio (measure-time-signature measure)) beats))
             (infos (rec 1 tree nil (list tree) nil)))
        (infos-compute-beaming infos)))))

(defun notated-dur2beam-number (dur)
  "The maximum number of beams that can be used with DUR."
  (multiple-value-bind (name dots)
      (abs-dur-name dur)
    (declare (ignore name))
    (let ((zero-dots-dur (/ dur
                            (ecase dots
                              (0 1)
                              (1 3/2)
                              (2 7/4)
                              (3 15/8)))))
      (max 0
           (- (truncate (log (denominator zero-dots-dur) 2))
              2)))))

(defun infos-compute-beaming (all-infos)
  (let ((infos (remove-if #'info-grace-p all-infos)))
    (let* ((notated-durs (mapcar #'info-notated-dur infos))
           (beam-numbers (mapcar #'notated-dur2beam-number notated-durs))
           (dur-constraints
             (map-neighbours #'list
                             (append (list 0)
                                     (map-neighbours #'min beam-numbers)
                                     (list 0))))
           (grouping-constraints
             (mapcar (lambda (info)
                       (list (if (info-beat-start-p info)
                                 0
                                 most-positive-fixnum)
                             (if (info-beat-end-p info)
                                 0
                                 most-positive-fixnum)))
                     infos))
           (beaming
             (mapcar (lambda (a b)
                       (list (min (first a) (first b))
                             (min (second a) (second b))))
                     dur-constraints
                     grouping-constraints)))
      (loop for info in infos
            for b in beaming
            do (setf (info-beaming info) b))))
  all-infos)

(defun validate-beaming (measure-content)
  (handler-case
      (let ((hash (make-hash-table :size 5)))
        (macrolet ((beam-state (index)
                     `(gethash ,index hash :off)))
          (labels ((beam-off-p (index) (eql :off (beam-state index)))
                   (beam-on-p (index) (eql :on (beam-state index)))
                   (process-begin (index)
                     #+sbcl(declare (sb-ext:muffle-conditions style-warning))
                     (assert (beam-off-p index))
                     (setf (beam-state index) :on))
                   (process-end (index)
                     #+sbcl(declare (sb-ext:muffle-conditions style-warning))
                     (assert (beam-on-p index) nil
                             "process-end: (beam-on-p index) failed")
                     (setf (beam-state index) :off))
                   (process-continue (index)
                     (assert (beam-on-p index) nil
                             "process-continue: (beam-on-p index) failed")))
            (dolist (x measure-content)
              (when (and (typep x 'note)
                         (not (note-chordp x))
                         (not (note-gracep x)))
                (assert (disjoint-p (note-beam-begin x)
                                    (note-beam-continue x)))
                (assert (disjoint-p (note-beam-begin x)
                                    (note-beam-end x)))
                (assert (disjoint-p (note-beam-end x)
                                    (note-beam-continue x)))
                (mapc #'process-continue (note-beam-continue x))
                (mapc #'process-end (note-beam-end x))
                (dotimes (i 10)
                  (when (beam-on-p i)
                    (assert (member i (note-beam-continue x)))))
                (mapc #'process-begin (note-beam-begin x))))
            (dotimes (i 10) (assert (beam-off-p i)))
            measure-content)))
    (error (c)
      (cerror "keep going"
              "Congratulations! You have found a beaming related bug:~%~A" c)
      measure-content)))

(defun measure-first-info (measure)
  (first (measure-infos measure)))

(defun measure-normalize-singleton-divs (measure)
  (declare (type measure measure))
  (labels ((rec (enp)
             (typecase enp
               (chord enp)
               (grace-div enp)
               (div (if (and (= 1 (length (div-items enp)))
                             (= 1 (chord-dur (first (div-items enp)))))
                        (let ((chord (first (div-items enp))))
                          `(,(div-dur enp)
                            (,(chord-change-dur chord (div-dur enp)))))
                        `(,(div-dur enp)
                          ,(mapcar #'rec (div-items enp))))))))
    `(,@(mapcar #'rec (measure-beats measure))
      :time-signature ,(measure-time-signature measure))))

(defun measure-split-not-notable-durs (measure)
  (declare (type measure measure))
  (labels ((rec (enp)
             (typecase enp
               ;; chord
               (chord
                (if (eql 5 (chord-dur enp))
                    (list (chord-change-dur enp 3)
                          (chord-change-dur enp 2 :tied t))
                    (list enp)))
               ;; grace-div
               (grace-div (list enp))
               ;; div
               (t (list `(,(div-dur enp)
                          ,(mapcan #'rec (div-items enp))))))))
    `(,@(mapcan #'rec (measure-beats measure))
      :time-signature ,(measure-time-signature measure))))

;;;# accidental-store
(defun make-accidental-store ()
  (make-hash-table :test #'equal))

(defun register-accidental (store step octave alter)
  (let ((previous-alter (gethash (list step octave) store 0)))
    (setf (gethash (list step octave) store) alter)
    (/= alter previous-alter)))

;;;# tuplet-store
(defun make-tuplet-store ()
  (list 0 (make-hash-table :test #'eql)))

(defun register-tuplet (store tuplet)
  (setf (gethash tuplet (second store))
        (incf (first store))))

(defun tuplet-number (store tuplet)
  (gethash tuplet (second store)))

;;;# slur-store
(defun make-slur-store ()
  (make-hash-table :test #'eql))

(defun slur-store-first-unassigned-number (store)
  (let ((candidates (list 1 2 3 4 5 6)))
    (maphash (lambda (key value)
               (declare (ignore key))
               (setf candidates (delete value candidates)))
             store)
    (first candidates)))

(defun register-slur (store slur)
  "Should be called for any slur expression that is known to either
  start or continue a slur. Will return a number for the slur if the
  slur expression starts the slur or nil if the slur expression
  continues the slur."
  (if (gethash slur store)
      nil
      (setf (gethash slur store)
            (slur-store-first-unassigned-number store))))

(defun unregister-slur (store slur)
  "Should be called for any slur expression that is known to end the
  slur."
  (prog1
      (progn
        (assert (gethash slur store) nil
                "in UNREGISTER-SLUR: slur not known (~S)" slur)
        (gethash slur store))
    (remhash slur store)))

;;;# wedge-store
(defun make-wedge-store ()
  (make-hash-table :test #'eql))

(defun wedge-store-first-unassigned-number (store)
  (let ((candidates (list 1 2 3 4 5 6)))
    (maphash (lambda (key value)
               (declare (ignore key))
               (setf candidates (delete value candidates)))
             store)
    (first candidates)))

(defun register-wedge (store wedge)
  "Should be called for any wedge expression that is known to either
  start or continue a wedge. Will return a number for the wedge if the
  wedge expression starts the wedge or nil if the wedge expression
  continues the wedge."
  (if (gethash wedge store)
      nil
      (setf (gethash wedge store)
            (wedge-store-first-unassigned-number store))))

(defun unregister-wedge (store wedge)
  "Should be called for any wedge expression that is known to end the
  wedge."
  (prog1
      (progn
        (assert (gethash wedge store) nil
                "in UNREGISTER-WEDGE: wedge not known (~S)" wedge)
        (gethash wedge store))
    (remhash wedge store)))

;;;# dynamic-store
(defun make-dynamic-store ()
  (cons nil nil))

(defun register-dynamics (store dynamics)
  (prog1
      (set-difference dynamics (car store))
    (setf (car store) dynamics)))

;;;# utils
(defgeneric ts (obj))
(defmethod ts ((obj integer)) (princ-to-string obj))

(defun plistp (list)
  (labels ((rec (list state)
             (if (and (null list)
                      (eql state :key))
                 t
                 (ecase state
                   (:key (when (keywordp (car list))
                           (rec (cdr list) :value)))
                   (:value (when (consp list)
                             (rec (cdr list) :key)))))))
    (rec list :key)))

(defun append-list-plist (list plist)
  (declare (type list list)
           (type (satisfies plistp) plist))
  (append list plist))

(defun split-list-plist (list)
  (let ((position (or (position-if #'keywordp list)
                      (length list))))
    (values (subseq list 0 position)
            (subseq list position))))

(defun split-plist-list (list)
  (cond
    ((null list) (values nil nil))
    ((and (keywordp (first list))
          (not (null (cdr list))))
     (multiple-value-bind (plist tail)
         (split-plist-list (cddr list))
       (values (list* (first list) (second list)
                      plist)
               tail)))
    (t (values nil list))))

(defun plist-keys (plist)
  (loop for key in plist by #'cddr
        collect key))

(defun power-of-two-p (x)
  (cond
    ((eql x 1) t)
    ((> x 1) (and (evenp x)
                  (power-of-two-p (truncate x 2))))
    (t (error "power-of-two-p called with ~S" x))))

(defun notable-dur-p (dur &optional (max-dots 3))
  (flet ((h (numer denom)
           (case numer
             ((1) (power-of-two-p denom))
             ((3) (and (> max-dots 0)
                       (>= denom 2) (power-of-two-p denom)))
             ((7) (and (> max-dots 1)
                       (>= denom 4) (power-of-two-p denom)))
             ((15) (and (> max-dots 2)
                        (>= denom 8) (power-of-two-p denom)))
             (t nil))))
    (h (numerator dur)
       (denominator dur))))

(defun list2ratio (list)
  (assert (null (cddr list)))
  (/ (first list) (second list)))

(defun map-neighbours (fn list)
  (loop for a in list
        for b in (cdr list)
        collect (funcall fn a b)))

(defun 1-to-n (n)
  (declare (type (integer 0)))
  (unless (zerop n)
    (loop for i from 1 to n collect i)))

(defun every* (fn a b)
  (assert (= (length a)
             (length b)))
  (every fn a b))

(defun keyword-without-id (keyword)
  (declare (type keyword keyword))
  (let* ((name (symbol-name keyword))
         (pos (position #\/ name)))
    (if pos
        (values (intern (subseq name 0 pos) "KEYWORD")
                (parse-integer (subseq name (1+ pos))))
        (values keyword nil))))

(defun disjoint-p (a b)
  (null (intersection a b)))

(defun atom-or-first (thing)
  (if (atom thing)
      thing
      (first thing)))
