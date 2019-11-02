;Description:
;Add layer to the document
;Arguments:
;name: Name of layer
;clr: Color of layer
;linetype: Type of line (Common linetypes: "ACAD_ISO03W100", "Continuous")
;Returns: nothing
(defun addlayer (name clr linetype / )
	(command "._Layer" "_Make" name "_Color" clr name "_LT" linetype name "")
)

;Description
;Set the current layer. Often used to reset the current layer after some operation that changes it.
;Arguments:
;lyr: layer to set to
;Returns: nothing
(defun setlayer (lyr)
	(cond ((tblsearch "LAYER" lyr)
		(command "._Layer" "_Thaw" lyr "_UnLock" lyr "_On" lyr "_Set" lyr ""))
		(T
			(command "._layer" "_M" lyr ""))
	)
)

;Description:
;Shortcut to quickly isolate the "misc" layer
(defun C:ISOM ()
	(new_isolate "tdsb-smsc-misc")
)

;Description:
;Isolate "layer"
;Arguments:
;layer: layer to isolate (string)
(defun new_isolate (layer / clyr)
	(LM:startundo (LM:acdoc))
	(setlayer layer)
	(cond
		((not *isIso*)
			(command "._-layer" "_off" "*" "" "")
			(setq clyr (getvar "clayer"))
			(setq *isIso* t)
		)
		(*isIso*
			(command "._-layer" "_on" "*" "" "")
			(setq *isIso* nil)
		)
	)
	(LM:endundo (LM:acdoc))
)

