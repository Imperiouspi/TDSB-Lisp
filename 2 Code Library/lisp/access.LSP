;Functions to transfer and geocode the accessibility plan automatically. Copies from the floor plan, and aligns to a geocoded sdf file.

(load "burst")
(load "hull")
(vl-load-com)
;Description:
;Copy the contents of the "Access" Tab
;Troubleshooting: Make sure the "Access" Tab exists. Make sure plan is in paper space not model space. 
(defun C:COPYACCESS ( / );copy a select startrot)
	(setq copy T)
	(setvar "cmdecho" 1)
	(if (member "Access" (layoutlist))(progn 
		(vl-bb-set 'copy T)
		(setvar "ctab" "Access")
		(setvar "osmode" 0)
		(command "PSpace")
		(setq a (ssget "X" (list (cons 410 "Access") (cons 2 "door"))))
		(if a
			(progn (sssetfirst nil a)
			(c:burst))
		)
		(c:AttDef2Text)
		(setq select (ssget "X" (list (cons -4 "<AND") (cons 410 "Access")
					  (cons -4 "<NOT") (cons 0 "HATCH") (cons -4 "NOT>")
					  (cons -4 "<NOT") (cons 0 "VIEWPORT") (cons -4 "NOT>")
					  (cons -4 "<NOT") (cons 2 "smsc-tblk-11x8.5 access PLAN") (cons -4 "NOT>")
					  (cons -4 "<NOT") (cons 2 "smsc-north arrow") (cons -4 "NOT>")
					  (cons -4 "<NOT") (cons 2 "tdsb-north arrow") (cons -4 "NOT>")
					  (cons -4 "AND>"))))
		(setq startrot (cdr (assoc 50 (entget (ssname (ssget "X" (list (cons -4 "<OR") (cons 2 "smsc-north arrow") (cons 2 "smsc-north arrow-metric") (cons 2 "tdsb-north arrow") (cons -4 "OR>"))) 0)))))
		(command "-block" "access" '(0 0) select "")
		(command "-insert" "access" '(0 0) 1 1 0)
		;(command "_.copybase" '(0 0) (ssget "X" (list (cons 2 "access"))) "")
		(command "explode" (ssget "X" (list (cons 2 "access"))))
		(setvar "cmddia" 0)
		(command "-wblock" (strcat "H:\\Map 3d\\3 exports\\access" ".dwg") "Y" "=" "N")
		(setvar "cmddia" 1)
		(command "-purge" "b" "access" "n")
		(vl-bb-set 'startrot startrot)
	) (vl-bb-set 'copy nil))
	(c:rsnap)
	(vl-cmdf "_.RESUME")
)

;Description:
;Insert and fix accessibility plan without automatically aligning it.
(defun C:PASTENOROTATE( / zero og bounds select access stuff otherstuff)
	(LM:startundo (LM:acdoc))
	(setq osm (getvar "osmode"))
	(setvar "osmode" 16384)
	(setvar "3dosmode" 1)
	;(setvar "cmdecho" 0)
	(setq zero (list 544481 4762500))
	(command "._Layer" "_Make" "tdsb-smsc-accessibility" "_Color" "white" "tdsb-smsc-accessibility" "_LT" "CONTINUOUS" "tdsb-smsc-accessibility" "")
	(command "._Layer" "_Make" "tdsb-smsc-accessibility green" "_Color" 92 "tdsb-smsc-accessibility green" "_LT" "CONTINUOUS" "tdsb-smsc-accessibility green" "")
	(command "._Layer" "_Make" "tdsb-smsc-accessibility red" "_Color" 10 "tdsb-smsc-accessibility red" "_LT" "CONTINUOUS" "tdsb-smsc-accessibility red" "")
	(setq og (ssget "X" (list (cons 410 "Model"))))
	;(command "pasteclip" zero)
	(command "-insert" "H:\\Map 3d\\3 exports\\access.dwg" zero 1 1 0)
	(setq bounds (LM:ssboundingbox (ssget "X" '((2 . "access")))))
	(command "explode" (ssget "X" '((2 . "access"))))
	(command "zoom" "E")
	
	(command "change" (ssget "C" (car bounds) (cadr bounds) (list
					(cons -4 "<OR") (cons 8 "tdsb-smsc-door") (cons 8 "tdsb-smsc-stairs") (cons -4 "OR>")))
		"" "p" "LA" "tdsb-smsc-accessibility red" "")

	;Setup over. Create and find the new access block. ONLY includes polylines.
	(command "-purge" "b" "access" "n")
	(setq select (ssget "C" (car bounds) (cadr bounds) (list (cons 8 "tdsb-smsc-accessibility"))))

	(command "-block" "access" '(0 0) select "")
	(command "-insert" "access" '(0 0) 1 1 0)
	(setq access (ssget "X" (list (cons 2 "access"))))

	(setq stuff (ssget "C" (car bounds) (cadr bounds) (list (cons 0 "INSERT") (cons -4 "<NOT") (cons 2 "smsc-access door label_1") (cons -4 "NOT>") (cons -4 "<NOT") (cons 2 "access") (cons -4 "NOT>"))))
	(explode stuff)
	(c:AttDef2Text)
	(setq select (ssget "C" (car bounds) (cadr bounds) (list (cons -4 "<NOT") (cons 2 "access") (cons -4 "NOT>"))))
	(command "-block" "otherstuff" '(0 0) select "")
	(command "-insert" "otherstuff" '(0 0) 1 1 0)
	(setq otherstuff (ssget "X" (list (cons 2 "otherstuff"))))
	(setvar "osmode" osm)
)

;Description:
;Insert, fix, and align the accessility plan into an sdf file.
;Matches the convex hull of the accessibility plan's polylines to the convex hull of the floor plan's gross area polyline. 
;Troubleshooting: Sometimes it fails. Do it manually, it'll be faster than debugging. If there's a large red line, that's a good indicator of failure.
(defun C:PASTEACCESS( / );zero og bounds select access stuff otherstuff pt pt2 lng minstep totalrot fit bestfit ct step_size dstep r_fit l_fit dfit num)
	(LM:startundo (LM:acdoc))
	(setvar "osmode" 16384)
	;(setvar "3dosmode" 1)
	;(setvar "xclipframe" 2)
	;(setvar "cmdecho" 0)
	(setq zero (list 544481 4762500))
	(command "-layer" "on" "*" "")
	(command "._Layer" "_Make" "tdsb-smsc-accessibility" "_Color" "white" "tdsb-smsc-accessibility" "_LT" "CONTINUOUS" "tdsb-smsc-accessibility" "")
	(command "._Layer" "_Make" "tdsb-smsc-accessibility green" "_Color" 92 "tdsb-smsc-accessibility green" "_LT" "CONTINUOUS" "tdsb-smsc-accessibility green" "")
	(command "._Layer" "_Make" "tdsb-smsc-accessibility red" "_Color" 10 "tdsb-smsc-accessibility red" "_LT" "CONTINUOUS" "tdsb-smsc-accessibility red" "")
	(command "-layer" "t" "*" "")
	(command "-layer" "u" "*" "")
	(setq og (ssget "X" (list (cons 410 "Model"))))
	(command "-insert" "H:\\Map 3d\\3 exports\\access.dwg" zero 1 1 0)
	(setq bounds (LM:ssboundingbox (ssget "X" '((2 . "access")))))
	(command "explode" (ssget "X" '((2 . "access"))))
	(c:fc)
	(command "zoom" "E")
	
	(command "change" (ssget "C" (car bounds) (cadr bounds) (list
					(cons -4 "<OR") (cons 8 "tdsb-smsc-door") (cons 8 "tdsb-smsc-stairs") (cons -4 "OR>")))
		"" "p" "LA" "tdsb-smsc-accessibility red" "")

	;Setup over. Create and find the new access block. ONLY includes polylines.
	(command "-purge" "b" "access" "n")
	(setq select (ssget "C" (car bounds) (cadr bounds) (list (cons 8 "tdsb-smsc-accessibility"))))

	(command "-block" "access" '(0 0) select "")
	(command "-insert" "access" '(0 0) 1 1 0)
	(setq access (ssget "X" (list (cons 2 "access"))))

	(setq stuff (ssget "C" (car bounds) (cadr bounds) (list (cons 0 "INSERT") (cons -4 "<NOT") (cons 2 "smsc-access door label_1") (cons -4 "NOT>") (cons -4 "<NOT") (cons 2 "access") (cons -4 "NOT>"))))
	(sssetfirst nil stuff)
	(c:burst)
	(c:AttDef2Text)
	(setq select (ssget "C" (car bounds) (cadr bounds) (list (cons -4 "<NOT") (cons 2 "access") (cons -4 "NOT>"))))
	(command "-block" "otherstuff" '(0 0) select "")
	(command "-insert" "otherstuff" '(0 0) 1 1 0)
	(setq otherstuff (ssget "X" (list (cons 2 "otherstuff"))))

	(if (ssget "X" (list (cons 8 "tdsb-smsc-gross area") (cons -4 "<OR") (cons 0 "LWPOLYLINE") (cons 0 "LINE") (cons -4 "OR>")))
		(setq floorhull (convexhull (ssget "X" (list (cons -4 "<OR") (cons 8 "tdsb-smsc-misc") (cons 8 "tdsb-smsc-gross area") (cons -4 "OR>") (cons -4 "<OR") (cons 0 "LWPOLYLINE") (cons 0 "LINE") (cons -4 "OR>")))))
		(if (ssget "X" (list (cons -4 "<NOT") (cons 0 "INSERT") (cons -4 "NOT>") (cons -4 "<OR") (cons 8 "tdsb-smsc-net area") (cons 8 "tdsb-smsc-misc") (cons 8 "tdsb-smsc-walls") (cons -4 "OR>")))
			(setq floorhull (convexhull (ssget "X" (list (cons -4 "<NOT") (cons 0 "INSERT") (cons -4 "NOT>") (cons -4 "<OR") (cons 8 "tdsb-smsc-net area") (cons 8 "tdsb-smsc-misc") (cons 8 "tdsb-smsc-walls") (cons -4 "OR>")))))
			(setq floorhull (convexhull (ssget "X" (list (cons -4 "<NOT") (cons 2 "access") (cons -4 "NOT>") (cons -4 "<NOT") (cons 2 "otherstuff") (cons -4 "NOT>")))))
		)
	)
	(setq accesshull (convexhull access))
  
	;Find "diameter"
	(foreach pt floorhull
		(foreach pt2 floorhull
			(setq lng (dist pt pt2))
			(if (> lng maxlng_floor)
				(progn
			  		(setq maxlng_floor lng)
				)
			)
		)
	)

	(foreach pt accesshull
		(foreach pt2 accesshull
			(setq lng (dist pt pt2))
			(if (> lng maxlng_access)
				(progn
			  		(setq maxlng_access lng)
				)
			)
		)
	)

	;Make Hulls
	(setq floorhull_pl
		(entmakex
			(append
				(list
					'(000 . "LWPOLYLINE")
					'(100 . "AcDbEntity")
					'(100 . "AcDbPolyline")
					(cons 90 (length floorhull))
					'(70 . 1)
				)
				(mapcar '(lambda ( x ) (cons 10 x)) floorhull)
			)
		)
	)
	(setq accesshull_pl
		(entmakex
			(append
				(list
					'(000 . "LWPOLYLINE")
					'(100 . "AcDbEntity")
					'(100 . "AcDbPolyline")
					(cons 90 (length accesshull))
					'(70 . 1)
				)
				(mapcar '(lambda ( x ) (cons 10 x)) accesshull)
			)
		)
	)
	(setq ssaccesshull_pl (ssadd accesshull_pl))
	;Scale so diameter lengths match
	(command "scale" access "" '(0 0) (/ maxlng_floor maxlng_access))
	(command "scale" accesshull_pl "" '(0 0) (/ maxlng_floor maxlng_access))
	(command "scale" otherstuff "" '(0 0) (/ maxlng_floor maxlng_access))

	;Move to match centroid of hulls
	(setq centroid_floor (getcenter (ssadd floorhull_pl)))
	(setq centroid_floor (list (car centroid_floor) (cdr centroid_floor) 0))
	(setq centroid_access (getcenter ssaccesshull_pl))
	(setq centroid_access (list (car centroid_access) (cdr centroid_access) 0))
	(command "._move" (ssget "X" (list (cons 2 "access"))) "" centroid_access centroid_floor)
	(command "._move" (ssadd accesshull_pl) "" centroid_access centroid_floor)
	(command "._move" otherstuff "" centroid_access centroid_floor)

	;Tolerance
	(setq minstep 0.00001)
	(setq totalrot 0)
	(setq fit (testoverlap accesshull_pl floorhull_pl))
	(setq bestfit (cons 0 0))
	(setq ct 0)
	(command "zoom" "E")
	(repeat 360
		(command "rotate" ssaccesshull_pl "" (getvcenter ssaccesshull_pl) 1)
		(setq fit (testoverlap accesshull_pl floorhull_pl))
		(if (> fit (car bestfit)) (setq bestfit (cons fit ct)))
		(setq ct (+ 1 ct))
	)

	(command "rotate" ssaccesshull_pl "" (getvcenter ssaccesshull_pl) (cdr bestfit))
	(command "rotate" access "" (getvcenter ssaccesshull_pl) (cdr bestfit))
	(setq totalrot (+ totalrot (cdr bestfit)))

	;Step parameters: initial and how much it should decrease each loop
	(setq step_size 0.5);in degrees
	(setq dstep 0.75);multiplier
	(while (> step_size minstep)
		(command "rotate" ssaccesshull_pl "" (getvcenter ssaccesshull_pl) step_size)
		(setq r_fit (testoverlap accesshull_pl floorhull_pl))
		(command "rotate" ssaccesshull_pl "" (getvcenter ssaccesshull_pl) (* -2 step_size))
		(setq l_fit (testoverlap accesshull_pl floorhull_pl))
		(command "rotate" ssaccesshull_pl "" (getvcenter ssaccesshull_pl) step_size)
		(cond
			((= (max r_fit l_fit fit) r_fit)
				(command "rotate" ssaccesshull_pl "" (getvcenter ssaccesshull_pl) step_size)
				(command "rotate" access "" (getvcenter ssaccesshull_pl) step_size)
				(setq totalrot (+ step_size totalrot))
				(setq dfit (- fit r_fit))
				(setq fit r_fit)
			)
			((= (max r_fit l_fit fit) l_fit)
				(command "rotate" ssaccesshull_pl "" (getvcenter ssaccesshull_pl) (* -2 step_size))
				(command "rotate" access "" (getvcenter ssaccesshull_pl) (* -2 step_size))
				(setq totalrot (+ (* -2 step_size) totalrot))
				(setq dfit (- fit l_fit))
				(setq fit l_fit)
			)
			((= (max r_fit l_fit fit) fit)
				(setq step_size (* step_size dstep))
			)
		)
	)

	;Cleanup
	;Replace door labels. Done later to filter out labels from block
	(command "rotate" otherstuff "" (getvcenter ssaccesshull_pl) totalrot)
	(explode otherstuff)
	(command "-layer" "t" "*" "")
	(foreach label (LM:ss->ent (ssget "X" (list (cons 2 "smsc-access door label_1"))))
		(setq num (LM:getattributevalue label "EXTERIOR_DOOR#"))
		(if label
			(sssetfirst nil (ssadd label))
		)
		(c:burst)
	)
	(explode access)
	(command "zoom" "E")
	(LM:endundo (LM:acdoc))
	
	;Delete hull_pl
	(entdel floorhull_pl)
	(entdel accesshull_pl)

	(foreach e (LM:ss->ent og)
		(entdel e)
	)
	(command "-purge" "A" "*" "N")
	(c:rsnap)
	(setvar "3dosmode" 1)
	(setvar "autosnap" 1)
	(setvar "cmdecho" 1)
	(c:fax)
	(vl-bb-set 'xrefname (strcat (getvar "dwgprefix") (getvar "dwgname")))
	(command "SAVEAS" "LT2013" (strcat "\\\\TDSBSHARES\\facilities_silo\\Facility-Services\\Standards-Comp-Envir\\Staff\\Record Drawing Master Files\\0000 sdf\\Accessibility\\" (vl-filename-base (getvar "dwgname")) "-A.dwg"))
	(vl-cmdf "_.RESUME")
)

;Description:
;First iteration of pasteAccess. Aligns with a simple rectangle/aspect ratio check. Not very accurate, replaced by the convex hull method.
(defun C:PASTEASPECTACCESS( / zero startrot bounds select accessbounds access floorbounds fas aaspect totalrot perfit fit step_size dstep r_aaspect_fit l_aaspect_fit stuff num)
	(LM:startundo (LM:acdoc))
	(c:prepmerge)
	(setq zero (list 544481 4762500))
	(setq startrot (* -57.29578 (vl-bb-ref 'startrot)))
	;(setq startrot 0)

	;(command "pasteclip" zero)
	(command "-insert" "H:\\Map 3d\\3 exports\\access.dwg" zero 1 1 0)
	(setq bounds (LM:ssboundingbox (ssget "X" '((2 . "access")))))
	(command "explode" (ssget "X" '((2 . "access"))))
	(command "zoom" "E")
	
	(command "change" (ssget "C" (car bounds) (cadr bounds) (list
					(cons -4 "<OR") (cons 8 "tdsb-smsc-door") (cons 8 "tdsb-smsc-stairs") (cons -4 "OR>")))
		"" "p" "LA" "tdsb-smsc-accessibility red" "")
	;Setup over. Create and find the new access block. ONLY includes polylines.
	(command "-purge" "b" "access" "n")
	(setq select (ssget "C" (car bounds) (cadr bounds) (list (cons 8 "tdsb-smsc-accessibility"))))
	(setq accessbounds (LM:ssboundingbox (ssget "C" (car bounds) (cadr bounds) (list (cons 8 "tdsb-smsc-accessibility")))))
	(command "-block" "access" '(0 0) select "")
	(command "-insert" "access" '(0 0) 1 1 0)
	(setq access (ssget "X" (list (cons 2 "access"))))

	;Get the bounds for the floor plan
	(setq floorbounds (LM:ssboundingbox (ssget "X" (list (cons 8 "tdsb-smsc-gross area") (cons 0 "LWPOLYLINE")))))
	;Rotate the access plan to the old compass rotation.
	(command "rotate" access "" '(0 0) startrot)

	;Find original aspect ratios
	(setq faspect (getaspectratio floorbounds))
	(setq aaspect (getaspectratio accessbounds))

	(setq totalrot startrot)

	;Tolerance
	(setq perfit 0.000000001)
	(setq fit (abs (- aaspect faspect)))

	;Step parameters: initial and how much it should decrease each loop
	(setq step_size 0.5);in degrees
	(setq dstep 0.75);multiplier
	(while (and (> fit perfit) (> step_size (expt 10.0 -99)))
		(command "rotate" access "" '(0 0) step_size)
		(setq r_aaspect_fit (abs (- (getaspectratio (getaccessbounds)) faspect)))
		(command "rotate" access "" '(0 0) (* -2 step_size))
		(setq l_aaspect_fit (abs (- (getaspectratio (getaccessbounds)) faspect)))
		(command "rotate" access "" '(0 0) step_size)
		(cond
			((= (min r_aaspect_fit l_aaspect_fit fit) r_aaspect_fit)
				(command "rotate" access "" '(0 0) step_size)
				(setq totalrot (+ step_size totalrot))
				(setq fit r_aaspect_fit)
			)
			((= (min r_aaspect_fit l_aaspect_fit fit) l_aaspect_fit)
				(command "rotate" access "" '(0 0) (* -2 step_size))
				(setq totalrot (+ (* -2 step_size) totalrot))
				(setq fit l_aaspect_fit)
			)
			((= (min r_aaspect_fit l_aaspect_fit fit) fit)
				(setq step_size (* step_size dstep))
			)
		)
	)

	;Replace door labels. Done later to filter out labels from block
	(setq stuff (ssget "C" (car bounds) (cadr bounds) (list (cons 0 "INSERT") (cons -4 "<NOT") (cons 2 "smsc-access door label_1") (cons -4 "NOT>"))))
	(explode stuff)
	(foreach label (LM:ss->ent (ssget "X" (list (cons 2 "smsc-access door label_1"))))
		(setq num (LM:getattributevalue label "EXTERIOR_DOOR#"))
		(sssetfirst nil (ssadd label))
		(c:burst)
	)
	(LM:endundo (LM:acdoc))
	;scale and move

)

;Description:
;Runs the default EXPLODE command that also sets the weird "qaflags" properly, whatever they're for.
;Arguments:
;ss: Selection set to explode
(defun explode (ss / qaflags)
	(setq qaflags (getvar "qaflags"))
	(setvar "QAFLAGS" 1)
	(command ".explode" ss "")
	(setvar "QAFLAGS" qaflags)
)

;Description:
;Calculate the aspect ratio of a rectangle described by the two points.
;Arguments:
;points: list of two points
;Returns: Aspect ratio as a decimal
(defun getaspectratio (points / p1 p2)
	(setq p1 (car points))
	(setq p2 (cadr points))
	(/ (- (nth 0 p2) (nth 0 p1)) (- (nth 1 p2) (nth 1 p1)))
)

;Description:
;Get the bounding box of the "access" block
;Returns: Bounding Box described by two points
(defun getaccessbounds ()
	(LM:ssboundingbox (ssget "X" (list (cons 2 "access"))))
)

;ignore
(defun C:TESTOV ()
	(testoverlap floorhull_pl accesshull_pl)
)

;Description:
;Find the % overlap of two polylines
;Arguments:
;plf: floor outline polyline
;pla: accessibility outline polyline
;Returns: % overlap between the polylines, as a decimal
(defun testoverlap (plf pla / area_f r area_int)
	(setvar 'delobj 0)
	(command "region" plf "")
	(setq area_f (vla-get-area (vlax-ename->vla-object (ssname (ssget "X" (list (cons 0 "REGION"))) 0))))
	(command "region" pla "")
	(command "intersect" (ssget "X" (list (cons 0 "REGION"))) "")
	(if (setq r (ssget "x" (list (cons 0 "REGION"))))
		(progn
			(setq area_int (vla-get-area (vlax-ename->vla-object (ssname r 0))))
			(foreach e (LM:ss->ent (ssget "X" (list (cons 0 "REGION"))))
				(entdel e)
			)
		)
		(setq area_int 0)
	)
	(setvar 'delobj 3)
	(/ area_int area_f)
)

;Description:
;Get the center of a selection set, returned as a list (vector)
;Arguments:
;ss: Selection set
;Returns: Center of ss, as a list
(defun getvcenter (ss / p)
	(setq p (getcenter ss))
	(list (car p) (cdr p) 0)
)

;Description:
;Changes attdef entities (attributes that haven't been put into a block) into dtext in the whole drawing
;Source: https://forums.augi.com/showthread.php?40372-change-exploded-block-attribute-tags-to-text
(defun C:ATTDEF2TEXT (/ ActDoc LayoutCol tmpLayoutBlk)
	(setq ActDoc (vla-get-ActiveDocument (vlax-get-Acad-Object)))
	(vla-StartUndoMark ActDoc)
	(setq LayoutCol (vla-get-Layouts ActDoc))
	(vlax-for LayoutObj LayoutCol
	 (setq tmpLayoutBlk (vla-get-Block LayoutObj))
	 (vlax-for Obj tmpLayoutBlk
	  (if (= (vla-get-ObjectName Obj) "AcDbAttributeDefinition")
	   (progn
	    (setq TextObj (vla-AddText tmpLayoutBlk (vla-get-TagString Obj) (vla-get-InsertionPoint Obj) (vla-get-Height Obj)))
	    (vla-put-Alignment TextObj (vla-get-Alignment Obj))
	    (if (/= (vla-get-Alignment TextObj) 0)
	     (vla-put-TextAlignmentPoint TextObj (vla-get-TextAlignmentPoint Obj))
	    )
	    (vla-put-Backward TextObj (vla-get-Backward Obj))
	    (vla-put-Layer TextObj (vla-get-Layer Obj))
	    (vla-put-Normal TextObj (vla-get-Normal Obj))
	    (vla-put-ObliqueAngle TextObj (vla-get-ObliqueAngle Obj))
	    (vla-put-Rotation TextObj (vla-get-Rotation Obj))
	    (vla-put-ScaleFactor TextObj (vla-get-ScaleFactor Obj))
	    (vla-put-StyleName TextObj (vla-get-StyleName Obj))
	    (vla-put-UpsideDown TextObj (vla-get-UpsideDown Obj))
	    (vla-Delete Obj)
	   )
	  )
	 )
	)
	(vla-EndUndoMark ActDoc)
	(princ)
)

;Description:
;Fix the accessibility drawing. Move doors and stairs to "tdsb-smsc-accessibility red", and burst all blocks.
(defun C:FAXESS ( / a ve)
	(if (ssget "X" (list (cons -4 "<OR") (cons 8 "tdsb-smsc-door") (cons 8 "tdsb-smsc-stairs") (cons -4 "OR>")))
		(command "change" (ssget "X" (list
					(cons -4 "<OR") (cons 8 "tdsb-smsc-door") (cons 8 "tdsb-smsc-stairs") (cons -4 "OR>")))
		"" "p" "LA" "tdsb-smsc-accessibility red" "")
	)
	(while (setq a (ssget "X" (list (cons 0 "INSERT") (cons 410 "Model"))))
		(foreach e (LM:ss->ent a)
			(sssetfirst nil (ssadd e))
			(c:burst)
			(if (setq ve (vlax-ename->vla-object e))
			(progn (vlax-safearray->list (variant-value (vlax-invoke-method ve "Explode")))
			(vla-delete ve)))
		)
	)
	(princ)
)

;Description:
;Shortcut for <a href="#c:faxess">faxess</a>, because I'm really lazy.
(defun C:FAX ()
	(c:faxess)
)