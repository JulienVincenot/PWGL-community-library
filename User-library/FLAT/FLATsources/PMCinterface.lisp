(in-package studioflat)
(defvar *L* nil) ;to access l in search engine
(defvar *RL* nil) ;to access rl in search engine

(defun write-one-searchvariable (variable-nr)
  (read-from-string (concatenate 'string "?" (format nil "~D" variable-nr))))

(defun write-searchvariables (nr-of-variables)
  (mapcar 'write-one-searchvariable (pw::arithm-ser 1 1 nr-of-variables)))

(defun make-wildcard-rule (function)
  "Takes any function and creats a pmc rule out of it. The inputs to the function 
will be called ?1 ?2 ?3.... ?n. The function migth be a PWGL abstraction in the lambda state."

  (let ((nr-? (length (system::arglist function))))
    (append '(*) (write-searchvariables nr-?) (list (list (read-from-string "?if")
                                                          (append (list 'progn)
                                                                  (read-from-string "((setf studioflat::*L* l))")
                                                                  (read-from-string "((setf studioflat::*RL* rl))")
                                                                  (list (append (list 'funcall function) (write-searchvariables nr-?))))
                                                          
                                                          )))))

(system::PWGLDef func->*rule   (&rest (functions  nil))
    "Takes any function and creats a pmc rule out of it. The inputs to the function 
will be called ?1 ?2 ?3.... ?n. The function migth be a PWGL abstraction in the lambda state.

By expanding the box several rules can be created."  
    ()

  (loop for function in functions
        collect (make-wildcard-rule function)))

;;;;

(defvar *extvar* 0)


(system::PWGLDef set-ext-var ((value nil))
    "Set the value of an external variable. The variable can be used inside a PWGL abstraction. 
This makes it possible to pass values into rules from anywhere in a patch."
    ()
  (setf *extvar* value))


(system::PWGLDef get-ext-var ()
    "Get a value from an external variable (set by the set-ext-var box). The box can be used inside a PWGL abstraction.
This makes it possible to pass values into rules from anywhere in a patch."
    ()
  *extvar*)
    
;;;;

(defun make-false-dummy-rule ()
  (read-from-string "(i1 (?if nil))"))

(defun write-one-searchvariable-i (variable-nr)
  (read-from-string (concatenate 'string "i" (format nil "~D" variable-nr))))

(defun write-searchvariables-i (variable-nr-list)
  (mapcar 'write-one-searchvariable-i variable-nr-list))

(defun make-i-rule (function i-nr-list)
  "no doc"
  
  (let ((nr-inputs (length (system::arglist function))))
    (if (/= nr-inputs (length i-nr-list))
      (progn (print "error when making rule: number of arguments must be the same as number of i in the i-nr-list")
        (make-false-dummy-rule))
      (append (write-searchvariables-i i-nr-list) (list (list (read-from-string "?if") 
                                                              (append (list 'progn)
                                                                  (read-from-string "((setf studioflat::*L* l))")
                                                                  (read-from-string "((setf studioflat::*RL* rl))")
                                                                  (list (append (list 'funcall function) (write-searchvariables-i i-nr-list))))
                                                              ))))))


(system::PWGLDef func->irule   ((function  nil) (i-nr-list '(1)) &rest (fn-ilist  nil))
    "Takes any function and creats a pmc index-rule out of it. The inputs to the function 
will be called i1 i2 i3.... in according to index numbers given as a list in the second input 
of each input pair. The function migth be a PWGL abstraction in the lambda state.

By expanding the box several rules can be created."  

    
    (:groupings '(2)  :extension-pattern '(2) :x-proportions '((0.2 0.4)(0.2 0.4)(0.2 0.4)(0.2 0.4)(0.2 0.4)(0.2 0.4)(0.2 0.4)(0.2 0.4)(0.2 0.4)(0.2 0.4)))
  (append (list (make-i-rule function i-nr-list))
          (loop for n from 0 to (1- (length fn-ilist)) by 2
                collect (make-i-rule (nth n fn-ilist) (nth (1+ n) fn-ilist)))))


;;;

(system::PWGLDef get-index ()
    "Get current index from pmc. This should be used inside a rule function."
    ()
  (ccl::cur-index))

 (system::PWGLDef get-temp-sol ()
     "Get the temporary solution. This should be used inside a rule function."
     ()
   *L*)

(system::PWGLDef get-rev-temp-sol ()
    "Get the reversed temporary solution. This should be used inside a rule function."
    ()
  *RL*)

(system::PWGLDef get-i-var ((i 1))
     ""
     ()
  (if (listp i)
      (loop for n in i
            collect (nth (1- n) *L*))
    (nth (1- i) *L*)))



;"Get the value of the variable at position i in solution. If not assigned - nil will be returned."