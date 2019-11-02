;Pointed to by acaddoc in the new lisp library. Loads all useful functions from old library, and adds shortcuts.

(load "addlayers")
(load "Downloaded\\CirclePolylineSwap")
(load "helper")
(load "movescale")
(load "mp")

;Shortcuts
;Description:
;Run c:mpoint
(defun C:MPO ()
	(c:mpoint)
)

;Description:
;Run c:updatelayers
(defun C:UPLAY ()
	(c:updatelayers)
)

;Description:
;Insert property line and portable label blocks into the drawing.
(defun insertextralabels ()
	(command "-insert" "*\\\\TDSBSHARES\\facilities_silo\\Facility-Services\\Standards-Comp-Envir\\Staff\\B Buildings\\B08 Drawings\\ArcGIS\\Site Plans\\Extra Labels.dwg" '(11.5 2.23) "" "" "")
)