(in-package :zosc)

;; define a user menu
(ccl::add-PWGL-user-menu 
 '(:menu-component
   ("zosc"
    ("send" (zosc-write-msg zosc-write-bundle))
    ("receive" (zosc-server zosc-decode)))))



