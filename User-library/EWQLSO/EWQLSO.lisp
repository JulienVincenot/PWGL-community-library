(in-package :ccl)

(defvar *EWQLSO-setup* (make-array 64))

(defun reset-EWQLSO-setup()
  "Clears the instrument sample cache and kills Kontakt"
  (let ((pid (parse-integer 
              (with-output-to-string (str)
                (call-system-showing-output "ps ux | awk '/Kontakt/ && !/awk/ {print $2}'" :SHOW-CMD () :PREFIX "" :OUTPUT-STREAM str)) :junk-allowed t)))
    (when pid
      (call-system (format () "kill ~a" pid)))
    (iter (for i below 64)
      (setf (aref *EWQLSO-setup* i) ()))))

(defun EWQLSO-setup-exists-p()
  (if (elt *EWQLSO-setup* 0)
      (count-if #'identity *EWQLSO-setup*)
    NIL))

;(reset-EWQLSO-setup)

(defvar *EWQLSO-library-location* #p"/Applications/Apps\ Jul/Native\ Instruments/Kontakt\ Lib/Kontakt-VSL-instruments/")
(defvar *EWQLSO-library-player-name* "kontakt 4")   ;; if you want to use Kontakt2 write "kontakt2" - without space
(defvar *EWQLSO-library-name* "VSL")

;;; (setq *EWQLSO-library-location* #p"/Users/mika/Documents/Sounds/GPO KP2 Library/Instruments/")
;;; (setq *EWQLSO-library-name* "GPO")

(defun EWQLSO-instruments-location()
  *EWQLSO-library-location*)

;(defvar *EWQLSO-pathnames* (map-all-files #p"/Users/mika/Documents/PRO XP Gold Library/Instruments/" :collect))

(defun disk-usage(f)
  (parse-integer 
   (with-output-to-string (stream)
     (call-system-showing-output (format () "du -s '~a'" f) :prefix () :show-cmd () :output-stream stream))
   :junk-allowed t))

(defparameter *sleep-time-multiplier* 3)

(defun sleep-time(f)
  (let ((file-size (disk-usage f)))
    (max (* file-size (/ *sleep-time-multiplier* 56.0)) 0.5)))

;;; (disk-usage (merge-pathnames #P"Percussion/Wood/F Steinway B.nki" #P"/Users/mika/Documents/Sounds/PRO XP Gold Library/Instruments/"))

(defun EWQLSO-sample-pathname(self)
  (merge-pathnames self (EWQLSO-instruments-location)))

(defmethod load-nki-instrument((self t))
  ())

(defmethod load-nki-instrument((self pathname))
  (if self
      (let ((pathname (EWQLSO-sample-pathname self)))
        (unless (EWQLSO-setup-exists-p)
          (with-message-dialog "Initializing Kontakt player..."
            (call-system-showing-output (format () "open --background -a '~a'" *EWQLSO-library-player-name*))
            (sleep 10)))
            
        (if (probe-file pathname)
            (1+
             (or (position self *EWQLSO-setup* :test #'equal)
                 (let ((next-vacant-slot (position NIL *EWQLSO-setup*))
                       (sleep *sleep-time-multiplier*))
                   (if next-vacant-slot
                       (with-message-dialog (format () "Loading ~a (~,1f sec)" (file-namestring pathname) sleep) 
                         (setf (elt *EWQLSO-setup* next-vacant-slot) self)
                         (call-system-showing-output (format () "open -a '~a' --background '~a'" *EWQLSO-library-player-name* pathname) :wait t)
                         (sleep sleep)
                         next-vacant-slot)
                     (error "The current configuration exceeds the 64 slots available."))))) ;; here, should open a new Kontakt app (-n) and assign channels from bus E onward
          (error (format () "instrument definition file ~a does not exist!" pathname))))
    (error "There is no sound corresponding to instrument")))

;;;; (defun load-nki-instruments(&rest pathnames) ;; does not work :(
;;;;   (let ((ablsoute-pathnames (mapcar #'(lambda(x) (merge-pathnames x (EWQLSO-instruments-location))) pathnames)))
;;;;     (call-system-showing-output (format () "open --background~{ '~a'~}"  ablsoute-pathnames) :wait t)))

(defun load-EWQLSO-instrument-definitions()
  (let ((pathname (merge-pathnames (make-pathname :directory (list :relative "Databases" *EWQLSO-library-name*)) (PWGL-location "EWQLSO"))))
    (when-let (pathname (probe-file (merge-pathnames (make-pathname :name *EWQLSO-library-name* :type "orch" :directory (list :relative "Databases")) (PWGL-location "EWQLSO"))))
      (load pathname))
    (map-all-files pathname #'(lambda(x) (load x)))))

;(load-EWQLSO-instrument-definitions)

(DEFMETHOD NKI ((SELF INSTRUMENT) (TYPE T) (EXPRESSION T)) ())

;********************************************************************************

(defun trill-pathname(p kind)
  (case kind
    (:whole
     (or	
      (alexandria:ends-with-subseq "GS.nki" (file-namestring p) :test #'equal)
      (alexandria:ends-with-subseq "WT.nki" (file-namestring p) :test #'equal)
      (alexandria:ends-with-subseq "W.nki" (file-namestring p) :test #'equal)))
    (t 
     (or
      (alexandria:ends-with-subseq "HS.nki" (file-namestring p) :test #'equal)
      (alexandria:ends-with-subseq "HT.nki" (file-namestring p) :test #'equal)
      (alexandria:ends-with-subseq "H.nki" (file-namestring p) :test #'equal)))))

(defun EWQLSO-relative-pathname(p)
  (let ((name (pathname-name p))
        (type (pathname-type p))
        (directory-namestring (enough-namestring p (EWQLSO-instruments-location))))
    (make-pathname
     :name name
     :type type
     :directory (pathname-directory directory-namestring))))

;(EWQLSO-relative-pathname #p"/Users/mika/Documents/PRO XP Gold Library/Instruments/Woodwinds/Solo Flute/1 Long/F SFL Exp Legato.nki")

(defparameter *expression-vocabulary* '()
  "Pattern(s) to match EW names (the string) to ENP expressions (the symbol)")

(defun load-expression-vocabulary()
  (let ((location (merge-pathnames (make-pathname :directory (list :relative "Databases")) (PWGL-location "EWQLSO"))))
    (let ((expression-vocabulary (merge-pathnames
                                  (make-pathname :name *EWQLSO-library-name*
                                                 :type "exp")
                                  location)))
      (when (probe-file expression-vocabulary)
        (with-open-file (stream expression-vocabulary)
          (setq *expression-vocabulary*
                (loop for item = (read stream () :EOF)
                      until (eql item :EOF)
                      when item
                      collect (print item))))))))

;;; (load-expression-vocabulary)

;;; TODO: distinguish between solo/section

(defun create-EWQLSO-folders()
  (let ((EWQLSO-instruments-location (merge-pathnames (make-pathname :directory (list :relative "Databases" *EWQLSO-library-name*)) (PWGL-location "EWQLSO"))))
    (unless (probe-file EWQLSO-instruments-location) (make-directory EWQLSO-instruments-location))
    (dolist (group (make-instrument-menu :instruments))
      (destructuring-bind (group-name instruments) group
        (declare (ignore instruments))
        (let ((database-location (merge-pathnames (make-pathname :directory (list :relative "Databases" *EWQLSO-library-name* (string-downcase group-name))) (PWGL-location "EWQLSO"))))
          (unless (probe-file database-location) (make-directory database-location))
          #+NIL (dolist (instrument instruments)
                  (let ((instrument-location (merge-pathnames
                                              (merge-pathnames
                                               (make-pathname :name (string-downcase (string (class-name (class-of instrument))))
                                                              :type "exp")
                                               database-location)
                                              (PWGL-location "EWQLSO"))))
                    (print (list :instrument-location instrument-location)))))))))

;;; (create-EWQLSO-folders)

(defun default-file-exists-p(instrument)
  (when (find-method #'nki () (list (find-class (type-of instrument)) (find-class T) (find-class T)) ())
    (let ((pathname (nki instrument t t)))
      (when pathname
        (probe-file (EWQLSO-sample-pathname pathname))))))

;;; (default-file-exists-p (find-instrument :flute))

(defun match-expressions()
  (create-EWQLSO-folders)
  (load-expression-vocabulary)
  (dolist (group (make-instrument-menu :instruments))
    (destructuring-bind (group-name instruments) group
      (let ((database-location (merge-pathnames (make-pathname :directory (list :relative "Databases" *EWQLSO-library-name* (string-downcase group-name))) (PWGL-location "EWQLSO"))))
        (dolist (instrument instruments)
          (format t "~a...~%" instrument)
          (with-open-stream (stream (open (merge-pathnames
                                           (merge-pathnames
                                            (make-pathname :name (string-downcase (string (class-name (class-of instrument))))
                                                           :type "lisp")
                                            database-location)
                                           (PWGL-location "EWQLSO"))
                                          :direction :output
                                          :if-does-not-exist :create
                                          :if-exists :supersede))
            ;; (format t "writing package~%")
            (pprint '(in-package :ccl) stream)
            (terpri stream)
            ;; (format t "default instrument (~a)...~%" (default-file-exists-p instrument))
            (when (default-file-exists-p instrument)
              ;; (format t "found ~%")
              (let ((location (merge-pathnames (make-pathname :directory (butlast (pathname-directory (nki instrument t t)))) (EWQLSO-instruments-location)))
                    reg-exp-expressions)     
                (iter (for (key expression) in *expression-vocabulary*)
                  ;; (format t "regex expression: ~a~%" expression)
                  ;; martele and marcato are missing
                  ;; ("Mart" martele) ("Marc" marcato)            
                  (let ((choices (sort (ppcre::split "\\n+" 
                                                     (with-output-to-string (str)
                                                       (call-system-showing-output (format () "cd '~a'; find . -type f -ipath '*~a*' -print" location key)
                                                                                   :wait t
                                                                                   :show-cmd ()
                                                                                   :prefix "" :output-stream str)
                                                       str))
                                       '< :key #'(lambda(x) (length (file-namestring x))))))
                  
                    (when choices
                      (format t "   - ~a~%" expression)
                      (cond ((eql expression 'trillo)
                             (pprint
                              `(defmethod nki ((self ,(class-name (class-of instrument))) (type t) (expression ,expression))
                                 (case (auxiliary-symbol expression)
                                   (:sharp ,(EWQLSO-relative-pathname (merge-pathnames (find-if #'(lambda(x) (trill-pathname x :whole)) choices) location)))
                                   (t  ,(EWQLSO-relative-pathname (merge-pathnames (find-if #'(lambda(x) (trill-pathname x :half)) choices) location)))))
                              stream))
                            ((stringp expression)
                             (push (list expression (EWQLSO-relative-pathname (merge-pathnames (car choices) location))) reg-exp-expressions))
                            (T
                             (pprint
                              `(defmethod nki ((self ,(class-name (class-of instrument))) (type t) (expression ,expression))
                                 ,(EWQLSO-relative-pathname (merge-pathnames (car choices) location)))
                              stream)))
                      (terpri stream))))
              
                (when reg-exp-expressions
                  (pprint
                   `(defmethod nki ((self ,(class-name (class-of instrument))) (type t) (expression expression))
                      (cond
                       ,(iter (for (reg-exp pathname) in reg-exp-expressions)
                          (appending (list `(ppcre::scan ,reg-exp (print-symbol expression))
                                           (EWQLSO-relative-pathname pathname))))))
                   stream)))))))))
  ;;;(load-EWQLSO-instrument-definitions)
  T)

;;; (match-expressions)

;;;; (defun generate-asdf-modules()
;;;;   (pprint
;;;;    (list :module "instruments"
;;;;          :components
;;;;          (iter (for group in (make-instrument-menu :instruments))
;;;;            (collect
;;;;             (destructuring-bind (group-name instruments) group
;;;;               (list :module (string-downcase group-name)
;;;;                     :components
;;;;                     (iter (for instrument in instruments)
;;;;                       (collect (list :file (string-downcase (string (class-name (class-of instrument))))))))))))))

;(generate-asdf-modules)

(defun describe-EWQLSO-instrument(instrument)
  (when-let (default-pathname (nki instrument t t))
    (cons (list :default (file-namestring default-pathname) (pathname-location (enough-namestring default-pathname (EWQLSO-instruments-location))))
          (iter (for (key val) in-hashtable *enp-expression-prototypes*)
            (declare (ignore key))
            (when-let (pathname (nki instrument t val))
              (unless (equal pathname default-pathname)
                (collect (list (internal-symbol val) (file-namestring pathname) (pathname-location (enough-namestring pathname (EWQLSO-instruments-location)))))))))))

;(describe-EWQLSO-instrument (nth 0 (enp-instruments)))

(defun EWQLSO-orchestra-browser-items()
  (sort (enp-instruments) #'string< :key #'name))
 
(capi::define-interface EWQLSO-orchestra-browser()
  ()
  (:panes
   (navigator-pane capi::list-panel
                   :items (EWQLSO-orchestra-browser-items)
                   :print-function #'(lambda(x) (format () "~a~a~a" (if (nki x t t) "" "          [") (name x) (if (nki x t t) "" "]")))
                   :visible-min-width 200
                   :visible-max-width 200
                   :selection-callback #'(lambda(item interface)
                                           (with-slots (details-pane) interface
                                             (setf (capi:collection-items details-pane)
                                                   (describe-EWQLSO-instrument item)))))
   (details-pane capi:multi-column-list-panel :columns '((:title "Expression") (:title "Sample") (:title "Path"))
                 :visible-max-height 700 :visible-min-height 600 :visible-min-width 500))
  (:layouts
   (main-layout capi::row-layout '(navigator-pane details-pane)))
  (:default-initargs
   :title "EWQLSO orchestra"
   :activate-callback #'(lambda(interface status)
                          (declare (ignore status))
                          (with-slots (navigator-pane) interface
                            (setf (capi:collection-items navigator-pane) (EWQLSO-orchestra-browser-items))))))

;(capi:find-interface 'EWQLSO-orchestra-browser)

(defun EWQLSO-player-browser-items()
  (loop for x across *EWQLSO-setup*
        for i from 1
        collect (list i (if x (file-namestring x) "-"))))

(capi::define-interface EWQLSO-player-browser()
  ()
  (:panes
   (navigator-pane capi:multi-column-list-panel
                   :items (EWQLSO-player-browser-items)
                   :visible-min-width 400
                   :visible-min-height 500
                   :columns '((:title "Chan" :visible-min-width 32) (:title "Default Sample")))
   (reset-button capi::push-button :text "Reset" :callback #'(lambda(item interface)
                                                               (declare (ignore item))
                                                               (reset-EWQLSO-setup)
                                                               (with-slots (navigator-pane) interface
                                                                 (setf (capi:collection-items navigator-pane) (EWQLSO-player-browser-items))))))
  (:default-initargs
   :title "EWQLSO player"
   :activate-callback #'(lambda(interface status)
                          (declare (ignore status))
                          (with-slots (navigator-pane) interface
                                                    (setf (capi:collection-items navigator-pane) (EWQLSO-player-browser-items))))))

;(capi:find-interface 'EWQLSO-player-browser)