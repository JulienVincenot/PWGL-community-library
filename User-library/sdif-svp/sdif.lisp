(in-package :SDIF-SVP)

;********************************************************************************
;querysdif
;********************************************************************************

(defclass sdif-svp-box(ccl::pwgl-shell-box)
  ())

(defclass sdif-svp-file-box(sdif-svp-box)
  ()
  (:default-initargs
   :io-type :file))

;********************************************************************************

(defclass querysdif (sdif-svp-box)
  ()
  (:default-initargs
   :help-command "-h"
   :shell-command :querysdif))

;(defmethod ccl::mk-extra-input-for-function?((self (eql 'querysdif)) (box t)) ())

(defmethod ccl::shell-command ((self querysdif))
  #.(ccl::pwgl-location "sdif-svp" #p"querysdif"))

(PWGLDef querysdif (&rest (argn ()))
    "View summary of data in an SDIF-file.  Per default, all ASCII chunks are
printed, followed by a count of the frames and the matrices occuring in
the file."
    (:class 'querysdif :w 0.4 
     :outputs (list (make-instance 'ccl::PWGL-shell-box-output :output-type :exe :box-string "exe")
                    (make-instance 'ccl::PWGL-shell-box-output :output-type :pipe :box-string "pipe")))
  ())

(ccl::add-shell-command-database
 (ccl::simple-parse-options "querysdif" (ccl::pwgl-location "sdif-svp" #p"shell-database/querysdif.txt")))

;********************************************************************************
;sdifextract
;********************************************************************************

(defclass sdifextract (sdif-svp-box)
  ((special-patch-value-p :initarg :special-patch-value-p :initform () :accessor special-patch-value-p))
  (:default-initargs
   :post-process :sdifextract
   :help-command "-h"
   :shell-command :sdifextract))

;(defmethod ccl::mk-extra-input-for-function?((self (eql 'sdifextract)) (box t)) ())

(defmethod ccl::shell-command ((self sdifextract))
  #.(ccl::pwgl-location "sdif-svp" #p"sdifextract"))

(ccl::make-key-event ccl::pwgl-pw-window sdifextract #\. "sdifextract change mode" (if (equalp (file-namestring (ccl::shell-command ccl::self)) "sdifextract")
                                                                                       (compile `(defmethod ccl::shell-command ((self sdifextract))
                                                                                                   #.(ccl::pwgl-location "sdif-svp" #p"LISPsdifextract")))
                                                                                     (compile `(defmethod ccl::shell-command ((self sdifextract))
                                                                                                 #.(ccl::pwgl-location "sdif-svp" #p"sdifextract")))))

(PWGLDef sdifextract (&rest (argn ()))
    ""
    (:class 'sdifextract :w 0.4 
     :outputs (list (make-instance 'ccl::PWGL-shell-box-output :output-type :exe :box-string "exe")
                    (make-instance 'ccl::PWGL-shell-box-output :output-type :pipe :box-string "pipe")))
  ())


(defmethod ccl::patch-value ((self sdifextract) outbox)
  (if (special-patch-value-p self)
      (when (ccl::shell-command self)
        (let ((tmp-file (ccl::pwgl-location :tmp (ccl::%address-of self))))
          (let ((args (ccl::construct-shell-args self :redirect-to-file tmp-file)))
            (case (ccl::output-type outbox)
              (:exe
               (time (ccl::pwgl-shell-box-call-system self args)))
              (:pipe
               args)))
          (with-open-stream (in (open tmp-file :direction :input))
            (time (read in)))))
    (call-next-method)))


(defmethod ccl::pwgl-shell-box-post-process((self ccl::pwgl-basic-shell-box) (in stream) (type (eql :sdifextract)))
  (loop for x = (read-line in () ())
        while x
        collect (mapcar #'read-from-string (ccl::read-all-from-string x :DELIMITING-CHAR #\tab))))

; 

(defun collect-numbers (in-string)
  (let ((start 0))
    (loop for n = (multiple-value-bind (s l) (lw:find-regexp-in-string " ?[A-Z0-9.]+" in-string :start start :case-sensitive ())
                    (when s
                      (setq start (+ s l))
                      (read-from-string (subseq in-string s start))))
          while n
          when n
          collect it)))

#|
(defun collect-numbers (string)
  (unless (ccl::empty-string-p string)
    (let ((numbers nil)
          (len (length string))
          (where 0))
      (loop
       (let ((next (position #\tab string :start where)))
         (unless (equal where len)
           (push (ccl::parse-float string
                                   :start where
                                   :end next)
                 numbers))
         (unless next
           (return (reverse numbers))) 
         (setf where (1+ next)))))))

(defun collect-numbers(string)
  (with-input-from-string (stream string)
    (loop for x = (read stream () ())
          while x
          collect x)))
|#

;(time (collect-numbers "234.34 234.45 565"))
;(collect-numbers "234.34 234.45 565 ")
;(collect-numbers "234.34 ")
;(collect-numbers "234.34")
;(collect-numbers "")
;(collect-numbers " ")
;(collect-numbers "  ")
;(collect-numbers " 88.000000	")
;(time (collect-numbers "3.000000	44100.000000	  1.000000	1024.000000	  8.000000"))

(defmethod ccl::pwgl-shell-box-post-process((self ccl::pwgl-basic-shell-box) (in stream) (type (eql :sdifextract)))
  (let (res)
    (loop for x = (read-line in () ())
          while x do
          (push (collect-numbers x) res))
    (nreverse res)))

(defmethod ccl::pwgl-shell-box-post-process((self ccl::pwgl-basic-shell-box) (in stream) (type (eql :flat)))
  (let (res)
    (loop for x = (read in () ())
          while x do
          (push x res))
    (nreverse res)))

(defmethod ccl::pwgl-shell-box-post-process((self ccl::pwgl-basic-shell-box) (in stream) (type (eql :read)))
  (read in () ()))

;(mapcar #'read-from-string (ccl::read-all-from-string " 23.000000	" :DELIMITING-CHAR #\tab))

(ccl::add-pwgl-shell-box-pre-process "sdifextract" "-t" #'(lambda(x) (format () "~f-~f" (car x) (cadr x))))
;(ccl::add-pwgl-shell-box-pre-process "LISPsdifextract" "-t" #'(lambda(x) (format () "~f-~f" (car x) (cadr x))))

(ccl::add-shell-command-database
 (ccl::simple-parse-options "sdifextract" (ccl::pwgl-location "sdif-svp" #p"shell-database/sdifextract.txt")))

;********************************************************************************
;supervp
;********************************************************************************

(defclass supervp (sdif-svp-box)
  ()
  (:default-initargs
   :option-type :ircam
   :shell-command :supervp))

;(defmethod ccl::mk-extra-input-for-function?((self (eql 'supervp)) (box t)) ())

(defmethod ccl::shell-command ((self supervp))
  #.(ccl::pwgl-location "sdif-svp" #p"supervp"))

(PWGLDef supervp (&rest (argn ()))
    "SuperVP (Super Vocoder de Phase) is the kernel in AudioSculpt. Using SuperVP, it is possible to carry out offline analysis/synthesis processing. From normalization to filtering, not forgetting cross synthesis, SuperVP offers the advantages of the Unix shell such as scripting and batch processing."
    (:class 'supervp :w 0.4 
     :outputs (list (make-instance 'ccl::PWGL-shell-box-output :output-type :exe :box-string "exe")
                    (make-instance 'ccl::PWGL-shell-box-output :output-type :pipe :box-string "pipe")))
  ())

(ccl::add-shell-command-database
 (ccl::simple-parse-options "supervp" (ccl::pwgl-location "sdif-svp" #p"shell-database/supervp.txt")))

;********************************************************************************
;pm2
;********************************************************************************

(defclass pm2 (sdif-svp-box)
  ()
  (:default-initargs
   :option-type :ircam
   :shell-command :pm2))

;(defmethod ccl::mk-extra-input-for-function?((self (eql 'pm2)) (box t)) ())

(defmethod ccl::shell-command ((self pm2))
  #.(ccl::pwgl-location "sdif-svp" #p"pm2"))

(PWGLDef pm2 (&rest (argn ()))
    "Pm2, is used for partial analysis and synthesis. However, unlike SuperVP, it uses the additive signal model, and not FFT."
    (:class 'pm2 :w 0.4 
     :outputs (list (make-instance 'ccl::PWGL-shell-box-output :output-type :exe :box-string "exe")
                    (make-instance 'ccl::PWGL-shell-box-output :output-type :pipe :box-string "pipe")))
  ())

(ccl::add-shell-command-database
 (ccl::simple-parse-options "pm2" (ccl::pwgl-location "sdif-svp" #p"shell-database/pm2.txt")))

;ln -f -s /Applications/AudioSculpt\ 2.6/Kernels/supervp.app/Contents/MacOS/supervp  /Users/mika/PWGL-User/User-library/sdif-svp/supervp
;ln -f -s /Applications/AudioSculpt\ 2.6/Kernels/pm2.app/Contents/MacOS/pm2  /Users/mika/PWGL-User/User-library/sdif-svp/pm2
;ln -f /usr/local/bin/sdifextract /Users/mika/PWGL-User/User-library/sdif-svp/sdifextract
;ln -f /usr/local/bin/querysdif /Users/mika/PWGL-User/User-library/sdif-svp/querysdif 

;(ccl::call-system "cd /Users/mika/PWGL-User/User-library/sdif-svp/SDIF-3.10.5-src; configure; make; sudo make install; cp /usr/local/bin/sdifextract /Users/mika/PWGL-User/User-library/sdif-svp/LISPsdifextract")