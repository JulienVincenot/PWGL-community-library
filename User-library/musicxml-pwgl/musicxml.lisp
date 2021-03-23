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

(in-package #:musicxml-pwgl.musicxml)

;;;define-element
(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun mkstr (&rest args)
    (with-output-to-string (s)
      (dolist (a args) (princ a s))))
  (defun symb (&rest args)
    (values (intern (apply #'mkstr args))))
  (defun kw (&rest args)
    (values (intern (apply #'mkstr args) "KEYWORD")))
  (defun list! (thing)
    (if (consp thing) thing (list thing))))

(defmacro define-element (name-options &body body)
  (labels ((accessor-form (slot-name obj)
             `(list 'quote
                    (,(symb obj "-" slot-name) ,obj))))
    (let ((slot-names (mapcar (lambda (x) (car (list! x))) body)))
      (destructuring-bind (name &key boa)
          (list! name-options)
        `(progn
           (defstruct (,name (:include musicxml-object))
             ,@body)
           ,(if boa
                `(defun ,name (,@slot-names)
                   (,(symb "MAKE-" name)
                    ,@(mapcan (lambda (name) (list (kw name) name))
                              slot-names)))
                `(defun ,name (&rest args &key ,@slot-names)
                   (declare (ignore ,@slot-names))
                   (apply #',(symb "MAKE-" name) args)))
           ,(if boa
                `(defmethod make-constructor-form ((,name ,name))
                   (cons ',name
                         (list
                          ,@(loop for a in slot-names
                                  collect (accessor-form a name)))))
                `(defmethod make-constructor-form ((,name ,name))
                   (cons ',name
                         (list
                          ,@(loop for a in slot-names
                                  collect (kw a)
                                  collect (accessor-form a name))))))
           (set-pprint-dispatch
            ',name 'generic-pretty-printer 0 *pprint-xml-table*))))))

(defun print-musicxml (dom &key (stream t) no-header)
  (let ((*print-circle* nil))
    (unless no-header
      (write-line
       "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>" stream)
      (format stream "<!DOCTYPE score-partwise PUBLIC ~
                   \"-//Recordare//DTD MusicXML 2.0 Partwise//EN\" ~
                   \"http://www.musicxml.org/dtds/partwise.dtd\">~%"))
    (musicxml-pwgl.pprint-xml:pprint-xml dom :stream stream)))

(defun from-lxml (dom)
  (cond ((and (consp dom)
              (consp (car dom)))
         (translate-from-lxml dom (caar dom)))
        ((consp dom)
         (translate-from-lxml dom (car dom)))
        ((stringp dom) dom)
        ((keywordp dom)
         (translate-from-lxml dom dom))
        (t
         (error "dunno with ~S?" dom))))

(defmethod translate-from-lxml (dom type)
  (if (consp dom)
      (cons (car dom)
            (mapcar 'from-lxml (cdr dom)))
      dom))

(defun to-lxml (obj)
  (translate-to-lxml obj))

(defmethod translate-to-lxml (obj)
  (if (consp obj)
      (cons (car obj)
            (mapcar 'translate-to-lxml (cdr obj)))
      obj))

(defgeneric make-constructor-form (obj))

(defun generic-pretty-printer (stream obj)
  (pprint-redispatch (translate-to-lxml obj) stream))

(defmacro assoc-bind (bindings exp &body body)
  (let ((=exp= (gensym "=EXP=")))
    `(let ((,=exp= ,exp))
       (let ,(mapcar
              (lambda (binding)
                `(,binding
                  (second (assoc
                           ,(intern (string-downcase (string binding))
                                    "KEYWORD")
                           ,=exp=))))
              bindings)
         ,@body))))

(defun assoc* (item list)
  (if (null list)
      nil
      (let ((candidate (first list)))
        (if (cond ((and (consp candidate)
                        (consp (first candidate)))
                   (eql item (caar candidate)))
                  ((consp candidate)
                   (eql item (first candidate)))
                  (t
                   (eql item candidate)))
            candidate
            (assoc* item (rest list))))))

(defmacro assoc-bind* (bindings exp &body body)
  (let ((=exp= (gensym "=EXP=")))
    `(let ((,=exp= ,exp))
       (let ,(mapcar
              (lambda (binding)
                `(,binding
                  (assoc*
                   ,(intern (string-downcase (string binding))
                            "KEYWORD")
                   ,=exp=)))
              bindings)
         ,@body))))

(defun intern* (name)
  (intern (string-upcase name) (find-package "MUSICXML-PWGL.MUSICXML")))

(defun mxml-equal (a b)
  (equal (translate-to-lxml a)
         (translate-to-lxml b)))

;;; eval-when currently needed by PWGL
(eval-when (:compile-toplevel :load-toplevel :execute)
  (defstruct musicxml-object))

(defmethod print-object ((musicxml-object musicxml-object) stream)
  (write-string "#." stream)
  (prin1 (make-constructor-form musicxml-object) stream))

;;; pitch
(deftype pitch-step ()
  '(member c d e f g a b))

(define-element (pitch :boa t)
  (step nil :type pitch-step) alter octave)

(defmethod translate-from-lxml (dom (type (eql ':|pitch|)))
  (assoc-bind (step alter octave) (cdr dom)
    (make-pitch :step (intern* step)
                :alter (if (null alter) 0 (read-from-string alter))
                :octave (parse-integer octave))))

(defmethod translate-to-lxml ((pitch pitch))
  `(:|pitch|
     (:|step| ,(string (pitch-step pitch)))
     ,@(unless
           (eql 0 (pitch-alter pitch))
         `((:|alter| ,(princ-to-string (pitch-alter pitch)))))
     (:|octave| ,(princ-to-string (pitch-octave pitch)))))

;;; rest*
(define-element rest*)

(defmethod translate-from-lxml (dom (type (eql ':|rest|)))
  (make-rest*))

(defmethod translate-to-lxml ((rest* rest*))
  :|rest|)

;;; note
(deftype accidental ()
  '(member nil unspecific sharp natural flat double-sharp sharp-sharp flat-flat
    natural-sharp natural-flat quarter-flat quarter-sharp three-quarters-flat
    three-quarters-sharp))

(deftype note-type ()
  '(member nil 256th 128th 64th 32nd 16th
    eighth quarter half whole breve long))

(defstruct (note (:include musicxml-object))
  pitch-or-rest duration chordp staff gracep
  (accidental nil :type accidental)
  (type nil :type note-type)
  (dots nil :type (integer 0 3))
  notations
  (tie-start nil :type boolean)
  (tie-stop nil :type boolean)
  (time-modification nil #-pwgl :type #-pwgl (or null time-modification))
  beam-begin beam-continue beam-end)

(defun beam-element-p (dom)
  (and (consp dom)
       (consp (first dom))
       (eql :|beam| (caar dom))))

(defun tied-element-p (dom)
  (and (consp dom)
       (consp (first dom))
       (eql :|tied| (caar dom))))

(defun decode-beams (list-of-beams)
  "Returns list of beams for start, continue and end."
  (flet ((beam-number (beam)
           (parse-integer (third (car beam))))
         (beam-type (beam)
           (intern* (second beam))))
    (let (start continue end)
      (dolist (beam list-of-beams)
        (ecase (beam-type beam)
          (begin (push (beam-number beam) start))
          (continue (push (beam-number beam) continue))
          (end (push (beam-number beam) end))))
      (values (nreverse start) (nreverse continue) (nreverse end)))))

(defmethod translate-from-lxml (dom (type (eql ':|note|)))
  (assoc-bind* (duration chord rest pitch staff
                         accidental type notations
                         time-modification)
      dom
    (multiple-value-bind (beam-begin beam-continue beam-end)
        (decode-beams (remove-if-not 'beam-element-p dom))
      (make-note :pitch-or-rest (if rest (rest*) (from-lxml pitch))
                 :duration (parse-integer (second duration))
                 :chordp chord
                 :staff (and staff (parse-integer (second staff)))
                 :accidental (and accidental (intern* (second accidental)))
                 :type (and type (intern* (second type)))
                 :dots (count '(:|dot|) (cdr dom) :test #'equal)
                 :notations (mapcar #'from-lxml
                                    (remove-if #'tied-element-p
                                               (rest notations)))
                 :tie-start (when (find '((:|tie| :|type| "start"))
                                        (cdr dom) :test #'equal)
                              t)
                 :tie-stop (when (find '((:|tie| :|type| "stop"))
                                       (cdr dom) :test #'equal)
                             t)
                 :time-modification (and time-modification
                                         (from-lxml time-modification))
                 :beam-begin beam-begin
                 :beam-continue beam-continue
                 :beam-end beam-end))))

(defmethod translate-to-lxml ((note note))
  `(:|note|
     ,@(when (note-gracep note) '(:|grace|))
     ,@(when (note-chordp note) '(:|chord|))
     ,(translate-to-lxml (note-pitch-or-rest note))
     ,@(when (note-duration note)
         `((:|duration|
             ,(princ-to-string (note-duration note)))))
     ,@(when (note-tie-stop note) '(((:|tie| :|type| "stop"))))
     ,@(when (note-tie-start note) '(((:|tie| :|type| "start"))))
     ,@(when (note-type note)
         `((:|type| ,(string-downcase (symbol-name (note-type note))))))
     ,@(loop repeat (note-dots note) collect '(:|dot|))
     ,@(when (note-accidental note)
         (case (note-accidental note)
           (unspecific '((:|accidental|)))
           (t `((:|accidental|
                  ,(string-downcase (symbol-name (note-accidental note))))))))
     ,@(when (note-time-modification note)
         (list (translate-to-lxml (note-time-modification note))))
     ,@(when (note-staff note)
         `((:|staff| ,(princ-to-string (note-staff note)))))
     ,@(sort
        (append
         (mapcar (lambda (n) `((:|beam| :|number| ,(princ-to-string n))
                               "begin"))
                 (note-beam-begin note))
         (mapcar (lambda (n) `((:|beam| :|number| ,(princ-to-string n))
                               "continue"))
                 (note-beam-continue note))
         (mapcar (lambda (n) `((:|beam| :|number| ,(princ-to-string n))
                               "end"))
                 (note-beam-end note)))
        #'< :key (lambda (x) (parse-integer (third (car x)))))
     ,@(when (note-notations* note)
         `((:|notations| ,@(mapcar #'to-lxml (note-notations* note)))))))

(defmethod make-constructor-form ((note note))
  `(note ,(note-pitch-or-rest note)
         ,(note-duration note)
         ',(note-type note)
         ,(note-dots note)
         ',(note-accidental note)
         :chordp ,(note-chordp note)
         :tie-start ,(note-tie-start note)
         :tie-stop ,(note-tie-stop note)
         :staff ,(note-staff note)
         :notations ',(remove-if #'tied-element-p (note-notations note))
         :time-modification ,(note-time-modification note)
         :beam-begin ,(note-beam-begin note)
         :beam-continue ,(note-beam-continue note)
         :beam-end ,(note-beam-end note)))

(defun note (pitch-or-rest duration type dots accidental
             &key chordp gracep staff notations tie-start tie-stop
               time-modification
               beam-begin beam-continue beam-end)
  (make-note :pitch-or-rest pitch-or-rest :duration duration :chordp chordp
             :staff staff :accidental accidental :type type
             :time-modification time-modification
             :beam-begin beam-begin
             :beam-continue beam-continue
             :beam-end beam-end
             :dots dots
             :tie-start tie-start
             :tie-stop tie-stop
             :notations notations
             :gracep gracep))

(defun note-notations* (note)
  (append (when (note-tie-stop note) '(((:|tied| :|type| "stop"))))
          (when (note-tie-start note) '(((:|tied| :|type| "start"))))
          (note-notations note)))

(set-pprint-dispatch 'note 'generic-pretty-printer 0 *pprint-xml-table*)

;;; time-modification
(define-element (time-modification :boa t)
  actual-notes normal-notes
  (normal-type nil :type note-type))

(defmethod translate-from-lxml (dom (type (eql ':|time-modification|)))
  (assoc-bind (actual-notes normal-notes normal-type) (cdr dom)
    (make-time-modification
     :actual-notes (parse-integer actual-notes)
     :normal-notes (parse-integer normal-notes)
     :normal-type (intern* normal-type))))

(defmethod translate-to-lxml ((time-modification time-modification))
  `(:|time-modification|
     (:|actual-notes|
       ,(princ-to-string (time-modification-actual-notes time-modification)))
     (:|normal-notes|
       ,(princ-to-string (time-modification-normal-notes time-modification)))
     ,@(when (time-modification-normal-type time-modification)
         `((:|normal-type|
             ,(string-downcase (symbol-name (time-modification-normal-type
                                             time-modification))))))))

;;; tuplet
(deftype start-stop ()
  '(member start stop))

(deftype yes-no? ()
  '(member nil yes no))

(defstruct (tuplet (:include musicxml-object))
  (type nil :type start-stop)
  id actual-number actual-type normal-number normal-type
  (bracket nil :type yes-no?))

(defmethod translate-from-lxml (dom (type (eql ':|tuplet|)))
  (assoc-bind* (tuplet-actual tuplet-normal) (cdr dom)
    (make-tuplet :type (intern* (third (car dom)))
                 :id (parse-integer (fifth (car dom)))
                 :actual-number (let ((x (second (assoc :|tuplet-number|
                                                        (cdr tuplet-actual)))))
                                  (and x (parse-integer x)))
                 :actual-type (intern*
                               (second (assoc :|tuplet-type|
                                              (cdr tuplet-actual))))
                 :normal-number (let ((x (second (assoc :|tuplet-number|
                                                        (cdr tuplet-normal)))))
                                  (and x (parse-integer x)))
                 :normal-type (intern*
                               (second (assoc :|tuplet-type|
                                              (cdr tuplet-normal))))
                 :bracket nil)))

(defmethod translate-to-lxml ((tuplet tuplet))
  `((:|tuplet|
     :|type|
     ,(string-downcase (symbol-name (tuplet-type tuplet)))
     :|number| ,(princ-to-string (tuplet-id tuplet))
     ,@(when (tuplet-bracket tuplet)
         `(:|bracket|
            ,(string-downcase (symbol-name (tuplet-bracket tuplet))))))
    ,@(when (tuplet-actual-number tuplet)
        `((:|tuplet-actual|
            (:|tuplet-number|
              ,(princ-to-string (tuplet-actual-number tuplet)))
            ,@(when (tuplet-actual-type tuplet)
                `((:|tuplet-type|
                    ,(string-downcase
                      (symbol-name (tuplet-actual-type tuplet)))))))))
    ,@(when (tuplet-normal-number tuplet)
        `((:|tuplet-normal|
            ,@(when (tuplet-normal-number tuplet)
                `((:|tuplet-number|
                    ,(princ-to-string (tuplet-normal-number tuplet)))))
            ,@(when (tuplet-normal-type tuplet)
                `((:|tuplet-type|
                    ,(string-downcase
                      (symbol-name
                       (tuplet-normal-type tuplet)))))))))))

(defmethod make-constructor-form ((tuplet tuplet))
  `(tuplet ',(tuplet-type tuplet)
           ,(tuplet-id tuplet)
           ,(tuplet-actual-number tuplet)
           ',(tuplet-actual-type tuplet)
           ,(tuplet-normal-number tuplet)
           ',(tuplet-normal-type tuplet)
           ',(tuplet-bracket tuplet)))

(defun tuplet (type id &optional
                         actual-number actual-type normal-number normal-type bracket)
  (make-tuplet :type type
               :id id
               :actual-number actual-number
               :actual-type actual-type
               :normal-number normal-number
               :normal-type normal-type
               :bracket bracket))

(set-pprint-dispatch 'tuplet 'generic-pretty-printer 0 *pprint-xml-table*)

;;; attributes
(deftype clef-sign ()
  '(member g))

(define-element attributes
  divisions time clefs staves key)

(defmethod translate-from-lxml (dom (type (eql ':|attributes|)))
  (assoc-bind* (divisions time clef staves key) (cdr dom)
    (make-attributes :divisions (and divisions
                                     (parse-integer (second divisions)))
                     :staves (and staves (parse-integer (second staves)))
                     :key (and key
                               (assoc-bind (fifths) (cdr key)
                                 (parse-integer fifths)))
                     :time (and time
                                (assoc-bind (beats beat-type) (cdr time)
                                  (list (parse-integer beats)
                                        (parse-integer beat-type))))
                     ;; this is wrong
                     :clefs (cond ((and staves
                                        (= 2 (parse-integer (second staves))))
                                   (list (list 'g)
                                         (list 'f)))
                                  (clef
                                   (list (assoc-bind (sign line) (cdr clef)
                                           (list (intern* sign)
                                                 (and line
                                                      (parse-integer line))))))
                                  (t nil)))))

(defmethod translate-to-lxml ((attributes attributes))
  (let ((dom `(:|attributes|
                ,@(when (attributes-divisions attributes)
                    `((:|divisions|
                        ,(princ-to-string
                          (attributes-divisions attributes)))))
                ,@(when (attributes-key attributes)
                    `((:|key| (:|fifths|
                                ,(princ-to-string
                                  (attributes-key attributes))))))
                ,@(when (attributes-time attributes)
                    `((:|time|
                        (:|beats|
                          ,(princ-to-string
                            (first (attributes-time attributes))))
                        (:|beat-type|
                          ,(princ-to-string
                            (second (attributes-time attributes)))))))
                ,@(when (and (attributes-staves attributes)
                             (/= 1 (attributes-staves attributes)))
                    `((:|staves|
                        ,(princ-to-string
                          (attributes-staves attributes)))))
                ,@(mapcar-state
                   (lambda (state clef)
                     `(,(if (= 1 (length (attributes-clefs attributes)))
                            :|clef|
                            `(:|clef|
                              :|number|
                              ,(princ-to-string
                                (mapcar-state-index state))))
                       (:|sign|
                         ,(symbol-name (first clef)))
                       ,@(when
                             (second clef)
                           `((:|line|
                               ,(princ-to-string
                                 (second clef)))))))
                   (attributes-clefs attributes)))))
    (if (cdr dom)
        dom
        nil)))

;;; direction
(define-element (direction :boa t)
  direction-types)

(defmethod translate-from-lxml (dom (type (eql ':|direction|)))
  (make-direction :direction-types (mapcar #'from-lxml (cdr dom))))

(defmethod translate-to-lxml ((direction direction))
  `((:|direction| :|placement| "below")
    ,@(mapcar #'to-lxml (direction-direction-types direction))))

;;; direction-type
(define-element (direction-type :boa t)
  dynamics)

(defmethod translate-from-lxml (dom (type (eql ':|direction-type|)))
  (make-direction-type
   :dynamics (mapcar #'from-lxml (cdr dom))))

(defmethod translate-to-lxml ((direction-type direction-type))
  `(:|direction-type| ,@(mapcar #'to-lxml (direction-type-dynamics direction-type))))

;;; dynamic
(define-element (dynamic :boa t)
  symbol)

(defmethod translate-from-lxml (dom (type (eql ':|dynamic|)))
  (make-dynamic :symbol (second dom)))

(defmethod translate-to-lxml ((dynamic dynamic))
  `(:|dynamics|
     ,(intern (string-downcase (symbol-name (dynamic-symbol dynamic)))
              "KEYWORD")))
