(in-package MC)

(system::PWGLDef rhythmic-hierarchy-rule ((layerhigh 0) (layerlow 1) (type?  10 (ccl::mk-menu-subview :menu-list '(":all_dur" ":low-only-cellstart" ":include-rests"":high-only-rest"))))
    "Forces a rhythm in one layer to relate in a hierarchical way to a rhythm 
in another layer.

Layerhigh is the layernr of the higher level in the hierarchy. Onsets in
layerhigh have to exist at simultaneous onsets in layerlow. The result is
that layerlow reinforces the onsets in layerhigh, however layerlow can
have onsets inbetween onsets in layerhigh. Layerlow can be said to have
the same rhythm as layerhigh, but with rhythmical ornaments (shorter note
values) allowed.

The type? setting:

all_dur: All durations are checked regardless of if the domain defines 
rhythms as motifs or not. Rests are ignored.

low-only-cellstart: The lower layer in the hierarchy has to have its 
cellstarts align at the time points for the onsets of layerhigh. Pauses as 
cellstarts are not valid points in the hierarchy, i.e. these cells can not 
be used at these points.

include-rests: Rests are treated as events. Otherwise identical to all_dur.

high-only-rests: only onsets for rests are considered in the high layer. Only
rhythms (no rests) are considered in the low layer.
"
    (:groupings '(3)  :x-proportions '((0.15 0.15 0.7)) :w 0.6)
  (cond ((equal type? :all_dur)
         (hierarchy-between-layers-rule layerhigh layerlow))
        ((equal type? :low-only-cellstart)
         (hierarchy-between-layers-rhythmcell-rule layerhigh layerlow))
        ((equal type? :include-rests)
         (hierarchy-between-layers-include-rests-rule layerhigh layerlow))
        ((equal type? :high-only-rest)
         (hierarchy-between-layers-only-rests-rule layerhigh layerlow))))




(system::PWGLDef metric-hierarchy-rule ((layers '(0)) (beatvalue0 4) (subdiv0 '(3 4)) &optional (beatvalue1 nil)  (subdiv1 '(2 3)) (beatvalue2 nil)  (subdiv2 '(2 3)) (beatvalue3 nil) (subdiv3 '(2 3)))
    "Restricts how rhythm can be put inside a metric framework.

Layers can be a list of layernrs - in that case the rule will apply to all
layers in the list.

Beatvalue is the lower value in a time signature, indicating the length of 
a beat (i.e. 4 indicating a quarter note length, 8 indicating an eight note
length, etc). The following field will only be applied on measures that
has this beat length.

Subdiv is a list of allowed subdivisions of the beat (the beat is indicated
in the preceeding field). This creates a grid for where onsets are allowed 
within a measure.

The box can be expanded with additional list of subdivisions of the beat for 
other beat values.
"
    (:groupings '(3) :extension-pattern '(2 2 2) :x-proportions '((0.2 0.4 0.4)))

    (set-timesign-grids (remove nil (list subdiv0 subdiv1 subdiv2 subdiv3)) (remove nil (list beatvalue0 beatvalue1 beatvalue2 beatvalue3)))
 
  (apply 'append
         (loop for n from 0 to (1- (length layers))
               collect (remove nil (list (if beatvalue0 (measure-rule (nth n layers) subdiv0 beatvalue0) nil)
                                         (if beatvalue1 (measure-rule (nth n layers) subdiv1 beatvalue1) nil)
                                         (if beatvalue2 (measure-rule (nth n layers) subdiv2 beatvalue2) nil)
                                         (if beatvalue3 (measure-rule (nth n layers) subdiv3 beatvalue3) nil))))))



                       
