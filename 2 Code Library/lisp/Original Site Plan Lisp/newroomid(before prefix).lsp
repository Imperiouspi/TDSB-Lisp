;Archival/Backup. Ignore.

(vl-load-com)
(load "util")
(load "exportrooms")
(load "search")

(defun C:EXPORTNEWIDS( / newid)
	(setq snapmode (getvar 'osmode))
	(setvar 'osmode 0)
	(setq edgelist nil)
	(if (not (null (beginexport)))
		(progn
			(setq minpt (getpoint "Get first boundary point"))
			(print)
			(setq maxpt (getpoint "Get second boundary point"))
			(print)
			(setq boundaryp1 (list (car minpt) (cadr minpt)))
			(setq boundaryp2 (list (car maxpt) (cadr maxpt)))

			(setq roomlist (LM:ss->ent (ssget "_W" boundaryp1 boundaryp2 (list (cons 8 "tdsb-smsc-net area") (cons 0 "LWPOLYLINE")))))
			(pc (ssget "_W" boundaryp1 boundaryp2 (list (cons 8 "tdsb-smsc-net area") (cons 0 "LWPOLYLINE"))))
			;Sort Clockwise
			;Create an edgelist
			(setq outlinegon (LM:ss->ent (ssget "_W" boundaryp1 boundaryp2 (list (cons 8 "tdsb-smsc-gross area") (cons 0 "LWPolyline")))));List of outline polygons
			(if (not (null outlinegon))
				(progn
					;(setq text "New ID, Room ID,Door Number,Door Name,Room Usage")
					;(write-line text f)
					(setq roomlist (sortclockwise roomlist outlinegon));Now contains (ename, centroid, closest edge) for each room

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
					(while (and (/= floor "3") (/= floor "2") (/= floor "1") (/= floor "b") (/= floor "B")) (setq floor (getstring "Which floor is this? (1/2/3/B)")))
					(if (= floor "b") (setq floor "B"))
					(print)
					
					(setq nameblockSS (getblockSS))
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
						(if (not (null (nth 5 proplist)))
							(highlight (nth 5 proplist))
						)
						(highlight (car roomprop))
						(setq input "Rehighlight")
						(while (= input "Rehighlight")
							(initget 0 "Label Back Rehighlight")
							(setq input (getkword "Change [L]abel selection, [B]ack, [R]ehighlight or continue"))
							(print)
							(highlight (car roomprop))
							(if (not (null (nth 5 proplist)))
								(highlight (nth 5 proplist))
							)
						)
						(cond 
							;Get correct label
							((= input "Label")
								(setq proplist (replace proplist 5 (car (entsel "Select Label, or continue if none exists"))))
								(if (not (null (nth 5 proplist)))
									(progn
										(highlight (nth 5 proplist))
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

(defun sortclockwise(arealist outlinelist / pt)
	(setq centroidlist (list nil))
	(setq sumx 0)
	(setq sumy 0)
	
	(foreach outline outlinelist
		(setq outlinepoints (LM:ent->pts outline 50))
		(if (isCounterClockwise outlinepoints)
			(setq outlinepoints (reverse outlinepoints))
		)
		(setq edgelist (append edgelist (list -1) outlinepoints));List of edges
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
			(setq returnlist (cons (list (nth k arealist) centroid (find_closest centroid edgelist)) returnlist))
			
		)
		(setq k (+ 1 k))
	)
	;Sort with vl-sort
	(setq returnlist (vl-sort returnlist 'testorder))
	(while (null (setq first (car (entsel "Select polygon adjacent to enterance 1\n")))))
	(setq index (vl-position (list first (getcenter (ssadd first)) (find_closest (getcenter (ssadd first)) edgelist)) returnlist))
	(setq end (LM:sublst returnlist index nil))
	(setq returnlist (append end (LM:sublst returnlist 0 index)))
	;Return list
	returnlist
)

(defun isCounterClockwise (alist / point total i)
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

(defun find_closest (apoint apointlist / px py );minindex mindist x1 y1 x2 y2 i)
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

(defun disttoline (x0 y0 x1 y1 x2 y2)
	(/ (abs (- (+ (- (* x0 (- y2 y1)) (* y0 (- x2 x1))) (* x2 y1)) (* y2 x1)))(sqrt (+(* (- y2 y1)(- y2 y1))(*(- x2 x1)(- x2 x1)))))
)

(defun testorder (ret1 ret2 /)
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

(defun dist (p1 p2 / dx dy)
	(setq dx (- (nth 0 p2)(nth 0 p1)))
	(setq dy (- (nth 1 p2)(nth 1 p1)))
	(sqrt (+ (* dx dx) (* dy dy)))
)

(defun getblockSS(/ blockSS blockLargeSS blockMediumSS blockSmallSS c)
	(setq blockSS (ssadd))

	(setq blockSS (ssget "_W" boundaryp1 boundaryp2 (list (cons -4 "<or") (cons 8 "0") (cons 8 "tdsb-smsc-roomlabels") (cons -4 "or>") (cons -4 "<or") (cons 2 "smsc-room label-large")(cons 2 "smsc-room label-medium")(cons 2 "smsc-room label-small")(cons -4 "or>"))))

	blockSS
)

(defun buildSelfilter (types layers blocknames / )
	;Build object filter
	(cons
		((= (length types) 0))
		((= (length types) 1) (setq filter (append filter (cons 8 (car types)))))
		(T
			(setq filter (cons -4 "<or"))
			(foreach typ types
				(setq filter (append filter (cons 8 typ)))
			)
			(append filter (cons -4 "or>"))
		)
	)

	;Build Layer filter
	(cons
		((= (length layers) 0))
		((= (length layers) 1) (setq filter (append filter (cons 8 (car layers)))))
		(T
			(setq filter (cons -4 "<or"))
			(foreach layer layers
				(setq filter (append filter (cons 8 layer)))
			)
			(append filter (cons -4 "or>"))
		)
	)

	;Build Block name filter
	(cons
		((= (length blocknames) 0))
		((= (length blocknames) 1) (setq filter (append filter (cons 2 (car blocknames)))))
		(T
			(setq filter (cons -4 "<or"))
			(foreach block blocknames
				(setq filter (append filter (cons 2 block)))
			)
			(append filter (cons -4 "or>"))
		)
	)
	filter

)

(defun highlight (label / )
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
)

(defun *error* (msg)
	(cond
		((= msg "Function cancelled") (close f))
		(T 
			(princ "whoops: ") (princ msg) (close f))
	)
)