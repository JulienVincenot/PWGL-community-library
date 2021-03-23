
(in-package :pwgl-sdif)

(defmethod convert-sdif((self pathname) &optional pathname)
  (let ((sdiftotext #+mac (merge-pathnames #p"osx/sdiftotext" (ccl::ENP-application-pathname :application-plugins)) #-mac ())
        (texttosdif #+mac (merge-pathnames #p"osx/texttosdif" (ccl::ENP-application-pathname :application-plugins))  #-mac ())
        tmp-filename)
    (when (and sdiftotext texttosdif)
      (case (ccl::string-to-keyword (pathname-type self))
        (:sdif
         (setq tmp-filename (or pathname (merge-pathnames (make-pathname :name (format () "_pwglsdif~a" (random 1243564533423456)) :type "txt") (ccl::ENP-application-pathname :tmp))))
         (ccl::call-system-showing-output (format () "~a -i '~a' -o '~a'" (namestring sdiftotext) self tmp-filename)))
        (:txt 
         (setq tmp-filename (or pathname (merge-pathnames (make-pathname :name (format () "_pwglsdif~a" (random 1243564533423456)) :type "sdif") (ccl::ENP-application-pathname :tmp))))
         (ccl::call-system-showing-output (format () "~a -i '~a' -o '~a'" (namestring texttosdif) self tmp-filename))))
      tmp-filename)))

;********************************************************************************

(defun curly-braces-match-p(open-brace close-brace)
  (unless (or (eql open-brace :undefined)
              (eql close-brace :undefined))
    (= open-brace close-brace)))

(defun read-brace-delimited-list(stream &key terminate-on-semicolon-p)
  (let ((open-brace :undefined)
        (close-brace :undefined))
    (read-from-string
     (with-output-to-string (str)
       (loop for c = (read-char stream () :EOF) ;#\{ then 
             until (or (eql c :EOF)
                       (curly-braces-match-p open-brace close-brace))
             do
             ;(print c)
             (cond
              ((eql c #\{)
               (princ #\( str)
               (when terminate-on-semicolon-p
                 (princ #\( str))
               (if (numberp open-brace) (incf open-brace) (setq open-brace 1)))
              ((eql c #\})
               (princ #\) str)
               (when terminate-on-semicolon-p
                 (princ #\) str))
               (if (numberp close-brace) (incf close-brace) (setq close-brace 1)))
              ((eql c #\:) ;skip
               (princ #\Space str))
              ((eql c #\;)
               (when terminate-on-semicolon-p
                 (princ #\) str)
                 (princ #\( str)))
              ((eql c #\,) (princ #\Space str))
              (t (princ c str))))
       str))))

#|
(with-input-from-string (stream
"
{
SampleRate	44100.000000;
Command	supervp -t -ns -S/Users/mika/Documents/TheVirtualOrchestra/sounds/brass/alto-trombone/Flutter-tongue/trba-ft-A2-ff.AIF -Af0 fm50.0 fM1000.0 F4000.0 sn50.0 smooth3  -N2048 -M2048 -oversamp 8 -Wblackman -OS0 /Applications/AudioSculpt 2.6/Fundamental/tempf0-Fzbc.f0.sdif ;
Soundfile	/Users/mika/Documents/TheVirtualOrchestra/sounds/brass/alto-trombone/Flutter-tongue/trba-ft-A2-ff.AIF;
NumChannels	1;
Version	2.85.0 (compiled by roebel for AudioSculpt on May  9 2006 01:49:05 );
Creator	SuperVP;
}") (read-brace-delimited-list stream :terminate-on-semicolon-p t))
|#

(defun curly-reader (stream char)
  (declare (ignore char))
  (list 'quote (read-brace-delimited-list stream)))

(defun curly-reader (stream char)
  (declare (ignore char))
  (read-brace-delimited-list stream))

(ccl::set-macro-character  #\{ 'curly-reader)
(ccl::set-macro-character #\} (get-macro-character #\)))

;********************************************************************************

(defun sdif-tag-p(n)
  (find-class n ()))

(defun sdif-tag-p(n)
  (= (length (symbol-name n)) 4))

;********************************************************************************

(defun SDIF-type(n)
  (second (find n 
                '((|0X0301| :ETEXT) (|0X0301| :ECHAR) (|0X0004| :EFLOAT4) (|0X0008| :EFLOAT8)
                  (|0X0101| :EINT1) (|0X0102| :EINT2) (|0X0104| :EINT4) (|0X0108| :EINT8)
                  (|0X0201| :EUINT1) (|0X0202| :EUINT2) (|0X0204| :EUINT4) (|0X0208| :EUINT8)
                  (|0X0001| :EFLOAT4A) (|0X0020| :EFLOAT4B) (|0X0002| :EFLOAT8A) (|0X0040| :EFLOAT8B))
                :key #'car :test #'equal)))

;(SDIF-type '|0X0301|)

;********************************************************************************
; THE MAIN FUNCTION
;********************************************************************************

(defun SDIF-EOF-p(tag)
  (eql tag :EOF))

(defun skip-sdif-header(stream)
  (loop for tag = (read-line stream)
        until (search "SDFC" tag)))

(defmethod sdif-read ((self NULL))
  (let ((pathname (capi::prompt-for-file "SDIF file:" :filters '("SDIF"    "*.txt;*.sdif"))))
    (when pathname
      (ccl::printl pathname)
      (sdif-read pathname))))

(defmethod sdif-read ((self pathname))
  (ccl::with-message-dialog "Loading SDIF file ..."
                       (let ((*package* (find-package :pwgl-sdif))
                             (real-pathname (case (ccl::string-to-keyword (pathname-type self))
                                              (:sdif (convert-sdif self))
                                              (t self)))
                             tag)
                         (with-open-file (stream real-pathname)
                           (setq tag (read stream () :EOF))
                           (cond 
                            ((eql tag 'SDIF)
        ;(skip-sdif-header stream)
                             (make-instance 'SDIF
                                            :frames
                                            (sdif-read-frames stream)))
                            (T (error "NOT A VALID SDIF FILE")))))))

;********************************************************************************

;(class-direct-subclasses (find-class '1FTD))

(defun built-in-sdif-frame-class(sym)
  (let ((class (find sym (class-direct-subclasses (find-class '1FTD)) :key #'class-name)))
    (if class
        sym
      '1FTD)))

;(built-in-sdif-frame-class '1FQ0)
;(find '1FQ0 (class-direct-subclasses (find-class '1MTD)) :key #'class-name)

(defun built-in-sdif-matrix-class(sym)
  (let ((class (find sym (class-direct-subclasses (find-class '1MTD)) :key #'class-name)))
    (if class
        sym
      '1MTD)))

;********************************************************************************

(defclass SDIF()
  ((frames :initarg :frames :initform () :accessor frames)))

;********************************************************************************

(defclass 1FTD()
  ((Signature :initarg :Signature :initform () :accessor Signature)
   (NbMatrix :initarg :NbMatrix :initform () :accessor NbMatrix)
   (NumID :initarg :NumID :initform () :accessor NumID)
   (FrameTime :initarg :FrameTime :initform () :accessor FrameTime)
   (FrameData :initarg :FrameData :initform () :accessor FrameData)))

(defmethod standard-SDIF-frame-p((self T))
  ())

(defmethod standard-SDIF-frame-p((self 1FTD))
  self)

;;

(defun sdif-read-frames(stream)
  (loop for tag = (read stream () :EOF)
        until (SDIF-EOF-p tag)
        when
        (and (sdif-tag-p tag)
             (case (ccl::symbol-to-keyword tag)
               ((:ENDC :ENDF :SDFC) ())
               (:1TYP (sdif-read-frame (make-instance '1TYP :Signature tag) stream))
               (:1NVT (sdif-read-frame (make-instance '1NVT :Signature tag) stream))
               (:1IDS (sdif-read-frame (make-instance '1IDS :Signature tag) stream))
               (T (sdif-read-frame (make-instance (built-in-sdif-frame-class tag) :Signature tag) stream))))
        collect it))

(defmethod sdif-read-frame ((self 1FTD) stream)
  (let ((NbMatrix (read stream))
        (NumID (read stream))
        (FrameTime (read stream)))
    (setf (NbMatrix self) NbMatrix
          (NumID self) NumID
          (FrameTime self) FrameTime
          (FrameData self)
          (sdif-read-matrixes NbMatrix stream))
    self))

;********************************************************************************

(defclass 1MTD()
  ((Signature :initarg :Signature :initform () :accessor Signature)
   (DataType :initarg :DataType :initform () :accessor DataType)
   (NbRow :initarg :NbRow :initform () :accessor NbRow)
   (NbCol :initarg :NbCol :initform () :accessor NbCol)
   (MatrixData :initarg :MatrixData :initform () :accessor MatrixData)))

(defun sdif-read-matrixes(NbMatrix stream)
  (loop repeat NbMatrix
        collect
        (let ((tag (read stream () :EOF)))
          (when (sdif-tag-p tag)
            (sdif-read-matrix (make-instance (built-in-sdif-matrix-class tag) :Signature tag) stream)))))

#|
(defmethod sdif-read-matrix((self 1MTD) stream)
  (let ((DataType (SDIF-type (read stream)))
        (NbRow (read stream))
        (NbCol (read stream)))
    (setf (DataType self) DataType
          (NbRow self) NbRow
          (NbCol self) NbCol
          (MatrixData self)
          (if (= NbCol 1)
              (loop repeat NbRow collect (read stream))
            (loop repeat NbRow collect
                  (loop repeat NbCol collect (read stream)))))
    self))


(defmethod sdif-read-matrix((self 1MTD) stream)
  (let ((DataType (SDIF-type (read stream)))
        (NbRow (read stream))
        (NbCol (read stream)))
    (setf (DataType self) DataType
          (NbRow self) NbRow
          (NbCol self) NbCol
          (MatrixData self)
          (loop repeat NbRow collect
                (loop repeat NbCol collect (read stream))))
    self))
|#

(defmethod sdif-read-matrix((self 1MTD) stream)
  (let ((DataType (SDIF-type (read stream)))
        (NbRow (read stream))
        (NbCol (read stream)))
    (setf (DataType self) DataType
          (NbRow self) NbRow
          (NbCol self) NbCol
          (MatrixData self)
          (print (if (loop repeat NbRow collect
                           (loop repeat NbCol collect (read stream)))
                     (loop repeat NbRow collect
                           (loop repeat NbCol collect (read stream)))
                   9999)))
    (print "--------------------------")    
    self))

;********************************************************************************

(defclass 1NVT(skipped-sdif-frame)
  ())

(defmethod sdif-read-frame ((self 1NVT) stream)
  (setf (stuff self) (read-brace-delimited-list stream :terminate-on-semicolon-p t))
  self)

;********************************************************************************

(defclass 1TYP(skipped-sdif-frame)
  ())

(defun create-SDIF-prop(inherit class prop-definitions)
  (cond 
   ((eql inherit '1FTD)
    ())
   ((eql inherit '1MTD)
    (loop for prop in prop-definitions
          for n from 0 collect
          (prog1
              `(,class ,(ccl::symbol-to-keyword prop))
            (unless (find-class class ())
              (print (eval `(defclass ,class(1MTD)
                              ()))))
            (print (eval `(defmethod sdif-prop((self ,class) (prop (eql ,(ccl::symbol-to-keyword prop))))
                            (loop for MatrixData in (MatrixData self)
                                  collect (nth ,n MatrixData))))))))))

;(create-SDIF-prop '1MTD 'IGBF '(windowsize framesize))

(defmethod sdif-read-frame ((self 1TYP) stream)
  (let ((1TYP (read-brace-delimited-list stream)))
    (setf (stuff self)
          (loop for inherit in 1TYP by #'cdddr
                for class  in (cdr 1TYP) by #'cdddr
                for prop-definitions  in (cddr 1TYP) by #'cdddr
                collect
                (create-SDIF-prop inherit class prop-definitions)))
    self))

;(sdif-prop *SDIF* '(:frametime))

;********************************************************************************

(defclass skipped-sdif-frame()
  ((Signature :initarg :Signature :initform () :accessor Signature)
   (stuff :initarg :stuff :initform () :accessor stuff)))


(defclass 1IDS(skipped-sdif-frame)
  ())

(defmethod sdif-read-frame ((self skipped-sdif-frame) stream)
  (setf (stuff self) (read-brace-delimited-list stream))
  self)

;******************************************************************************** 

(defclass void-sdif-frame()
  ((Signature :initarg :Signature :initform () :accessor Signature)
   (stuff :initarg :stuff :initform () :accessor stuff)))

(defclass ENDC(void-sdif-frame)
  ())

(defclass ENDF(void-sdif-frame)
  ())

(defclass SDFC(void-sdif-frame)
  ())

(defmethod sdif-read-frame ((self void-sdif-frame) stream)
  ())

;********************************************************************************
;TEST CASES
;********************************************************************************

;(defparameter *SDIF* ())
;(setq *SDIF* (sdif-read (current-pathname "1.sdif")))
;(setq *SDIF* (sdif-read (current-pathname "2.sdif")))
;(setq *SDIF* (sdif-read (current-pathname "3.sdif")))
;(setq *SDIF* (sdif-read (current-pathname "4.sdif")))
;(setq *SDIF* (sdif-read (current-pathname "5.sdif")))
;(inspect *SDIF*)

;********************************************************************************

(defmethod sdif-prop((self t) prop)
  ())

(defmethod sdif-prop((self cons) prop)
  (mapcar #'(lambda(x) (sdif-prop x prop)) self))

;

(defmethod sdif-prop((self SDIF) (props list))
  (when props
    (apply #'mapcar #'list
           (loop for prop in props
                 collect (sdif-prop self prop)))))

#|
(defmethod sdif-prop((self SDIF) (props list))
  (when props
    (apply #'mapcar #'list 
           (loop for prop in props
                 collect 
                 (sdif-prop self prop)))))
|#

(defmethod sdif-prop((self SDIF) (props list))
  (when props
    (loop for prop in props
          collect 
          (sdif-prop self prop))))

;(apply #'mapcar #'list '(1.0 2.0) (apply #'mapcar #'list '((226.412 550.278 1003.48) (0.020674 0.0182309 0.011899))))

;(sdif-prop *SDIF* '(:FrameTime :freq))
;(sdif-prop *SDIF* '(:FrameTime :matrix-data))
;(sdif-prop *SDIF* :FrameTime)
;(sdif-prop *SDIF* :freq)

(defmethod sdif-prop((self SDIF) prop)
  (loop for frame in (frames self)
        append
        (when (standard-SDIF-frame-p frame)
          (loop for matrix in (FrameData frame)
                when
                (sdif-prop matrix prop)
                collect it))))

(defmethod sdif-prop((self SDIF) (prop (eql :frameTime)))
  (loop for frame in (frames self)
        when (standard-SDIF-frame-p frame)
        collect
        (FrameTime frame)))

(defmethod sdif-prop((self SDIF) (prop (eql :readers)))
  (loop for frame in (frames self)
        when (eql (type-of frame) '1TYP)
        append
        (mapcar #'second (ccl::PWGL-apply #'append (remove () (stuff frame))))))

;(sdif-prop *SDIF* :FrameTime)
;(sdif-prop *SDIF* :freq)
;(sdif-prop *SDIF* :amp)
;(sdif-prop *SDIF* :matrix-data)
;(sdif-prop *SDIF* :confidence)

;********************************************************************************

(defmethod sdif-prop((self 1MTD) (prop (eql :matrix-data)))
  (loop for MatrixData in (MatrixData self)
        collect (print MatrixData)))

;********************************************************************************

#|
1TRC
Index, freq, amp, phase
Sinusoidal tracks represent sinusoids that maintain their continuity over time as their frequencies, amplitudes, and phases evolve. Sinusoidal tracks are the standard data format used as the input to classical additive synthesis.
|#

(defclass 1TRC(1MTD)
  ())

(defmethod sdif-prop((self 1TRC) (prop (eql :Index)))
  (loop for MatrixData in (MatrixData self)
        collect (first MatrixData)))

(defmethod sdif-prop((self 1TRC) (prop (eql :freq)))
  (loop for MatrixData in (MatrixData self)
        collect (second MatrixData)))

(defmethod sdif-prop((self 1TRC) (prop (eql :amp)))
  (loop for MatrixData in (MatrixData self)
        collect (third MatrixData)))

(defmethod sdif-prop((self 1TRC) (prop (eql :phase)))
  (loop for MatrixData in (MatrixData self)
        collect (fourth MatrixData)))

#|
1FQ0
Fundamental frequency, confidence
Not all sounds have a definite fundamental frequency; some have multiple possible fundamental frequencies. Note that we use the term "fundamental frequency" or "f0" rather than "pitch"; this is because pitch is a perceptual phenomenon while fundamental frequency is a signal processing quantity. We might invent a new SDIF frame and matrix type for pitch to represent the result of a true pitch estimator that applied a model based on human perception.
|#

(defclass 1FQ0(1MTD)
  ())

(defmethod sdif-prop((self 1FQ0) (prop (eql :freq)))
  (loop for MatrixData in (MatrixData self)
        collect (first MatrixData)))

(defmethod sdif-prop((self 1FQ0) (prop (eql :confidence)))
  (loop for MatrixData in (MatrixData self)
        collect (or (second MatrixData) 1)))

#|

|#