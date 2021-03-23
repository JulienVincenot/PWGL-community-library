(in-package :ccl)

#|
(defun get-synth-Sample-numSamples (sampleID)
  (fli:foreign-slot-value (pwsGetSampleData sampleID) 'numSamples))

(defun get-synth-Sample-sampleRate (sampleID)
  (fli:foreign-slot-value (pwsGetSampleData sampleID) 'sampleRate))

(defun get-synth-Sample-channelCount (sampleID)
  (fli:foreign-slot-value (pwsGetSampleData sampleID) 'channelCount))

(defun get-synth-Sample-sampleType (sampleID)
  (fli:foreign-slot-value (pwsGetSampleData sampleID) 'sampleType))

;;; (defun get-synth-Sample-sampleData (ptr);;?? (fli:foreign-slot-value   ptr 'sampleData ))
(defun get-synth-Sample-sampleData (sampleID &optional (chan 0))
  (pwsGetSampleDataData sampleID chan))

(defun get-synth-Sample-fundamental (sampleID)
  (fli:foreign-slot-value (pwsGetSampleData sampleID) 'fundamental))
(defun get-synth-Sample-midiKeyLow (sampleID)
  (fli:foreign-slot-value (pwsGetSampleData sampleID) 'midiKeyLow))
(defun get-synth-Sample-midiKeyHigh (sampleID)
  (fli:foreign-slot-value (pwsGetSampleData sampleID) 'midiKeyHigh))
(defun get-synth-Sample-midiVelLow (sampleID)
  (fli:foreign-slot-value (pwsGetSampleData sampleID) 'midiVelLow))
(defun get-synth-Sample-midiVelHigh (sampleID)
  (fli:foreign-slot-value (pwsGetSampleData sampleID) 'midiVelHigh))
|#

;********************************************************************************

#-sample-info
(progn
  (defmethod sample-info ((self PWGL-sample-function) (property T))
    ())
  
  (defmethod sample-info ((self PWGL-sample-function) (property (eql :sample-count)))
    (get-synth-Sample-numSamples (sampleid (sound-object self))))

  (defmethod sample-info ((self PWGL-sample-function) (property (eql :sample-rate)))
    (get-synth-Sample-sampleRate (sampleid (sound-object self))))

  (defmethod sample-info ((self PWGL-sample-function) (property (eql :channels)))
    (get-synth-Sample-channelCount (sampleid (sound-object self))))

  (defmethod sample-info ((self PWGL-sample-function) (property (eql :sample-type)))
    (get-synth-Sample-sampleType (sampleid (sound-object self))))

  (defmethod sample-info ((self PWGL-sample-function) (property (eql :duration)))
    (let* ((chans (sample-info self :channels))
           (samples (/ (sample-info self :sample-count) chans))
           (sample-rate (truncate (sample-info self :sample-rate))))
      (if (zerop sample-rate) 
          0 
        (/ samples sample-rate 1.0)))))