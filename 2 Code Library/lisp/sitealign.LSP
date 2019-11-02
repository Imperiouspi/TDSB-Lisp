;A set of commands used when aligning site plans to the map.

;Description:
;A set of commands to prep a drawing to be ready to align the site plan
;Changes units, adds several layers, converts circles to polylines, and then changes the colour and line type of certain layers.
(defun C:PREPALIGN ()
	(c:chgunits)
	(command "-layer" "UN" "*" "")
	(command "._Layer" "_Make" "tdsb-smsc-building parapet lines" "_Color" "magenta" "tdsb-smsc-building parapet lines" "_LT" "ACAD_ISO03W100" "tdsb-smsc-building parapet lines" "")
	(command "._Layer" "_Make" "tdsb-smsc-building outline" "_Color" "red" "tdsb-smsc-building outline" "_LT" "ACAD_ISO03W100" "tdsb-smsc-building outline" "")
	(command "._Layer" "_Make" "tdsb-smsc-roof equip" "_Color" 8 "tdsb-smsc-roof equip" "_LT" "ACAD_ISO03W100" "tdsb-smsc-roof equip" "")
	(c:uplay)

	(C2P:nogui (LM:ss->ent (ssget "X" (list (cons 0 "Circle")))))
  
	(command "_.chprop" (ssget "X" (list (cons 8 "tdsb-smsc-gross area") (cons 62 2))) "" "LA" "tdsb-smsc-building parapet lines" "")
	(command "_.chprop" (ssget "X" (list (cons 8 "tdsb-smsc-gross area"))) "" "LA" "tdsb-smsc-building outline" "")
	(command "change" (ssget "X" (list (cons 8 "tdsb-smsc-building parapet lines"))) "" "p" "c" "bylayer" "")
	(command "change" (ssget "X" (list (cons 8 "tdsb-smsc-building outline"))) "" "p" "c" "bylayer" "")
)

;Description:
;Change all circles to polylines.
(defun C:FIXCIRCLES ()
	(C2P:nogui (LM:ss->ent (ssget "X" (list (cons 0 "Circle")))))
)

;Description:
;Add "SITE PLAN TRACE" to the drawing, or get rid of it if already attached.
(defun C:STRACE ()
	(if (null (vl-position "SITE PLAN TRACE" (getxref)))
		(command "-xref" "a" "\\\\TDSBSHARES\\facilities_silo\\Facility-Services\\Standards-Comp-Envir\\Staff\\B Buildings\\B08 Drawings\\ArcGIS\\Site Plans\\SITE PLAN TRACE.dwg" "0,0" "1" "1" "0")
		(command "-xref" "d" "SITE PLAN TRACE")
	)
)

;Description:
;Retrieve a list of xrefs.
;Returns: List of all xrefs in the drawing.
(defun getxref ( / activedocument blocks xlist isXref blk)
	(vl-load-com)
	(setq activedocument (vla-get-activedocument (vlax-get-Acad-Object)))
	(setq blocks (vla-get-blocks activedocument))
	(setq xlist '())
	(vlax-for item blocks
		(setq isXref (vlax-get-property item 'isXref))
		(if (= isXref :vlax-true)
			(progn
				(setq blk (vlax-get-property item 'Name))
				(setq xlist (append (list blk) xlist))

			)

		)
	)
xlist
)

;Description:
;Shortcut for <a href="#c:fixcircles">FIXCIRCLES</a>
(defun C:FC ()
	(c:fixcircles)
)