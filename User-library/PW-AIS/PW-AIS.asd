(in-package :ASDF)

(defsystem "PW-AIS"

  :description "All Interval Series Library for PWGL."
  :long-description "This is the AIS (All Interval Series) Library for PWGL
.
By Paulo Henrique Raposo, 2021.

This library was created to deal with calculations and manipulations of All-Interval Series.
There are 3856 possible normal form AIS, 1928 prime form AIS and some invariant AIS 
(R, QI and QRMI invariants).The operations available are:
 -  retrogradation (R)
 - inversion (I)
 - retrograde inversion (RI) 
 - operation Q (Q)
 - multiplication (M)
 - inversion multiplication (IM)
 - retrograde Q (QR)
 - operation 0 - (0)
 - constellation:  
P - I - IM  - M
R - R - RIM - RM
QR- QRI-QRIM-QRM
Q - QI -QIM - QM

References 

Harmony Book, by Elliott Carter

On Eleven-Interval Twelve-Tone Rows, by Stefan Bauer-Mengelberg and Melvin Ferentz

PWGL Book, p.142, by Mikael Laurson and Mika Kuuskankare 

PWConstraints, by Mikael Laurson.

The Structure of All-Interval Series by Robert Morris and Daniel Starr
 
The Composition of Elliott Carter's Night Fantasies, by John F. Link

The \"Link Chords\", by John F. Link

Icon from the series Lyric Suite by Robert Motherwell

"
  :version "1.0"
  :author "Paulo Henrique Raposo"
  :licence "Copyright (C) 2021 Paulo Henrique Raposo
This program is free software; you can redistribute it and/or modify
it under the terms of the Lisp Lesser Gnu Public License.  See
http://www.cliki.net/LLGPL for the text of this agreement."
  :maintainer "Paulo Henrique Raposo"

  ;; :serial t means that each component is only compiled, when the
  ;; predecessors are already loaded
  :serial t
  :components
  (
   (:FILE "package")
   (:FILE "standard-lisp-functions")
   (:FILE "boxes")
   (:FILE "menus")   
   ))