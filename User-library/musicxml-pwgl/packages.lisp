;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Coding:utf-8 -*-

;;; This file is part of MusicXML-PWGL.

;;; Copyright (c) 2010 - 2011, Kilian Sprotte. All rights reserved.

;;; This program is free software: you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation, either version 3 of the License, or
;;; (at your option) any later version.

;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.

;;; You should have received a copy of the GNU General Public License
;;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(in-package :cl-user)

(defpackage #:musicxml-pwgl.mapcar-state
  (:use #:cl)
  (:export
   #:mapcar-state
   #:mapcan-state
   #:mapcar-state-index
   #:mapcar-state-firstp
   #:mapcar-state-next
   #:mapcar-state-previous
   #:mapcar-state-lastp))

(defpackage #:musicxml-pwgl.pprint-xml
  (:use #:cl)
  (:export
   #:pprint-xml
   #:remove-whitespace
   #:*pprint-xml-table*
   #:pprint-redispatch))

(defpackage #:musicxml-pwgl.musicxml
  (:use #:cl
        #:musicxml-pwgl.pprint-xml
        #:musicxml-pwgl.mapcar-state)
  (:export
   #:128th
   #:16th
   #:256th
   #:32nd
   #:64th
   #:a
   #:accidental
   #:attributes
   #:b
   #:breve
   #:c
   #:d
   #:direction
   #:direction-type
   #:double-sharp
   #:dynamic
   #:e
   #:eighth
   #:f
   #:flat
   #:flat-flat
   #:from-lxml
   #:g
   #:half
   #:long
   #:make-constructor-form
   #:mxml-equal
   #:natural
   #:natural-flat
   #:natural-sharp
   #:no
   #:note
   #:note-beam-begin
   #:note-beam-continue
   #:note-beam-end
   #:note-chordp
   #:note-gracep
   #:note-tie-start
   #:note-tie-stop
   #:pitch
   #:print-musicxml
   #:quarter
   #:quarter-flat
   #:quarter-sharp
   #:rest*
   #:sharp
   #:sharp-sharp
   #:start
   #:stop
   #:three-quarters-flat
   #:three-quarters-sharp
   #:time-modification
   #:to-lxml
   #:tuplet
   #:unspecific
   #:whole
   #:yes
   ))

(defpackage #:musicxml-pwgl.enp2musicxml
  #+sbcl(:nicknames #:enp2musicxml)
  (:use #:cl
        #:musicxml-pwgl.musicxml
        #:musicxml-pwgl.mapcar-state)
  (:export
   #:enp2musicxml
   #:*tuplet-show-bracket*
   #:*eighth-tone-encoding*
   #:preferences-env))
