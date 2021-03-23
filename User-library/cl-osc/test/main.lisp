;;; Copyright (c) 2007, Kilian Sprotte. All rights reserved.

;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:

;;;   * Redistributions of source code must retain the above copyright
;;;     notice, this list of conditions and the following disclaimer.

;;;   * Redistributions in binary form must reproduce the above
;;;     copyright notice, this list of conditions and the following
;;;     disclaimer in the documentation and/or other materials
;;;     provided with the distribution.

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

(in-package :cl-osc)

(in-suite :cl-osc-test)

(test simple.1
  (let ((out (flexi-streams:make-in-memory-output-stream)))
    (is (= 12 (write-osc-message out nil "h" 1)))
    (is (equalp #(104 0  0  0
                  44  105 0  0
                  0   0  0  1)
                (flexi-streams:get-output-stream-sequence out)))))

(test blob.1
  (let ((out (flexi-streams:make-in-memory-output-stream)))
    (is (= 16 (write-osc-message out nil "h" #(1 2))))
    (is (equalp #(104 0  0  0
                  44  98 0  0
                  0   0  0  2
                  1   2  0  0)
                (flexi-streams:get-output-stream-sequence out)))))
