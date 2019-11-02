(load "entrance_ids")
(load "ids_2")
;Description:
;Originally just a shortcut for site_mon_nums, but now also does some cleaning.
;Merges "parking point" into "parking points"
;Also runs NEWFIELDS to add site ids to anything not assigned in the normal procedure.
(defun C:SMN ( / )
	(setq cmd (getvar "cmdecho"))
	(setq os (getvar "osmode"))
	(setq dyn (getvar "DYNMODE"))
	(setvar "osmode" 0)
	(setvar "cmdecho" 0)
	(setvar "dynmode" 0)
	(foreach e (LM:ss->ent (ssget "X")) (setSiteID e ""))
	(if (not (tblsearch "LAYER" "tdsb-smsc-parking point"))
		(progn
			(c:newfields)
			(site_mon_nums)
		)
		(progn
			(prompt "POINT layer exists. Change to POINTS!")
			(command "._laymrg" "N" "tdsb-smsc-parking point" "" "N" "tdsb-smsc-parking points" "y" "")
			(c:smn)
		)
	)
	(command "regen")
	(setvar "osmode" os)
	(setvar "cmdecho" cmd)
	(setvar "dynmode" dyn)
	(print)
)

;Description:
;Returns the master list of layers, functions, labels, and arguments, for execution of monument labelling.
(defun list_layers ()
	(list	
		(list "tdsb-smsc-building outline"				(list "SCHL" "CTYD")		"let" 	id_by_hand 			nil 								)
		(list "tdsb-smsc-property line"					"PROP" 						"let" 	id_by_hand 			nil 								)
		;(list "tdsb-smsc-building parapet lines"		"ROOF"						"let"	helper2)
		;(list "tdsb-smsc-building canopy" 				"ROOF" 						nil 	nil 				T 									)
		(list "tdsb-smsc-road" 							(list "PARK" "DRIV")		"let" 	id_by_hand 			'("tdsb-smsc-parking")				)
		(list "tdsb-smsc-accessibility green pg" 		"RAMP" 						"num" 	id_by_hand			nil 								)
		(list "tdsb-smsc-misc" 				(list "BUNK" "FLAG" "SIGN" "MISC")		"num" 	id_by_hand			nil 								)
		(list "tdsb-smsc-parking points" 				(list "PARK" "DSPL") 		"num" 	id_by_line_child_parking 	"tdsb-smsc-road" 		nil	)
		(list "tdsb-smsc-fence" 						"FNCE" 						"num" 	id_layer 			nil									)
		(list "tdsb-smsc-gate" 							"GATE" 						"num" 	id_layer 			nil									)
		(list "tdsb-smsc-playground basketball" 		"BSKT" 						"num" 	id_layer 			T 									)
		(list "tdsb-smsc-playground funnelball" 		"FNBL" 						"num" 	id_layer 			T 									)
		(list "tdsb-smsc-playground baseball diamond" 	"BASE" 						"let" 	id_field 												)
		(list "tdsb-smsc-playground baseball fence" 	"BASE" 						"num"	id_layer_child 		(list "tdsb-smsc-playground baseball diamond" "tdsb-smsc-playground baseball diamond 2") nil	nil)
		(list "tdsb-smsc-playground soccerfield" 		"SOCC" 						"let" 	id_field 												)
		(list "tdsb-smsc-playground soccerpost" 		"SOCC"						"num"	id_soccer_posts		(list "tdsb-smsc-playground soccerfield" "tdsb-smsc-playground soccerfield 2") 	T)
		(list "tdsb-smsc-landscape" 					(list "GRSS" "FRST") 		"num" 	id_forest												)
		(list "tdsb-smsc-walkway" 						"WALK" 						"num" 	id_by_line 			nil 									)
		(list "tdsb-smsc-playground outline" 			"PLAY" 						"let" 	id_by_line 			nil									)
		(list "tdsb-smsc-playground playscape" 			"PLAY" 						"num" 	id_layer_child 		(list "tdsb-smsc-playground outline") 		T	T)
		;(list "tdsb-smsc-police safety plan" 			"ETFS" 						nil 	label_entrance 		T 									);Uncomment to run the police safety plan labelling too
		(list "tdsb-smsc-roof equip" 					nil 						nil 	nil 													)
		(list "tdsb-smsc-portables" 					"" 						nil 	id_portables_2 													)
	)
)

;Description:
;Add monument ids to all features
(defun site_mon_nums ( / snapmode labelct laylist)
	;Set up Environment
	(setq snapmode (getvar 'osmode))
	(setvar 'osmode 0)
	(setq *siteid* (substr (getvar "dwgname") 1 4))
	; (setq bp1 (getpoint "Get First Point"))
	; (setq bp2 (getpoint "Get Second Point"))
	(setq labelct 0)
	(setq laylist (list_layers))

	(foreach lay laylist
		(setq id 1)
		(princ (strcat "tdsb-smsc-" (nth 0 lay) "\n"))
		(command "redraw")
		(if (or (not (null (ssget "X" (list (cons 410 "Model") (cons 8 (nth 0 lay)))))) (not (null (ssget "X" (list (cons 410 "Model") (cons 8 (strcat (nth 0 lay) " 2")))))))
			(cond
				((= (nth 3 lay) id_layer) 			(id_layer (nth 0 lay) (nth 1 lay) (nth 2 lay) (nth 4 lay)))
				((= (nth 3 lay) id_layer_child) 	(id_layer_child (nth 0 lay) (nth 4 lay) (nth 1 lay) (nth 2 lay) (nth 5 lay) (nth 6 lay)))
				((= (nth 3 lay) id_by_line) 		(id_by_line (nth 0 lay) (nth 1 lay) (nth 2 lay) (nth 4 lay)))
				((= (nth 3 lay) id_by_line_child_parking) 	(id_by_line_child_parking (nth 0 lay) (nth 4 lay) (nth 1 lay) (nth 2 lay) (nth 5 lay)))
				((= (nth 3 lay) id_by_hand)			(id_by_hand (nth 0 lay) (nth 1 lay) (nth 2 lay) (nth 4 lay)))
				((= (nth 3 lay) id_soccer_posts)	(id_soccer_posts (nth 0 lay) (nth 4 lay) (nth 1 lay) (nth 2 lay) (nth 5 lay)))
				((= (nth 3 lay) label_entrance)		(if (= "Yes" (progn (initget "Yes No") (getkword "Label ETFS entrances?"))) (label_entrance (nth 0 lay)(nth 1 lay))))
				((not (null (nth 3 lay))) 			((nth 3 lay) (nth 0 lay) (nth 1 lay)))
				(T nil)
			)
			(print "No objects on layer\n")
		)
	)
	(setvar "osmode" snapmode)
)

;Description: 
;User selects a layer from a dropdown list, and this functions runs the correct method to label it, or asks for a new layer if no method is specified for that layer.
(defun C:LABELLAYER ( / snapmode labelct laylist lay ans sel)
	;Set up Environment
	(setq dcl_id (load_dialog "selectlayer.dcl"))
	(setq snapmode (getvar "osmode"))
	(setvar "osmode" 0)
	(setq *siteid* (substr (getvar "dwgname") 1 4))
	(setq laylist (list_layers))
	(initget 1)
	(setq ans "")
	(setq fl 3)
	(setq lay nil)
	(while (and (= ans "") (> fl 2))
		(if (not (new_dialog "selectlayer" dcl_id))
			(exit)
		)

		(start_list "layer_select" 3)
		(setq full_laylist (vl-sort (Table "layer") '<))
		(mapcar 'add_list full_laylist)
		(end_list)

		(set_tile "layer_select" (itoa (vl-position (getvar "clayer") full_laylist)))

		(action_tile "label"
			"(saveLayer)(done_dialog 4)"
		)

		(setq fl (start_dialog))
		(cond 
			((= fl 4)
				(setq ans savedlayer)
				(setq lay nil)
				(foreach l laylist
					(if (= (nth 0 l) ans)
						(progn (setq lay l)
						(setq fl 2))
					)
				)
				(if (null lay) (setq ans ""))
			)
		)
	)
	(if (= fl 2)
		(progn	(setq id 1)
		(command "redraw")
		(princ (strcat (nth 0 lay) "\n"))
		(if (not (null (ssget "X" (list (cons 410 "Model") (cons 8 (nth 0 lay))))))
			(cond
					((= (nth 3 lay) id_layer) 			(id_layer (nth 0 lay) (nth 1 lay) (nth 2 lay) (nth 4 lay)))
					((= (nth 3 lay) id_layer_child) 	(id_layer_child (nth 0 lay) (nth 4 lay) (nth 1 lay) (nth 2 lay) (nth 5 lay) (nth 6 lay)))
					((= (nth 3 lay) id_by_line) 		(id_by_line (nth 0 lay) (nth 1 lay) (nth 2 lay) (nth 4 lay)))
					((= (nth 3 lay) id_by_line_child_parking) 	(id_by_line_child_parking (nth 0 lay) (nth 4 lay) (nth 1 lay) (nth 2 lay) (nth 5 lay)))
					((= (nth 3 lay) id_by_hand)			(id_by_hand (nth 0 lay) (nth 1 lay) (nth 2 lay) (nth 4 lay)))
					((= (nth 3 lay) id_soccer_posts)	(id_soccer_posts (nth 0 lay) (nth 4 lay) (nth 1 lay) (nth 2 lay) (nth 5 lay)))
					((= (nth 3 lay) label_entrance)		(if (= "Yes" (progn (initget "Yes No") (getkword "Label ETFS entrances?"))) (label_entrance (nth 0 lay)(nth 1 lay))))
					((not (null (nth 3 lay))) 			((nth 3 lay) (nth 0 lay) (nth 1 lay)))
					(T nil)
			)
		))
	)
	(command "redraw")
	(setvar 'osmode snapmode)
)

;Description:
;Save layer name when DCL is closed
(defun saveLayer()
	(setq savedlayer(get_tile "layer_select"))
	(if(= savedlayer "") (alert "No layer selected"))
	(setq savedlayer (nth (atoi savedlayer) full_laylist))
)

;Description: 
;Redirects to gensortclockwise (for compatibility). Sort a list of areas.
;Arguments:
;arealist: List of entities to be sorted
;outlinelist: List of points
;Returns: sorted list
(defun sortclockwise (arealist outlinelist / centroidlist pt)
	(setq centroidlist (list nil))
	;Create a centroidlist
	(foreach room arealist
		(setq pt (get_obj_point room))
		(setq pt (cons (car pt) (cadr pt)))
		(setq centroidlist (cons pt centroidlist));List of centroids
	)
	(gensortclockwise arealist (setq centroidlist (cdr (reverse centroidlist))) outlinelist)
)

;Description:
;Redirects to gensortclockwise (for compatibility). Sort a list of points.
;Arguments:
;pointlist: List of points to be sorted
;outlinelist: List of points
;Returns: sorted list
(defun sortclockwisePt (pointlist outlinelist / centroidlist pt)
	(setq centroidlist (list nil))
	;Create a centroidlist
	(foreach point pointlist
		(setq pt (cdr (assoc 10 (entget point))))
		(setq pt (cons (car pt) (cadr pt)))
		(setq centroidlist (cons pt centroidlist));List of centroids
	)
	(gensortclockwise pointlist (setq centroidlist (cdr (reverse centroidlist))) outlinelist)
)

;Documentation
;Sort list of entitys into clockwise order.
;Arguments:
;arealist: List of entity names to be sorted
;pointlist: List of centroids (dotted pairs: (x . y))
;outlinelist: List of points
;Returns: sorted list
(defun gensortclockwise (arealist pointlist outlinelist / sumx sumy outlinepoints edgelist returnlist k centroid returnlist)
	(setq sumx 0)
	(setq sumy 0)
	
	(foreach outline outlinelist
		(setq outlinepoints (LM:ent->pts outline 50))
		(if (isCounterClockwise outlinepoints)
			(setq outlinepoints (reverse outlinepoints))
		)
		(setq edgelist (append edgelist (list -1) outlinepoints));List of edges
	)

	(setq returnlist nil);Final list, each element in the form (object, centroid, index of closest edge)
	(setq k 0)
	(repeat (length pointlist)
		(setq centroid (nth k pointlist))
		(if (not (null centroid))
			(setq returnlist (cons (list (nth k arealist) centroid (find_closest centroid edgelist)) returnlist))
			
		)
		(setq k (+ 1 k))
	)
	;Sort with vl-sort
	(setq returnlist (vl-sort returnlist 'testorder))
	;Return list
	returnlist
)

;Description:
;Test if list of points is mostly counterclockwise.
;Arguments:
;alist: List of points
;Returns: T or nil
(defun isCounterClockwise (alist / total i x1 x2 y1 y2)
	(setq total 0)
	(setq i 0)
	(repeat (- (length alist) 1)
		(setq x1 (car (nth i alist)))
		(setq x2 (car (nth (+ i 1) alist)))
		(setq y1 (cadr (nth i alist)))
		(setq y2 (cadr (nth i alist)))
		(setq total (+ (* (- x2 x1) (+ y2 y1) (dist (list x1 y1) (list x2 y2)))))
		(setq i (+ 1 i))
	)
	(< 0 total)
)

;Description:
;Get building outline
;Returns: Selection set of building outlines
(defun gbo ( / sel)
	(setq sel (ssget "X" (buildSelfilter (list "LWPOLYLINE") (list "tdsb-smsc-building outline") nil)))
)

;Description:
;Find closest edge (described by two points) to a point
;Arguments:
;apoint: the point
;apointlist: list of points that describes edges
;Returns: integer, index of closest edge from apointlist
(defun find_closest (apoint apointlist / px py minindex mindist x1 y1 x2 y2 i end)
	(setq px (car apoint))
	(setq py (cdr apoint))
	(setq minindex 0)
	(setq mindist 10000)

	(setq end (- (length apointlist) 1));The end of the first polygon
	(repeat (setq i (- (length apointlist) 1))
		(if (> i 1)
			(progn (setq x1 (nth 0 (nth i apointlist)))
			(setq y1 (nth 1 (nth i apointlist)))
			(setq placeholder i)
			(if (/= (nth (- i 1) apointlist) -1);If the next index is not a -1
				(progn ;The next index is the other side of the line segment
					(setq x2 (nth 0 (nth (- i 1) apointlist)))
					(setq y2 (nth 1 (nth (- i 1) apointlist)))
					(setq i (- i 1))
				)

				(progn ;Find the last -1 (or the end of the list)
					(setq x2 (nth 0 (nth end apointlist)))
					(setq y2 (nth 1 (nth end apointlist)))
					(setq end (- i 2))
					(setq i (- i 2))
				)
			)

			;(grdraw (list x1 y1 0) (list x2 y2 0) i)
		
			(cond
				((/= (+(* (- y2 y1)(- y2 y1))(*(- x2 x1)(- x2 x1))) 0)
					(cond
						((and (< (disttoline px py x1 y1 x2 y2) mindist) (and (< (LM:getinsideangle (list x1 y1) (list x2 y2) (list px py)) (/ pi 2)) (< (LM:getinsideangle (list x2 y2) (list x1 y1) (list px py))(/ pi 2))))
						(setq minindex placeholder)
						(setq mindist (disttoline px py x1 y1 x2 y2)))

						((or (< (dist (list px py) (list x1 y1)) mindist) (< (dist (list px py) (list x2 y2)) mindist))
						(setq minindex placeholder)
						(setq mindist (min (dist (list px py) (list x1 y1)) (dist (list px py) (list x2 y2)))))
					)
				)
			))
		)
	)
	minindex
)

;Description:
;Distance from point to line
;Arguments:
;x0: point x
;y0: point y
;x1: beginning x-coord
;x2: end x-coord
;y1: beginning y-coord
;y2: end y-coord
;Returns: real, distance
(defun disttoline (x0 y0 x1 y1 x2 y2)
	(/ (abs (- (+ (- (* x0 (- y2 y1)) (* y0 (- x2 x1))) (* x2 y1)) (* y2 x1)))(sqrt (+(* (- y2 y1)(- y2 y1))(*(- x2 x1)(- x2 x1)))))
)

;Descriptioin:
;Test if the entities are one after an other.
;Arguments:
;Ret1: list, containing (object, centroid, index of closest edge)
;Ret2: other list, same format as ret1
;Returns: T or nil
(defun testorder (ret1 ret2 / x11 y11 x21 y21 )
	(cond
		((or (= (nth 1 ret1)) (= (nth 1 ret2))) T)
		((= (caddr ret1) (caddr ret2));On the same edge
			(setq x11 (car (nth (caddr ret1) edgelist)))
			(setq y11 (cadr (nth (caddr ret1) edgelist)))

			(setq x21 (car (nth (caddr ret2) edgelist)))
			(setq y21 (cadr (nth (caddr ret2) edgelist)))

			(if (< (dist (list (caadr ret1) (cdadr ret1)) (list x11 y11)) (dist (list (caadr ret2) (cdadr ret2)) (list x21 y21)))
				T
				nil
			)
		)
		((> (caddr ret1) (caddr ret2)) T)
		((< (caddr ret1) (caddr ret2)) nil)
	)

)

;Description:
;Distance between two points. Only tests x and y, not z, but will work with a 3d point.
;Arguments:
;p1: point 1.
;p2: point 2.
;Returns: real, distance between points
(defun dist (p1 p2 / dx dy)
	(setq dx (- (nth 0 p2)(nth 0 p1)))
	(setq dy (- (nth 1 p2)(nth 1 p1)))
	(sqrt (+ (* dx dx) (* dy dy)))
)

;Description:
;Highlight an object by drawing a rounding box, and zooming to the object
;Arguments:
;obj: the object
(defun highlight (obj / minpt maxpt border p1 p2 p3 p4)
	(vla-getBoundingBox (vlax-ename->vla-object obj) 'minpt 'maxpt)
	(setq minpt (vlax-safearray->list minpt))
	(setq maxpt (vlax-safearray->list maxpt))

	; (setq m (/ (- (cadr maxpt) (cadr minpt)) (- (car maxpt) (car minpt))))
	; (setq L (dist minpt maxpt))
	; (setq scale 0.05)
	(setq border 10)
	(vla-ZoomWindow (vlax-get-acad-object) (vlax-3d-point (list (- (car minpt)  border)(- (cadr minpt) border) 0)) (vlax-3d-point (list (+ (car maxpt) border) (+ (cadr maxpt) border) 0)))
	(setq p1 (list (car minpt) (cadr minpt)))
	(setq p2 (list (car minpt) (cadr maxpt)))
	(setq p3 (list (car maxpt) (cadr maxpt)))
	(setq p4 (list (car maxpt) (cadr minpt)))
	(grvecs (list 
			256 p1 p2 
			256 p2 p3 
			256 p3 p4 
			256 p4 p1
	))
)

;Description:
;Builds a filter for ssget. Filter will select any objects that share any of the traits given.
;Arguments:
;types: list of object types (e.g. LWPOLYLINE, POINT, or INSERT)
;layers: list of layers
;blocknames: list of blocks
;Returns: list of strings
(defun buildSelfilter (types layers blocknames / filter)
	(setq filter (list (cons 410 "Model")))
	;Build object filter
	(cond
		((= (length types) 0)(print))
		((= (length types) 1) (if (not (null (car types))) (setq filter (append filter (list (cons 0 (car types)))))))
		(T
			(setq filter (append filter (list (cons -4 "<or"))))
			(foreach typ types
				(if (not (null typ)) (setq filter (append filter (list (cons 0 typ)))))
			)
			(setq filter (append filter (list (cons -4 "or>"))))
		)
	)

	;Build Layer filter
	(cond
		((= (length layers) 0)(print))
		((= (length layers) 1) (if (not (null (car layers))) (setq filter (append filter (list (cons 8 (car layers)))))))
		(T
			(setq filter (append filter (list (cons -4 "<or"))))
			(foreach lay layers
				(if (not (null lay)) (setq filter (append filter (list (cons 8 lay)))))
			)
			(setq filter(append filter (list (cons -4 "or>"))))
		)
	)

	;Build Block name filter
	(cond
		((= (length blocknames) 0)(print))
		((= (length blocknames) 1) (if (not (null (car blocknames))) (setq filter (append filter (list (cons 2 (car blocknames)))))))
		(T
			(setq filter (append filter (list (cons -4 "<or"))))
			(foreach block blocknames
				(if (not (null block)) (setq filter (append filter (list (cons 2 block)))))
			)
			(setq filter (append filter (list (cons -4 "or>"))))
		)
	)
	filter
)

;Description:
;Change parking points DSPL. Based on distance to closest icon. Changes the layer to "tdsb-smsc-parking points u".
;Arguments:
;pointlist: list of parking points in the drawing
;Returns: count of points changed
(defun chgdspl (pointlist / iconlist ct iconcenter curpt mindist)
	(if (not (null(setq iconlist (ssget "X" (buildSelfilter (list "LWPOLYLINE") (list "tdsb-smsc-parking icon") nil)))))
		(progn	(setq ct 0)
		(repeat (sslength iconlist)
			(if (not (< 5.0 (vlax-curve-getarea (ssname iconlist ct))))
				(progn (setq iconlist (ssdel (ssname iconlist ct) iconlist)) (setq ct (- ct 1)))
			)
			(setq ct (+ ct 1))
		)
		(setq ct 0)
		(repeat (sslength iconlist)
			(setq iconcenter (getcenter (ssadd (ssname iconlist ct))))
			(setq iconcenter (list (car iconcenter) (cdr iconcenter) 0))
			(setq curpt (entget (nth 0 pointlist)))
			(setq mindist (dist (cdr (assoc 10 (entget (nth 0 pointlist)))) iconcenter))
			(foreach point pointlist
				;(highlight point)
				(if (< (abs (dist (cdr (assoc 10 (entget point))) iconcenter)) mindist)
					(progn (setq mindist (dist (cdr (assoc 10 (entget point))) iconcenter))
					(setq curpt (entget point)))
				)
			)
			;(setcolor curpt '(0 0 255))
			(make_layer "tdsb-smsc-parking points u" "blue" "Continuous")
			(change_layer (cdr (assoc -1 curpt)) "tdsb-smsc-parking points u")
			(setq ct (+ ct 1))
		)
	))
	(if (not (null (ssget "X" (buildSelfilter (list "INSERT") nil (list "smsc-access parking icon")))))
		(princ "\nSOME PARKING ICONS MAY NOT BE EXPLODED! They will not be detected.")
	)
	ct
)

;Description: change the layer of an object. Will fail if layer doesn't exist
;Arguments:
;obj: object to move
;newlayer: layer to place object on
(defun change_layer (obj newlayer)
	(if (tblsearch  "layer" newlayer) 
		(command "change" (ssadd obj) "" "p" "LA" newlayer "")
		(*error* "Layer not found.")
	)
)

;Description: Create a new layer, if it doesn't exist.
;Arguments:
;layername: Name of the layer
;colour: Colour of the new layer
;linetype: Linetype of the new layer. "Continuous" is a good default.
(defun make_layer (layername colour linetype)
	(if (null (tblsearch  "layer" layername)) (command "._Layer" "_Make" layername "_Color" colour layername "_LT" linetype layername ""))
)