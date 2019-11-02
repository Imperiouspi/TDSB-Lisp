;Helps label rooves. Early days of learning lisp and autolisp, so it's not particularly efficient.

(load "Downloaded\\WriteCSV-V1-1");Load CSV writing script by Lee Mac 
(load "Downloaded\\OutlineObjectsV1-1");Using some document management functions by Lee Mac
(load "Downloaded\\del-layer")
(load "colorLines");Load useful functions
(setq featuretype "ROOF");change this string to change feature code when OD is written
(setq featurelist (list "ROOF" "SWAMP"));list of possible feature codes.

;Description:
;Controls DCL
(defun helper ( / dcl_id layerList flag)
	(setq dcl_id (load_dialog "helper.dcl"))
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
	
		(start_list "layer_select" 3)
		(mapcar 'add_list (Table "layer"))
		(end_list)

		(set_tile "layer_select" (itoa (vl-position (getvar "clayer") (Table "layer"))))

		(action_tile "selectobj"
			"(saveLayer)(done_dialog 4)"
		)
		(action_tile "labelobj"
			"(saveLayer)(done_dialog 5)"
		)
		(action_tile "export"
			"(saveLayer)(done_dialog 6)"
		)
		(action_tile "isolate"
			"(saveLayer)(done_dialog 7)"
		)
		(action_tile "fixlabel"
			"(saveLayer)(done_dialog 8)"
		)
		(action_tile "options"
			"(saveLayer)(options)"
		)
		(action_tile "done"
			"(saveLayer)(done_dialog)"
		)

		(setq flag (start_dialog))
		(cond 
			( (= flag 4) (createSections) )
			( (= flag 5) (labelLayers) )
			( (= flag 6) (export) )
			( (= flag 7) (isolate) )
			( (= flag 8) (fixlabel) )
		)
		(set_tile "layer_select" (itoa (vl-position (getvar "clayer") (Table "layer"))))
	)

	(unload_dialog dcl_id)
	(setvar "osmode" oldosmode)
	(setvar "cmdecho" oldcmdecho)
	(print)
)

;Description:
;Save layer when DCL is closed
(defun saveLayer()
	(setq savedlayer(get_tile "layer_select"))
	(if(= savedlayer "") (alert "No layer selected"))
	(setq savedlayer (nth (atoi savedlayer) (Table "layer")))
)

;Description:
;Create "sections" list, color sections
(defun createSections( / color sel_list enamelist)
	(setq colorlist (list (list 230 82 75) (list 60 180 75) (list 255 225 25) (list 0 130 200) (list 245 130 48) (list 145 30 180) (list 70 240 240) (list 240 50 230) (list 210 245 60) (list 250 190 190) (list 0 128 128) (list 230 190 255) (list 170 110 40) (list 255 250 200) (list 128 0 0) (list 170 255 195) (list 128 128 0) (list 255 215 180) (list 0 0 128)))
	(setq *sections* nil)
	(setq *sectionct* 0)
	(setq *isx* nil)
	(setq layerfilter savedlayer);layer to filter for
	(setq sel_list (getSelection))
	(setq countervar 0)
	;select all not x sections
	(LM:startundo (LM:acdoc))
	(while (and (not (null sel_list)) (> (sslength sel_list) 0))
		(setq sel_list (getlayer sel_list layerfilter))
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
(defun labelLayers ( / countervar sel ctvar a id sec)
	(LM:startundo (LM:acdoc))
	(delbylayer (strcat "labelText-TEMP " savedlayer))
	(setlayer savedlayer)
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
					(if (not (PSC (ssname a 0)))(placeText a id savedlayer))
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
;export sections and od to csv file
(defun export( / ctvar countervar sec id)
	(setq ctvar 0)
	(setq countervar 0)
	(setq id "")
	(setq sec nil)
	;build list
	(setq *contents* '())
	(while (< ctvar (- *sectionct* 1));for each section
		(setq sec (nth ctvar *sections*))
		(while (< countervar (length sec));for each polygon in the section
			(setq id (strcat (chr (+ 65 ctvar)) (itoa (+ 1 countervar))));get id
			(setq *contents* (append *contents* (list "\n" (strcat "\"=\"" "\"" (getschoolnum) "\"\"\"") (strcat (getschoolnum) "_" featuretype "_" id) "=SUM(A1)")));create a list of contents to be appended to the file
			(setq countervar (+ 1 countervar))
		)
		(setq ctvar (+ 1 ctvar))
		(setq countervar 0)
	)

	;handle last section (could be section x or the consecutive letter)
	(setq countervar 0)
	(setq sec (nth ctvar *sections*))
	(while (< countervar (length sec))
		(cond (*isx* (setq id (strcat "X" (itoa (+ 1 countervar))))) 
			(t (setq id (strcat (chr (+ 65 ctvar)) (itoa (+ 1 countervar)))))
		)
			(setq *contents* (append *contents* (list "\n" (strcat "\"=\"" "\"" (getschoolnum) "\"\"\"") (strcat (getschoolnum) "_" featuretype "_" id) "=SUM(A1)")))
		(setq countervar (+ 1 countervar))
	)
	;add a comma to every string passed into *contents*
	(setq text "")
	(foreach l *contents*
		(if (not (eq l "\n"))
			(setq l (strcat l ","))
		)
		(setq text (strcat text l));add contents to the text string
	)

	;append to file
	(setq f (open *filename* "w"))
	(write-line (substr text 2) f)
	(close f)
)

;Description:
;Load options window. Unused.
(defun options( / dcl_id1)
	(setq dcl_id1 (load_dialog "helper.dcl"))
	(if (not (new_dialog "optionswindow" dcl_id1))(exit))

	(start_list "feature_select" 3)
	(mapcar 'add_list featurelist)
	(end_list)
  
	(action_tile "back"
		"(saveoptions)(done_dialog)"
	)

	(start_dialog)
	(unload_dialog dcl_id1)
)

;Description:
;Save options
(defun saveoptions ()
	(setq featuretype(get_tile "feature_select"))
  	(setq featuretype (nth (atoi featuretype) featurelist))
)

;Description:
;Fix any roof id, replacing old monument id with the new one. Only the section and section number need by specified (i.e. "A4")
(defun fixlabel( / dcl_id2 flag)
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
	(if (not (PSC (ssname a 0)))(placeText a id savedlayer))
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