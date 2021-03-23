(in-package :ccl)

;********************************************************************************
; PWGL Box definition
;********************************************************************************

(PWGLDef supervp ((input-file ()) 
            (analysis-type () (mk-menu-subview :menu-list '(":f0" ":fft" ":chordseq" ":sonogram" ":markers") :value 0)) 
            &optional (flags ()))
    "PWGL supervp interface"
    (:groupings '(1 1) :w 0.35)
  (unless input-file (setq input-file (capi::prompt-for-file "" :filters '("" "*.*"))))
  (supervp-analysis input-file analysis-type))
      
(defmethod supervp-analysis :around ((input-file pathname) (analysis-type t) &key output-file (output-type :txt) (read-p t))
  (if (and (eql output-type :sdif) read-p)
      (format *so* "output-type = :sdif and read-p = T is not a valid combination!")
    (let ((out (call-next-method))
          tmp-file)
      (when out
        (setq tmp-file
              (case output-type
                (:sdif out)
                (:txt (pwgl-sdif::convert-sdif out))))
        (if read-p
            (pwgl-sdif::sdif-read tmp-file)
          tmp-file)))))

;********************************************************************************
; supervp-analysis methods
;********************************************************************************

(defun generate-tmp-file(&key (prefix "") type)
;(merge-pathnames (make-pathname :name (format () "~a~a" prefix (random 9999999999999999)) :type type) (ccl::ENP-application-pathname :tmp))  
(merge-pathnames (make-pathname :name (format () "~a~a" prefix (random 9999999999999999)) :type type) "/Applications/AudioSculpt 2.8.3/"))

(defmethod supervp-analysis((input-file pathname) (analysis-type t) &key output-file (output-type :txt))
  ())


(defmethod supervp-analysis((input-file pathname) (analysis-type (eql :f0)) &key output-file (output-type :txt))
  (let ;((supervp "/Applications/AudioSculpt 2.8.3/Kernels/supervp.app/Contents/MacOS/supervp"))
      ((supervp "/Applications/AudioSculpt 2.8.3/AudioSculpt.app/Contents/MacOS/supervp"))
    (let ((out (or output-file
                   (generate-tmp-file :type "sdif") 
                   ;;;(merge-pathnames (make-pathname :name (format () "_pwglsdif~a" (random 9999999999999999)) :type "sdif") (ccl::ENP-application-pathname :tmp))
                   )))
      (ccl::call-system-showing-output (format () "'~a' -t -ns -S'~a' -Af0 -OS0 '~a'" supervp (namestring input-file) (namestring out)))
      out)))

(defmethod supervp-analysis((input-file pathname) (analysis-type (eql :fft)) &key output-file (output-type :txt))
  (let ((supervp "/Applications/AudioSculpt 2.8.3/AudioSculpt.app/Contents/MacOS/supervp"))
    (let ((out (or output-file
                   (generate-tmp-file :type "sdif")
                   ;;;(merge-pathnames (make-pathname :name (format () "_pwglsdif~a" (random 9999999999999999)) :type "sdif") (ccl::ENP-application-pathname :tmp))
                   )))
      (ccl::call-system-showing-output (format () "'~a' -t -ns -S'~a' -Afft -OS0 '~a'" supervp (namestring input-file) (namestring out)))
      out)))

(defmethod supervp-analysis((input-file pathname) (analysis-type (eql :chordseq)) &key output-file (output-type :txt))
  (let ((supervp "/Applications/AudioSculpt 2.8.3/AudioSculpt.app/Contents/MacOS/supervp")
        (pm2 "/Applications/AudioSculpt 2.8.3/AudioSculpt.app/Contents/MacOS/pm2"))
    (let (sdif
          frame-start-times
          chord-times
          (tmp-file (generate-tmp-file :prefix "chords" :type "txt")
                    ;;;(merge-pathnames (make-pathname :name (format () "_chords~a" (random 9999999999999999)) :type "txt") (ccl::ENP-application-pathname :tmp))
                    )
          (out (or output-file
                   (generate-tmp-file :prefix "sdif" :type "sdif")
                   ;;;(merge-pathnames (make-pathname :name (format () "_sdif~a" (random 9999999999999999)) :type "sdif") (ccl::ENP-application-pathname :tmp))
                   )))
      (ccl::call-system-showing-output (format () "'~a' -t  -S'~a' -Afft  -N2048 -M2048 -oversamp 8 -Wblackman  -OT -td_thresh 1.39999998 -td_G 2.5 -td_band 0.0,22050.0 -td_nument 10.0 '~a'"
                                               supervp (namestring input-file) (namestring out)))
      (setq sdif (pwgl-sdif::sdif-read out)
            frame-start-times (pwgl-sdif::sdif-prop sdif :frametime)
            chord-times (loop for frame-start-time in frame-start-times by #'cddr
                              collect frame-start-time))
      (with-output-file (stream tmp-file)
                        (loop for chord-time1 in chord-times
                              for chord-time2 in (cdr chord-times)
                              do
                              (format stream "~a ~a~%" chord-time1 chord-time2)))
      (ccl::call-system-showing-output (format () "'~a' -S'~a' -Aseqs  -N2048 -M2048 -I256.0  -Wblackman  -OS -p1 -q15 -m40.0 --chords='~a'  '~a'" pm2 (namestring input-file) (namestring tmp-file) (namestring out)))
;pm2  
      out)))

(defmethod supervp-analysis((input-file pathname) (analysis-type (eql :sonogram)) &key output-file (output-type :txt))
  (let ((supervp "/Applications/AudioSculpt 2.8.3/AudioSculpt.app/Contents/MacOS/supervp"))
    (let ((out (or output-file
                   (generate-tmp-file :type "sdif")
                   ;;;(merge-pathnames (make-pathname :name (format () "_pwglsdif~a" (random 9999999999999999)) :type "sdif") (ccl::ENP-application-pathname :tmp))
                   )))
      (ccl::call-system-showing-output (format () "'~a' -t -ns  -S'~a' -Afft  -N2048 -M2048 -oversamp 8 -Wblackman  -OS0  '~a'" supervp (namestring input-file) (namestring out)))
      out)))


(defmethod supervp-analysis((input-file pathname) (analysis-type (eql :markers)) &key output-file (output-type :txt))
  (let ((supervp "/Applications/AudioSculpt 2.8.3/AudioSculpt.app/Contents/MacOS/supervp"))
    (let ((out (or output-file
                   (generate-tmp-file :type "sdif")
                   ;;;(merge-pathnames (make-pathname :name (format () "_pwglsdif~a" (random 9999999999999999)) :type "sdif") (ccl::ENP-application-pathname :tmp))
                   )))
      (ccl::call-system-showing-output (format () "'~a' -t  -S'~a' -Afft  -N2048 -M2048 -oversamp 8 -Wblackman  -OT -td_thresh 1.39999998 -td_G 2.5 -td_band 0.0,22050.0 -td_nument 10.0 '~a'" supervp (namestring input-file) (namestring out)))
      out)))



#|
(supervp-analysis #p"/Applications/AudioSculpt 2.8.3/Sounds/africa.aiff" :f0)
(supervp-analysis #p"/Applications/AudioSculpt 2.8.3/Sounds/africa.aiff" :f0 :output-file #p"/Users/mika/Desktop/test.sdif")
(supervp-analysis #p"/Applications/AudioSculpt 2.8.3/Sounds/africa.aiff" :f0 :output-file #p"/Users/mika/Desktop/test.sdif" :output-type :sdif)
(supervp-analysis #p"/Applications/AudioSculpt 2.8.3/Sounds/africa.aiff" :f0 :output-file #p"/Users/mika/Desktop/test.sdif" :read-p ())

(supervp-analysis #p"/Applications/AudioSculpt 2.8.3/Sounds/africa.aiff" :sonogram)
(supervp-analysis #p"/Applications/AudioSculpt 2.8.3/Sounds/africa.aiff" :markers)


(supervp-analysis #p"/Applications/AudioSculpt 2.8.3/Sounds/africa.aiff" :chordseq)
(setq aaa (supervp-analysis #p"/Applications/AudioSculpt 2.8.3/Sounds/africa.aiff" :chordseq))
(pwgl-sdif::sdif-prop aaa :freq)
(pwgl-sdif::sdif-prop aaa :amp)
|#