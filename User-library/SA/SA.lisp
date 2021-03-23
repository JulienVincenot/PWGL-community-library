(in-package :SA)

(ccl::def-pwgl-library-preference *supervp-command* "/Applications/AudioSculpt 2.6/Kernels/supervp.app/Contents/MacOS/supervp" :SA :title "supervp command" :editor-type :file)
(ccl::def-pwgl-library-preference *pm2-command* "/Applications/AudioSculpt 2.6/Kernels/pm2.app/Contents/MacOS/pm2" :SA :title "pm2 command" :editor-type :file)

;********************************************************************************

(defclass sa-box(ccl::pwgl-shell-box)
  ())

;********************************************************************************
;supervp
;********************************************************************************

(defclass supervp (sa-box)
  ()
  (:default-initargs
   :option-type :ircam
   :shell-command :supervp))

;(defmethod ccl::mk-extra-input-for-function?((self (eql 'supervp)) (box t)) ())

(defmethod ccl::shell-command ((self supervp))
  *supervp-command*)

(defmethod ccl::shell-command-name ((self supervp))
  "supervp")

(PWGLDef supervp (&rest (argn ()))
    "SuperVP (Super Vocoder de Phase) is the kernel in AudioSculpt. Using SuperVP, it is possible to carry out offline analysis/synthesis processing. From normalization to filtering, not forgetting cross synthesis, SuperVP offers the advantages of the Unix shell such as scripting and batch processing."
    (:class 'supervp :w 0.4 
     :outputs (list (make-instance 'ccl::PWGL-shell-box-output :output-type :exe :box-string "exe")
                    (make-instance 'ccl::PWGL-shell-box-output :output-type :pipe :box-string "pipe")))
    ())

(ccl::add-shell-command-database
 (ccl::simple-parse-options "supervp" (ccl::pwgl-location "sa" #p"shell-database/supervp.txt")))

;********************************************************************************
;pm2
;********************************************************************************

(defclass pm2 (sa-box)
  ()
  (:default-initargs
   :option-type :ircam
   :shell-command :pm2))

;(defmethod ccl::mk-extra-input-for-function?((self (eql 'pm2)) (box t)) ())

(defmethod ccl::shell-command ((self pm2))
  *pm2-command*)

(defmethod ccl::shell-command-name ((self pm2))
  "pm2")

(PWGLDef pm2 (&rest (argn ()))
    "Pm2, is used for partial analysis and synthesis. However, unlike SuperVP, it uses the additive signal model, and not FFT."
    (:class 'pm2 :w 0.4 
     :outputs (list (make-instance 'ccl::PWGL-shell-box-output :output-type :exe :box-string "exe")
                    (make-instance 'ccl::PWGL-shell-box-output :output-type :pipe :box-string "pipe")))
    ())

(ccl::add-shell-command-database
 (ccl::simple-parse-options "pm2" (ccl::pwgl-location "sa" #p"shell-database/pm2.txt")))

;********************************************************************************

(defmethod ccl::mk-extra-input-for-function? ((self symbol) (box supervp)) ())
(defmethod ccl::mk-extra-input-for-function? ((self symbol) (box pm2)) ())

;********************************************************************************