;Description:
;Return the type of an object. User will be prompted for the object
(defun C:TYPES () (MAPCAR '(LAMBDA (X) (CDR (ASSOC 0 (ENTGET X)))) (LM:SS->ENT (ssget))))

;OD Data Utility Functions follow
;Description:
;Add a table with a character field
;Arguments:
;e: Entity to add data to
;tblname: Name of table (e.g. "2" or "3")
;field: title of field in table. ("site_id" or "room_id" have been used)
(defun addODTable (e tblname field / tbl)
	(if (not (ade_odtabledefn tblname));if table doesn't exist
		(progn c
			(setq tbl (ade_oddefinetab ;define table
				(list 
					(cons "tablename" tblname)
					'("tabledesc" . "")
					(list "columns"
						( list 
							(cons "colname" field)
							'("coldesc" . "")
							'("coltype" . "character")
							'("defaultval" . "")
						)
					)
				)
			));end setq
		);end progn
	)
	(if (not (member tblname (ade_odgettables e)));if table not attached
		(ade_odaddrecord e tblname);add field site_id
	)
)

;Description:
;Add an table with an integer field
;Arguments:
;e: Entity to add data to
;tblname: Name of table (e.g. "2" or "3")
;field: title of field in table. ("site_id" or "room_id" have been used)
(defun addintODTable (e tblname field / tbl)
	(if (not (ade_odtabledefn tblname));if table doesn't exist
		(progn c
			(setq tbl (ade_oddefinetab ;define table
				(list 
					(cons "tablename" tblname)
					'("tabledesc" . "")
					(list "columns"
						( list 
							(cons "colname" field)
							'("coldesc" . "")
							'("coltype" . "integer")
							'("defaultval" . "")
						)
					)
				)
			));end setq
		);end progn
	)
	(if (not (member tblname (ade_odgettables e)));if table not attached
		(ade_odaddrecord e tblname);add field site_id
	)
)

;Description:
;Attach old Rom ID table.
;Arguments:
;e: entity name
(defun addoldRoomID (e)
	(addintODTable e "1" "room_id");attach room_id
)

;Description:
;Attach a site id to e
;Arguments:
;e: entity name
(defun addSiteID (e)
	(addODTable e "2" "site_id");attach site_id
)

;Description:
;Attach a new rood id to e
;Arguments:
;e: entity name
(defun addnewRoomID (e)
	(addODTable e "4" "room_id2");attach room_id
)

;Description:
;Set old room id to a new value. This should likely not be used, it will overwrite data with no way to retrieve it.
;Arguments:
;e: entity name
;id: new id to set
(defun setoldRoomID (e id)
	(ade_odsetfield e "1" "room_id" 0 id);set site_id
)

;Description
;Set the site id/monument number
;Arguments:
;e: entity name
;id: new id to set
(defun setSiteID (e id)
	(ade_odsetfield e "2" "site_id" 0 id);set site_id
)

;Description
;Set the new room id
;Arguments:
;e: entity name
;id: new id to set
(defun setnewRoomID (e id)
	(ade_odsetfield e "4" "room_id2" 0 id);set site_id
)

;Description:
;Draw a point at (x, y)
;Arguments:
;x: x-coord of point
;y: y-coord of point
(defun point (x y / pt)
	(setq pt (list x y 0))
	(command "point" pt)
)

;Description:
;Wrapper function to pass a list instead of coordinates to (point). List should be in the form (x y ...)
;Arguments:
;alist: list of coordinates.
(defun pointvector (alist)
	(point (car alist) (cdr alist))
)

;Description:
;Replace an index in a list with a new item.
;Arguments:
;alist: the list
;pos: the index to be replaced (starting from 0)
;newitem: the item to be inserted.
;Returns: the new list with the extra item.
(defun replace (alist pos newitem / i )
 (setq i -1)
 (mapcar '(lambda ( x ) (if (= pos (setq i (1+ i))) newitem x)) alist)
)

;Description:
;Add ss2 to ss1
;Arguments:
;ss1: selection set
;ss2: selection set.
;Returns: merged selection set. Order not guaranteed.
(defun mergeSS (ss1 ss2 / c)
	(setq c 0)
	(if (not (null ss2)) (repeat (sslength ss2)
		(ssadd (ssname ss2 c) ss1)
		(setq c (+ 1 c))
	))
	ss1
)

;Description:
;Command to detect errors with <a href="#finderr">finderr</a>.
(defun C:FIXERR ()
	(finderr)
)

;Description:
;Command to find errors in a merged file with <a href="#findROOMerr">findROOMerr</a>.
(defun C:BOUNDFIXROOM ()
	(findROOMerr nil nil)
)

;Description:
;Find broken net area polygons. Broken if the getcenter method fails.
;Returns: count of wrong rooms.
(defun C:FIXROOM ( / roomlist wrongcount)
	(setq roomlist (LM:ss->ent (ssget "X"  (list (cons 8 "tdsb-smsc-net area") (cons 0 "LWPOLYLINE")))));Select all polylines on "net area" layer
	(pc (ssget "X" (list (cons 8 "tdsb-smsc-net area") (cons 0 "LWPOLYLINE")))) ;Close all polylines

  	(setq wrongcount 0)
	(foreach room roomlist
		(if (equal (getcenter (ssadd room)) '(-1.0 . -1.0))
			(progn
				(setcolor (entget room) '(120 120 120))
				(setq wrongcount (+ 1 wrongcount))
			)
		)
	)
	wrongcount
)

;Description:
;Find errors in a file. Looks through entire file for polylines where (getcenter) fails (i.e. returns (-1 . -1)). It will fail if (vla-AddRegion) fails.
;This might happen because:
;1. The polyline is not closed
;2. The polyline may have self-intersecting or overlapping geometry. Look for vertices that are on top of other vertices, or edges that lay on top of others.
;Polylines that have failed will be turned grey (specifically (120 120 120))
;Will only look at polylines contained in the layers specified by lolist.
;Returns: number of failed polylines.
(defun finderr (/ lolist roomlist wrongcount )
	(setq lolist
		(list
			"tdsb-smsc-building parapet lines"
			"tdsb-smsc-building canopy"
			"tdsb-smsc-fence"
			"tdsb-smsc-gate"
			"tdsb-smsc-landscape"
			"tdsb-smsc-misc"
			"tdsb-smsc-playground outline"
			"tdsb-smsc-playground playscape"
			"tdsb-smsc-playground baseball diamond"
			"tdsb-smsc-playground soccerfield"
			"tdsb-smsc-portables"
			"tdsb-smsc-road"
			"tdsb-smsc-parking points"
			"tdsb-smsc-walkway"
			"tdsb-smsc-property line"
		)
	)
	(setq roomlist (LM:ss->ent (ssget "X" (buildSelfilter (list "LWPOLYLINE") lolist (list)))))

  	(setq wrongcount 0)
	(foreach room roomlist
		(if (equal (getcenter (ssadd room)) '(-1.0 . -1.0))
			(progn
				(setcolor (entget room) '(120 120 120))
				(setq wrongcount (+ 1 wrongcount))
			)
		)
	)
	wrongcount
)

;Description:
;Same as finderr, but will only search the selection set passed to it.
;Arguments:
;ss: selection set to search.
;Returns: count of broken lines.
(defun findselerr (ss / roomlist wrongcount)
	(setq roomlist (LM:ss->ent ss))
	(foreach room roomlist
		(if (/= (cdr (assoc 0 (entget room))) "LWPOLYLINE")
			(setq roomlist (LM:ss->ent (ssdel room ss)))
		)
	)
  	(setq wrongcount 0)
	(foreach room roomlist
		(if (equal (getcenter (ssadd room)) '(-1.0 . -1.0))
			(progn
				(setcolor (entget room) '(120 120 120))
				(setq wrongcount (+ 1 wrongcount))
			)
		)
	)
	wrongcount
)

;Description:
;Will search the layer "tdsb-smsc-net area" to find broken polylines. Will either ask for a boundary specified by two points, or will use the ones passed to it.
;Acts the same as finderr, but will also close polylines automatically.
;p1: point in the form (x y z).
;p2: point in the form (x y z).
;Returns: count of broken lines.
(defun findROOMerr (p1 p2 / minpt maxpt boundaryp1 boundaryp2 roomlist wrongcount)
	(cond ((or (null p1) (null p2))
		(setq minpt (getpoint "Get first boundary point"))
		(print)
		(setq maxpt (getpoint "Get second boundary point"))
		(print)
		(setq boundaryp1 (list (car minpt) (cadr minpt)))
		(setq boundaryp2 (list (car maxpt) (cadr maxpt)))
		)
		(T (setq boundaryp1 p1) (setq boundaryp2 p2))
	)

	(setq roomlist (LM:ss->ent (ssget "_W" boundaryp1 boundaryp2  (list (cons 8 "tdsb-smsc-net area") (cons 0 "LWPOLYLINE")))));Select all polylines on "net area" layer
	(pc (ssget "_W" boundaryp1 boundaryp2 (list (cons 8 "tdsb-smsc-net area") (cons 0 "LWPOLYLINE")))) ;Close all polylines

  	(setq wrongcount 0)
	(foreach room roomlist
		(if (equal (getcenter (ssadd room)) '(-1.0 . -1.0))
			(progn
				(setcolor (entget room) '(120 120 120))
				(setq wrongcount (+ 1 wrongcount))
			)
		)
	)
	wrongcount
)

;Description:
;Produces error messages for SMN.
;Arguments:
;msg: Error Message. Automatically passed on error.
(defun *error* (msg)
	(cond
		((= msg "Function cancelled") (close f) (setvar "osmode" osm) (command "redraw"))
		((= msg "bad argument type: consp -1") (princ (strcat msg "\nTestorder likely broken. Try 'fixerr'.\nBroken Layer: " currentlayer)))
		(T 
			(princ "whoops: ") (princ msg) (princ "\n")(close f))
	)
	(setvar 'osmode snapmode)
)

;Description:
;Set the color of an entity to (R G B).
;Arguments:
;e: entity name
;ncolor: a list of integers from 0 to 255. (R G B)
(defun setcolor (e ncolor / vlaE clrR clrG clrB r g b)
	(setq vlaE (vlax-ename->vla-object (cdr(car e))))		;get vla entity
	(setq oColor (vlax-get-property vlaE 'TrueColor)		;get the current color
		clrR (vlax-get-property oColor 'Red)
		clrG (vlax-get-property oColor 'Green)
		clrB (vlax-get-property oColor 'Blue))
	(setq r (nth 0 ncolor))
	(setq g (nth 1 ncolor))
	(setq b (nth 2 ncolor))
  
	(vla-setRGB oColor r g b)					;set the color
	(vla-put-TrueColor vlaE oColor)
	(vla-update vlaE)
)

;Description:
;Reset the entity's color to its original one. Will only work after (setcolor) is called.
;Arguments:
;e: entity name
(defun resetcolor (e / vlaE)
	(setq vlaE (vlax-ename->vla-object (cdr(car e))))
	(vla-put-ColorIndex oColor acByLayer)
	(vla-put-TrueColor vlaE oColor)
	(vla-update vlaE)
)

;Description:
;Move to first paperspace
(DEFUN PSS ()
	(GC)
	(SETVAR "CMDECHO" 0)
	(COMMAND "Tilemode" 0)
)

;Description:
;Move to model space
(DEFUN MSS ()
	(GC)
	(SETVAR "CMDECHO" 0)
	(COMMAND "Tilemode" 1)
)

;Description:
;From AfraLisp (<a href="https://www.afralisp.net/archive/Tips/code20.htm)">https://www.afralisp.net/archive/Tips/code20.htm</a>)
;asin
;-1<=y<=1
;Arguments:
;y: ratio
;Returns: inverse sin in radians
(defun asin (y)
	(atan y (sqrt (- 1 (* y y))))
)

;Description:
;From AfraLisp (<a href="https://www.afralisp.net/archive/Tips/code20.htm)">https://www.afralisp.net/archive/Tips/code20.htm</a>)
;acos
;-1<=y<=1
;Arguments:
;y: ratio
;Returns: inverse cos in radians
(defun acos (y)
	(atan (sqrt (- 1 (* y y))) y)
)

;Description:
;code converted from <a href="https://www.cadtutor.net/forum/topic/96-lisp-for-marks-centroids-of-closed-polylines/">https://www.cadtutor.net/forum/topic/96-lisp-for-marks-centroids-of-closed-polylines</a>
;WILL ONLY RETURN CENTER OF LAST POLYLINE IN SELECTION SET, so don't bother passing more that one object in the set.
;Arguments:
;selection: a selection set.
;Returns: the center of the last object in the selection set
(defun getcenter (selection / polySet polyList clyr Model newP1 obArr newReg point)
	(if (setq polySet selection) 
			(progn 
				(setq polyList(mapcar 'vlax-ename->vla-object 
					(vl-remove-if 'listp 
					(mapcar 'cadr(ssnamex polySet))))
					Model(vla-get-ModelSpace 
						(vla-get-ActiveDocument 
							(vlax-get-acad-object)))
				)
				(foreach p polyList 
					(if(= :vlax-true(vla-get-Closed p)) 
						(progn 
							(setq newPl(vla-copy p) 
								obArr(vlax-make-safearray vlax-vbObject '(0 . 0)) 
							);end setq 
							(vlax-safearray-put-element obArr 0 newPl)
							(if (not (vl-catch-all-error-p (setq tryreg (vl-catch-all-apply 'vla-AddRegion (list Model obArr)))));Tries addregion.
								(progn
									(setq newReg(car(vlax-safearray->list 
										(vlax-variant-value 
										tryreg))))
									(setq newPt(vlax-3d-point 
										(append 
										(vlax-safearray->list 
										(vlax-variant-value 
										(vla-get-Centroid newReg)))(list 0.0)))
									)
									(vla-delete newReg) 
								)
								(setq newPt (vlax-3d-point (list -1 -1 -1)));If addregion fails, construct point with (-1 -1 -1)
							)
							(vla-delete newPl)
						);end progn 
					);end if 
				);end foreach 
			);end progn 
	);end if
	(setq returnpt (vlax-safearray->list (vlax-variant-value newPt)))
	(cons (car returnpt) (cadr returnpt))
)

;Description:
;This will return the centroid of a set of points, as a fast approximation of the centroid of a polygon.
;This is not the same as the centroid of a polygon, if sides are made of more than two points.
;Arguments:
;p: entity name
;Returns: a list (x y)
(defun avgCentroid (p / plist sumx sumy)
	(setq sumx 0)
	(setq sumy 0)
	(setq plist (LM:ent->pts p 50))
	(foreach point plist
		(setq sumx (+ sumx (car point)))
		(setq sumy (+ sumy (cadr point)))
	)
	(list (/ sumx (length plist)) (/ sumy (length plist)))
)

;Description:
;Convert a circle to a 2-point polyline.
;Arguments:
;clist: list of circles.
(defun C2P:nogui (clist / *error* csel cir cdata cctr crad cextdir pdata a)
  (command "-color" "bylayer")
  (setq a (list))
  (foreach c clist
	  (setq
	    ;Circle entity name
	    cdata (entget c);entity data
	    cctr (cdr (assoc 10 cdata));center point, OCS for Circle & LWPolyline w/ WCS 0,0,0 as origin
	    crad (cdr (assoc 40 cdata));radius
	    cextdir (assoc 210 cdata);extrusion direction
	  );end setq
	  (setq 
	    pdata (vl-remove-if-not '(lambda (x) (member (car x) '(67 410 8 62 6 48 370 39))) cdata) 
	      ;start Polyline entity data list -- remove Circle-specific entries from
	      ;Circle's entity data, and extrusion direction;62 Color, 6 Linetype, 48
	      ;LTScale, 370 LWeight, 39 Thickness present only if not default/bylayer
	    pdata
	      (append ;add Polyline-specific entries
	        '((0 . "LWPOLYLINE") (100 . "AcDbEntity"))
	        pdata ;remaining non-entity-type-specific entries
	        '((100 . "AcDbPolyline") (90 . 2) (70 . 129) (43 . 0.0))
	          ;90 = # of vertices, 70 1 bit = closed 128 bit = ltype gen. on, 43 = global width
	        (list
	          (cons 38 (caddr cctr));elevation in OCS above WCS origin [Z of Circle center]
	          (cons 10 (list (- (car cctr) crad) (cadr cctr)));vertex 1
	          '(40 . 0.0) '(41 . 0.0) '(42 . 1);0 width, semi-circle bulge factors
	          (cons 10 (list (+ (car cctr) crad) (cadr cctr)));vertex 2
	          '(40 . 0.0) '(41 . 0.0) '(42 . 1)
	          cextdir ;extr. dir. at end [if in middle, reverts to (210 0.0 0.0 1.0) in (entmake)]
	        );end list
	      );end append & pdata
	  );end setq
	  (entdel c);[remove or comment out this line to retain selected Circle]
	  (append a (entmake pdata))
  )
)

;Description
;Written By Michael Puckett. Used to find layers.
(defun Table (s / d r)
	(while (setq d (tblnext s (null d)))
		(setq r (cons (cdr (assoc 2 d)) r))
	)
)

;All following Scripts by Lee Mac. Website: http://www.lee-mac.com/

;Description:
;Converts a SelectionSet to a list of Entities
;Author: Lee Mac, Copyright © 2011: www.lee-mac.com
;Arguments:
;ss: Valid SelectionSet (Pickset) ;
;Returns: List of Entity names, else nil;
(defun LM:ss->ent ( ss / i l )
	(if ss
		(repeat (setq i (sslength ss))
			(setq l (cons (ssname ss (setq i (1- i))) l))
		)
	)
)

;Description:
;Start Undo-Lee Mac
;Opens an Undo Group.
;Arguments:
;doc: VLA active document object (use (LM:acdoc))
(defun LM:startundo ( doc )
	(LM:endundo doc)
	(vla-startundomark doc)
)

;Description:
;End Undo-Lee Mac
;Closes an Undo Group.
;Arguments:
;doc: VLA active document object (use (LM:acdoc))
(defun LM:endundo ( doc )
	(while (= 8 (logand 8 (getvar 'undoctl)))
		(vla-endundomark doc)
	)
)

;Description:
;Active Document-Lee Mac
;Returns: the VLA Active Document Object
(defun LM:acdoc nil
	(eval (list 'defun 'LM:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
	(LM:acdoc)
)

;Description:
;Get Attribute Value-Lee Mac
;Returns the value held by the specified tag within the supplied block, if present.
;Arguments:
;blk: [vla] VLA Block Reference Object
;tag: [str] Attribute TagString
;Returns: [str] Attribute value, else nil if tag is not found.
(defun LM:vl-getattributevalue ( blk tag )
	(setq tag (strcase tag))
	(vl-some '(lambda ( att ) (if (= tag (strcase (vla-get-tagstring att))) (vla-get-textstring att))) (vlax-invoke blk 'getattributes))
)

;Description:
;Set Attribute Value-Lee Mac
;Sets the value of the first attribute with the given tag found within the block, if present.
;Arguments:
;blk: [vla] VLA Block Reference Object
;tag: [str] Attribute TagString
;val: [str] Attribute Value
;Returns: [str] Attribute value if successful, else nil.
(defun LM:vl-setattributevalue ( blk tag val )
	(setq tag (strcase tag))
	(vl-some
	 '(lambda ( att )
	(if (= tag (strcase (vla-get-tagstring att)))
		(progn (vla-put-textstring att val) val)
		)
		)
		(vlax-invoke blk 'getattributes)
	)
)

;Description:
;Get Attribute Values-Lee Mac
;Returns an association list of attributes present in the supplied block.
;Arguments:
;blk: [vla] VLA Block Reference Object
;Returns: [lst] Association list of ((<tag> . <value>) ... )
(defun LM:vl-getattributevalues ( blk )
	(mapcar '(lambda ( att ) (cons (vla-get-tagstring att) (vla-get-textstring att))) (vlax-invoke blk 'getattributes))
)

;Description:
;Set Attribute Values-Lee Mac
;Sets attributes with tags found in the association list to their associated values.
;Arguments:
;blk: [vla] VLA Block Reference Object
;lst: [lst] Association list of ((<tag> . <value>) ... )
;Returns: nil
(defun LM:vl-setattributevalues ( blk lst / itm )
	(foreach att (vlax-invoke blk 'getattributes)
		(if (setq itm (assoc (vla-get-tagstring att) lst))
			(vla-put-textstring att (cdr itm))
		)
	)
)

;Description:
;Get Attribute Value-Lee Mac
;Returns the value held by the specified tag within the supplied block, if present.
;Arguments:
;blk: [ent] Block (Insert) Entity Name
;tag: [str] Attribute TagString
;Returns: [str] Attribute value, else nil if tag is not found.
(defun LM:getattributevalue ( blk tag / enx )
	(if (and (setq blk (entnext blk)) (= "ATTRIB" (cdr (assoc 0 (setq enx (entget blk))))))
		(if (= (strcase tag) (strcase (cdr (assoc 2 enx))))
			(cdr (assoc 1 (reverse enx)))
			(LM:getattributevalue blk tag)
		)
	)
)

;Description:
;Get Attribute Value-Lee Mac
;Returns the value held by the specified tag within the supplied block, if present.
;Arguments:
;blk: [ent] Block (Insert) Entity Name
;tag: [str] Attribute TagString
;Returns: [str] Attribute value, else nil if tag is not found.
(defun LM:getattributevalue ( blk tag / val enx )
	(while
		(and
			(null val)
			(setq blk (entnext blk))
			(= "ATTRIB" (cdr (assoc 0 (setq enx (entget blk)))))
		)
		(if (= (strcase tag) (strcase (cdr (assoc 2 enx))))
			(setq val (cdr (assoc 1 (reverse enx))))
		)
	)
)

;Description:
;Set Attribute Value-Lee Mac
;Sets the value of the first attribute with the given tag found within the block, if present.
;Arguments:
;blk: [ent] Block (Insert) Entity Name
;tag: [str] Attribute TagString
;val: [str] Attribute Value
;Returns: [str] Attribute value if successful, else nil.
(defun LM:setattributevalue ( blk tag val / enx )
	(if (and (setq blk (entnext blk))
		 (= "ATTRIB" (cdr (assoc 0 (setq enx (entget blk)))))
	    )
	  (if (= (strcase tag) (strcase (cdr (assoc 2 enx))))
	    (if	(entmod (subst (cons 1 val) (assoc 1 (reverse enx)) enx))
	      (progn
		(entupd blk)
		val
	      )
	    )
	    (LM:setattributevalue blk tag val)
	  )
	)
)

;Attribute Value Functions: Get block values

;Description:
;Set Attribute Value-Lee Mac
;Sets the value of the first attribute with the given tag found within the block, if present.
;Arguments:
;blk: [ent] Block (Insert) Entity Name
;tag: [str] Attribute TagString
;val: [str] Attribute Value
;Returns: [str] Attribute value if successful, else nil.
(defun LM:setattributevalue ( blk tag val / end enx )
	(while
	  (and
	    (null end)
	    (setq blk (entnext blk))
	    (= "ATTRIB" (cdr (assoc 0 (setq enx (entget blk)))))
	  )
	   (if (= (strcase tag) (strcase (cdr (assoc 2 enx))))
	     (if (entmod (subst (cons 1 val) (assoc 1 (reverse enx)) enx))
	       (progn
		 (entupd blk)
		 (setq end val)
	       )
	     )
	   )
	)
)

;Description:
;Get Attribute Values-Lee Mac
;Returns an association list of attributes present in the supplied block.
;Arguments:
;blk: [ent] Block (Insert) Entity Name
;Returns: [lst] Association list of ((<tag> . <value>) ... )
(defun LM:getattributevalues ( blk / enx )
	(if (and (setq blk (entnext blk)) (= "ATTRIB" (cdr (assoc 0 (setq enx (entget blk))))))
		(cons
			(cons
				(cdr (assoc 2 enx))
				(cdr (assoc 1 (reverse enx)))
			)
			(LM:getattributevalues blk)
		)
	)
)

;Description:
;Get Attribute Values-Lee Mac
;Returns an association list of attributes present in the supplied block.
;Arguments:
;blk: [ent] Block (Insert) Entity Name
;Returns: [lst] Association list of ((<tag> . <value>) ... )
(defun LM:getattributevalues ( blk / enx lst )
	(while
	  (and (setq blk (entnext blk))
	       (= "ATTRIB" (cdr (assoc 0 (setq enx (entget blk)))))
	  )
	   (setq lst
		  (cons
		    (cons
		      (cdr (assoc 2 enx))
		      (cdr (assoc 1 (reverse enx)))
		    )
		    lst
		  )
	   )
	)
	(reverse lst)
)

;Description:
;Set Attribute Values-Lee Mac
;Sets attributes with tags found in the association list to their associated values.
;Arguments:
;blk: [ent] Block (Insert) Entity Name
;lst: [lst] Association list of ((<tag> . <value>) ... )
;Returns: nil
(defun LM:setattributevalues ( blk lst / enx itm )
	(if (and (setq blk (entnext blk))
		 (= "ATTRIB" (cdr (assoc 0 (setq enx (entget blk)))))
	    )
	  (if (setq itm (assoc (cdr (assoc 2 enx)) lst))
	    (progn
	      (if
		(entmod
		  (subst (cons 1 (cdr itm)) (assoc 1 (reverse enx)) enx)
		)
		 (entupd blk)
	      )
	      (LM:setattributevalues blk lst)
	    )
	    (LM:setattributevalues blk lst)
	  )
	)
)

;Description:
;Set Attribute Values-Lee Mac
;Sets attributes with tags found in the association list to their associated values.
;Arguments:
;blk: [ent] Block (Insert) Entity Name
;lst: [lst] Association list of ((<tag> . <value>) ... )
;Returns: nil
(defun LM:setattributevalues ( blk lst / enx itm )
	(while
	  (and (setq blk (entnext blk))
	       (= "ATTRIB" (cdr (assoc 0 (setq enx (entget blk)))))
	  )
	   (if
	     (and
	       (setq itm (assoc (cdr (assoc 2 enx)) lst))
	       (entmod
		 (subst (cons 1 (cdr itm)) (assoc 1 (reverse enx)) enx)
	       )
	     )
	      (entupd blk)
	   )
	)
	nil
)

;Description:
;Entity to Point List-Lee Mac
;Returns a list of points describing or approximating the supplied entity, else nil if the entity is not supported.
;Arguments:
;ent: [ent] Entity name to be described by point list (POINT/LINE/ARC/CIRCLE/LWPOLYLINE/POLYLINE/ELLIPSE/SPLINE)
;acc: [num] Positive number determining the point density for non-linear objects
(defun LM:ent->pts (ent acc / der di1 di2 enx inc lst par rad )
	(setq enx (entget ent))
	(cond
	  ((= "POINT" (cdr (assoc 0 enx)))
	   (list (cdr (assoc 10 enx)))
	  )
	  ((= "LINE" (cdr (assoc 0 enx)))
	   (list (cdr (assoc 10 enx)) (cdr (assoc 11 enx)))
	  )
	  ((wcmatch (cdr (assoc 0 enx)) "ARC,CIRCLE")
	   (setq di1 0.0
		 di2 (vlax-curve-getdistatparam ent (vlax-curve-getendparam ent))
		 inc (/	di2
			(1+ (fix (* acc (/ di2 (cdr (assoc 40 enx)) (+ pi pi)))))
		     )
		 di2 (- di2 1e-8)
	   )
	   (while (< di1 di2)
	     (setq lst (cons (vlax-curve-getpointatdist ent di1) lst)
		   di1 (+ di1 inc)
	     )
	   )
	   (reverse
	     (if (vlax-curve-isclosed ent)
	       lst
	       (cons (vlax-curve-getendpoint ent) lst)
	     )
	   )
	  )
	  ((and	(wcmatch (cdr (assoc 0 enx)) "*POLYLINE")
		(zerop (logand 80 (cdr (assoc 70 enx))))
	   )
	   (setq par 0)
	   (repeat (fix (+ 1.0 1e-8 (vlax-curve-getendparam ent)))
	     (cond
	       ((not (setq der (vlax-curve-getsecondderiv ent par))))
	       ((equal der '(0.0 0.0 0.0) 1e-8)
		(setq lst (cons (vlax-curve-getpointatparam ent par) lst))
	       )
	       ((setq rad (distance '(0.0 0.0) (vlax-curve-getfirstderiv ent par))
		      di1 (vlax-curve-getdistatparam ent par)
		      di2 (vlax-curve-getdistatparam ent (1+ par))
		)
		(setq inc (/ (- di2 di1)
			     (1+ (fix (* acc (/ (- di2 di1) rad (+ pi pi)))))
			  )
		      di2 (- di2 1e-8)
		)
		(while (< di1 di2)
		  (setq	lst (cons (vlax-curve-getpointatdist ent di1) lst)
			di1 (+ di1 inc)
		  )
		)
	       )
	     )
	     (setq par (1+ par))
	   )
	   (setq lst (cons (vlax-curve-getendpoint ent) lst))
	   (while
	     (and (cdr lst)
		  (or (equal (car lst) (last lst) 1e-8)
		      (equal (car lst) (cadr lst) 1e-8)
		  )
	     )
	      (setq lst (cdr lst))
	   )
	   (reverse lst)
	  )
	  ((= "ELLIPSE" (cdr (assoc 0 enx)))
	   (setq di1 (vlax-curve-getdistatparam
		       ent
		       (vlax-curve-getstartparam ent)
		     )
		 di2 (vlax-curve-getdistatparam ent (vlax-curve-getendparam ent))
		 di2 (- di2 1e-8)
	   )
	   (while (< di1 di2)
	     (setq lst (cons (vlax-curve-getpointatdist ent di1) lst)
		   rad (distance
			 '(0.0 0.0)
			 (vlax-curve-getfirstderiv
			   ent
			   (vlax-curve-getparamatdist ent di1)
			 )
		       )
		   di1 (+ di1 (/ di2 (1+ (fix (* acc (/ di2 rad (+ pi pi)))))))
	     )
	   )
	   (reverse
	     (if (vlax-curve-isclosed ent)
	       lst
	       (cons (vlax-curve-getendpoint ent) lst)
	     )
	   )
	  )
	  ((= "SPLINE" (cdr (assoc 0 enx)))
	   (setq di1 (vlax-curve-getdistatparam
		       ent
		       (vlax-curve-getstartparam ent)
		     )
		 di2 (vlax-curve-getdistatparam ent (vlax-curve-getendparam ent))
		 inc (/ di2 acc)
		 di2 (- di2 1e-8)
	   )
	   (while (< di1 di2)
	     (setq lst (cons (vlax-curve-getpointatdist ent di1) lst)
		   der (/ (distance
			    '(0.0 0.0)
			    (vlax-curve-getsecondderiv
			      ent
			      (vlax-curve-getparamatdist ent di1)
			    )
			  )
			  inc
		       )
		   di1 (+ di1
			  (if (equal 0.0 der 1e-10)
			    inc
			    (max (/ 1.0 der (* acc inc)) inc)
			  )
		       )
	     )
	   )
	   (reverse
	     (if (vlax-curve-isclosed ent)
	       lst
	       (cons (vlax-curve-getendpoint ent) lst)
	     )
	   )
	  )
	)
)

;Browse for Folder-Lee Mac
;Displays a dialog prompting the user to select a folder.
;Arguments:
;msg: [str] message to display at top of dialog
;dir: [str] [optional] root directory (or nil)
;bit: [int] bit-coded flag specifying dialog display settings
;Returns: [str] Selected folder filepath, else nil.
(defun LM:browseforfolder ( msg dir bit / err fld pth shl slf )
	(setq err
	       (vl-catch-all-apply
		 (function
		   (lambda (/ app hwd)
		     (if (setq app (vlax-get-acad-object)
			       shl (vla-getinterfaceobject app "shell.application")
			       hwd (vl-catch-all-apply 'vla-get-hwnd (list app))
			       fld (vlax-invoke-method
				     shl
				     'browseforfolder
				     (if (vl-catch-all-error-p hwd)
				       0
				       hwd
				     )
				     msg
				     bit
				     dir
				   )
			 )
		       (setq slf (vlax-get-property fld 'self)
			     pth (vlax-get-property slf 'path)
			     pth (vl-string-right-trim
				   "\\"
				   (vl-string-translate "/" "\\" pth)
				 )
		       )
		     )
		   )
		 )
	       )
	)
	(if slf
	  (vlax-release-object slf)
	)
	(if fld
	  (vlax-release-object fld)
	)
	(if shl
	  (vlax-release-object shl)
	)
	(if (vl-catch-all-error-p err)
	  (prompt (vl-catch-all-error-message err))
	  pth
	)
)

(defun LM:GetInsideAngle ( p1 p2 p3 )
	((lambda ( a ) (min a (- (+ pi pi) a)))
		(rem (+ pi pi (- (angle p2 p1) (angle p2 p3))) (+ pi pi))
	)
)

;Description:
;Polyline Close-Lee Mac
;Closes all polylines in a selection.
;Arguments:
;sel: selection set
(defun pc (sel / idx)
	(repeat (setq idx (sslength sel))
		(vla-put-closed (vlax-ename->vla-object (ssname sel (setq idx (1- idx)))) :vlax-true)
	)
)

(defun opc (sel / idx)
	(repeat (setq idx (sslength sel))
		(vla-put-closed (vlax-ename->vla-object (ssname sel (setq idx (1- idx)))) :vlax-false)
	)
)

;Description:
;Sublst :  Lee Mac
;The list analog of the substr function
;Arguments:
;lst: [lst] List from which sublist is to be returned
;idx: [int] Zero-based index at which to start the sublist
;len: [int] Length of the sublist or nil to return all items following idx
(defun LM:sublst ( lst idx len )
	(cond
		(   (null lst) nil)
		(   (< 0  idx) (LM:sublst (cdr lst) (1- idx) len))
		(   (null len) lst)
		(   (< 0  len) (cons (car lst) (LM:sublst (cdr lst) idx (1- len))))
	)
)

;Description
;Version 1.6 - 2016-03-21	
;An analog of the 'getfiled' function for multiple file selection.
;File count label added by Noah Cassidy
;CAN HANDLE UP TO 525 FILES added to the box at once
;Author:  Lee Mac, Copyright © 2012 :  www.lee-mac.com
;Arguments:
;msg: [str/nil] Dialog box label;'Select Files' if nil or "".
;def: [str/nil] Default directory;dwgprefix if nil or "".
;ext: [str/nil] File extension filter (e.g. "dwg;lsp");"*" if nil
; Returns:  List of selected files, else nil
(defun LM:getfiles ( msg def ext / *error* dch dcl des dir dirdata lst rtn )
 
	(defun *error* ( msg )
		(if (= 'file (type des))
			(close des)
		)
		(if (and (= 'int (type dch)) (< 0 dch))
			(unload_dialog dch)
		)
		(if (and (= 'str (type dcl)) (findfile dcl))
			(vl-file-delete dcl)
		)
		(if (and msg (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*")))
			(princ (strcat "\nError: " msg))
		)
		(princ)
	)	
	
	(if
		(and
			(setq dcl (vl-filename-mktemp nil nil ".dcl"))
			(setq des (open dcl "w"))
			(progn
				(foreach x
				   '(
						"lst : list_box"
						"{"
						"	width = 40.0;"
						"	height = 20.0;"
						"	fixed_width = true;"
						"	fixed_height = true;"
						"	alignment = centered;"
						"	multiple_select = true;"
						"}"
						"but : button"
						"{"
						"	width = 20.0;"
						"	height = 1.8;"
						"	fixed_width = true;"
						"	fixed_height = true;"
						"	alignment = centered;"
						"}"
						"getfiles : dialog"
						"{"
						"	key = \"title\";spacer;"
						"	: row"
						"	{"
						"		: text"
						"		{"
						"			label = \"DO NOT ADD MORE THAN 525 FILES AT A TIME!\";"
						"			key = \"warn\";"
						"		}"
						"	}"
						"	: row"
						"	{"
						"		alignment = centered;"
						"		: edit_box { key = \"dir\";label = \"Folder:\";}"
						"		: button"
						"		{"
						"			key = \"brw\";"
						"			label = \"Browse\";"
						"			fixed_width = true;"
						"		}"
						"	}"
						"	spacer;"
						"	: row"
						"	{"
						"		: column"
						"		{"
						"			: lst { key = \"box1\";}"
						"			: but { key = \"add\" ;label = \"Add Files\";}"
						"		}"
						"		: column {"
						"			: lst { key = \"box2\";}"
						"			: but { key = \"del\" ;label = \"Remove Files\";}"
						"		}"
						"	}"
						"	: row"
						"	{"
						"			: text"
						"			{"
						"				label = \"File count: 0\";"
						"				key = \"ct\";"
						"			}"
						"	}"
						"	spacer;"	
						"	ok_cancel;"
						"	}"
					)
					(write-line x des)
				)
				(setq des (close des))
				(< 0 (setq dch (load_dialog dcl)))
			)
			(new_dialog "getfiles" dch)
		)
		(progn
			(setq ext (if (= 'str (type ext)) (LM:getfiles:str->lst (strcase ext) ";") '("*")))
			(set_tile "title" (if (member msg '(nil "")) "Select Files" msg))
			(set_tile "dir"
				(setq dir
					(LM:getfiles:fixdir
						(if (or (member def '(nil "")) (not (vl-file-directory-p (LM:getfiles:fixdir def))))
							(getvar 'dwgprefix)
							def
						)
					)
				)
			)
			(setq lst (LM:getfiles:updatefilelist dir ext nil))
			(mode_tile "add" 1)
			(mode_tile "del" 1)
 
			(action_tile "brw"
				(vl-prin1-to-string
				   '(if (setq tmp (LM:getfiles:browseforfolder "" nil 512))
						(setq lst (LM:getfiles:updatefilelist (set_tile "dir" (setq dir tmp)) ext rtn)
							  rtn (LM:getfiles:updateselected dir rtn)
						)							  
					)
				)
			)
 
			(action_tile "dir"
				(vl-prin1-to-string
				   '(if (= 1 $reason)
						(setq lst (LM:getfiles:updatefilelist (set_tile "dir" (setq dir (LM:getfiles:fixdir $value))) ext rtn)
							  rtn (LM:getfiles:updateselected dir rtn)
						)
					)
				)
			)
 
			(action_tile "box1"
				(vl-prin1-to-string
				   '(
						(lambda ( / itm tmp )
							(if (setq itm (mapcar '(lambda ( n ) (nth n lst)) (read (strcat "(" $value ")"))))
								(if (= 4 $reason)
									(cond
										(   (equal '("..") itm)
											(setq lst (LM:getfiles:updatefilelist (set_tile "dir" (setq dir (LM:getfiles:updir dir))) ext rtn)
												  rtn (LM:getfiles:updateselected dir rtn)
											)
										)
										(   (vl-file-directory-p (setq tmp (LM:getfiles:checkredirect (strcat dir "\\" (car itm)))))
											(setq lst (LM:getfiles:updatefilelist (set_tile "dir" (setq dir tmp)) ext rtn)
												  rtn (LM:getfiles:updateselected dir rtn)
											)
										)
										(   (setq rtn (LM:getfiles:sort (append rtn (mapcar '(lambda ( x ) (strcat dir "\\" x)) itm)))
												  rtn (LM:getfiles:updateselected dir rtn)
												  lst (LM:getfiles:updatefilelist dir ext rtn)
											)
										)
									)
									(if (vl-every '(lambda ( x ) (vl-file-directory-p (strcat dir "\\" x))) itm)
										(mode_tile "add" 1)
										(mode_tile "add" 0)
									)
								)
							)
						)
					)
				)
			)
 
			(action_tile "box2"
				(vl-prin1-to-string
				   '(
						(lambda ( / itm )
							(if (setq itm (mapcar '(lambda ( n ) (nth n rtn)) (read (strcat "(" $value ")"))))
								(if (= 4 $reason)
									(setq rtn (LM:getfiles:updateselected dir (vl-remove (car itm) rtn))
										  lst (LM:getfiles:updatefilelist dir ext rtn)
									)
									(mode_tile "del" 0)
								)
							)
						)
					)
				)
			)
 
			(action_tile "add"
				(vl-prin1-to-string
				   '(
						(lambda ( / itm )
							(if
								(setq itm
									(vl-remove-if 'vl-file-directory-p
										(mapcar '(lambda ( n ) (nth n lst)) (read (strcat "(" (get_tile "box1") ")")))
									)
								)
								(setq rtn (LM:getfiles:sort (append rtn (mapcar '(lambda ( x ) (strcat dir "\\" x)) itm)))
									  rtn (LM:getfiles:updateselected dir rtn)
									  lst (LM:getfiles:updatefilelist dir ext rtn)
								)
							)
							(mode_tile "add" 1)
							(mode_tile "del" 1)
						)
					)
				)
			)
 
			(action_tile "del"
				(vl-prin1-to-string
				   '(
						(lambda ( / itm )
							(if (setq itm (read (strcat "(" (get_tile "box2") ")")))
								(setq rtn (LM:getfiles:updateselected dir (LM:getfiles:removeitems itm rtn))
									  lst (LM:getfiles:updatefilelist dir ext rtn)
								)
							)
							(mode_tile "add" 1)
							(mode_tile "del" 1)
						)
					)
				)
			)
		 
			(if (zerop (start_dialog))
				(setq rtn nil)
			)
		)
	)
	(*error* nil)
	rtn
)
 
(defun LM:getfiles:listbox ( key lst )
	(start_list key)
	(foreach x lst (add_list x))
	(end_list)
	(if (= key "box2")(set_tile "ct" (strcat "File count: "(itoa (length lst)))))
	lst
)
 
(defun LM:getfiles:listfiles ( dir ext lst )
	(vl-remove-if '(lambda ( x ) (member (strcat dir "\\" x) lst))
		(cond
			(   (cdr (assoc dir dirdata)))
			(   (cdar
					(setq dirdata
						(cons
							(cons dir
								(append
									(LM:getfiles:sortlist (vl-remove "." (vl-directory-files dir nil -1)))
									(LM:getfiles:sort
										(if (member ext '(("") ("*")))
											(vl-directory-files dir nil 1)
											(vl-remove-if-not
												(function
													(lambda ( x / e )
														(and
															(setq e (vl-filename-extension x))
															(setq e (strcase (substr e 2)))
															(vl-some '(lambda ( w ) (wcmatch e w)) ext)
														)
													)
												)
												(vl-directory-files dir nil 1)
											)
										)
									)
								)
							)
							dirdata
						)
					)
				)
			)
		)
	)
)
 
(defun LM:getfiles:checkredirect ( dir / itm pos )
	(cond
		(   (vl-directory-files dir) dir)
		(   (and
				(=  (strcase (getenv "UserProfile"))
					(strcase (substr dir 1 (setq pos (vl-string-position 92 dir nil t))))
				)
				(setq itm
					(cdr
						(assoc (substr (strcase dir t) (+ pos 2))
						   '(
								("my documents" . "Documents")
								("my pictures"  . "Pictures")
								("my videos"	. "Videos")
								("my music"	 . "Music")
							)
						)
					)
				)
				(vl-file-directory-p (setq itm (strcat (substr dir 1 pos) "\\" itm)))
			)
			itm
		)
		(   dir   )
	)
)
 
(defun LM:getfiles:sort ( lst )
	(apply 'append
		(mapcar 'LM:getfiles:sortlist
			(vl-sort
				(LM:getfiles:groupbyfunction lst
					(lambda ( a b / x y )
						(and
							(setq x (vl-filename-extension a))
							(setq y (vl-filename-extension b))
							(= (strcase x) (strcase y))
						)
					)
				)
				(function
					(lambda ( a b / x y )
						(and
							(setq x (vl-filename-extension (car a)))
							(setq y (vl-filename-extension (car b)))
							(< (strcase x) (strcase y))
						)
					)
				)
			)
		)
	)
)
 
(defun LM:getfiles:sortlist ( lst )
	(mapcar (function (lambda ( n ) (nth n lst)))
		(vl-sort-i (mapcar 'LM:getfiles:splitstring lst)
			(function
				(lambda ( a b / x y )
					(while
						(and
							(setq x (car a))
							(setq y (car b))
							(= x y)
						)
						(setq a (cdr a)
							  b (cdr b)
						)
					)
					(cond
						(   (null x) b)
						(   (null y) nil)
						(   (and (numberp x) (numberp y)) (< x y))
						(   (numberp x))
						(   (numberp y) nil)
						(   (< x y))
					)
				)
			)
		)
	)
)
 
(defun LM:getfiles:groupbyfunction ( lst fun / tmp1 tmp2 x1 )
	(if (setq x1 (car lst))
		(progn
			(foreach x2 (cdr lst)
				(if (fun x1 x2)
					(setq tmp1 (cons x2 tmp1))
					(setq tmp2 (cons x2 tmp2))
				)
			)
			(cons (cons x1 (reverse tmp1)) (LM:getfiles:groupbyfunction (reverse tmp2) fun))
		)
	)
)
 
(defun LM:getfiles:splitstring ( str )
	(
		(lambda ( l )
			(read
				(strcat "("
					(vl-list->string
						(apply 'append
							(mapcar
								(function
									(lambda ( a b c )
										(cond
											(   (member b '(45 46 92))
												(list 32)
											)
											(   (< 47 b 58)
												(list b)
											)
											(   (list 32 34 b 34 32))
										)
									)
								)
								(cons nil l) l (append (cdr l) '(( )))
							)
						)
					)
					")"
				)
			)
		)
		(vl-string->list (strcase str))
	)
)
 
(defun LM:getfiles:browseforfolder ( msg dir flg / err fld pth shl slf )
	(setq err
		(vl-catch-all-apply
			(function
				(lambda ( / app hwd )
					(if (setq app (vlax-get-acad-object)
							  shl (vla-getinterfaceobject app "shell.application")
							  hwd (vl-catch-all-apply 'vla-get-hwnd (list app))
							  fld (vlax-invoke-method shl 'browseforfolder (if (vl-catch-all-error-p hwd) 0 hwd) msg flg dir)
						)
						(setq slf (vlax-get-property fld 'self)
							  pth (LM:getfiles:fixdir (vlax-get-property slf 'path))
						)
					)
				)
			)
		)
	)
	(if slf (vlax-release-object slf))
	(if fld (vlax-release-object fld))
	(if shl (vlax-release-object shl))
	(if (vl-catch-all-error-p err)
		(prompt (vl-catch-all-error-message err))
		pth
	)
)
 
(defun LM:getfiles:full->relative ( dir path / p q )
	(setq dir (vl-string-right-trim "\\" dir))
	(cond
		(   (and
				(setq p (vl-string-position 58  dir))
				(setq q (vl-string-position 58 path))
				(/= (strcase (substr dir 1 p)) (strcase (substr path 1 q)))
			)
			path
		)
		(   (and
				(setq p (vl-string-position 92  dir))
				(setq q (vl-string-position 92 path))
				(= (strcase (substr dir 1 p)) (strcase (substr path 1 q)))
			)
			(LM:getfiles:full->relative (substr dir (+ 2 p)) (substr path (+ 2 q)))
		)
		(   (and
				(setq q (vl-string-position 92 path))
				(= (strcase dir) (strcase (substr path 1 q)))
			)
			(strcat ".\\" (substr path (+ 2 q)))
		)
		(   (= "" dir)
			path
		)
		(   (setq p (vl-string-position 92 dir))
			(LM:getfiles:full->relative (substr dir (+ 2 p)) (strcat "..\\" path))
		)
		(   (LM:getfiles:full->relative "" (strcat "..\\" path)))
	)
)
 
(defun LM:getfiles:str->lst ( str del / pos )
	(if (setq pos (vl-string-search del str))
		(cons (substr str 1 pos) (LM:getfiles:str->lst (substr str (+ pos 1 (strlen del))) del))
		(list str)
	)
)
 
(defun LM:getfiles:updatefilelist ( dir ext lst )
	(LM:getfiles:listbox "box1" (LM:getfiles:listfiles dir ext lst))
)
 
(defun LM:getfiles:updateselected ( dir lst )
	(LM:getfiles:listbox "box2" (mapcar '(lambda ( x ) (LM:getfiles:full->relative dir x)) lst))
	lst
)
 
(defun LM:getfiles:updir ( dir )
	(substr dir 1 (vl-string-position 92 dir nil t))
)
 
(defun LM:getfiles:fixdir ( dir )
	(vl-string-right-trim "\\" (vl-string-translate "/" "\\" dir))
)
 
(defun LM:getfiles:removeitems ( itm lst / idx )
	(setq idx -1)
	(vl-remove-if '(lambda ( x ) (member (setq idx (1+ idx)) itm)) lst)
)

;Description:
;Selection Set Bounding Box:  Lee Mac
;Returns a list of the lower-left and upper-right WCS coordinates of a
;rectangular frame bounding all objects in a supplied selection set.
;Arguments:
;sel: [sel] Selection set for which to return bounding box
(defun LM:ssboundingbox ( sel / idx llp ls1 ls2 obj urp )
    (repeat (setq idx (sslength sel))
        (setq obj (vlax-ename->vla-object (ssname sel (setq idx (1- idx)))))
        (if (and (vlax-method-applicable-p obj 'getboundingbox)
                 (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-getboundingbox (list obj 'llp 'urp))))
            )
            (setq ls1 (cons (vlax-safearray->list llp) ls1)
                  ls2 (cons (vlax-safearray->list urp) ls2)
            )
        )
    )
    (if (and ls1 ls2)
        (mapcar '(lambda ( a b ) (apply 'mapcar (cons a b))) '(min max) (list ls1 ls2))
    )
)