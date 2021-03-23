(in-package "PW")


(PWGLDef make-num-fun ((fexpr "(f(x)= (+ x 1))"))
    "Creates a lisp function object from the \"functional\" expr <fexpr> which is
basically an infixed expression (see prefix-expr and prefix-help).
When <fexpr> begins with something like (f(x)= ...), the formal arguments are
taken from the given list, otherwise they are deduced from the body of <fexpr>
and collected in the order they appear in it. Local variables are automatically
handled. The resulting function is compiled when the value of *compile-num-
lambda* is T (default). <make-num-fun> has the following syntax:
the standard Lisp syntax, i.e., (f(x) = (- (* x x) x))). The variable name definition 
at the beginning of the function (f(x)= ...) is optional. If it is not included by the 
user, the program figures out which variables are involved."
    ;; fexpr == <expr> || (<fun> <args> = . <expr>)
    (:w 0.4)
  (multiple-value-bind (lambda name) (make-num-lambda fexpr)
    name
    (eval `(function ,lambda))))