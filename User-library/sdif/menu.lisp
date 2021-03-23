(in-package :SDIF)
        
(ccl::add-PWGL-user-menu
 '("SDIF" (sdifextract querysdif "" sdif-selection sdif-range sdif-selection-spec)))