(in-package :PW-AIS)

(ccl::add-PWGL-user-menu 
 '(:menu-component
   ("PW-AIS"
   
    ("ALL" (normal-AIS 
		    prime-AIS 
			normal-R-invariant 
			prime-R-invariant 
			normal-QI-invariant 
			prime-QI-invariant 
			normal-QRMI-invariant 
			prime-QRMI-invariant 
			LINK-CHORDS 
			LINK-TWO-INSTANCES
			;LINK-RI-invariant 
			SAISs 
			MYSTERY-AIS))
			
    ("OPERATIONS" (Q-AIS 
		           I-AIS 
				   R-AIS 
				   RI-AIS 
				   M-AIS 
				   IM-AIS 
				   QR-AIS 
				   0-AIS
				   CONSTELLATION))
				   
    ("UTILS" (AIS->CHORD 
		      pc->m 
			  m->pc 
			  intervals-mod12 
			  AIS->normal 
			  AIS->prime))		
   )
  )
)
