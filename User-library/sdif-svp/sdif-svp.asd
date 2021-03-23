(in-package :ASDF)

#+unix
(defsystem :sdif-svp
  :name "sdif-svp"
  :description "SDIF, SuperVP and pm2 interface"
  :long-description "SDIF-SVP library provides an interface for SDIF, supervp, and pm2. The library assumes that you have access to the following command-line programs:
- querysdif
- sdifextract
- supervp
- pm2

querysdif and sdifextract are part of the SDIF source code distribution and can be downloaded form http://sourceforge.net/projects/sdif. Supervp and Pm2, in turn, belong to IRCAM Research Forum. Consult the web page of the Research Forum for purchasing information.

Before you can use this library you need to create aliases/links to these programs in the root of the SDIF-SVP folder.

Note, that you can use a subset of the boxes in case you do not have access to all of the command-line programs."

  :version "0.3"
  :author "Mika Kuuskankare"
  :licence "PWGL"
  :maintainer "Mika Kuuskankare" 

  ;; :serial t means that each component is only compiled, when the
  ;; predecessors are already loaded
  :serial t 
  :components
  (;; use your own package
   (:file "package")
   (:file "sdif")))