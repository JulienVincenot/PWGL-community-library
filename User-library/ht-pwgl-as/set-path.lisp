

(in-package :ht-pwgl-as)



(defvar HT-PWGL-AS::*svp_unixpath* nil)
(setf HT-PWGL-AS::*svp_unixpath* nil)

(defvar HT-PWGL-AS::*pwgl-as-source-sound-folder* nil)
(setf HT-PWGL-AS::*pwgl-as-source-sound-folder* nil)
(defvar HT-PWGL-AS::*pwgl-as-result-sound-folder* nil)
(setf HT-PWGL-AS::*pwgl-as-result-sound-folder* nil)
(defvar HT-PWGL-AS::*pwgl-as-parameter-folder* nil)
(setf HT-PWGL-AS::*pwgl-as-parameter-folder* nil)

(defvar HT-PWGL-AS::*pwgl-as-appli-prefsfile* nil)
(setf HT-PWGL-AS::*pwgl-as-appli-prefsfile* #P"/Applications/ht-pwgl-as-prefappli")

(defvar HT-PWGL-AS::*pwgl-as-soundout-prefsfile* nil)
(setf HT-PWGL-AS::*pwgl-as-soundout-prefsfile* #P"/Applications/ht-pwgl-as-prefsoundout")

(defvar HT-PWGL-AS::*pwgl-as-soundin-prefsfile* nil)
(setf HT-PWGL-AS::*pwgl-as-soundin-prefsfile*  #P"/Applications/ht-pwgl-as-prefsoundin")

(defvar HT-PWGL-AS::*pwgl-as-param-prefsfile* nil)
(setf HT-PWGL-AS::*pwgl-as-param-prefsfile*  #P"/Applications/ht-pwgl-as-prefparam")


(if (probe-file HT-PWGL-AS::*pwgl-as-appli-prefsfile*)
  (load HT-PWGL-AS::*pwgl-as-appli-prefsfile* :verbose nil)
  (print "FOLDER for the application AUDIOSCULPT must be specified"))

(if (probe-file HT-PWGL-AS::*pwgl-as-param-prefsfile*)
  (load HT-PWGL-AS::*pwgl-as-param-prefsfile* :verbose nil)
  (print "FOLDER for parameterfiles must be specified"))

(if (probe-file HT-PWGL-AS::*pwgl-as-soundin-prefsfile*)
  (load HT-PWGL-AS::*pwgl-as-soundin-prefsfile* :verbose nil)
  (print "FOLDER for source sounds must be specified"))

(if (probe-file HT-PWGL-AS::*pwgl-as-soundout-prefsfile*)
  (load HT-PWGL-AS::*pwgl-as-soundout-prefsfile* :verbose nil)
  (print "FOLDER for resulting sounds must be specified"))



(in-menu access-path)
;---------------------------------------------------------------------------------------------------------
(define-box HT-PWGL-AS::set-AudioSculpt-folder ()
  "point the file selector to /Applications/AudioSculpt/Kernels/supervp - this just needs 
to be done once, unless you change your AudioSculpt installation"
  :non-generic t
  
  (let ((newpath (ccl::namestring 
                  (capi::prompt-for-file "point to AudioSculpt/Kernals/supervp" :filters '("AudioSculpt/Kernals/supervp"    "*.*")))))
    (when newpath
      (setf HT-PWGL-AS::*svp_unixpath* newpath)
      (WITH-OPEN-FILE (out HT-PWGL-AS::*pwgl-as-appli-prefsfile* :direction :output  
                           :if-does-not-exist :create :if-exists :supersede) 
        (prin1 '(in-package :HT-PWGL-AS) out)
        (let ((*package* (find-package :HT-PWGL-AS)))
          (prin1 `(setf HT-PWGL-AS::*svp_unixpath* ,  newpath) out)))
      )
    ))

(define-box HT-PWGL-AS::print-AudioSculpt-folder ()
  "prints the current path for supervp"
  :non-generic t
  (ccl::printl  HT-PWGL-AS::*svp_unixpath*))

;---------------------------------------------------------------------------------------------------------

(define-box HT-PWGL-AS::set-pwgl-as-source-soundfolder ()
  "specify the folder where the source soundfiles are stored"
  :non-generic t

  (let ((newpath (ccl::namestring 
                  (capi::prompt-for-directory "" )
                  )))
    (when newpath
      (setf HT-PWGL-AS::*pwgl-as-source-sound-folder* newpath)
      (WITH-OPEN-FILE (out HT-PWGL-AS::*pwgl-as-soundin-prefsfile* :direction :output  
                           :if-does-not-exist :create :if-exists :supersede) 
        (prin1 '(in-package :HT-PWGL-AS) out)
        (let ((*package* (find-package :HT-PWGL-AS)))
          (prin1 `(setf HT-PWGL-AS::*pwgl-as-source-sound-folder* ,newpath) out)))
      )
    ))

(define-box HT-PWGL-AS::print-pwgl-as-source-soundfolder ()
"prints the folder where the source soundfiles are stored"
  HT-PWGL-AS::*pwgl-as-source-sound-folder*
  )

;---------------------------------------------------------------------------------------------------------

(define-box HT-PWGL-AS::set-pwgl-as-result-soundfolder ()
  "specify the folder where the treated soundfiles will be stored"
  :non-generic t

  (let ((newpath (ccl::namestring 
                  (capi::prompt-for-directory "" )
                  )))
    (when newpath
      (setf HT-PWGL-AS::*pwgl-as-result-sound-folder* newpath)
      (WITH-OPEN-FILE (out HT-PWGL-AS::*pwgl-as-soundout-prefsfile* :direction :output  
                           :if-does-not-exist :create :if-exists :supersede) 
        (prin1 '(in-package :HT-PWGL-AS) out)
        (let ((*package* (find-package :HT-PWGL-AS)))
          (prin1 `(setf HT-PWGL-AS::*pwgl-as-result-sound-folder* ,newpath) out)))
      )
    ))

(define-box HT-PWGL-AS::print-pwgl-as-result-soundfolder ()
"prints the folder where the source soundfiles are stored"
  HT-PWGL-AS::*pwgl-as-result-sound-folder*
  )

;---------------------------------------------------------------------------------------------------------

(define-box HT-PWGL-AS::set-pwgl-as-parameterfolder ()
  "specify the folder where parameterfiles will be stored"
  :non-generic t

  (let ((newpath (ccl::namestring 
                  (capi::prompt-for-directory "" )
                  )))
    (when newpath
      (setf HT-PWGL-AS::*pwgl-as-parameterfolder* newpath)
      (WITH-OPEN-FILE (out HT-PWGL-AS::*pwgl-as-param-prefsfile* :direction :output  
                           :if-does-not-exist :create :if-exists :supersede) 
        (prin1 '(in-package :HT-PWGL-AS) out)
        (let ((*package* (find-package :HT-PWGL-AS)))
          (prin1 `(setf HT-PWGL-AS::*pwgl-as-parameterfolder* ,newpath) out)))
      )
    ))

(define-box HT-PWGL-AS::print-pwgl-as-parameterfolder ()
"prints the folder where the source soundfiles are stored"
  HT-PWGL-AS::*pwgl-as-parameterfolder*
  )




#|


(define-box HT-PWGL-AS::set-om-as-transientfolder ()
"specify the folder where the transient SDIF files will be stored"
  
  (let ((newpath (mac-namestring (choose-directory-dialog))))
    (when newpath
      (setf ASX::*om-as-transient-folder* (mac-namestring  newpath ))
      (WITH-OPEN-FILE (out ASX::*om-as-soundout-prefsfile* :direction :output  
                           :if-does-not-exist :create :if-exists :supersede) 
        (prin1 '(in-package :ASX) out)
        (let ((*package* (find-package :ASX)))
          (prin1 `(setf ASX::*om-as-transient-folder* ,(mac-namestring  newpath)) out)))
      )
    ))

(define-box HT-PWGL-AS::print-om-as-transientfolder ()
"prints the folder where the transient SDIF files will be stored"
  (print ASX::*om-as-transient-folder*)
  )

|#

(defun string+ (&rest strings) (eval `(concatenate 'string ,.strings)))

(defun unique-pathname (dir name &optional (ext ""))
  (let ((pathname (make-pathname :device (pathname-device dir) :directory (pathname-directory dir) :name name :type ext)))
    (loop while (probe-file pathname)
          for i = 1 then (+ i 1) do
          (setf pathname (make-pathname :device (pathname-device dir) :directory (pathname-directory dir) :name (string+ name (format nil "~D" i)) :type ext)))
    pathname))