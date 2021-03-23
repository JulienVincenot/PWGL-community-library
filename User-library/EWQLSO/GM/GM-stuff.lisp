(make-instance 'capi::row-layout
               :title "GM"
               :title-position :frame
               :description
               (list
                (make-instance 'capi::push-button
                               :visible-min-width 110
                               :text "Reset GM"
                               :callback #'(lambda(&rest x) (reset-GM-setup)))
                (make-instance 'capi::push-button
                               :visible-min-width 110
                               :text "GM player"
                               :callback #'(lambda(&rest x) (capi:find-interface 'GM-player-browser)))))