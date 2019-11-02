(defun c:prepalign ()
	(c:chgunits)
	(command "-layer" "UN" "*" "")
	(command "._Layer" "_Make" "tdsb-smsc-building parapet lines" "_Color" "magenta" "tdsb-smsc-building parapet lines" "_LT" "ACAD_ISO03W100" "tdsb-smsc-building parapet lines" "")
	(command "._Layer" "_Make" "tdsb-smsc-building outline" "_Color" "red" "tdsb-smsc-building outline" "_LT" "ACAD_ISO03W100" "tdsb-smsc-building outline" "")
	(command "._Layer" "_Make" "tdsb-smsc-roof equip" "_Color" 8 "tdsb-smsc-roof equip" "_LT" "ACAD_ISO03W100" "tdsb-smsc-roof equip" "")

	(C2P:nogui (LM:ss->ent (ssget "X" (list (cons 0 "Circle")))))
  
	(command "_.chprop" (ssget "X" (list (cons 8 "tdsb-smsc-gross area") (cons 62 2))) "" "LA" "tdsb-smsc-building parapet lines" "")
	(command "_.chprop" (ssget "X" (list (cons 8 "tdsb-smsc-gross area"))) "" "LA" "tdsb-smsc-building outline" "")
	(command "change" (ssget "X" (list (cons 8 "tdsb-smsc-building parapet lines"))) "" "p" "c" "bylayer" "")
	(command "change" (ssget "X" (list (cons 8 "tdsb-smsc-building outline"))) "" "p" "c" "bylayer" "")
)

(defun c:fixcircles ()
	(C2P:nogui (LM:ss->ent (ssget "X" (list (cons 0 "Circle")))))
)

(defun c:strace ()
	(if (null (vl-position "SITE PLAN TRACE" (getxref)))
		(command "-xref" "a" "\\\\TDSBSHARES\\facilities_silo\\Facility-Services\\Standards-Comp-Envir\\Staff\\B Buildings\\B08 Drawings\\ArcGIS\\Site Plans\\SITE PLAN TRACE.dwg" "0,0" "1" "1" "0")
		(command "-xref" "d" "SITE PLAN TRACE")
	)
)

(defun getxref ()
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