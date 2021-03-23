(in-package :SDIF)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defparameter *querysdif-command* (ccl::pwgl-location "sdif" #p"bin/querysdif"))
  (defparameter *sdifextract-command* (ccl::pwgl-location "sdif" #p"bin/sdifextract")))

;********************************************************************************
;querysdif
;********************************************************************************

(defclass sdif-box(ccl::pwgl-shell-box)
  ())

(defclass sdif-file-box(sdif-box)
  ()
  (:default-initargs
   :io-type :file))

;********************************************************************************

(defclass querysdif (sdif-box)
  ()
  (:default-initargs
   :help-command "-h"
   :shell-command :querysdif
   :w 0.4
   :h 0.025))

(defmethod ccl::shell-command ((self querysdif))
  *querysdif-command*)

(defmethod ccl::shell-command-name ((self querysdif))
  "querysdif")

(PWGLDef querysdif (&rest (argn ()))
    "View summary of data in an SDIF-file."
    (:class 'querysdif :w 0.4 
     :outputs (list (make-instance 'ccl::PWGL-shell-box-output :output-type :exe :box-string "exe")
                    (make-instance 'ccl::PWGL-shell-box-output :output-type :pipe :box-string "pipe")))
  ())

(ccl::add-shell-command-database
 (ccl::simple-parse-options "querysdif" (ccl::pwgl-location "sdif" #p"shell-database/querysdif.txt")))

;********************************************************************************
;sdifextract
;********************************************************************************

(defclass sdifextract (sdif-box)
  ()
  (:default-initargs
   ;;; :post-process :sdifextract
   :help-command "-h"
   :shell-command :sdifextract
   :w 0.4
   :h 0.025))

(defmethod ccl::shell-command ((self sdifextract))
  *sdifextract-command*)

(defmethod ccl::shell-command-name ((self sdifextract))
  "sdifextract")

(PWGLDef sdifextract (&rest (argn ()))
    "Extract data in the given stream, frame type, matrix type, row and column."
    (:class 'sdifextract :w 0.4 
     :outputs (list (make-instance 'ccl::PWGL-shell-box-output :output-type :exe :box-string "exe")
                    (make-instance 'ccl::PWGL-shell-box-output :output-type :pipe :box-string "pipe")))
  ())

(defmethod ccl::patch-value ((self sdifextract) outbox)
  (when (ccl::shell-command self)
    (let ((tmp-file (ccl::pwgl-location :tmp (ccl::object-address self))))
      (let ((args (ccl::construct-shell-args self :redirect-to-file tmp-file)))
        (case (ccl::output-type outbox)
          (:exe
           (ccl::pwgl-shell-box-call-system self args))
          (:pipe
           args))
        (case (ccl::output-type outbox)
          (:exe
           (with-open-stream (in (open tmp-file :direction :input))
             (read in () ())))
          (:pipe args))))))

(ccl::add-pwgl-shell-box-pre-process "sdifextract" "-t" #'(lambda(x) 
                                                            (if (stringp x)
                                                                x
                                                              (format () "~f-~f" (car x) (cadr x)))))

(ccl::add-shell-command-database
 (ccl::simple-parse-options "sdifextract" (ccl::pwgl-location "sdif" #p"shell-database/sdifextract.txt")))

;********************************************************************************

(defmethod ccl::mk-extra-input-for-function? ((self symbol) (box querysdif)) ())
(defmethod ccl::mk-extra-input-for-function? ((self symbol) (box sdifextract)) ())

(pwgldef SDIF-selection ((filename ()) &key (stream ()) (frame ()) (matrix ()) (column ()) (row ()) (time ()))
    ""
    (:groupings '(1) :extension-pattern '(2))
  (with-output-to-string (selection)
    (format selection "~a::" filename)
    (ccl::when-let (selection-component stream)
      (format selection "#~a" selection-component))
    (ccl::when-let (selection-component frame)
      (format selection ":~a" selection-component))
    (ccl::when-let (selection-component matrix)
      (format selection "/~a" selection-component))
    (ccl::when-let (selection-component column)
      (format selection ".~a" selection-component))
    (ccl::when-let (selection-component row)
      (format selection "_~a" selection-component))
    (ccl::when-let (selection-component time)
      (format selection "@~a" selection-component))))

;;; [filename]::[#stream][:frame][/matrix][.column][_row][@time]

(pwgldef SDIF-range (&key (begin NIL) (end NIL) (delta NIL))
    ""
    (:groupings () :extension-pattern '(2))
  (if delta
      (format () "~f+~f" begin delta)
    (format () "~f-~f" begin end)))

(pwgldef SDIF-selection-spec (&key (begin NIL) (end NIL) (list NIL) (range NIL))
    ""
    (:groupings () :extension-pattern '(2))
  (if list 
      (format () "~@{~a~^,~}" list)
    (if range
        (if (cdr range)
            (format () "~f-~f" (car range) (cadr range))
          "")
      (if begin
          (if end
              (format () "~f-~f" begin end)
            (format () "~f-" begin))
        (if end
            (format () "-~f" end)
          "")))))
        
    

