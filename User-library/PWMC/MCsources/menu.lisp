(in-package MC)


(ccl::add-PWGL-user-menu 
 ' (:menu-component
    ("MusicalConstraints"
     (("build-domain" (build-domain lock-rhythms lock-pitches))
     (rules->pmc)
     (heuristic-r->pmc)
     (MCdecode)
     ("Debug tools" (MCdebug debug-one-rule))
     ("-----------")
     ("pitch <-> rhythm rules" (access-pitch-and-rhythm pitch->dur-rule dur->pitch-rule mel-interval->dur-rule))
     ("meter <-> rhythm rules" (access-metric-structure metric-hierarchy-rule))
     ("rhythm <-> rhythm rules" (access-rhythm access-poly-rhythm rhythmic-hierarchy-rule rhythmic-canon-rule))
     ("pitch <-> pitch rules" (access-melody access-2part-harmony rule-4-voice-chords pitch-canon-rule startpitch-rule access-harmony))
     ("meter <-> meter rules" (access-meter lock-meter-rule))
     ("stochastic rules" (rule-pitch-probability))
     ("morphological rules" (energy-profile-rule))
     ("strategy rules" (strategy-rule-1layer strategy-rule-2layers strategy-only-motifs) ("freeze" (store-sol freeze-rule)))
     (nr-of-events)
     ))
    ))

