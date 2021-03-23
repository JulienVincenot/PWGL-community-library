(in-package :ASDF)

(defsystem :sdif
  :name "sdif"
  :description "PWGL SDIF Library"
  :long-description "The SDIF library provides an interface for reading in SDIF files. For this it uses the sdifextract command-line tool that is a part of the SDIF source code distribution (http://sourceforge.net/projects/sdif). A slightly modified version is provided with PWGL. It will be installed locally inside the SDIF library folder.

The library works only on OS X.
"

  :version "1.11"
  :author "Mika Kuuskankare"
  :licence "PWGL"
  :maintainer "Mika Kuuskankare" 

  :serial t 
  :components
  #+unix
   ((:file "package")
   (:file "install-sdif-tools")
   (:file "sdif")
   (:file "menu"))
  #-unix
   ((:file "package")))	

#+unix
(defmethod perform :after ((o load-op) (c (eql (find-system :sdif))))
  (funcall (find-symbol "INSTALL-SDIF-TOOLS" :sdif)))

#-unix
(defmethod perform :around ((o load-op) (c (eql (find-system :sdif))))
  (capi:display-message "This library can be used on OS X only!"))
