(in-package MC)

(defun l-pitches ()
  (let* ((layer (get-layer-nr *this-variable*))
         (indexx (ccl::cur-index))
         (nr-of-pitches (get-number-of-pitches-at-index layer indexx)))       
    (get-pitches-between-nths-when-all-exist 0 indexx 0 (1- nr-of-pitches))))

(defun rl-pitches ()
   (reverse (l-pitches)))


(defun test-ruletype (rule)
	(not (functionp rule)))


(defun jbs-mc-pitch (rule)
  (if (test-ruletype rule)
      (let* ((jbsrule (cdr rule))
             (arglist (list (butlast (cdr jbsrule))))
             (statement (cdr (car (last jbsrule)))))
        (setf statement (subst '(rl-pitches) 'system::RL statement))
        (setf statement (subst '(l-pitches) 'system::L statement))
        (eval (append '(lambda) arglist statement))
        )
    rule))


(defun l-rhythms ()
  (let* ((layer (get-layer-nr *this-variable*))
         (indexx (ccl::cur-index))
         (nr-of-rhythms (get-number-of-rhythms-and-pauses-at-index layer indexx)))       
    (get-durations-upto-this-including-this-if-all-exist layer indexx nr-of-rhythms)))

(defun rl-rhythms ()
   (reverse (l-rhythms)))

(defun jbs-mc-rhythm (rule)
  (if (test-ruletype rule)
      (let* ((jbsrule (cdr rule))
             (arglist (list (butlast (cdr jbsrule))))
             (statement (cdr (car (last jbsrule)))))
        (setf statement (subst '(rl-rhythms) 'system::RL statement))
        (setf statement (subst '(l-rhythms) 'system::L statement))
        (eval (append '(lambda) arglist statement))
        )
    rule))