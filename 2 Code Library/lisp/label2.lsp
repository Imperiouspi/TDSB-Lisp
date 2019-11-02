;Helps label rooves, rewritten from Original Site Plan Lisp\\helper.lsp. No longer depends on anything from that folder.

(load "del-layer")

;Description:
;Command to run <a href="#helper2">helper2</a>. See <a href="Process-Documentation.html#RoofPlan">Roof Plan Documentation</a> for how to use it.
(defun C:ROOF ()
	(helper2 "tdsb-smsc-building parapet lines" "ROOF")
)

;Description:
;Label roof parapet lines and canopy lines. Run through <a href="#C:ROOF">ROOF</a>. See <a href="Process-Documentation.html#RoofPlan">Roof Plan Documentation</a> for how to use it.
(defun helper2 (layername featuretype / dcl_id layerList flag)
	(setq dcl_id (load_dialog "label2.dcl"))
	(setq flag 4)
	(setq *filename* (strcat "H:\\Map 3d\\exports\\Conversion Key Spreadsheet.csv"))
	(setq isIso nil)

	(setq oldosmode (getvar "osmode"))
	(setq oldcmdecho (getvar "cmdecho"))
	(setvar "osmode" 0)
	(setvar "cmdecho" 0)

	(while (> flag 2)
		(if (not (new_dialog "helper" dcl_id))
			(exit)
		)
		(action_tile "selectobj"
			"(done_dialog 4)"
		)
		(action_tile "labelobj"
			"(done_dialog 5)"
		)
		(action_tile "fixlabel"
			"(done_dialog 8)"
		)
		(action_tile "done"
			"(done_dialog)"
		)

		(setq flag (start_dialog))
		(cond 
			( (= flag 4) (createSections2) )
			( (= flag 5) (labelLayers2) )
			( (= flag 8) (fixlabel2) )
		)
	)

	(unload_dialog dcl_id)
	(setvar "osmode" oldosmode)
	(setvar "cmdecho" oldcmdecho)
	(print)
)

;Description:
;Create "sections" list, color sections
(defun createSections2 ( / color sel_list enamelist)
	(command "._-layer" "_off" "*" "" "")
	(command "._-layer" "_on" "tdsb-smsc-building parapet lines" "" "")
	(command "._-layer" "_on" "tdsb-smsc-building canopy" "" "")
	(setq colorlist (list (list 230 82 75) (list 60 180 75) (list 255 225 25) (list 0 130 200) (list 245 130 48) (list 145 30 180) (list 70 240 240) (list 240 50 230) (list 210 245 60) (list 250 190 190) (list 0 128 128) (list 230 190 255) (list 170 110 40) (list 255 250 200) (list 128 0 0) (list 170 255 195) (list 128 128 0) (list 255 215 180) (list 0 0 128)))
	(setq *sections* nil)
	(setq *sectionct* 0)
	(setq *isx* nil)
	(setq sel_list (getSelection))
	(setq countervar 0)
	;select all not x sections
	(LM:startundo (LM:acdoc))
	(while (and (not (null sel_list)) (> (sslength sel_list) 0))
		;(setq sel_list (getlayer sel_list layerfilter))
		(while (< countervar (sslength sel_list))
			(setq e (entget (ssname sel_list countervar)))
			(setcolor e (nth *sectionct* colorList ))
			(setq countervar (+ 1 countervar));increase counter
		)
		(setq enamelist (LM:ss->ent sel_list))
		(setq *sections* (append *sections* (list enamelist)))
		(setq *sectionct* (+ 1 *sectionct*))
		(setq sel_list (getSelection))
		(setq countervar 0)
	)
	;select x
	(print "Select any x sections")
	(setq sel_list (getSelection))
	(setq counterver 0)
	(cond
		((and (not (null sel_list)) (> (sslength sel_list) 0))
			(setq sel_list (getlayer sel_list layerfilter))
			(while (< countervar (sslength sel_list))
				(setq e (entget (ssname sel_list countervar)))
				(setcolor e (list 255 255 255))
				(setq countervar (+ 1 countervar))
			)
			(setq enamelist (LM:ss->ent sel_list))
			(setq *sections* (append *sections* (list enamelist)))
			(setq *sectionct* (+ 1 *sectionct*))
			(setq countervar 0)
			(setq *isx* t)
		)
	)
	(LM:endundo (LM:acdoc))
	(command "._-layer" "_on" "*" "" "")
)

