;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; PatchWorkMusicalConstraints Library version 0.863
;;; Copyright (c) 2007, Örjan Sandred.  All rights reserved.
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
;;;           This is an early pre-release. It might not be compatible with future versions. Functions are randomly documented on line.
;;;           No manual exist yet.
;;;
;;;           All copyright for the concept of this library as well as the code belongs to Örjan Sandred, orjan@sandred.com
;;;
;;;           version 0.79 (March 4, 2007) supports new library format (same functionality as version 0.78)
;;;           version 0.83 released at PRISMA in Paris July 2007
;;;               new accessor access-pitch-and-rhythm
;;;               new domain definitions: lock-rhythms, lock-pitches
;;;           version 0.84, end of July 2007
;;;           new accessors access-poly-rhythm, access-metric-structure
;;;           version 0.841 and 0.842: bug fixes in access-poly-rhythm (window function) and access-metric-structure (gave access to non-extisting values).
;;;           version 0.844 added menu option to access-metric-structure
;;;           version 0.85 (October 30, 2007) extension patterns added to build-domain and metric-hierarchy-rule. File names adaptet to PC and Unix.
;;;           version 0.86 (November 6, 2007 - Partly coded in Helsinki, partly in Stockholm)
;;;              MCdecode and MCdebug added (with advanced graphics). rules->pmc now include debugger support.
;;;              Bugfix in access-metric-structure (the fix avoids some cases of backtracking and heuritic version work better).
;;;              Added lock-meter-rule and access-meter. System now supports up to 10 layers.
;;;           version 0.861 (November 18, 2007 - Winnipeg)
;;;              MCdebug now shows index number and includes locked layers (and is not compatible with 0.86).
;;;              Lock rhythm layers do not include a hidden pause at the end anymore (this is not obvious for the user).
;;;              Added rule-4layers chord (settings: always and duration-at-beat possible).
;;;           version 0.863 (December 14, 2007 - Winnipeg)
;;;              Energy profile rule and Markov rule added. access-2part-harmony added (replaces acccess-harmony).
;;;           version 0.8631 (March 1, 2008 - Winnipeg)
;;;              A first version of online documentation of all boxes now exist. The collection of tutorial patches has expanded.
;;;              Compatible with rc10. Bugfix in access-2part-harmony
;;;           version 0.864 (March, 2008 - Winnipeg)
;;;              access-rhythm now has the option list-all-rhythms
;;;           version 0.865 (March 29, 2008 - Winnipeg)
;;;              MCdecode now has an added input for filtering out layers in the score display.
;;;           version 0.866 (July 1, 2008 - Uppsala)
;;;              Menues include morphology and stochastic rules.
;;;           version 0.867 (Feb 17, 2009 - Winnipeg)
;;;              Limited support for jbs-constraints rule: only access-melody and access-rhythm accepts these rules. The rules can not contain l or rl variables.
;;;              Grace notes supported (duration 0)
;;;              r-quant and hr-quant-dev added (quantification). 
;;;           version 0.868 (Feb 19, 2009 - Winnipeg)
;;;              access-melody and access-rhythm now also supports jbs-constraint rules that contain l and rl
;;;           version 0.87 (Oct 22, 2009 - Shanghai)
;;;              old menu option removed (caused program nit to load in RC15
;;;              bugfix in access-2part-harmony (rests could give error messages
;;;              KNOWN BUG: grace notes are not compatible with chords in a voice - chords are split up into individual notes in access-2part-harmony. Rules can be design to work with this in mind.

(in-package :asdf)

;; a declaration would be better in the source files
;; (declaim (optimize (speed 3) (safety 0) (compilation-speed 0) (debug 0)))

(defsystem :pwmc
    :version "0.87"
    :author "Orjan Sandred"
    :default-component-class ccl::pwgl-source-file
    :serial t
    :components
    ((:file "MCsources/package")
     (:file "MCsources/vectors-basic")
     (:file "MCsources/classes")
     (:file "MCsources/lock-layers")
     (:file "MCsources/PWGL-lock-layers")
     (:file "MCsources/build-domain")
     (:file "MCsources/PWGL-build-domain")
     (:file "MCsources/pmc-decode-solution")
     (:file "MCsources/PWGL-pmc-decode-solution")
     (:file "MCsources/PWGL-rule-maintain-vectors")
     (:file "MCsources/PWGLsimple-to-tree")
     (:file "MCsources/jbs-mc")  ;Compability to Jacopos library
     (:file "MCsources/strategy-rules")
     (:file "MCsources/PWGL-strategy-rules")
     (:file "MCsources/vectors-cont")
     (:file "MCsources/rules")
     (:file "MCsources/PWGL-rules")
     (:file "MCsources/hierarchy-rule")
     (:file "MCsources/PWGL-hierarchy-rules")
     (:file "MCsources/canon-rules")
     (:file "MCsources/PWGL-canon-rules")
     (:file "MCsources/pitch-rule-interface")
     (:file "MCsources/PWGL-pitch-rule-interface")
     (:file "MCsources/pitch-rules")
     (:file "MCsources/PWGL-pitch-rules")
     (:file "MCsources/rhythm-rule-interface")
     (:file "MCsources/PWGL-rhythm-rule-interface")
     (:file "MCsources/dur-and-mel-interv")
     (:file "MCsources/PWGL-dur-and-mel-interv")
     (:file "MCsources/tools")
     (:file "MCsources/PWGL-tools")
     (:file "MCsources/heur-rules-interface")
     (:file "MCsources/metric-pitch-rule")
     (:file "MCsources/freeze")
     (:file "MCsources/PWGL-freeze")
     (:file "MCsources/access-pitch-and-rhythm")
     (:file "MCsources/access-pitch-and-rhythm-and-beats1")
     (:file "MCsources/access-pitch-and-rhythm-and-beats2")
     (:file "MCsources/PWGL-access-pitch-and-rhythm")
     (:file "MCsources/access-meter-and-dur-offsets")
     (:file "MCsources/access-meter-and-dur-offsets2")
     (:file "MCsources/PWGL-access-meter-dur-offsets")
     (:file "MCsources/access-poly-rhythm")
     (:file "MCsources/PWGL-access-poly-rhythm")
     (:file "MCsources/MCdebug")
     (:file "MCsources/PWGLadvanced_scoreboxes")
     (:file "MCsources/access-lock-timesigns-rule")
     (:file "MCsources/PWGL-access-lock-timesigns-rule")
     (:file "MCsources/MC-markov") ;this includes PWGL function
     (:file "MCsources/MC-probability") ;this includes PWGL function
     (:file "MCsources/MC-morph-energyprofile") ;this includes PWGL function
     (:file "MCsources/access-2-layer-harm") ;replaces old function
     (:file "MCsources/PWGL-access-2-layer-harm") 
     (:file "MCsources/PWGL-quant-rule")


(:file "MCsources/My-engine")


     ;; beta morphology
     (:file "MCsources/morphology-rules")
     (:file "MCsources/PWGL-morphology-rules")

    ; (:file "MCsources/PWGL-back-compability")

     (:file "MCsources/menu")))

