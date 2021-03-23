(in-package :fe)

(export '(;; data structure
	  fenv fenv->list y fenv?
	  ;; Concrete generators
	  BPF->fenv mk-linear-fenv mk-sin-fenv mk-sin-fenv1
	  saw-fenv saw1-fenv triangle-fenv square-fenv
	  steps-fenv random-steps-fenv rising-expon-fenv constant-fenv
	  ;; Generic generators
	  make-fenv make-fenv1 points->fenv
	  funcs->fenv fenv-seq osciallator
	  ;; Transformers
	  add-fenvs multiply-fenvs reverse-fenv scale-fenv rescale-fenv
	  combine-fenvs waveshape
	  )
	:fe)