;Description:
;Turn on only savedlayer (set by the gui) and the text layer for savedlayer.
(defun isolate()
	(LM:startundo (LM:acdoc))
	(setlayer savedlayer)
	(cond
		((not isIso)
			(command "._-layer" "_off" "*" "" "")
			(setq clyr (getvar "clayer"))
			(setlayer(strcat "labelText-TEMP " savedlayer))
			(setlayer clyr)
			(setq isIso t)
		)
		(isIso
			(command "._-layer" "_on" "*" "" "")
			(setq isIso nil)
		)
	)
	(LM:endundo (LM:acdoc))
)

;Description:
;label room sections.
(defun labelLayers2 ( / countervar sel ctvar a id sec)
	(command "._-layer" "_off" "*" "" "")
	(command "._-layer" "_on" "tdsb-smsc-building parapet lines" "" "")
	(command "._-layer" "_on" "tdsb-smsc-building canopy" "" "")
	(LM:startundo (LM:acdoc))
	(delbylayer "labelText-TEMP tdsb-smsc-building parapet lines")
	(setlayer "tdsb-smsc-building parapet lines")
	(setq countervar 0)
	(setq ctvar 0)
	(setq sel nil)
	(while (< ctvar *sectionct*);loop through letters except the last one
		(setq sec (nth ctvar *sections*))
		(while (< countervar (length sec));loop through numbers
			(setq a (ssadd));init a
			(cond ((and *isx* (= ctvar (- *sectionct* 1))) (setq id (strcat "X" (itoa (+ 1 countervar)))));set as x if there is x and it's the last letter
				(t (setq id (strcat (chr (+ 65 ctvar)) (itoa (+ 1 countervar)))));otherwise set the letter
			)
			;get input: either selection or Undo
			(while (null sel)
				(initget 7 "Undo")
				(setq sel (entsel (strcat "Select " id " or press u to undo")))
			)

			
			(cond 
				((not (= sel "Undo"));if sel is a selection set
					(ssadd (car sel) a)
					(addSiteID (ssname a 0))
					(setSiteID (ssname a 0) (strcat (getschoolnum)"_" featuretype "_" id))
					(if (not (PSC (ssname a 0)))(placeText a id "tdsb-smsc-building parapet lines"))
					(setq countervar (+ 1 countervar))
					(setq sel nil)
				)
				;handle undo
				((= sel "Undo")
					(cond
						((and (<= ctvar 0)(<= countervar 0));if a1
							;Do nothing
							(setq sel nil);reset selection
							(cond ((and *isx* (= ctvar (- *sectionct* 1))) (setq id (strcat "X" (itoa (+ 1 countervar)))));set as x if there is x and it's the last letter
								(t (setq id (strcat (chr (+ 65 ctvar)) (itoa (+ 1 countervar)))));otherwise set the letter
							)
							(if (setq ss (ssget "X" (list (cons 1 id))))(command "erase" ss ""))
						)
						((> countervar 0); if number > 1
							(setq countervar (- countervar 1))
							(setq sel nil);reset selection
							(cond ((and *isx* (= ctvar (- *sectionct* 1))) (setq id (strcat "X" (itoa (+ 1 countervar)))));set as x if there is x and it's the last letter
								(t (setq id (strcat (chr (+ 65 ctvar)) (itoa (+ 1 countervar)))));otherwise set the letter
							)
							(if (setq ss (ssget "X" (list (cons 1 id))))(command "erase" ss ""))
						)
						((and (> ctvar 0)(= countervar 0));if not a but is 1
							(setq countervar (length sec));Exit countervar loop
						)
					)
				)
			);end undo
		);end countervar while

		(cond 
			((= sel "Undo");only if ctvar should be reduced
				(setq ctvar (- ctvar 1))
				(setq sec (nth ctvar *sections*))
				(setq countervar (- (length sec) 1))
				(cond ((and *isx* (= ctvar (- *sectionct* 1))) (setq id (strcat "X" (itoa (+ 1 countervar)))));set as x if there is x and it's the last letter
					(t (setq id (strcat (chr (+ 65 ctvar)) (itoa (+ 1 countervar)))));otherwise set the letter
				)
				(if (setq ss (ssget "X" (list (cons 1 id))))(command "erase" ss ""))
			)
			((not (= sel "Undo"))
				(setq ctvar (+ 1 ctvar))
				(setq countervar 0)
			)
		)
		(setq sel nil)
	);end ctvar while
	(LM:endundo (LM:acdoc))
)

