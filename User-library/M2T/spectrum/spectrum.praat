form Get spectrum
	sentence File ...
endform
	Read from file... 'file$'
	To Spectrum: "yes"	
	bw = Get bin width
List: "no", "no", "no", "no", "no", "yes"
appendInfo: bw 