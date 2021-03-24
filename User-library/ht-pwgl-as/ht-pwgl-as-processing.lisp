;;;================================================================================================================
;;; SuperVP Sound Processing
;;; Hans Tutschku 2008
;;;================================================================================================================

(in-package :ht-pwgl-as)
  
(in-menu processing)


#|
(define-box groupe-notes222 (liste)
  ""
  :non-generic t
  (let ((aux0 nil) (aux1 nil) (mem -1))
    (dolist (n liste aux1)
      (if (not (= (first n) mem))
	  (progn nil (push (remove nil aux0) aux1) (setf aux0 nil)
		 (push (second n) aux0) (setf mem (first n)))
	  (progn nil (push (second n) aux0))))
    (mat-trans (list (remove-dup (first (mat-trans liste)) 'equalp 1)
		     (remove nil (reverse (push aux0 aux1)))))))

|#

(defvar *tmpparfiles* nil)



;;;;------------------------------------------------------------------------------------------------#| |#

#|
;;; FORMAT SVP COMMAND
(define-box make-svp-command ((srcpath nil) (processings nil) ( begin 0.0) (end 1.0) 
(windowsize 2000) ( fftsize 4096) ( windowstep-oversamp 8) 
( window-type nil) ( shape-invariant nil) ( preserve-transient nil) 
( normalize nil) ( outpath nil))
"doc"

#|
  :icon 950 
  :menuins '((4 (("1/4" 4) ("1/8" 8) ("1/16" 16) ("1/32" 32)))
             (5 (("Blackman" "blackman") ("Hanning" "hanning")("Hamming" "hamming")))
             (6 (("Shape Invariant On" t) ("Shape Invariant Off" nil)))
             (8 (("Normalize On" t) ("Normalize Off" nil)))
             )
  :initvals '(nil "" 4096 4096 8 "hanning" nil t nil "out.aiff")
|#

  (if (and *SVP-PATH* (probe-file *SVP-PATH*))
    (let ((srcpath (pathname srcpath))
          (beginstr (if begin (format nil "-B~D " begin) "")) 
          (endstr (if end (format nil "-E~D " end) ""))
          (command ""))
      (when (probe-file srcpath)
        (setf command (om::string+ command (format nil "~s -t -v -Z " 
                                               (om::om-path2cmdpath *SVP-PATH*)
                                               )
                               beginstr endstr))
        
        (when normalize
          (setf command (om::string+ command "-norm ")))
        
        (setf command (om::string+ command (format nil "-U -S~s -Afft " 
                                               (om::om-path2cmdpath srcpath)
                                               )))

        (setf command (om::string+ command (format nil "-M~D -N~D -oversamp ~D -W~D -J~D "
                                              windowsize fftsize windowstep-oversamp window-type window-type)))
        (when shape-invariant
          (setf command (om::string+ command "-shape 2 -Vuf -4 ")))
        
        ;;; transients
        (if preserve-transient
          (let ((tr-settings (when preserve-transient
                         (if (listp preserve-transient) preserve-transient
                             '(1.4 (0.0 22050.0) 1.5 nil)))))

            (setf command (om::string+ command (format nil "-P1 -td_thresh ~D -td_band ~D,~D -td_ampfac ~D "
                                                   (nth 0 tr-settings)
                                                   (car (nth 1 tr-settings))
                                                   (cadr (nth 1 tr-settings))
                                                   (nth 2 tr-settings)
                                                   )))
          (when (nth 4 tr-settings)
            (setf command (om::string+ command (format nil "-td_relaxto ~D -td_relax ~D ")
                                   (car (nth 3 tr-settings))
                                   (cadr (nth 3 tr-settings))
                                   )))
          )
          (setf command (om::string+ command (format nil "-P0 "))))
        
        ;;; processings
        (loop for p in (om::list! processings) do
              (setf command (om::string+ command p " ")))
        
        ;;; out
        (setf command (om::string+ command (format nil "~s" (om::om-path2cmdpath outpath))))
        
      command))
  
    (om-beep-msg "SVP is not available.")
    ))
|#
;;;;------------------------------------------------------------------------------------------------#| |#


(define-box supervp-processing ((srcpath nil) 
                                (processings nil) 
                                (begin nil)
                                (end nil)
                                (windowsize nil)
                                (fftsize nil)
                                (windowstep-oversamp  nil)
                                (window-type () (mk-menu-subview :menu-list '(":blackman" ":hanning" ":hamming") :value 0))
                                (shape-invariant nil)
                                (preserve-transient nil)
                                (normalize nil)
                                (outfile nil))
  ""
  :non-generic t
  :menu (mode? :true/false :heuristic)

; (analysis-type () (mk-menu-subview :menu-list '(":f0" ":fft" ":chordseq" ":sonogram" ":markers") :value 0))


  #| 
 :icon 950 
  :menuins '((6 (("1/4" 4) ("1/8" 8) ("1/16" 16) ("1/32" 32)))
             (7 (("Blackman" "blackman") ("Hanning" "hanning")("Hamming" "hamming")))
             (8 (("Shape Invariant On" t) ("Shape Invariant Off" nil)))
             (10 (("Normalize On" t) ("Normalize Off" nil))))
  :initvals '(nil "" nil nil 4096 4096 8 "hanning" nil t nil "out.aiff")




  (let* ((outpath (if (pathnamep outfile) outfile (om::outfile outfile)))
         (cmd (make-svp-command (om::om-sound-file-name srcpath) processings begin end windowsize fftsize windowstep-oversamp 
                                window-type shape-invariant preserve-transient normalize
                                outpath)))
    (when (print cmd)
      (om::om-cmd-line cmd om::*sys-console*)
      (loop for file in *tmpparfiles* do (delete-file file))
      (setf *tmpparfiles* nil)
    outpath)))
|#

  (print "test"))
    
;;;;------------------------------------------------------------------------------------------------#| |#
#|
(om::defmethod! supervp-processing ((srcpath string) processings begin end windowsize fftsize windowstep-oversamp 
                                     window-type shape-invariant preserve-transient
                                     normalize outfile)
  (let* ((file (if (probe-file (pathname srcpath)) srcpath
                 (om::infile srcpath)))
         (outpath (if (pathnamep outfile) outfile (om::outfile outfile)))
         (cmd (make-svp-command file processings begin end windowsize fftsize windowstep-oversamp 
                                window-type shape-invariant preserve-transient normalize
                                outpath)))
    (when (print cmd)
      (om::om-cmd-line cmd om::*sys-console*)
      (loop for file in *tmpparfiles* do (delete-file file))
      (setf *tmpparfiles* nil)
      outpath)))

(om::defmethod! supervp-processing ((srcpath pathname) processings begin end windowsize fftsize windowstep-oversamp 
                                     window-type shape-invariant preserve-transient
                                     normalize outfile)
  (let* ((outpath (if (pathnamep outfile) outfile (om::outfile outfile)))
         (cmd (make-svp-command srcpath processings begin end windowsize fftsize windowstep-oversamp 
                                window-type shape-invariant preserve-transient normalize
                                outpath)))
    (when (print cmd)
      (om::om-cmd-line cmd om::*sys-console*)
      (loop for file in *tmpparfiles* do (delete-file file))
      (setf *tmpparfiles* nil)
      outpath)))




;;;=================================================================================================
;;; TIME STRETCH
;;;=================================================================================================

(om::defmethod! supervp-timestretch ((self number))
    :icon 951 
    (format nil "-D~D" self))

(om::defmethod! supervp-timestretch ((self pathname))
    :icon 951 
    (format nil "-D~s" (om::om-path2cmdpath self)))

(om::defmethod! supervp-timestretch ((self string))
    :icon 951 
    (format nil "-D~s" (om::om-path2cmdpath (if (probe-file (pathname self))
                  self (om::paramfile self)))))

(om::defmethod! supervp-timestretch ((self om::textfile))
    :icon 951 
    (let ((tmpfile (om::paramfile "temptimestretch.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (format nil "-D~s" (om::om-path2cmdpath tmpfile))))

(om::defmethod! supervp-timestretch ((self om::bpf))
    :icon 951 
    (let ((tmpfile (om::paramfile "temptimestretch.par")))
     (om::save-params self tmpfile)
     (push tmpfile *tmpparfiles*)
     (format nil "-D~s" (om::om-path2cmdpath tmpfile))))

(om::defmethod! supervp-timestretch ((self list))
    :icon 951 
    (let ((tmpfile (om::paramfile "temptimestretch.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (format nil "-D~s" (om::om-path2cmdpath tmpfile))))


;;;=================================================================================================
;;; TRANSPOSITION
;;;=================================================================================================


(defun transp-cmd (param preserve env order envtrans timecor)
  (print param)
  (setq trans_string "-transnc") 
  (if timecor (setq trans_string "-trans"))
  (if preserve
    (if (numberp param) 
      (om::string+ "-transke " (format nil "~D" ( - param envtrans)) " " trans_string " " (format nil "~D" envtrans) " -Afft " (om::integer-to-string order) 
             (if env "t" ""))
      (om::string+ " -transke " param " -Afft " (om::integer-to-string order) 
             (if env "t" "")))
    (om::string+ " " trans_string " " (format nil "~D" param) " -Afft ")
  )
)


    
(om::defmethod! supervp-transposition ((self number) preserve-enveloppe enveloppe-type filter-order &optional envtransp time-correction)
    :icon 951 
    :menuins '((1 (("Preserve Enveloppe On" t) ("Preserve Enveloppe Off" nil)))
               (2 (("True Enveloppe" t) ("LPC Enveloppe" nil)))
               (5 (("Time correction On" t) ("Time correction Off" nil))))
    :initvals '(0 t t 70 0 t)

   (transp-cmd self preserve-enveloppe enveloppe-type filter-order envtransp time-correction)
)

(om::defmethod! supervp-transposition ((self pathname) preserve-enveloppe enveloppe-type filter-order &optional envtransp time-correction)
    :icon 951 
    (transp-cmd (format nil "~s" (om::om-path2cmdpath self)) preserve-enveloppe enveloppe-type filter-order envtransp time-correction))

  
(om::defmethod! supervp-transposition ((self string) preserve-enveloppe enveloppe-type filter-order &optional envtransp time-correction)
    :icon 951 
    (transp-cmd (format nil "~s" (om::om-path2cmdpath (if (probe-file (pathname self))
                  self (om::paramfile self)))) preserve-enveloppe enveloppe-type filter-order envtransp time-correction))

(om::defmethod! supervp-transposition ((self om::textfile) preserve-enveloppe enveloppe-type filter-order &optional envtransp time-correction)
    :icon 951 
    (let ((tmpfile (om::paramfile "temptransp.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (transp-cmd (format nil "~s" (om::om-path2cmdpath tmpfile)) preserve-enveloppe enveloppe-type filter-order envtransp time-correction)))

(om::defmethod! supervp-transposition ((self om::bpf) preserve-enveloppe enveloppe-type filter-order &optional envtransp time-correction)
    :icon 951 
    (let ((tmpfile (om::paramfile "temptransp.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (transp-cmd (format nil "~s" (om::om-path2cmdpath tmpfile)) preserve-enveloppe enveloppe-type filter-order envtransp time-correction)))

(om::defmethod! supervp-transposition ((self list) preserve-enveloppe enveloppe-type filter-order &optional envtransp time-correction)
  :icon 951 
  (let ((tmpfile (om::paramfile "temptransp.par")))
    (om::save-params self tmpfile)
    (push tmpfile *tmpparfiles*)
    (transp-cmd (format nil "~s" (om::om-path2cmdpath tmpfile)) preserve-enveloppe enveloppe-type filter-order envtransp time-correction)))



;;;=================================================================================================
;;; FREQUENCY-SHIFTING
;;;=================================================================================================


(om::defmethod! supervp-frequencyshift ((self number))
    :icon 951 
    (let ((tmpfile (om::paramfile "fshift.par")))
      (om::save-params (list (list 0 self)) tmpfile)
      (push tmpfile *tmpparfiles*)
      (format nil "-Ffshift ~s" (om::om-path2cmdpath tmpfile))))

(om::defmethod! supervp-frequencyshift ((self pathname))
    :icon 951 
    (format nil "-Ffshift ~s" (om::om-path2cmdpath self)))

(om::defmethod! supervp-frequencyshift ((self string))
    :icon 951 
    (format nil "-Ffshift ~s" (om::om-path2cmdpath (if (probe-file (pathname self))
                  self (om::paramfile self)))))

(om::defmethod! supervp-frequencyshift ((self om::textfile))
    :icon 951 
    (let ((tmpfile (om::paramfile "fshift.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (format nil "-Ffshift ~s" (om::om-path2cmdpath tmpfile))))

(om::defmethod! supervp-frequencyshift ((self om::bpf))
    :icon 951 
    (let ((tmpfile (om::paramfile "fshift.par")))
     (om::save-params self tmpfile)
     (push tmpfile *tmpparfiles*)
     (format nil "-Ffshift ~s" (om::om-path2cmdpath tmpfile))))

(om::defmethod! supervp-frequencyshift ((self list))
    :icon 951 
    (let ((tmpfile (om::paramfile "fshift.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (format nil "-Ffshift ~s" (om::om-path2cmdpath tmpfile))))

;;;=================================================================================================
;;; BREAKPOINT-FILTER
;;;=================================================================================================

(defun breakpt-cmd (param extrapol)
  (if extrapol
    (om::string+ "-Fbreakpt " param)
    (om::string+ "-Fbreakpt-noex " param)))


(om::defmethod! supervp-breakpointfilter  ((self list) extrapolation)
    :icon 951
    :menuins '((1 (("Extrapolation On" t) ("Extrapolation Off" nil))))
    :initvals '(((0.1 0 4 100 0 500 -30 1000 -30 4000 0)) t) 
    (let ((tmpfile (om::paramfile "breakpt.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (breakpt-cmd (format nil "~s" (om::om-path2cmdpath tmpfile)) extrapolation)))

(om::defmethod! supervp-breakpointfilter   ((self pathname) extrapolation)
    :icon 951 
    (fbreakpt-cmd (format nil "~s" (om::om-path2cmdpath self)) extrapolation))

(om::defmethod! supervp-breakpointfilter  ((self string) extrapolation)
    :icon 951 
    (breakpt-cmd (format nil "~s" (om::om-path2cmdpath (if (probe-file (pathname self))
                  self (om::paramfile self)))) extrapolation))

(om::defmethod! supervp-breakpointfilter   ((self om::textfile) extrapolation)
    :icon 951 
    (let ((tmpfile (om::paramfile "breakpt.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (breakpt-cmd (format nil "~s" (om::om-path2cmdpath tmpfile)) extrapolation)))


;;;=================================================================================================
;;; FORMANT FILTER 
;;;=================================================================================================


(defun formant-cmd (param interpol extrapol)
  (if interpol
    (om::string+ (if extrapol "-Ffof " "-Ffof-noex") param)
    (om::string+ (if extrapol "-Ffifof " "-Ffifof-noex") param)))
    
(om::defmethod! supervp-formantfilter ((self list) interpolation extrapolation)
    :icon 951 
    :menuins '((1 (("Interpolation On" t) ("Interpolation Off" nil)))
               (2 (("Extrapolation On" t) ("Extrapolation Off" nil))))
    :initvals '(((0 2 350 0 50 1700 -5 100)) t t)

    (let ((tmpfile (om::paramfile "formant.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (formant-cmd (format nil "~s" (om::om-path2cmdpath tmpfile)) interpolation extrapolation)))
    

(om::defmethod! supervp-formantfilter ((self pathname) interpolation extrapolation)
    :icon 951 
    (formant-cmd (format nil "~s" (om::om-path2cmdpath self)) interpolation extrapolation))

  
(om::defmethod! supervp-formantfilter ((self string) interpolation extrapolation)
    :icon 951 
    (formant-cmd (format nil "~s" (om::om-path2cmdpath (if (probe-file (pathname self))
                  self (om::paramfile self)))) interpolation extrapolation))

(om::defmethod! supervp-formantfilter ((self om::textfile) interpolation extrapolation)
    :icon 951 
    (let ((tmpfile (om::paramfile "formant.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (formant-cmd (format nil "~s" (om::om-path2cmdpath tmpfile)) interpolation extrapolation)))

(om::defmethod! supervp-formantfilter ((self om::bpf) interpolation extrapolation)
    :icon 951 
    (let ((tmpfile (om::paramfile "formant.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (formant-cmd (format nil "~s" (om::om-path2cmdpath tmpfile)) interpolation extrapolation)))


;;;=================================================================================================
;;; BAND-FILTER
;;;=================================================================================================

(defun fband-cmd (param extrapol)
  (if extrapol
    (om::string+ "-Fbande " param)
    (om::string+ "-Fbande-noex " param)))


(om::defmethod! supervp-bandfilter  ((self list) extrapolation)
    :icon 951
    :menuins '((1 (("Extrapolation On" t) ("Extrapolation Off" nil))))
    :initvals '(((0 2 350 500)) t) 
    (let ((tmpfile (om::paramfile "fband.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (fband-cmd (format nil "~s" (om::om-path2cmdpath tmpfile)) extrapolation)))

(om::defmethod! supervp-bandfilter  ((self pathname) extrapolation)
    :icon 951 
    (fband-cmd (format nil "~s" (om::om-path2cmdpath self)) extrapolation))

(om::defmethod! supervp-bandfilter ((self string) extrapolation)
    :icon 951 
    (fband-cmd (format nil "~s" (om::om-path2cmdpath (if (probe-file (pathname self))
                  self (om::paramfile self)))) extrapolation))

(om::defmethod! supervp-bandfilter  ((self om::textfile) extrapolation)
    :icon 951 
    (let ((tmpfile (om::paramfile "fband.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (fband-cmd (format nil "~s" (om::om-path2cmdpath tmpfile)) extrapolation)))


;;;=================================================================================================
;;; CLIPING FILTER 
;;;=================================================================================================

(defun clipping-cmd (param renorm)
  (if renorm
    (om::string+ "-Fclip-norm " param)
    (om::string+ "-Fclip " param)))


(om::defmethod! supervp-clipping ((self pathname) renormalize)
    :icon 951
    :menuins '((1 (("Renormalize On" t) ("Renormalize Off" nil))))
    :initvals '(((-70 -60)) nil)
 
    (clipping-cmd (format nil "~s" (om::om-path2cmdpath self)) renormalize))

(om::defmethod! supervp-clipping ((self string) renormalize)
    :icon 951 
    (clipping-cmd (format nil "~s" (om::om-path2cmdpath (if (probe-file (pathname self))
                  self (om::paramfile self)))) renormalize))

(om::defmethod! supervp-clipping ((self om::textfile) renormalize)
    :icon 951 
    (let ((tmpfile (om::paramfile "clipping.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (clipping-cmd (format nil "~s" (om::om-path2cmdpath tmpfile)) renormalize)))

(om::defmethod! supervp-clipping ((self list) renormalize)
    :icon 951 
    (let ((tmpfile (om::paramfile "clipping.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (clipping-cmd (format nil "~s" (om::om-path2cmdpath tmpfile)) renormalize)))


;;;=================================================================================================
;;; FREEZE (Using SuperVP newfreeze)
;;;=================================================================================================

(om::defmethod! supervp-freeze ((self pathname))
    :icon 951
    :initvals '(((0.1 0.4 0.1)) nil) 
    (format nil "-Anewfreeze ~s" (om::om-path2cmdpath self)))

(om::defmethod! supervp-freeze ((self string))
    :icon 951 
    (format nil "-Anewfreeze ~s" (om::om-path2cmdpath (if (probe-file (pathname self))
                  self (om::paramfile self)))))

(om::defmethod! supervp-freeze ((self om::textfile))
    :icon 951 
    (let ((tmpfile (om::paramfile "freeze.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (format nil "-Anewfreeze ~s" (om::om-path2cmdpath tmpfile))))

(om::defmethod! supervp-freeze ((self om::bpf))
    :icon 951 
    (let ((tmpfile (om::paramfile "freeze.par")))
     (om::save-params self tmpfile)
     (push tmpfile *tmpparfiles*)
     (format nil "-Anewfreeze ~s" (om::om-path2cmdpath tmpfile))))

(om::defmethod! supervp-freeze ((self list))
    :icon 951 
    (let ((tmpfile (om::paramfile "freeze.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (format nil "-Anewfreeze ~s" (om::om-path2cmdpath tmpfile))))



;;;=================================================================================================
;;; SURFACE FILTER 
;;;=================================================================================================


(om::defmethod! supervp-surfacefilter ((self pathname))
    :icon 951 
    (format nil "-Fsurface ~s" (om::om-path2cmdpath self)))

(om::defmethod! supervp-surfacefilter ((self string))
    :icon 951 
    (format nil "-Fsurface ~s" (om::om-path2cmdpath (if (probe-file (pathname self))
                  self (om::paramfile self)))))

(om::defmethod! supervp-surfacefilter ((self om::textfile))
    :icon 951 
    (let ((tmpfile (om::paramfile "surfacefilter.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (format nil "-Fsurface ~s" (om::om-path2cmdpath tmpfile))))

(om::defmethod! supervp-surfacefilter ((self om::bpf))
    :icon 951 
    (let ((tmpfile (om::paramfile "surfacefilter.par")))
     (om::save-params self tmpfile)
     (push tmpfile *tmpparfiles*)
     (format nil "-Fsurface ~s" (om::om-path2cmdpath tmpfile))))

(om::defmethod! supervp-surfacefilter ((self list))
    :icon 951 
    (let ((tmpfile (om::paramfile "surfacefilter.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (format nil "-Fsurface ~s" (om::om-path2cmdpath tmpfile))))

;;;=================================================================================================
;;; FILE-POS
;;;=================================================================================================

(om::defmethod! supervp-filepos  ((self pathname))
    :icon 951 
    (format nil "-Ipos ~s" (om::om-path2cmdpath self)))

(om::defmethod! supervp-filepos  ((self string))
    :icon 951 
    (format nil "-Ipos  ~s" (om::om-path2cmdpath (if (probe-file (pathname self))
                  self (om::paramfile self)))))

(om::defmethod! supervp-filepos  ((self om::textfile))
    :icon 951 
    (let ((tmpfile (om::paramfile "posfile.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (format nil "-Ipos  ~s" (om::om-path2cmdpath tmpfile))))

(om::defmethod! supervp-filepos  ((self list))
    :icon 951 
    (let ((tmpfile (om::paramfile "posfile.par")))
      (om::save-params self tmpfile)
      (push tmpfile *tmpparfiles*)
      (format nil "-Ipos  ~s" (om::om-path2cmdpath tmpfile))))


;;;=================================================================================================
;;; PACK
;;;=================================================================================================


;(defvar *svp-treatments-package* (omNG-protect-object (omNG-make-new-package "Treatments")))
;(defvar *svp-processing-package* (omNG-protect-object (omNG-make-new-package "Processing")))
;(addPackage2Pack *svp-treatments-package* *svp-package*)
;(addPackage2Pack *svp-processing-package* *svp-package*)
;(AddGenFun2Pack  '(supervp-transposition supervp-timestretch
;                   supervp-frequencyshift supervp-breakpointfilter
;                   supervp-formantfilter supervp-bandfilter
;                   supervp-clipping supervp-freeze
;                   supervp-surfacefilter) *svp-treatments-package*)
;(AddGenFun2Pack  '(supervp-processing) *svp-processing-package*)




|#