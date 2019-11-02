;This file contains functions written while assigning room ids.
;The use of these functions takes place in "newroomid.lsp"

;Description:
;Try to find label contained in the room.
;Arguments:
;areae: an entity name
;Returns: a list in the form (New ID (placeholder only), Old Room ID, Door Number, Door Name, Room Use, Label entity name). All properties except new id from the found label.
(defun getlabel (areae / in ptlist l newid blocklist origin x y countin roomid doornum doorname roomuse blocke checklist);roomidlist doornumlist doornamelist roomuselist areae in ptlist l blocke x y countin roomid doornum doorname roomuse );Commented out to help with debugging
	(setq in 0)
	(setq ptlist (LM:ent->pts areae 50))
	(setq l (length ptlist))
	(setq newid "Room_2")
	(setq blocklist nil)
  
	(foreach blocke (LM:ss->ent (nri:getblockss))
		(setq origin (getorigin blocke))
		(setq x (nth 0 origin))
		(setq y (nth 1 origin))

		(setq countin (testpt x y ptlist))
		;If count is odd, point is inside.
		;Track how many labels are inside this block
		(if (= (rem countin 2) 1)
			(progn
				(setq in (+ in 1))
				(setq blocklist (cons blocke blocklist))
			)
		)
	)
	(setq roomid 0)
	(setq doornum nil)
	(setq doorname nil)
	(setq roomuse nil)
	(cond
		( (= in 1)
			(setq blocke (nth 0 blocklist))
			(if (ssmemb blocke checklist) (setq checklist (ssdel blocke checklist)))
			(setq roomid (ade_odgetfield areae "1" "room_id" 0));Get OD for room id
		 	(if (null roomid)
				(setq roomid 0)
			)
			(setq doornum (LM:getattributevalue (nth 0 blocklist) "DOOR#"));Get attributes
			(setq doorname (LM:getattributevalue (nth 0 blocklist) "DOORNAME"))
			(setq roomuse (LM:getattributevalue (nth 0 blocklist) "ROOMUSAGE"))
		)
		(T
			(setq blocke nil)
			(setq roomid (ade_odgetfield areae "1" "room_id" 0));Get OD for room id
		 	(if (null roomid)
				(setq roomid 0)
			)
			(setq doornum "")
			(setq doorname "")
			(setq roomuse "")
		)
	)
	(princ in)
	(list newid roomid doornum doorname roomuse blocke)
)

;Description:
;Ray Test, to figure out whether a point x y is in the polygon.
;To obtain ptlist, use the function (LM:ent->pts) written by Lee Mac in utils.lsp
;Arguments:
;x: x coordinate of point to test
;y: y coordinate of point to test
;ptlist: list of points defining polygon. Either 2d or 3d.
;Returns: count of how many lines were intersected with the ray test. If it is odd, the point is inside. If it is even, the point is outside the polyline.
(defun testpt (x y ptlist / counter px1 px2 py1 py2 m b isIntersect i l)
	(setq counter 0)
	(setq l (length ptlist))
	(repeat (setq i (length ptlist))
		(setq px1 (nth 0 (nth (setq i (- i 1)) ptlist)))
		(setq py1 (nth 1 (nth i ptlist)))
		(if (/= i 0)
			(progn
				(setq px2 (nth 0 (nth (- i 1) ptlist)))
				(setq py2 (nth 1 (nth (- i 1) ptlist)))
			)
			(progn
			 	(setq px2 (nth 0 (nth (- l 1) ptlist)))
				(setq py2 (nth 1 (nth (- l 1) ptlist)))
			)
		)
		(if (/= px1 px2)
			(progn
				(setq m (/ (- py2 py1) (- px2 px1)))
				(setq b (- py1 (* m px1)))
				(setq isIntersect (intersect m b py1 py2 x y))
				(if isIntersect
					(setq counter (+ counter 1))
				)
			)
			(if (and (> px1 x) (or (and (> py1 y) (< py2 y)) (and (< py1 y) (> py2 y))))
				(setq counter (+ counter 1))
			)
		)
	)
	counter
)

;Description:
;Test intersection of a ray from point x,y along the x axis, to the line segment defined by slope m, intersect b, and between points py1 and py2.
;Arguments:
;m: slope of line
;b: y-intercept of line
;py1: end point of line
;py2: end point of line
;x: x-coord of point to test
;y: y-coord of point to test
;Returns: T if the ray intersects, nil if not.
(defun intersect (m b py1 py2 x y / )
	(if (/= m 0)
		;Test if:
		;	Intersection point of lines is to the right of the point AND
		;	Point is between extremes of polyline segment.
		(if (and (>= (/ (- y b) m) x) (or (and (> py1 y) (< py2 y)) (and (< py1 y) (> py2 y)))) T nil)
		nil
	)
)

