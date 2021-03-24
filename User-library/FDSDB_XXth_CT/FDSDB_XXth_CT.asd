;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; FDSDB_XXth_CT Library version 1.0
;;; Copyright (c) 2017, Fabio De sanctis De Benedictis.  All rights reserved.
;;;
;;; This is an experimental library, and a work in progress
;;;
;;; THIS SOFTWARE IS PROVIDED BY THE AUTHOR 'AS IS' AND ANY EXPRESSED
;;; OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
;;; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
;;; GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
;;; WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(in-package :ASDF)

(defsystem "FDSDB_XXth_CT"

  :description "Library addressed to some XXth Century Composition Techniques"
  :long-description "In this library are collected some patches developed in these last years, addressed to illustrate some XXth Century Composition techniques.

Where possible references are given. Composition techniques already developed in other libraries have been as much as possible avoided. The library requires ksquant library.

The fields of application of this library can be the composition, the didactics of composition and the musical analysis. It is conceived to be used together patches that illustrate the specific technique: first one should have to study the algorithm as expressed in the patches, and to study the references where possible, and then to use the relative object of this library. Otherwise the use of technique is deprived of its meaning, comprised expressive meaning. The aim is also that of transmitting and preserving some techniques of the past that, in my modest opinion, have an actual value, particularly for their utopic thought, too.

The library has been tested on OsX 10.8.5 and a little on Sierra; for any question or suggestion: fdesanctis@teletu.it.

I dedicate this library to my wife, for her patience and support, without which this work would not have been possible."
  :version "1.0"
  :author "Fabio De Sanctis De Benedictis"
  :licence "Creative Commons, Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)."
  :maintainer "Fabio De Sanctis De Benedictis"

  ;; :serial t means that each component is only compiled, when the
  ;; predecessors are already loaded
  :serial t
  :components
  (
   (:FILE "package")
   (:FILE "standard-lisp-code")
   (:FILE "boxes")
   (:FILE "menus")
)
:depends-on (:ksquant :iterate))