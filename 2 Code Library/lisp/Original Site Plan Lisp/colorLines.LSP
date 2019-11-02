;Utility functions written during roof id labelling. Most copied to "utils" in new library of functions.

;Description
;debug/testing command
(defun C:COLORLINES ( / entitylist dxf_model layerfilter countervar sel_list ncolor clyr lyr)
	(setq ncolor (list 0 255 255))
	
	(setq entitylist (getSelection))
	(setq sel_list (getlayer entitylist layerfilter));filter selection list for layerfilter

  	(LM:startundo (LM:acdoc))

	(setq clyr (getvar "clayer"))
	(setq lyr "buildingoutline-TEMP")
  	(setlayer lyr)
	(LM:outline sel_list)
	(setlayer clyr)
	(placeText sel_list)

	(LM:endundo (LM:acdoc))
)

;Description
;Ask for a selection of polylines
;Returns: A selection set.
(defun getSelection( / entitylist)
	(setq entitylist 
		(ssget "_:L"						;select only on unlocked layers
			(list 
				(cons 0 "*")
				(cons 67 (if (eq (getvar "CVPORT") 2) 0 1))
				(cons 410 (if (eq (getvar "CVPORT") 2) "Model" (getvar "CTAB")))
			)
		)
	)
  entitylist
)

;Description
;Filter a selection set objects by layer.
;Arguments
;sel_list: Selection set, the list to filter
;layer: String, name of layer to filter for.
;Returns: Filtered selection set.
(defun getlayer (sel_list layer / countervar slist) ;slist is selection set
	(setq slist (ssadd))
	(setq countervar 0)
	(while (< countervar (sslength sel_list))
		(setq e (entget (ssname sel_list countervar)))	;e is the object in sel_list
		;(print (strcat "\n" (cdr (assoc 8 e)) " "))		;print name
		;(print (eq (cdr (assoc 8 e)) layer))			;print T/nil for removal
		(cond 
			((eq (cdr (assoc 8 e)) layer)			;if e is on the right layer
			(ssadd (ssname sel_list countervar) slist));add it to the new selection list
			;(print (strcat " removed " (cdr (assoc 8 e)) "\n")) ;print which were removed
		)
		(setq countervar (+ 1 countervar))
	);end while
	slist
)

;Description
;Set the color of an entity.
;Arguments:
;e: NOT JUST AN ENAME. Pass in the list returned by (entget ename)
;ncolor: a list, (r g b)
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

;Description
;Reset color of the entity. Only works after (setcolor) has been run.
;Arguments:
;e: same as setcolor. Use (entget ename) as the argument.
(defun resetcolor (e / vlaE)
	(setq vlaE (vlax-ename->vla-object (cdr(car e))))
	(vla-put-ColorIndex oColor acByLayer)
	(vla-put-TrueColor vlaE oColor)
	(vla-update vlaE)
)

;Description
;Set the current layer as lyr. Will add the layer if it does not already exist.
(defun setlayer (lyr)
	(cond ((tblsearch "LAYER" lyr)
  		(command "._Layer" "_Thaw" lyr "_UnLock" lyr "_On" lyr "_Set" lyr ""))
		(T
			(command "._layer" "_M" lyr ""))
	)
)

;Description
;Written By Michael Puckett. Used to find layers.
(defun Table (s / d r)
	(while (setq d (tblnext s (null d)))
		(setq r (cons (cdr (assoc 2 d)) r))
	)
)

;Description
;code from <a href="https://www.cadtutor.net/forum/topic/96-lisp-for-marks-centroids-of-closed-polylines/">https://www.cadtutor.net/forum/topic/96-lisp-for-marks-centroids-of-closed-polylines/</a>
;Place text "id" on "savedlayer" in the center of "selection"
;Arguments:
;selection: a selection set.
;id: a string to place at the center of each polyline in selection.
;savedlayer: layer on which id will be placed.
(defun placeText (selection id savedlayer / polySet polyList clyr Model newP1 obArr newReg newPt textString ht point text)
	(setq clyr (getvar "clayer"))
	(setq lyr (strcat "labelText-TEMP " savedlayer))
  	(setlayer lyr)
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
							); end setq 
							(vlax-safearray-put-element obArr 0 newPl) 
							(setq newReg(car(vlax-safearray->list 
								(vlax-variant-value 
								(vla-AddRegion Model obArr)))) 
								newPt(vlax-3d-point 
								(append 
								(vlax-safearray->list 
								(vlax-variant-value 
								(vla-get-Centroid newReg)))(list 0.0))) 
							); end setq

						  	(setq ht 0.75
							      point (vlax-3d-point 2 2 0))
						  
							(setq text (vla-addText Model id newPt ht))
							(vla-delete newPl)(vla-delete newReg) 
						); end progn 
					); end if 
				); end foreach 
			); end progn 
	); end if 
	(print)
	(setlayer clyr) 
)

;Description
;Add an object data table to an object e.
;Arguments:
;e: entity name to add od table to
;tblname: String. Name of Object Data table to add
;field: String. Name of field to add to table. (e.g. room_id or "0")
(defun addODTable (e tblname field)
  (if (not (ade_odtabledefn tblname));if table doesn't exist
    (progn c  
    	(print "doens't exist")
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

;Description
;Attach a site id to entity e
;Arguments:
;e: entity name
(defun addSiteID (e)
	(addODTable e "2" "site_id");attach site_id
)

;Description
;Set the site Id to entity e, with text id.
;Arguments:
;e: entity name
;id: id to insert in "site_id" field
(defun setSiteID (e id)
	(ade_odsetfield e "2" "site_id" 0 id);set site_id
)

;Description
;Retrieve the facility id from the document name (assuming the facility id is the first 4 characters of the name)
(defun getschoolnum()
	(setq num (substr (getvar "dwgname") 1 4))
)

;Description
;Converts a SelectionSet to a list of Entities
;Author: Lee Mac, Copyright © 2011 - www.lee-mac.com
;Arguments:
;ss: Valid SelectionSet (Pickset)
;Returns: List of Entity names, else nil

(defun LM:ss->ent ( ss / i l )
    (if ss
        (repeat (setq i (sslength ss))
            (setq l (cons (ssname ss (setq i (1- i))) l))
        )
    )
)