(in-package :zosc)

(defun zosc-zosc-server (hostname portnumber &optional oscfunction)
  (let* ((zosc-process-name (concatenate 'string "OSC receiver on \"" hostname "\" " (write-to-string portnumber)))
	 (zosc-server-process (mp:find-process-from-name zosc-process-name)))
    (if (not zosc-server-process)
	(start-osc-server hostname portnumber oscfunction)
	(progn (osc:stop-osc-server zosc-server-process)
	       (pprint (concatenate 'string "OSC server with process name \""zosc-process-name "\" STOPED"))))))
      
(defun zosc-zosc-write-msg (message hostname portnumber)
  (write-osc-msg message (open-osc-out-stream hostname portnumber)))

(defun zosc-zosc-write-bundle (bundle hostname portnumber)
  (write-osc-bundle bundle (open-osc-out-stream hostname portnumber)))

(PWGLdef zosc-server ((hostname (write-to-string '"localhost"))
		      (portnumber 3001)
		      &optional
		      (oscfunction ()))
    "
Start/stop a OSC server.
1: string with hostname/ip
2: int with UDP portnumber
3: an abstraction in lambda mode (remember to press Shift L) that will process incoming messages and bundles


"
    ()
     (zosc-zosc-server hostname portnumber oscfunction))



(PWGLdef zosc-write-msg ((message '("/titi" 123))
			 (hostname (write-to-string '"localhost"))
			 (portnumber 3000))
    "
Sends a message (list) to an address:portnumber.
1: list - message
2: string - hostname/ip
3: int - portnumber


"
    ()
     (zosc-zosc-write-msg message hostname portnumber))


(PWGLdef zosc-write-bundle ((bundle '(("/titi" 123)("/tete" 234)))
			    (hostname (write-to-string '"localhost"))
			    (portnumber 3000))
    "
Sends a message (tree) to an address:portnumber.
1: tree - bundle
2: string - hostname/ip
3: int - portnumber


"
    ()
     (zosc-zosc-write-bundle bundle hostname portnumber))




(PWGLdef zosc-decode ((message #(47 98 105 110 103 0 0 0 44 105 102 115 0 0 0 0 0 0 0 1 64 6 102 102 116 104 114 101 101 0 0 0)))
    "
Decodes a message or a bundle (received as a vector) in a list (msg) or a tree (bundle)
1: vector - OSC message or bundle

"
    ()
     (decode-msg-or-bundle message))



