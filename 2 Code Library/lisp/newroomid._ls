;Built alongisde exportrooms.lsp
;Functions proceeded with nri: are written as such to avoid conflicts with "monumentids" function definitions, as some were redifined there to be more general.
;nri stands for "new room id". 
;Swap "X" for "X" for drawings not individual

;Description:
;Export and find room ids and labels, assign new monument ids to the rooms.
;USE:
;1. Specify folder to export to
;2. Specify two points that define the boundary of the site.
;3. Select the polygon that is entrance 1 of the building.
;4. It will go through each room. It highlights each room with a red box, and also highlights the label it thinks belongs to that room.
;5. If the label is correct, press ENTER to move on. If it is incorrect, type L and then select the correct label.
;6. Enter "B" to go to previous room, press R to redraw highlight boxes (they will disappear on any screen redraw)
;7. After completing each room, it will automatically create "export2.csv" in the folder chosen, and will write the data to that.
(defun C:EXPORTNEWIDS( / checklist snapmode edgelist roomlist minpt maxpt boundaryp1 boundaryp2 roomlist id outlinegon i x y Model siteid clyr floor nameblockSS fullblocklist co j isfirst exportlist roomprop proplist mp input)
	(if (tblsearch "LAYER" "13")
		(command "._laymrg" "N" "13" "" "N" "0" "y" "")
	)
	;(removepface) CHANGE BACK TO OLD VERSION
	(setq checklist (nri:getblockSS))
	(setq snapmode (getvar 'osmode))
	(setvar "osmode" 4779)
	(setq edgelist nil)
	(setq roomlist nil)
	(if (not (null (beginexport T)))
		(progn
			; (setq minpt (getpoint "Get first boundary point"))
			; (print)
			; (setq maxpt (getpoint "Get second boundary point"))
			; (print)
			; (setq boundaryp1 (list (car minpt) (cadr minpt)))
			; (setq boundaryp2 (list (car maxpt) (cadr maxpt)))

			(setq roomlist (LM:ss->ent (ssget "X" (list (cons 8 "tdsb-smsc-net area") (cons 0 "LWPOLYLINE")))))
			(pc (ssget "X" (list (cons 8 "tdsb-smsc-net area") (cons 0 "LWPOLYLINE"))))
			(foreach room roomlist
				(if (setq id (ade_odgetfield room "room_id" "room_id" 0))
					(setoldRoomID room id)
				)
			)
		 	;Sort Clockwise
			;Create an edgelist
			(setq outlinegon (LM:ss->ent (ssget "X" (list (cons 8 "tdsb-smsc-gross area") (cons 0 "LWPolyline")))));List of outline polygons
			(if (not (null outlinegon))
				(progn
					;(setq text "New ID, Room ID,Door Number,Door Name,Room Usage")
					;(write-line text f)
					(setq roomlist (nri:sortclockwise roomlist outlinegon));Now contains (ename, centroid, closest edge) for each room

					;Draw lines to label polygons
					;; (setq i 1)
					;; (setq Model(vla-get-ModelSpace (vla-get-ActiveDocument (vlax-get-acad-object))))
					;; (repeat (length roomlist)
					;; 	(setq x (caadr (nth (- i 1) roomlist)))
					;; 	(setq y (cdadr (nth (- i 1) roomlist)))
					;; 	(setq clyr (getvar "clayer"))
					;; 	(setlayer "Text")
					;; 	(vla-addText Model i (vlax-3d-point x y 0) 40)
					;; 	(setlayer clyr)
					;; 	(setq i (+ i 1))
					;; )
					;Get data
					(setq siteid (getstring "Enter site id"))
					(print)
					(setq floor nil)
					(initget (+ 1 2 4))
					(while (and (/= floor "3") (/= floor "2") (/= floor "1") (/= floor "1M") (/= floor "2M") (/= floor "3M") (/= floor "4") (/= floor "5") (/= floor "6") (/= floor "b") (/= floor "B") (/= floor "BM") (/= floor "FB") (/= floor "GM") (/= floor "GM") (/= floor "g") (/= floor "G") (/= floor "M") (/= floor "P") (/= floor "PH")) (setq floor (getstring "Which floor is this? (1/1M/2/2M/3/3M/4/5/6/B/BM/Fb/G/GM/M/P/PH)")))
					(if (= floor "b") (setq floor "B"))
					(if (= floor "g") (setq floor "G"))
					(if (= floor "FB") (setq floor "Fb"))
					(print)
					
					(setq nameblockSS (nri:getblockSS))
					(setq fullblocklist nameblockSS)

					(setq co 0)
					(foreach room roomlist
						(addSiteID (car room))
						(if (null (ade_odgetfield room "1" "room_id" 0))
							(progn
								(addoldRoomID (car room))
							)
						)
						(setq co (+ co 1))
					)

					(setq j 0)
					(setq isfirst T)
					(setq exportlist '(0))
					(while (< j (length roomlist));Main loop
						(setq roomprop (nth j roomlist))
						(addSiteID (car roomprop))
						(setSiteID (car roomprop) siteid)
						(if isfirst
							(setq proplist (getlabel (car roomprop)))
						)
						(setq mp (nri:highlight (car roomprop)))
						(command "-pan" mp (getvar "viewctr"))
						(if (not (null (nth 5 proplist)))
							(nri:highlight (nth 5 proplist))
						)
						(setq mp (nri:highlight (car roomprop)))
						(setq input "Rehighlight")
						(while (= input "Rehighlight")
							(initget 0 "Label Back Rehighlight Center")
							(setq input (getkword "Change [L]abel selection, [B]ack, [R]ehighlight, re[C]enter or continue"))
							(print)
							(nri:highlight (car roomprop))
							(if (not (null (nth 5 proplist)))
								(nri:highlight (nth 5 proplist))
							)
						)
						(cond 
							;Center view
							((= input "Center")
								(command "-pan" mp (getvar "viewctr"))
							)
							;Get correct label
							((= input "Label")
								(setq proplist (replace proplist 5 (car (entsel "Select Label, or continue if none exists"))))
								(if (not (null (nth 5 proplist)))
									(progn
										(nri:highlight (nth 5 proplist))
										(setq proplist (replace proplist 2 (LM:getattributevalue (nth 5 proplist) "DOOR#")));Get attributes
										(setq proplist (replace proplist 3 (LM:getattributevalue (nth 5 proplist) "DOORNAME")))
										(setq proplist (replace proplist 4 (LM:getattributevalue (nth 5 proplist) "ROOMUSAGE")))
									)
									(progn
										(setq proplist (replace proplist 2 ""))
										(setq proplist (replace proplist 3 ""))
										(setq proplist (replace proplist 4 ""))
									)
								)
								(setq isfirst nil)
							)
							;Go back
							((= input "Back")
								(if (> j 0) (setq j (- j 1)))
								(setq nameblockSS fullblocklist)
								(setq isfirst T)
							)
							((null input)
								;Export and write new id
								(cond
									((< j 9)(setq roomnum (strcat "0" "0" (itoa (+ j 1)))))
									((< j 99)(setq roomnum (strcat "0"(itoa (+ j 1)))))
									((< j 999)(setq roomnum (itoa (+ j 1))))
								)
								(setq newid (strcat siteid "_" floor "_" roomnum))
								(addnewRoomID (car roomprop))
								(setnewRoomID (car roomprop) newid)
								(if (<= (length exportlist) j)
									(setq exportlist (append exportlist '(0)))
								)
								(setq exportlist (replace exportlist j (list newid (itoa (nth 1 proplist)) (nth 2 proplist) (nth 3 proplist) (nth 4 proplist))))
								(setq j (+ j 1))
								(setq isfirst T)
							)
						)
						(redraw)
					)
					(foreach item exportlist
						(write_export siteid (nth 0 item) (nth 1 item) (nth 2 item) (nth 3 item) (nth 4 item))
					)
					(close f)
					(setvar 'osmode snapmode)
					(print)
				);End standard operating Progn
				(prompt "No gross area polyline found, ending\n");No outline found
			);End if
		);end progn
	);end if
);end defun

;Description:
;Sort the list of entities in arealist clockwise, following outlinelist.
;Arguments:
;arealist: list of entity names to be sorted
;outlinelist: list of entity names. Each represents an outline the polygons should be sorted by.
;Returns: a sorted list of arealist, in the form (room, centroid, index of closest edge)
(defun nri:sortclockwise(arealist outlinelist / centroidlist sumx sumy outlinepoints edgelist pt centroidlist returnlist k centroid index end)
	(setq centroidlist (list nil))
	(setq sumx 0)
	(setq sumy 0)
	
	(foreach outline outlinelist
		(setq outlinepoints (LM:ent->pts outline 50))
		(if (nri:isCounterClockwise outlinepoints)
			(setq outlinepoints (reverse outlinepoints))
		)
		(setq edgelist (append edgelist (list -1) outlinepoints));List of edges. Append -1 between polygons to define ends.
	)

	;Create a centroidlist
	(foreach room arealist
		(setq pt (getcenter (ssadd room)))
		(setq centroidlist (cons pt centroidlist));List of centroids
	)
	(setq centroidlist (cdr (reverse centroidlist)))
	
	(setq returnlist nil);Final list, each element in the form (room, centroid, index of closest edge)
	(setq k 0)
	(repeat (length centroidlist)
		(setq centroid (nth k centroidlist))
		(if (not (null centroid))
			(setq returnlist (cons (list (nth k arealist) centroid (nri:find_closest centroid edgelist)) returnlist))
			
		)
		(setq k (+ 1 k))
	)
	;Sort with vl-sort
	(setq returnlist (vl-sort returnlist 'nri:testorder))
	(while (or (null (setq first (car (entsel "Select polygon adjacent to enterance 1\n"))))(not (= (cdr (assoc 8 (entget first))) "tdsb-smsc-net area"))))
	(setq index (vl-position (list first (getcenter (ssadd first)) (nri:find_closest (getcenter (ssadd first)) edgelist)) returnlist))
	(setq end (LM:sublst returnlist index nil))
	(setq returnlist (append end (LM:sublst returnlist 0 index)))
	;Return list
	returnlist
)

;Description:
;Calculate if a list of points (alist) is mostly counterclockwise.
;Arguments:
;alist: a list of points in the form ((x1 y1 z1) (x2 y2 z2) (x3 y3 z3)...)
;Returns: T if counterclockwise, nil otherwise.
(defun nri:isCounterClockwise (alist / point total i x1 x2 y1 y2)
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
;Find the closest line defined in apointlist to the point apoint.
;Arguments:
;apoint: dotted pair (x . y)
;apointlist: a list of points, each in the form (x y z). Each sequential pair of points defines an edge, but different polygons are defined by the value -1 in between their list of points.
;Returns: the index of the closest line in apointlist.
(defun nri:find_closest (apoint apointlist / px py minindex mindist end i x1 y1 placeholder x2 y2)
	(setq px (car apoint))
	(setq py (cdr apoint))
	(setq minindex 1)
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
;Minimum distance (length of perpendicular line) from point x0 y0 to line segment x1 y1 to x2 y2
;Arguments:
;x0: x of p1
;y0: y of p1
;x1: x-coord of the starting point
;y1: y-coord of the starting point
;x2: x-coord of the ending point
;y2: y-coord of the ending point
;Returns: Minimum distance from point to line.
(defun disttoline (x0 y0 x1 y1 x2 y2)
	(/ (abs (- (+ (- (* x0 (- y2 y1)) (* y0 (- x2 x1))) (* x2 y1)) (* y2 x1)))(sqrt (+(* (- y2 y1)(- y2 y1))(*(- x2 x1)(- x2 x1)))))
)

;Description:
;Test if the order of object ret1 is correct relative to ret2.
;Arguments:
;ret1: list in the form of (room, centroid, index of closest edge)
;ret2: list in the form of (room, centroid, index of closest edge)
;Returns: T if: the index of the edge ret1 is closest to is larger than that of ret2. OR if they are on the same edge, T if ret1 is closer to the beginning of the edge than ret2 is.
(defun nri:testorder (ret1 ret2 / x11 y11 x21 y21)
	(cond
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
;Distance between point 1 and point 2.
;Arguments:
;p1: list. (x y z)
;p2: list. (x y z)
;Returns: Distance.
(defun dist (p1 p2 / dx dy)
	(setq dx (- (nth 0 p2)(nth 0 p1)))
	(setq dy (- (nth 1 p2)(nth 1 p1)))
	(sqrt (+ (* dx dx) (* dy dy)))
)

;Description:
;Finds a selection set of all labels in the boundary. Requires that variables boundaryp1 and boundaryp2 are pre-defined. Written for convenience.
;Returns: Selection Set of all labels in bounds.
(defun nri:getblockSS(/ blockSS blockLargeSS blockMediumSS blockSmallSS c)
	(setq blockSS (ssadd))
	(setq blockSS (ssget "X" (buildSelFilter nil (list "tdsb-smsc-roomlabels" "tdsb-roomlabels""0") (list "smsc-room label-large" "smsc-room label-medium" "smsc-room label-small" "smsc-room label-imper"))))
	blockSS
)

;Description:
;Highlight an object by zooming to it, and surrounding it with a box.
;Arguments:
;label: the object to be highlghted.
(defun nri:highlight (label / minpt maxpt p1 p2 p3 p4 mp)
	(vla-getBoundingBox (vlax-ename->vla-object label) 'minpt 'maxpt)
	(setq minpt (vlax-safearray->list minpt))
	(setq maxpt (vlax-safearray->list maxpt))
	(setq p1 (list (car minpt) (cadr minpt)))
	(setq p2 (list (car minpt) (cadr maxpt)))
	(setq p3 (list (car maxpt) (cadr maxpt)))
	(setq p4 (list (car maxpt) (cadr minpt)))
	(grvecs (list 
			1 p1 p2 
			1 p2 p3 
			1 p3 p4 
			1 p4 p1
	))
	(setq mp (list (/(+ (car minpt) (car maxpt)) 2) (/(+ (cadr minpt) (cadr maxpt)) 2) 0))
)

;Description:
;Test for polyface meshes. On net area and gross area layers.
;Returns: number of meshes. Also presents an alert if some are present.
(defun testforpface ( / pfacess)
	(setq pfacess (ssget "X" (list (cons 0 "Polyline") (cons 100 "AcDbPolyFaceMesh"))))
	(if (null pfacess)
		(setq pfacess (ssadd))
	)
	;(if (> (sslength pfacess) 0)(alert "Polyface Meshes Present"))
	(> (sslength pfacess) 0)
)

;Description:
;Replaces polyface meshes with polylines. Will exit runtime, with an alert reminding the user to check the new polylines.
(defun removepface ( / pfaces pl)
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
			(alert "Closing, Check new polylines.")
			(vl-exit-with-error "")
		)
	)
)

;Description:
;Get coordinates of a polyface mesh. (or any object).
;Arguments: 
;ename: entity name of mesh.
;Returns: list of coordinates. (x0 y0 z0 x1 y1 z1...)
(defun getmeshcoords (ename / obj coords)
	(setq obj (vlax-ename->vla-object ename))
	(setq coords (vlax-safearray->list(vlax-variant-value (vla-get-coordinates obj))))
	coords
)

;Description:
;Sort Coordinates clockwise. This is good enough, and should eliminate most weird conversion errors.
;<a href="https://www.cadtutor.net/forum/topic/59260-sort-selected-entities-by-shortest-distance-between-start-coordinates-of-each-entity/">(SRC)</a>
;Arguments:
;coords: list of coordinates
;Returns: sorted list of coordinates
(defun sortcoords (coo / coordinates i c ret c2c1 j c1 minc ret)
	(setq coordinates coo)
	(setq i 0)
	(setq c (nth i coordinates))
	(setq ret (cons c nil))
	(while (> (length coordinates) 0)
		(setq c2c1 0)
		(setq j 0)
		(while (< j (length coordinates))
			(setq c1 (nth j coordinates))
			(if (and (< (dist c c1) c2c1) (/= (dist c c1) 0))
				(progn (setq c2c1 (dist c c1))
					(setq minc c1)
				)
			)
			(setq j (+ 1 j))
		)
		(setq ret (append ret (list minc)))
		(setq i (+ 1 i))
		(setq coordinates (cdr coordinates))
	)
	ret
)

;Description:
;Add polyline with the same coordinates as a poylface mesh. (side note: likely works with any object)
;Arguments:
;pface: entity name
;Returns: new polyline.
(defun plpface (pface / coords coordlist i pl)
	(setq coords (getmeshcoords pface))
	(setq coordlist (list))
	(setq i 0)
	(while (< i (length coords))
		(setq coordlist (append coordlist (list (list (nth i coords) (nth (+ i 1) coords) (nth (+ i 2) coords)))))
		(setq i (+ i 3))
	)
  	;(setq coordlist (sortcoords coordlist))
	(setq pl (makePL coordlist))
	pl
)

;Description:
;Create a polyline from a list of points.
;Arguments:
;coords: list of points
;Returns: new polyline
(defun makePL (coords)
	(entmakex
		(append
			(list
				(cons 0 "LWPOLYLINE")
				(cons 100 "AcDbEntity")
				(cons 100 "AcDbPolyline")
				(cons 90 (length coords))
				(cons 70 1)
			)
			(mapcar (function (lambda (p) (cons 10 p))) coords)
		)
	)
)