;Description:
;Get the origin of a label, the left corner of the bottommost block.
;Hardcoded to work with four types of blocks.
;Arguments:
;ent: block ename
;Returns: origin in a list (x y)
(defun getorigin (ent / ox oy ang labeltype scale x y)
	(setq ox (nth 0 (cdr (assoc 10 (entget ent)))));Bottom of line 4
	(setq oy (nth 1 (cdr (assoc 10 (entget ent)))))
	(setq ang (getpropertyvalue ent "Rotation"))
	;Get height of text based on block type
	(setq labeltype (cdr (assoc 2 (entget ent))))
	(setq scale (cdr (assoc 41 (entget ent))))
	(cond 
		((= labeltype "smsc-room label-large") (setq height 0.0703))
		((= labeltype "smsc-room label-medium") (setq height 0.0469))
		((= labeltype "smsc-room label-small") (setq height 0.0313))
		((= labeltype "smsc-room label-imper") (setq height 0.0261))
	)
	;Scale height by which line is bottommost
	(setq lines 0)
	(cond
		((/= "" (LM:getattributevalue ent "ROOM_ID#")) (setq lines 0))
		((/= "" (LM:getattributevalue ent "ROOMUSAGE")) (setq lines 1))
		((/= "" (LM:getattributevalue ent "DOORNAME")) (setq lines 2))
		((/= "" (LM:getattributevalue ent "DOOR#")) (setq lines 3))
	)
	(setq x (+ ox (* (cos (+ (/ pi 2) ang)) (* height scale (* 1.5 lines)))))
	(setq y (+ oy (* (sin (+ (/ pi 2) ang)) (* height scale (* 1.5 lines)))))
	
	;Find polylines close by
	(if (> (length (setq leaderlist (LM:ss->ent (ssget "X" (buildSelFilter (list "LWPOLYLINE" "LINE") (list "tdsb-smsc-roomlabels" "tdsb-roomlabels" "0") nil))))) 0)
		;Get bounding box
		(progn
		(setq errorcode (vl-catch-all-apply 'vla-getBoundingBox (list (vlax-ename->vla-object ent) 'minpt 'maxpt)))
		(if (vl-catch-all-error-p errorcode)
			(progn (princ (vl-catch-all-error-message errorcode)))
			(progn
				(setq minpt (vlax-safearray->list minpt))
				(setq maxpt (vlax-safearray->list maxpt))
				(setq p1 (list (- (car minpt) (* 10 height)) (- (cadr minpt) (* 10 height))))
				(setq p2 (list (- (car minpt) (* 10 height)) (+ (cadr maxpt) (* 10 height))))
				(setq p3 (list (+ (car maxpt) (* 10 height)) (+ (cadr maxpt) (* 10 height))))
				(setq p4 (list (+ (car maxpt) (* 10 height)) (- (cadr minpt) (* 10 height))))
		
				(setq 1in 0)
				(setq leadinlist nil)
				(foreach lead leaderlist
					(setq 
						end1 (vlax-curve-getStartPoint lead)
						end2 (vlax-curve-getEndPoint lead)
					)
					(setq x1 (nth 0 end1))
					(setq y1 (nth 1 end1))
					(setq x2 (nth 0 end2))
					(setq y2 (nth 1 end2))
					;Test end1
					(setq countin (testpt x1 y1 (list p1 p2 p3 p4)))
					;If count is odd, point is inside.
					;Track how many labels are inside this block
					(setq 1in nil)
					(if (= (rem countin 2) 1)
						(progn
							(setq leadinlist (cons (cons lead end2) leadinlist))
							(setq 1in T)
						)
					)
					;Test end2
					(setq countin (testpt x2 y2 (list p1 p2 p3 p4)))
					;If count is odd, point is inside.
					;Track how many labels are inside this block
					(if (and (= (rem countin 2) 1) (not 1in))
						(progn
							(setq leadinlist (cons (cons lead end1) leadinlist))
						)
					)
				)
				(cond
					((= 1 (length leadinlist))
						(setq x (cadar leadinlist))
						(setq y (caddar leadinlist))
						(nri:highlight (caar leadinlist))
					)
					(T

					)
				)

			)
		)
		);end progn
	)
	;(point x y)
	(list x y)
)

;Description:
;Set up the export for the rooms. Opens a folder selection dialog, and opens a file "export2.csv" in append mode in that folder.
;Append mode will not overwrite existing contents.
;Arguments:
;default: boolean. Use the default directory if True (H:\\Map 3d\\3 exports).
;Returns: the folder path where it is saved. No folder was selected if nil returned.
(defun beginexport (default / savedpath text)
	(if (not default)
		(setq savedpath (LM:browseforfolder "Select a folder to export to" "" 0))
		(setq savedpath "H:\\Map 3d\\3 exports")
	)
	(if (not (null savedpath))
		(progn
			(setq f (open (strcat savedpath "\\export2.csv") "a"))
		)
	)
	savedpath
)

;Description:
;Write the values to the export file. File defined as variable "f" outside the function (bad form sorry).
;Arguments:
;siteid: the Facility number, or site id of the building
;newid: the new room id added to the room
;roomid: the old room id for the room
;doornum: Door Number, if it were retrieved from the label.
;doorname: Door Name if it was retrieved from the label.
;roomuse: "Used As", as specified in the label.
(defun write_export (siteid newid roomid doornum doorname roomuse / text)
	(if (null doornum) (setq doornum ""))
	(if (null doorname) (setq doorname ""))
	(if (null roomuse) (setq roomuse ""))
	(setq text (strcat "\"=\"\"" siteid "\"\"\"," newid "," roomid "," doornum "," doorname "," roomuse))
	(write-line text f)
)