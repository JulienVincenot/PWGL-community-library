(in-package MC)


(system::PWGLDef min-flex-max-rule-beta ((layernrs '(0))
                                         (max-length 5)
                                         (length  10 (ccl::mk-menu-subview :menu-list '(":keep_lengths" ":use_max_lengths")))
                                         (vals nil)
                                         (value  10 (ccl::mk-menu-subview :menu-list '(":keep_values" ":no_values")))
                                         )
    "This rule takes an analysis from the min-flex-max function in the morphology 
library and re-creates a sequence of pitches that match the given analysis. The 
analysis given to this rul should always be of type 3 (i.e. what is called vals 
in the min-flex-max function).

Settings:
You can re-create the prim form (i.e. analysis type 1) by setting values to 
no_values (do not keep original values) and length to use_max_length."
    (:w 0.6 :groupings '(3 2)  :x-proportions '((1 1 (:fix 0.35))(1 (:fix 0.35))))
  (cond ((and (equal value :keep_values) (equal length :keep_lengths))
         (format-vals-rule layernrs vals))
        ((and (equal value :keep_values) (equal length :use_max_lengths))
         (format-vals-no-length-rule layernrs vals max-length))
        ((and (equal value :no_values) (equal length :keep_lengths))
         (format-vals-no-values-rule layernrs vals))
        ((and (equal value :no_values) (equal length :use_max_lengths))
         (format-prim-rule layernrs vals max-length))
        )
  )
