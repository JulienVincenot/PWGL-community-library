;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; PatchWorkStudioFLAT Library version 0.95
;;; Copyright (c) 2008, Örjan Sandred.  All rights reserved.
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

;;; version 0.92 (March 17, 2008 - Winnipeg)
;;;    Added simplelayer->score
;;; version 0.93 (Feb 7, 2009 - Winnipeg)
;;;    Added velocities to simplelayer->tree (only when pitches are defined)
;;;    Grace notes supported in simplelayer->tree and simplelayer->score
;;; version 0.94 (March 6, 2009 - Winnipeg)
;;;    Improved notation of gracenotes in immediate sequence
;;; version 0.95 (February 3, 2011 - Winnipeg)
;;;    Bugfix in probability-analysis and markov-analysis: the list of items 
;;;    was not properly put together of the items were anything other than numbers.

(in-package :asdf)

;; you might want to put this somewhere else:
;; (:optimize ((debug 3) (speed 3) (safety 1)))

;; e.g. 
;; (declaim (optimize ((debug 3) (speed 3) (safety 1))))
;; at the top of each file after in-package

(defsystem :flat
    :version "0.95"
    :author "Orjan Sandred"
    :default-component-class ccl::pwgl-source-file
    :serial t
    :components
    ((:file "FLATsources/package")
     (:file "FLATsources/PMCinterface")
     (:file "FLATsources/logic-statements")
     (:file "FLATsources/PWGLUTsimple-tree")
     (:file "FLATsources/probability")
     (:file "FLATsources/markov")
     (:file "FLATsources/build-enp-score")
     (:file "FLATsources/number-series")
     (:file "FLATsources/random-distribution")
     (:file "FLATsources/chaos")
     (:file "FLATsources/menu")
     (:file "FLATsources/energyprofile_rule")
     (:file "FLATsources/jbs_rules")))


