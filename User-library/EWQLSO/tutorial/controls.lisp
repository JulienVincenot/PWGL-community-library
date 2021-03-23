(make-instance 'capi::column-layout
               :description
               (list (make-instance 'capi::row-layout
                                    :title "Kontakt"
                                    :title-position :frame
                                    :description
                                    (list
                                     (make-instance 'capi::push-button
                                                    :text "Initialize Library"
                                                    :callback #'(lambda(&rest x) (ccl::load-EWQLSO-instrument-definitions)))
                                     (make-instance 'capi::push-button
                                                    :text "Reset Kontakt"
                                                    :callback #'(lambda(&rest x) (ccl::reset-EWQLSO-setup)))
                                     (make-instance 'capi::push-button
                                                    :text "EWQLSO orchestra"
                                                    :callback #'(lambda(&rest x) (capi:find-interface 'EWQLSO-orchestra-browser)))
                                     (make-instance 'capi::push-button
                                                    :text "EWQLSO player"
                                                    :callback #'(lambda(&rest x) (capi:find-interface 'EWQLSO-player-browser)))))
                     (make-instance 'capi::column-layout
                                    :title "Setup"
                                    :title-position :frame
                                    :description
                                    (list
                                     (make-instance 'capi::row-layout
                                                    :title "Name"
                                                    :title-position :frame
                                                    :description (list
                                                                  (make-instance 'capi::push-button
                                                                                 :data ccl::*ewqlso-library-name*
                                                                                 :callback-type :item
                                                                                 :callback #'(lambda(item)
                                                                                               (when-let (name (capi:prompt-for-string "Give the name of the library:"))
                                                                                                 (setf (capi:item-data item) name)
                                                                                                 (setq ccl::*ewqlso-library-name* name))))))
                                     (make-instance 'capi::row-layout
                                                    :title "Sample pathname"
                                                    :title-position :frame
                                                    :description (list
                                                                  (make-instance 'capi::push-button
                                                                                 :data ccl::*ewqlso-library-location*
                                                                                 :callback-type :item
                                                                                 :callback #'(lambda(item) 
                                                                                               (when-let (name (capi:prompt-for-directory "Give the directory inside which your sample database is located:"))
                                                                                                 (setf (capi:item-data item) name)
                                                                                                 (setq ccl::*ewqlso-library-location* name))))))
                                     (make-instance 'capi::row-layout
                                                    :title "Sample player name"
                                                    :title-position :frame
                                                    :description (list
                                                                  (make-instance 'capi::push-button
                                                                                 :data ccl::*ewqlso-library-player-name*
                                                                                 :callback-type :item
                                                                                 :callback #'(lambda(item) 
                                                                                               (when-let (name (capi:prompt-for-string "Give the (UNIX) name of your sample player:"))
                                                                                                 (setf (capi:item-data item) name)
                                                                                                 (setq ccl::*ewqlso-library-player-name* name))))))))
                     (make-instance 'capi::push-button
                                                    :text "Create Database"
                                                    :callback #'(lambda(&rest x) (ccl::match-expressions)))
                     (make-instance 'capi::grid-layout
                                    :title "Examples"
                                    :title-position :frame
                                    :description
                                    (loop for file in (ccl::map-all-files (ccl::pwgl-location "EWQLSO") :collect :include '("enp"))
                                          collect
                                          (make-instance 'capi::push-button
                                                         :text (file-namestring file)
                                                         :data file
                                                         :callback-type :data
                                                         :callback #'(lambda(data)
                                                                       (ccl::open-enp-document data)))))))