;Description:
;Fix any roof id, replacing old monument id with the new one. Only the section and section number need by specified (i.e. "A4")
(defun fixlabel2 ( / dcl_id2 flag)
	(setq savedid "")
	(setq dcl_id2 (load_dialog "helper.dcl"))
	(setq flag 4)
	(while (> flag 2)
		(if (not (new_dialog "fixwindow" dcl_id2))
			(exit)
		)
		(set_tile "labelbox" savedid)
		(action_tile "back"
			"(done_dialog 0)"
		)
		(action_tile "relabel"
			"(saveid)(done_dialog 4)"
		)

		(setq flag (start_dialog))
		(cond 
			( (= flag 4) (redolabel))
		)
	)
	(unload_dialog dcl_id2)
)

;Description:
;Save the id entered in the fixlabel box before closing the box.
(defun saveid ()
	(setq savedid(get_tile "labelbox"))
	(if(or(= savedid "")(= savedid nil)) (alert "No id entered"))
)

;Description:
;Actually reset the label specified in "fixid".
(defun redolabel ()
	(LM:startundo (LM:acdoc))
	(setq a (ssadd))
	(setq id (strcase savedid))
	(setq sel nil)
	(if (setq ss (ssget "X" (list (cons 1 id))))(command "erase" ss ""))
	(while (null sel)
		(setq sel(entsel (strcat "Select " id "\n")))
	)
	(ssadd (car sel) a)
	(setq sel nil)
	(addSiteID (ssname a 0))
	(setSiteID (ssname a 0) (strcat (getschoolnum) "_" featuretype "_" id))
	(if (not (PSC (ssname a 0)))(placeText a id "tdsb-smsc-building parapet lines"))
	(LM:endundo (LM:acdoc))
)
;Description:
;To determine whether a Polyline of any type Crosses itSelf.
;With 3D Polylines, must have true intersection in 3D, not apparent in 2D.
;Arguments:
;poly: entity to be examined
;Returns: T if self-crossing, nil if not.
(defun PSC (poly / pltyp plobj plverts plints)
  (setq
    pltyp (cdr (assoc 0 (entget poly)))
    plobj (vlax-ename->vla-object poly)
    plverts (length (safearray-value (variant-value (vla-get-Coordinates plobj))))
    plints (/ (length (safearray-value (variant-value (vla-intersectwith plobj plobj acExtendNone)))) 3)
  ); end setq
  (setq plverts (/ plverts (if (= pltyp "LWPOLYLINE") 2 3)))
  (if (vlax-curve-isClosed poly)
    (< plverts plints); then - closed
    (if (equal (vlax-curve-getStartPoint poly) (vlax-curve-getEndPoint poly) 1e-8); else - open
      (<= plverts plints); then - start/end at same place
      (<= plverts (1+ plints)); else - open
    ); if
  ); if
); defun

;Description:
;Fix all ids in a selection set after they were all set to use facility number 0388 rather than the correct one.
(defun C:FIXALL ()
	(setq all (ssget))
  	(setq countervar 0)
  	(while (< countervar (sslength all))
	  	(setq e (ssname all countervar))
	  	(setq oldid (ade_odgetfield e "2" "site_id" 0))
	  	(setq newid (strcat (getschoolnum) (substr oldid 5)))
		(ade_odsetfield e "2" "site_id" 0 newid)
	  	(setq countervar (+ 1 countervar))
	)
)

;Description
;Ask for a selection of polylines
;Returns: A selection set.
(defun getSelection ( / entitylist)
	(print "Select sections by year built:")
	(setq entitylist 
		(ssget "_:L"						;select only on unlocked layers
			(list 
				(cons 0 "LWPOLYLINE")
				(cons 67 (if (eq (getvar "CVPORT") 2) 0 1))
				(cons 410 (if (eq (getvar "CVPORT") 2) "Model" (getvar "CTAB")))
			)
		)
	)
  entitylist
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
;Retrieve the facility id from the document name (assuming the facility id is the first 4 characters of the name)
(defun getschoolnum()
	(setq num (substr (getvar "dwgname") 1 4))
)