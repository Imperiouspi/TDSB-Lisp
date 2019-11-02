;Works, however the labels are sometimes on the wrong elevation, which causes problems.

;Description:
;Command to run <a href="#label_entrance">label_entrance</a>
(defun C:ENTRANCE_IDS ()
	(label_entrance "tdsb-smsc-police safety plan" "ETFS")
)

;Description: Label all the entrances for the police safety plans, connecting the traingles to the labels with site_id, and transferring everything to model space.
;Arguments:
;layer: Where to find the police safety labels and triangles.
;label: 4-letter code for site_id field
(defun label_entrance (layer label / labels triangles lab results)
	(if (member "8x11" (layoutlist)) (setvar "ctab" "8x11") (setvar "ctab" "8.5x11"))
	(setlayer layer)
	(c:newfields)

	(command "zoom" "e")
	;Get all labels
	(setq labels (ssget "W" '(0 0) '(11 8.5) (list (cons 410 (getvar "ctab")) (cons -4 "<OR") (cons 2 "smsc-exterior door label_1") (cons 2 "smsc-exterior door label_2") (cons -4 "OR>"))))
	;Get all triangles
	(setq triangles (ssget "W" '(0 0) '(11 8.5) (list (cons 410 (getvar "ctab")) (cons -4 "<OR") (cons 2 "smsc-exterior door-small") (cons 2 "smsc-access main entrance") (cons -4 "OR>"))))

	;Flag for review if there are more triangles than labels. Also flag no labels or triangles. Write to a file.
	(if (and labels triangles)
		(progn (if (< (sslength labels) (sslength triangles))
			(flag "more")
		)
		
		;For each label
		(foreach lab (LM:ss->ent labels)
			;Find closest triangle
			(setq results (find_entrance_tri lab triangles))
			(setq pl (nth 1 results))
			(setq closest (nth 0 results))
			(ssdel closest triangles)
			;Add OD to closest triangle
			(sssetfirst nil (ssadd closest))
			(c:burst)
		  	(setq closest (nth 0 (setq prev (LM:ss->ent (ssget "_P")))))
			(addSiteID closest)
			(setSiteID closest (strcat (ade_odgetfield lab "2" "site_id" 0) "_" label"_" (get_number lab)))
			(if (not (null pl))
				(if (not (= (cdr (assoc 8 (entget pl))) "tdsb-smsc-police safety plan pl")) (command "change" (ssadd pl) "" "p" "LA" "tdsb-smsc-police safety plan pl" ""))
			)
			;Send triangle and label to model space
			(vla-copy (vlax-ename->vla-object closest))
			(vla-copy (vlax-ename->vla-object lab))
			(command "chspace" (ssadd closest) "")
			(command "pspace")
			(command "chspace" (ssadd lab) "")
			(command "pspace")
		)
		(MSS)
		(command "._Layer" "_Make" "tdsb-smsc-police safety plan #" "_Color" 181 "tdsb-smsc-police safety plan #" "_LT" "CONTINUOUS" "tdsb-smsc-police safety plan #" "")
		;Add a placeholder polyline to avoid the chspace-burst bug.
		;If it's not there, chspace does something weird to entnext, which causes c:burst to loop infinitely on the LASTENT function (see burst.lsp in Express tools).
		;Adding a placeholder polyline makes the last entity something not weird, which allows burst to proceed unhindered.
		;Only other mention I could find: https://www.cadtutor.net/forum/topic/30321-burst-command-not-working/
		(setq placeholderpl (makepl (list '(0 0) '(10 10))))
;;;		(command "-purge" "a" "*" "n")
		(foreach ent (LM:ss->ent (ssget "X" (list (cons 0 "INSERT") (cons 410 "Model"))))
			(if (or (= (cdr (assoc 2 (entget ent))) "smsc-exterior door label_1") (= (cdr (assoc 2 (entget ent))) "smsc-exterior door label_2"))
				(progn
					(sssetfirst nil (ssadd ent))
					(c:burst)
					(setq prev (ssget "_P"))
					(foreach pe (LM:ss->ent prev)
						(if (= (cdr (assoc 0 (entget pe))) "LWPOLYLINE")
							(entdel pe)
						)
					)
				)
			)
		)
;;;		(if (ssget "X" (list (cons -4 "*,*,!=") (list 10 0.0 0.0 0.0)))
;;;			(command "resume")
;;;		)
		(setq ss (ssget "X"))
		(acet-autoload2 '("FLATTENSUP.LSP" (acet-flatn ss hide)))
		(setq ss (ssget "l"))
		(acet-flatn ss T)
		(foreach p (LM:ss->ent (ssget "X" (list (cons 410 "Model") (cons 0 "TEXT") (cons 8 "tdsb-smsc-police safety plan")))) (move_to_tri_center p))
		(command "change" (ssget "X" (list (cons 410 "Model") (cons 0 "TEXT") (cons 8 "tdsb-smsc-police safety plan"))) "" "p" "LA" "tdsb-smsc-police safety plan #" "")
		(entdel placeholderpl))
		(flag "null")
	)
	(MSS)
)

;Description: Given a label, identify which triangle is the closest.
;Arguments:
;label: which label, as an ename
;triangles: list of triangle enames.
(defun find_entrance_tri (label triangles / smalltri tri results pdist pl)
	(setq mindist 10000000)
	(setq smalltri nil)
	;Foreach triangle
	(foreach tri (LM:ss->ent triangles)
		;Find Distance
		(if (setq pl (find_pl tri))
			(setq pdist (min_dist_btwn_objects_pl tri label pl))
			(setq pdist (min_dist_btwn_objects tri label))
		)
		;Set Minimum Distance
		(if (< pdist mindist)
			(progn (setq mindist pdist)
			(setq smalltri tri)
			(setq found_pl pl))
		)
	)
	(list smalltri found_pl)
)

;Description: For the given triangle, find any leader line close by (within 0.005).
;Arguments:
;tri: triangle to search around.
;Returns: the ename of the leader line (if found), or nil
(defun find_pl (tri / bounds lines)
	(setq bounds (LM:ssboundingbox (ssadd tri)))
	(setq lines (ssget "C" (v+ (nth 0 bounds) '(0.005 0.005 0.0)) (v+ (nth 1 bounds) '(0.005 0.005 0.0)) (list (cons 410 (getvar "ctab")) (cons -4 "<OR") (cons 0 "LINE")(cons 0 "LWPOLYLINE") (cons -4 "OR>")(cons -4 "<OR") (cons 8 "tdsb-smsc-police safety plan pl") (cons 8 "tdsb-smsc-police safety plan") (cons -4 "OR>"))))
	(if (null lines) nil (nth 0 (LM:ss->ent lines)))
)

;Description:
;Find the minimum distance between two objects, with a polyline leader pointing between them.
;Arguments:
;tri: The object (as used, a triangle to label the entrance)
;label: The other object (as used, an entrance label)
;pl: the polyline leader between the two objects
;Returns: 1000000 if the leader does not point to the label, or 0 if it does.
(defun min_dist_btwn_objects_pl (tri label pl / end start labs)
	(setq end (vlax-curve-getendpoint (vlax-ename->vla-object pl)))
	(setq start (vlax-curve-getstartpoint (vlax-ename->vla-object pl)))
	(setq labstart (ssget "C" (v- start '(0.05 0.05 0.0)) (v+ start '(0.05 0.05 0.0)) (list (cons 410 (getvar "ctab")) (cons 0 "INSERT") (cons -4 "<OR") (cons 2 "smsc-exterior door label_1") (cons 2 "smsc-exterior door label_2") (cons -4 "OR>") (cons -4 "<OR") (cons 8 "tdsb-smsc-police safety plan pl") (cons 8 "tdsb-smsc-police safety plan") (cons -4 "OR>"))))
	(setq labend (ssget "C" (v- end '(0.05 0.05 0.0)) (v+ end '(0.05 0.05 0.0)) (list (cons 410 (getvar "ctab")) (cons 0 "INSERT") (cons -4 "<OR") (cons 2 "smsc-exterior door label_1") (cons 2 "smsc-exterior door label_2") (cons -4 "OR>") (cons -4 "<OR") (cons 8 "tdsb-smsc-police safety plan pl") (cons 8 "tdsb-smsc-police safety plan") (cons -4 "OR>"))))
	(if (and (not (null labstart)) (not (null labend)))
		(if (ssmemb label (mergess labstart labend)) 0 1000000)
		(if (and (null labstart) (not (null labend)))
			(if (ssmemb label labend) 0 1000000)
			(if (and (not (null labstart)) (null labend))
				(if (ssmemb label labstart) 0 1000000)
				1000000
			)
		)
	)
)

;Description:
;Find the minimum distance between two objects
;Arguments:
;tri: The object (as used, a triangle to label the entrance)
;label: The other object (as used, an entrance label)
;Returns: The minimum distance between the traingle and label, as a float.
(defun min_dist_btwn_objects (tri lab / tri_bounds lab_bounds i pt1 pt2 j pl1 pl2 pdist minlinedist)
	(setq tri_bounds (convexhull (ssadd tri)))
	(setq lab_bounds (convexhull (ssadd lab)))
	(setq minlinedist 1000000)
	(setq i 0)
	(while (< i (length tri_bounds))
		(setq pt1 (nth i tri_bounds))
		(if (< i (1- (length tri_bounds)))
				(setq pt2 (nth (1+ i) tri_bounds))
				(setq pt2 (nth 0 tri_bounds))
		)
		(setq j 0)
		(while (< j (length lab_bounds))
			(setq pl1 (nth j lab_bounds))
			(if (< j (1- (length lab_bounds)))
					(setq pl2 (nth (1+ j) lab_bounds))
					(setq pl2 (nth 0 lab_bounds))
			)
			(setq pdist (dist_line_to_line (list pt1 pt2) (list pl1 pl2)))
;;;			(redraw)
;;;			(grvecs (list 
;;;				256 pt1 pt2 
;;;				256 pl2 pl2 
;;;				256 pt1 pl1 
;;;				256 pt2 pl2
;;;			))
			(if (< pdist minlinedist)
				(setq minlinedist pdist)
			)
			(setq j (1+ j))
		)
		(setq i (1+ i))
	)
	minlinedist
)

;Description:
;Find the minimum distance between two line segments, described by two points
;Arguments:
;l1: segment 1
;l2: segment 2
;Returns: distance between the lines
(defun dist_line_to_line (l1 l2 / p1 p2 p3 p4)
	(setq     p1 (nth 0 l1)
		  p2 (nth 1 l1)
		  p3 (nth 0 l2)
		  p4 (nth 1 l2)
	)
	(min (disttosegment p1 p3 p4) (disttosegment p2 p3 p4) (disttosegment p3 p1 p2) (disttosegment p4 p1 p2))
)

;Description:
;Distance from a point to a segment ab
;Arguments:
;a: first point of the segment
;b: second point of the segment
;p: point
;Returns: distance, as a float
(defun disttosegment (p a b / n pa c d)
	(setq res nil)
	(setq n (v- b a))
	(setq pa (v- a p))
	(setq c (dot n pa))
	(if (> c 0) (setq res (dot pa pa))
		(progn
			(setq bp (v- p b))
			(if (> (dot n bp) 0) (setq res (dot bp bp))
				(progn
					(setq e (v- pa (v* n (/ c (dot n n)))))
					(setq res (sqrt (dot e e)))
				)
			)
		)
	)
	res
)

;Description:
;Perform vector subtraction
;Arguments:
;v1: vector 1
;v2: vector 2
;Returns: v1 - v2
(defun v- (v1 v2 / vres i)
	(setq vres (list))
	(setq i 0)
	(if (= (length v1) (length v2))
		(while (< i (length v1))
			(setq vres (append vres (list (- (nth i v1) (nth i v2)))))
			(setq i (1+ i))
		)
	)
	vres
)

;Description:
;Perform vector addition
;Arguments:
;v1: vector 1
;v2: vector 2
;Returns: v1 + v2
(defun v+ (v1 v2 / vres i)
	(setq vres (list))
	(setq i 0)
	(if (= (length v1) (length v2))
		(while (< i (length v1))
			(setq vres (append vres (list (+ (nth i v1) (nth i v2)))))
			(setq i (1+ i))
		)
	)
	vres
)

;Description:
;Perform vector addition on a list of vectors
;Arguments:
;vlist: a list of vectors
;Returns: v1 + v2 + v3...
(defun v++ (vlist)
	(setq v1 (list 0 0 0))
	(foreach v2 vlist
		(setq v1 (v+ v1 v2))
	)
	v1
)

;Description:
;Multiplies a vector by a scalar
;Arguments:
;v: vector
;a: scalar
;Returns: v * a
(defun v* (v a)
	(setq vres (list))
	(foreach i v
		(setq vres (append vres (list (* i a))))
	)
)

;Description:
;Perform dot multiplication
;Arguments:
;l1: vector 1
;l2: vector 2
;Returns: l1 · l2
(defun dot (l1 l2 / i sum)
	(if (= (length l1) (length l2))
		(progn
			(setq sum 0)
			(setq i 0)
			(while (< i (length l1))
				(setq sum (+ sum (* (nth i l1) (nth i l2))))
				(setq i (1+ i))
			)
		)
	)
	sum
)

;Description:
;Find the length of a vector (vl stands for Vector Length). All it does is v · v.
;Arguments:
;v: the vector
;Returns: v · v, the length of vector v
(defun vl (v)
	(dot v v)
)

;Description:
;Retrieve the number from the attributes of the exterior door label, formatting it to be ready for the monument id.
;Arguments:
;label: from where the number is retrieved.
;Returns: the id, formatted as XX.
(defun get_number (label / id)
	(setq id (strcat (LM:getattributevalue label "EXTERIOR_DOOR_ID#") (LM:getattributevalue label "EXTERIOR_DOOR#")))
	(cond
		((= (strlen id) 1) (setq id (strcat "0" id)))
		((= (strlen id) 2) 
			(if (wcmatch id "*@*")
				(setq id (strcat "0" id))
			)
		)
		((= (strlen id) 3)
			
		)
	)
	id
)

;Description:
;Highlight an object by drawing a rounding box
;obj: the object
(defun highlight_nozoom (obj / minpt maxpt p1 p2 p3 p4)
	(vla-getBoundingBox (vlax-ename->vla-object obj) 'minpt 'maxpt)
	(setq minpt (vlax-safearray->list minpt))
	(setq maxpt (vlax-safearray->list maxpt))

	; (setq m (/ (- (cadr maxpt) (cadr minpt)) (- (car maxpt) (car minpt))))
	; (setq L (dist minpt maxpt))
	; (setq scale 0.05)
	(setq border 10)
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
;Flag a drawing as bad for some reason. Written to flagged_site.csv.
;Arguments:
;arg: The reason the site is bad, a short phrase usually.
(defun flag (arg / f)
	(setq f (open "H:\\Map 3d\\3 exports\\flagged_site.csv" "a"))
	(write-line (strcat (getvar "dwgname") "," arg) f)
	(close f)
)

;Description:
;Reset a file back to the state when it was first opened, undoing everything possible.
(defun C:UNDOALL ()
	(command "undo" "end" "undo" "b" "y")
)

;Description:
;Move the text to the center of the traingle.
;Arguments:
;txt: the text object to be moved onto the entrance triangle
(defun move_to_tri_center (txt)
	(setq id (cdr (assoc 1 (entget txt))))
	(cond
		((= (strlen id) 1) (setq id (strcat "0" id)))
		((= (strlen id) 2) 
			(if (wcmatch id "*@*")
				(setq id (strcat "0" id))
			)
		)
		((= (strlen id) 3)

		)
	)
	(setq tris (ssget "X" (list (cons 410 "Model") (cons 0 "LWPOLYLINE") (cons -4 "<OR") (cons 8 "tdsb-smsc-accessibility black pg") (cons 8 "tdsb-smsc-accessibility") (cons 8 "tdsb-smsc-police safety plan") (cons -4 "OR>"))))
	(foreach tri (LM:ss->ent tris)
		(if (wcmatch (ade_odgetfield tri "2" "site_id" 0) (strcat "*_ETFS_" id)) (vla-move (vlax-ename->vla-object txt) (vlax-3d-point (cdr (assoc 10 (entget txt)))) (center_tri tri)))
	)
)

;Description:
;Find the center of the triangle. Takes an average of all points, so only accurate for regular polygons.
;Arguments:
;tri: the triangle.
;Returns: a 3d vla point.
(defun center_tri (tri / pts)
	(setq pts (avgcentroid tri))
	(vlax-3d-point (nth 0 pts) (nth 1 pts) 0)
)