(load "Ellipse2ArcV1-1")

;Description:
;Shortcut function to run <a href="#c:prepmerge">PREPMERGE</a> command
(defun C:PM()
	(c:prepmerge)
)

;Description:
;Clean up the drawing.
; - purge 
; - remove sdf layer
; - fix circles
; - Remove arcs and ellipses
; - test for polyface meshes/2d polylines
; - test for extra layers
(defun C:PREPMERGE( / arcs fp fe)
	(setlayer "0")
	(command "-purge" "a" "*" "n")
	(command "-layer" "on" "*" "")
	(command "-layer" "u" "*" "")
	(command "-layer" "t" "*" "")
	(if (not (null (tblsearch "Layer" "sdf")))
		(progn
		(command "-laydel" "n" "sdf" "" "y"))
	)
	(if (not (null (tblsearch "Layer" "SDF_IMPORT")))
		(progn
		(command "-laydel" "n" "SDF_IMPORT" "" "y"))
	)
	;Remove Circles
	(c:fc)
	;Remove Arcs and Ellipses
	(c:e2a)
	(setq arcs (LM:ss->ent (ssget "X" (list (cons 0 "ARC") (cons 410 "Model")))))
	(foreach arc arcs
		(command "pedit" arc "y" "")
	)
	;Polyface Meshes
	(if (testforpface)
		(progn (write-line (getvar "dwgname")(setq fp (open "H:\\Map 3d\\3 exports\\pface.csv" "a"))) (close fp))
	)

	(removepface_noalert)
	(if (testforextralayers)
		(progn (write-line (getvar "dwgname")(setq fe (open "H:\\Map 3d\\3 exports\\extralayers.csv" "a"))) (close fe))
	)
)

;Description:
;Test if current drawing has any layers not in the standard list.
;Returns: T if there are extra layers.
(defun testforextralayers ( / hasweirdlayers masterlist layerlist)
	(setq hasweirdlayers nil)
	(setq masterlist (list "DEFPOINTS" "ESRI_WORLD_IMAGERY" "TDSB-SMSC-PLAYGROUND BASEBALL DIAMOND 2" "TDSB-SMSC-PLAYGROUND BASEBALL DIAMOND" "TDSB-SMSC-PLAYGROUND SOCCERFIELD 2" "TDSB-SMSC-PLAYGROUND SOCCERFIELD" "TDSB-SMSC-PARKING POINTS" "TDSB-SMSC-CITYROAD" "TDSB-SMSC-SOLAR PANELS" "TDSB-SMSC-ACCESSIBILITY GREEN PL" "TDSB-SMSC-ACCESSIBILITY GREEN PG" "TDSB-SMSC-ROOF EQUIP" "TDSB-SMSC-POLICE SAFETY PLAN PL" "TDSB-SMSC-PLAYGROUND PLAYSCAPE" "TDSB-SMSC-LANDSCAPE PLANTERS" "TDSB-SMSC-GATE" "TDSB-SMSC-BUILDING CANOPY" "TDSB-SMSC-BUILDING HIDDEN" "TDSB-SMSC-BUILDING RENOVATION" "TDSB-SMSC-BUILDING DEMOLITION" "TDSB-SMSC-BUILDING ADDITION" "TDSB-SMSC-STAIRS" "TDSB-SMSC-ROAD" "TDSB-SMSC-ROOMLABELS" "TDSB-SMSC-BRIDGES" "TDSB-SMSC-RIVER" "TDSB-SMSC-POLICE SAFETY PLAN" "TDSB-LOGO3" "TDSB-LOGO2" "TDSB-LOGO1" "TDSB-TBTXT-S" "TDSB-TBTXT-M" "TDSB-TBTXT" "TDSB-TBLK" "TDSB-SMSC-MISC" "TDSB-SMSC-PORTABLES" "TDSB-SMSC-WALKWAY" "TDSB-SMSC-SYMBOLS" "TDSB-SMSC-SERVICES" "TDSB-SMSC-PROPERTY LINE" "TDSB-SMSC-PLAYGROUND" "TDSB-SMSC-PARKING" "TDSB-SMSC-LANDSCAPE" "TDSB-SMSC-GRASS" "TDSB-SMSC-FIXTURES" "TDSB-SMSC-FENCE" "TDSB-SMSC-CURBS" "TDSB-SMSC-BUILDING" "TDSB-SMSC-AREA" "TDSB-CC LEASE" "TDSB-SMSC-GROSS AREA (SUB.)" "TDSB-SMSC-ROOF LINES" "TDSB-SMSC-ACCESSIBILITY RED" "TDSB-SMSC-ACCESSIBILITY GREEN" "TDSB-SMSC-ACCESSIBILITY" "TDSB-SMSC-MILLWORK" "TDSB-SMSC-PLUMBING" "TDSB-SMSC-BUILDING RENOVATION" "TDSB-SMSC-BUILDING DEMOLITION" "TDSB-SMSC-BUILDING ADDITION" "TDSB-ROOMLABELS" "TDSB-LOGO3" "TDSB-LOGO2" "TDSB-LOGO1" "TDSB-SMSC-POLICE SAFETY PLAN" "TDSB-SMSC-FIRE SAFETY PLAN" "TDSB-TBTXT-S" "TDSB-TBTXT-M" "TDSB-LOGO" "TDSB-TBTXT" "TDSB-TBLK" "TDSB-SMSC-FIXTURES" "TDSB-SMSC-GROSS AREA (ADD.)" "TDSB-SMSC-NET AREA" "TDSB-SMSC-MISC" "TDSB-SMSC-WINDOWS" "TDSB-SMSC-WALLS" "TDSB-SMSC-STAIRS" "TDSB-SMSC-HATCH" "TDSB-SMSC-DOOR" "DEFPOINTS" "0" "TDSB-SMSC-GROSS AREA"))
	(setq hasweirdlayers nil)
	(Setq layerlist (Table "layer"))
	(foreach lyr layerlist
		(if (null (member (strcase lyr nil) masterlist))
			(progn (princ (strcat lyr " "))
			(setq hasweirdlayers T))
		)
	)
	hasweirdlayers
)

;Description:
;Shortcut for <a href="#removepface_noalert">removing polyface meshes</a>, and 2D polylines.
(defun C:RFC ()
	(removepface_noalert)
)

;Description:
;copy of <a href="#removepface">removepface</a>, but with no alert message at the end.
(defun removepface_noalert ( / pfaces pl)
	(if (testforpface)
		(progn
			(setq pfaces (LM:ss->ent (ssget "X" (list (cons 8 "tdsb-smsc-net area") (cons 0 "Polyline") (cons 100 "AcDbPolyFaceMesh")))))
			(foreach pface pfaces
				(setq pl (plpface pface))
				(entdel pface)
				(addoldRoomID pl)
				(setoldRoomID pl (ade_odgetfield pface "1" "room_id" 0))
			)
			(setq pfaces (LM:ss->ent (ssget "X" (list (cons 0 "Polyline") (cons 100 "AcDbPolyFaceMesh")))))
			(foreach pface pfaces
				(setlayer (cdr (assoc 8 (entget pface))))
				(setq pl (plpface pface))
				(entdel pface)
			)
		)
	)
)