(in-package MC)

(system::PWGLDef rhythmic-canon-rule ((layerdux 0) (layercomes 1) (offset 1/4) (free-start?  10 (ccl::mk-menu-subview :menu-list '(":pause" ":any-rhythm"))) &optional (scaletime 1))
    "Forces the rhythm in one layer to imitate the rhythm in another layer
as a strict canon.

layerdux: This is the voice that starts the canon.
layercomes: This is the voice that follows layerdux.
offset: This sets how much later the imitation in layercomes starts.

The free-start? setting:

pause: This forces layercomes to have pause(s) until the imitation starts. 
If this option is selected the domain has to contain the necessary pauses
for this offset to be possible.

any-rhythm: This allows layercomes to have any rhythm (or pause) before the
imitation starts.

Optional a factor (scaletime) determines if the durations in the imitation 
should be identical to the original voice (scaletime = 1, default) or if 
they should be scaled by the given factor. For example if scaletime is 
set to 2, the imitation will be in double note values. 
"
    (:groupings '(2 2)  :x-proportions '((0.5 0.5)(0.5 (:fix 0.35))))

  (cond ((and (equal free-start? :any-rhythm ) (= scaletime 1))
         (rcanon-rule layercomes layerdux offset))
        ((and (equal free-start? :pause) (= scaletime 1))
         (rcanon-rule-pausestart layercomes layerdux offset))
        ((and (equal free-start? :any-rhythm ) (/= scaletime 1))
         (r-timescaled-canon-rule layercomes layerdux offset scaletime))
        ((and (equal free-start? :pause ) (/= scaletime 1))
         (r-timescaled-canon-rule-pausestart layercomes layerdux offset scaletime))
        (t t)))

