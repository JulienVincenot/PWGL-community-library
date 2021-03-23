(in-package studioflat)


(ccl::add-PWGL-user-menu 
 ' (:menu-component
    ("StudioFLAT tools"
     (("number series" (number-ser 3sum-number-ser dx[1-x] mandelbrot henon))
      ("probabilities" (probability-distribution probability-analysis probability-seq markov-analysis markov-seq))
      ("pmc interface" (func->*rule func->irule get-temp-sol get-rev-temp-sol get-i-var get-index all-diff? within-deviation?))
      ("score" (simplelayer->score simplelayer->tree chords-at-times->score))
      ))
    ))
