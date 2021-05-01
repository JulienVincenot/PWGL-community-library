(defpackage :PW-AIS (:use :cl))
(in-package :PW-AIS)
(import '(
        ;PATCH-WORK FUNCTIONS
		pw::arithm-ser
		pw::permut-circ
		pw::x->dx
		pw::dx->x
		pw::arithm-ser
		pw::last-elem
		pw::firstn
		pw::posn-match
		pw::list-min
		pw::x-append
							
		;PWGL-SYSTEM FUNCTIONS			
        system::g/
		system::g*
		system::g+
		system::g- 
		system::mod12
		system::flat
		system::flat-once
		system::sc-name					
		)	  
 :pw-ais)

(eval-when (:execute :compile-toplevel :load-toplevel)
  (import '(ccl::PWGLdef) :PW-AIS))