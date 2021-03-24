

(in-package :ht-pwgl-as)




;------------------------------------------------------------------------

(in-menu f0)
(define-box f0-analysis ((input-file pathname) &key output-file (output-type :txt))
            "this function calls supervp with a given format string"
            :non-generic t
            (let
                ((supervp "/Applications/AudioSculpt 2.8.3/AudioSculpt.app/Contents/MacOS/supervp"))
              (let ((out (or output-file
                             (generate-tmp-file :type "sdif") 
                             
                             )))
                (ccl::call-system-showing-output (format () "'~a' -t -ns -S'~a' -Af0 -OS0 '~a'" supervp (namestring input-file) (namestring out)))
                out)))




;(ccl::printl (ccl::namestring (capi::prompt-for-file "point to AudioSculpt/Kernals/supervp" :filters '("AudioSculpt/Kernals/supervp"    "*.*"))))

;(ccl::printl HT-PWGL-AS::*svp_unixpath*)