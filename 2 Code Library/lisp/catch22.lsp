;Description
;Find all files that still contain the "22" layer, and output them to <a href="file:///H:\\Map 3d\\3 exports\\caught22.txt"> caught22.txt </a>. 
(defun C:CATCH22 ( / file)
	(setq file (open "H:\\Map 3d\\3 exports\\caught22.txt" "a"))
	(if (not (null (tblsearch "Layer" "22")))
		(write-line (getvar "dwgname") file)
	)
	(close file)
	(c:chgunits)
	(c:stop)
)

;Description:
;Check alignment of a drawing. Attaches "All Site Plans" as an xref to the current drawing. If offset, try fixing units and reattaching.
(defun C:BEGIN ()
	(command "xref" "a" "H:\\Map 3d\\4 Test Drawings\\All Site Plans.dwg" "0,0" 1.0 1.0 0.0)
)

;Description:
;Detaches "All Site Plans" xref.
(defun C:STOP ()
	(command "xref" "d" "All Site Plans")
)