(in-package MC)

; Store sequense of variables from pmc

(system::PWGLdef store-sol ((solution-from-pmc nil))
    "Store part of a solution to freeze in next calculation.
The solution to store should come directly from the pmc. Use this
function with freeze-rule"
    (:groupings '(1)  :x-proportions ' ((1.0)))
  (save-solution solution-from-pmc))



(system::PWGLdef freeze-rule ((end-index 20) (data nil) &optional (transpose 0))
    "Freeze the first n variables from last solution in next calculation. Use this rule with store-sol."
    (:groupings '(2)  :x-proportions ' ((0.5 0.5)))

  (compare-to-saved-pmc-solutionlist data end-index transpose))