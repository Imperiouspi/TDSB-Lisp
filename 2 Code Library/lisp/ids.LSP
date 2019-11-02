;Functions to add monument ids to various features on site plans. Functions can be called by themselves, but are called in "monumentids.lsp".
;Generally follow form:
;(id_feature "Layer Name" "List of four letter codes associated with layer")

;Description:
;Add a facility id to every object.
(defun C:IDS ()
	(c:fac_id)
)

;Description:
;Adds the facility number in site_id object data, to any object that does not already have a site id.
(defun C:NEWFIELDS( / ct)
	(setq ct 0)
	(foreach obj (LM:ss->ent(ssget "X"))
		(addSiteID obj)
		(if (or (= (ade_odgetfield obj "2" "site_id" 0) "") (null (ade_odgetfield obj "2" "site_id" 0)))
			(setSiteID obj (substr (getvar "dwgname") 1 4))
			(setq ct (+ ct 1))
		)
	)
	ct
)

;Description:
;Adds the facility number in site_id object data, to any object that does not already have a site id.
(defun C:FAC_ID( / ct)
	(setq ct 0)
	(command "-layer" "u" "*" "")
	(command "-layer" "t" "*" "")
	(command "-layer" "on" "*" "")
	(foreach obj (LM:ss->ent(ssget "X"))
		(addODTable obj "3" "fac_id")
		(if (or (= (ade_odgetfield obj "3" "fac_id" 0) "") (null (ade_odgetfield obj "3" "fac_id" 0)))
			(ade_odsetfield obj "3" "fac_id" 0 (substr (getvar "dwgname") 1 4))
			(setq ct (+ ct 1))
		)
	)
	ct
)

;Description:
;Add Monument ID to a generic layer.
;If in numbered mode, will set id as facility#_XXXX_NUM, where NUM is a two digit number. The first feature will be assigned _01
;If in letter mode, will set id as facility#_XXXX_Y, where Y is a single letter. The first feature will be assigned _A
;Arguments:
;layname: string. layer name of feature
;label: string. four letter code associated with layer (e.g. "GRSS" or "WALK" or "ROOF")
;mode: string. "num" to use number mode, and "let" to use letter mode. 
;isclose: bool. should this layer be automatically closed during execution?
(defun id_layer (layname label mode isclose / objlist outlinegon id id_str)
	(if (not (null (setq objlist (ssget "X" (buildSelfilter (list "LWPOLYLINE") (list layname) nil)))))
		(progn
			(pc objlist)
			(setq objlist (LM:ss->ent objlist))
			;Sort Clockwise
			;Create an edgelist
			(setq outlinegon (LM:ss->ent(gbo)))
			(if (not (null outlinegon))
				(progn
					(setq objlist (sortclockwise objlist outlinegon));Now contains (ename, centroid, closest edge) for each object
					;Reorder based on the entrance
					(setq id 1)
					(foreach obj objlist
						(cond
							((= mode "num")
								(cond
									((< id 9)(setq id_str (strcat "0" (itoa id))))
									((< id 99)(setq id_str (strcat "" (itoa id))))
								)
							)
							((= mode "let")
								(setq id_str (chr (+ 64 id)))
							)
						)
						(addSiteID (car obj))
						(setSiteID (car obj) (strcat *siteid* "_" label "_" id_str))
						;(print (strcat *siteid* "_" label "_" id_str))
						(setq id (+ id 1))
					)
					(if (null isclose) (opc (ssget "X" (buildSelfilter (list "LWPOLYLINE") (list layname) nil))))
				);end progn
				(prompt "No outline polyline found, ending\n");No outline found
			);End if
		)
	)
);end defun

;Description:
;Label the layer based on their outline (e.g. playscape label from playground outline).
;Arguments:
;layname: Name of the layer
;parentlayer: Name of the outline layer
;label: 4-letter code for the layer. This method only accepts a string
;mode: "let" or "num", to specify whether the labels use A-Z or 0, 1, 2...
;isclose: Whether or not to close the polygons after they've been labelled
;byhand: label with a polyline path (T), or automatically (nil).
(defun id_layer_child (layname parentlayer label mode isclose byhand / objlist outlinegon id id_str)
	(setq goodlist nil)
	(setq parents (ssget "X" (buildSelfilter (list "LWPOLYLINE") parentlayer nil)))
	(foreach parent (LM:ss->ent parents)
		(setq pid (substr (ade_odgetfield parent "2" "site_id" 0) (strlen (ade_odgetfield parent "2" "site_id" 0))))
		(if (not (null (setq objlist (ssget "X" (buildSelfilter (list "LWPOLYLINE") (list layname) nil)))))
			(progn
				(if isclose (pc objlist))
				(setq objlist (LM:ss->ent objlist))
				;Sort Clockwise
				;Create an edgelist
				(setq outlinegon (list parent))
				(if (not (null outlinegon))
					(progn
						(setq objlist (sortclockwise objlist outlinegon));Now contains (ename, centroid, closest edge) for each object
						;Reorder based on the entrance
						(setq id 1)
						(foreach obj objlist
							(if (= 1 (rem (testpt (nth 0 (get_obj_point (car obj))) (nth 1 (get_obj_point (car obj))) (LM:ent->pts parent 50)) 2))
								(progn 
									(cond
										((= mode "num")
											(cond
												((< id 9)(setq id_str (strcat pid "0" (itoa id))))
												((< id 99)(setq id_str (strcat pid "" (itoa id))))
											)
										)
										((= mode "let")
											(setq id_str (chr (+ 64 id)))
										)
									)
									(addSiteID (car obj))
									(setSiteID (car obj) (strcat (substr (getvar "dwgname") 1 4) "_" label "_" id_str))
									;(print (strcat *siteid* "_" label "_" id_str))
									(setq id (+ id 1))
									(setq goodlist (append goodlist (list (car obj))))
								)
							)
						)
						(if (null isclose) (opc (ssget "X" (buildSelfilter (list "LWPOLYLINE") (list layname) nil))))
					);end progn
					(prompt "No outline polyline found, ending\n");No outline found
				);End if
			);end progn
		);end if
	);end foreach
	(setq id 1)
	(setq objs (ssadd))
	(foreach e (LM:ss->ent (ssget "X" (list (cons 8 layname))))
		(if (and (not (null goodlist)) (null (member e goodlist)))
			(progn 
				(if byhand
					(setq objs (ssadd e objs))
					(progn (cond
						((= mode "num")
							(cond
								((< id 9)(setq id_str (strcat "0" (itoa id))))
								((< id 99)(setq id_str (strcat "" (itoa id))))
							)
						)
						((= mode "let")
							(setq id_str (chr (+ 64 id)))
						)
					)
					(addSiteID e)
					(setSiteID e (strcat (substr (getvar "dwgname") 1 4) "_" label "_" id_str))
					;(print (strcat *siteid* "_" label "_" id_str))
					(setq id (+ id 1)))
				)
			)
		)
	)
	(if (not (null objs)) (id_set_by_line objs layname label mode nodel))
);end defun

;Description:
;Add id to the landscape layer. If a landscape layer exists, will ask whether any forests exist (usually none do on sites).
;If a forest is present on site, will loop through all landscape polylines and ask if each one is a forest feature.
;It tries to highlight each polyline with a white box as it goes, and zooms to each one, but the white box is erased by a redraw and is not always visible.
;Arguments:
;layname: "tdsb-smsc-landscape".
;labels: List of labels associated with the forest ("FRST")
(defun id_forest (layname labels / for_id gr_id objlist outlinegon reply plreply id_str label)
	(setq for_id 0)
	(setq gr_id 0)
	(if (not (null (setq objlist (ssget "X" (buildSelfilter (list "LWPOLYLINE") (list layname) nil)))));Get all landscape
		(progn
			(setq objlist (LM:ss->ent objlist))
			;Is there a forest?
			(setq outlinegon (LM:ss->ent(gbo)))
			(if (not (null outlinegon))
				(progn
					(setq objlist (mapcar 'car (sortclockwise objlist outlinegon)))
				  
					(setq reply(ACET-UI-MESSAGE "Is there a forest on site?" "ID helper" (+ Acet:YESNO)))
					(if (= reply 6)
						(foreach obj objlist
							(highlight obj)
							(setq plreply (ACET-UI-MESSAGE "Is this polygon a forest?" "ID helper" (+ Acet:YESNO)))
							(if (= plreply 6)
								(progn
									(cond
										((< for_id 9)(setq id_str (strcat "0" (itoa (+ for_id 1)))))
										((< for_id 99)(setq id_str (strcat "" (itoa (+ for_id 1)))))
									)
									(setq label (nth 1 labels))
									(setq for_id (+ for_id 1))
								)
								(progn
									(cond
										((< gr_id 9)(setq id_str (strcat "0" (itoa (+ gr_id 1)))))
										((< gr_id 99)(setq id_str (strcat "" (itoa (+ gr_id 1)))))
									)
									(setq label (nth 0 labels))
									(setq gr_id (+ gr_id 1))
								)
							)
							(addSiteID obj)
							(setSiteID obj (strcat *siteid* "_" label "_" id_str))
							;(print (strcat *siteid* "_" label "_" id_str))
							(setq labelct (+ labelct 1))
							(redraw)
						)
						(vla-ZoomExtents (vlax-get-acad-object))

					)
					(if (= reply 7)
						(id_layer layname (nth 0 labels) "num" T)
					)
				)
			)
		)
	)
)

;ignore. (replaced)
;Description:
;Add id to the playscapes. Looks for a surrounding playground outline, and then adds the id in the form: Facitilty#_PLAY_X##
;Unfortunately, this is unreliable, and also does not correctly increase index as new playscapes are found within playground outlines, so it was done by hand rather than bother fixing this code.
;To fix: A list of values, length = # of playground outlines, and keep track of how many playscapes have been found in each.
;	OR follow the form of id_parking, and loop through outlines and check which playscapes are inside.
;If a playscape was not inside, it was labelled as: Facitilty#_PLAY_##, clockwise from enterance 1.
;Not used, do it manually.
;Arguments:
;layname: "tdsb-smsc-playground outline"
;label: list. ("PLAY")
(defun id_playscape (layname label / objlist pllist id id_str c outline_id)
	(if (not (null (setq objlist (ssget "X" (buildSelfilter (list "LWPOLYLINE") (list layname) nil)))))
		(progn
			(setq objlist (LM:ss->ent objlist))
			(setq pllist (LM:ss->ent (ssget "X" (buildSelfilter (list "LWPOLYLINE") (list "tdsb-smsc-playground outline") nil))))
			(foreach obj objlist
				(setq id 0)
				(setq id_str "OUTLINE NOT FOUND")
				(foreach ploutline pllist
					(setq c (getcenter (ssadd obj)))
					(addSiteID obj)
					(if (= 1 (rem (testpt (car c) (cdr c) (LM:ent->pts ploutline 50)) 2))(progn 
						(setq outline_id (ade_odgetfield ploutline "2" "site_id" 0))
						(setq id_str (substr outline_id (strlen outline_id)))
						(cond
							((< id 9)(setq id_str (strcat id_str "0" (itoa (+ id 1)))))
							((< id 99)(setq id_str (strcat id_str "" (itoa (+ id 1)))))
						)
						(setq id (+ id 1))
					))
					(setSiteID obj (strcat *siteid* "_" label "_" id_str))
				)
			)
		)
	)
)

;ignore. (replaced)
;Description:
;Add id to parking points. For each parking lot, it distinguishes all disabled parking spaces (with (chgdspl)), and then assigns ids clockwise as normal.
;Arguments:
;layname: "tdsb-smsc-parking points"
;labels: list. ("PARK" "DSPL")
(defun id_parking (layname labels / label parkpointlist parkinglist id_str c norm_id dspl_id counter singleparkinglist outline_id letter )
	(setq label (nth 0 labels))
	(if (not (null (setq parkpointlist (ssget "X" (buildSelfilter (list "POINT") (list layname) nil)))))
		(progn
			(setq parkpointlist (LM:ss->ent parkpointlist))
			(chgdspl parkpointlist)
			(setq parkinglist (LM:ss->ent (ssget "X" (buildSelfilter (list "LWPOLYLINE") (list "tdsb-smsc-road") nil))))
			(foreach obj parkpointlist
				(setq id_str "OUTLINE NOT FOUND")
			  	(setq c (cdr (assoc 10 (entget obj))))
				(addSiteID obj)
				(foreach ploutline parkinglist
						(if (= 1 (rem (testpt (nth 0 c) (nth 1 c) (LM:ent->pts ploutline 50)) 2))(progn 
							(setq outline_id (ade_odgetfield ploutline "2" "site_id" 0))
							(setq id_str (substr outline_id (strlen outline_id)))
						)
					)
					(setSiteID obj (strcat *siteid* "_" label "_" id_str))
				)
			)

			(foreach pl parkinglist
				(setq norm_id 0)
				(setq dspl_id 0)
				(setq counter 0)
				(setq singleparkinglist (list))
				(setq outline_id (ade_odgetfield pl "2" "site_id" 0))
				(setq letter (substr outline_id (strlen outline_id)))
				(foreach point parkpointlist
					(if (wcmatch (ade_odgetfield point "2" "site_id" 0) (strcat "*_" letter))
						(setq singleparkinglist (append singleparkinglist (list point)))
					)
					(setq counter (+ counter 1))
				)
				(setq singleparkinglist (mapcar 'car (sortclockwisePt singleparkinglist (list pl))))
				(foreach point singleparkinglist
					(setq id_str letter)
					(if (/= (cdr (assoc 62 (entget point))) 5)
						(progn
							(cond
								((< norm_id 9)(setq id_str (strcat id_str "0" (itoa (+ norm_id 1)))))
								((< norm_id 99)(setq id_str (strcat id_str "" (itoa (+ norm_id 1)))))
								((< norm_id 999)(setq id_str (strcat id_str "" (itoa (+ norm_id 1)))))
							)
							(setq norm_id (+ norm_id 1))
							(setq label (nth 0 labels))
						)
						(progn
							(cond
								((< dspl_id 9)(setq id_str (strcat id_str "0" (itoa (+ dspl_id 1)))))
								((< dspl_id 99)(setq id_str (strcat id_str "" (itoa (+ dspl_id 1)))))
								((< dspl_id 999)(setq id_str (strcat id_str "" (itoa (+ dspl_id 1)))))
							)
							(setq dspl_id (+ dspl_id 1))
							(setq label (nth 1 labels))
						)
					)
					(setSiteID point (strcat *siteid* "_" label "_" id_str))
				)
			)
		)
	)
)

;ignore. (not used)
;Description:
;Add Ids to portables. This is found in model space, and was assumed to be in a "smsc-room label-small" block. This is inconsistent, and is probably better done by hand.
;Arguments:
;layname: "tdsb-smsc-portables"
;labels: ""
(defun id_portables (layname labels / objlist blocks ct portables i pt)
	(if (not (null (setq objlist (ssget "X" (buildSelfilter (list "LWPOLYLINE") (list layname) nil)))))
		(progn ;Move to 8.5x11 space
		(PSS)
		;Find Labels
		(if (not (null (setq blocks (ssget "X" (list (cons 2 "smsc-room label-small"))))))
		(progn 
		(setq ct 0)
		(repeat (sslength blocks)
			(if (/=(substr (LM:getattributevalue (ssname blocks ct) "ROOMUSAGE") 1 1) "P")
				(setq blocks (ssdel (ssname blocks ct) blocks))
				(setq ct (+ ct 1))
			)
		)
		;CHSPACE
		(command "chspace" blocks "")
		;Assign IDS to whatever portable they're in
		(setq portables (LM:ss->ent (ssget "X" (buildSelfilter (list "LWPOLYLINE") (list "tdsb-smsc-portables") nil))))
		(foreach port portables
			(setq i 0)
			(addSiteID port)
			(repeat (sslength blocks)
				(setq pt (getorigin (ssname blocks i)))
				(if (= 1 (rem (testpt (car pt)(cadr pt) (LM:ent->pts port 50)) 2))
					(setSiteID port (LM:getattributevalue (ssname blocks i) "ROOM_ID#"))
				)
			)
		)
		;CHSPACE
		(setq blocks (ssget "X" (list (cons 2 "smsc-room label-small"))))
		(command "chspace" blocks "")
		))
		;Move to model space
		(MSS)
	))
)

;Description:
;Labels by distance to the building outline centroid. Includes "[layname] 2" to use for soccerfields and baseball diamonds.
;Arguments:
;layname: layer name to label
;labels: list of 4 letter codes to add to the label.
(defun id_field (layname labels / objlist outlinegon objlist id id_str)
	(setq layname (list layname (strcat layname " 2")))
	(if (not (null (setq objlist (ssget "X" (buildSelfilter (list "LWPOLYLINE") layname nil)))))
		(progn
			(setq objlist (LM:ss->ent objlist))
			;Sort Clockwise
			;Create an edgelist
			(setq outlinegon (LM:ss->ent (ssget "X" (list (cons 8 "tdsb-smsc-building outline") (cons 0 "LWPOLYLINE")))))
			(if (not (null outlinegon))
				(progn
					(setq objlist (sortbydist objlist outlinegon));Now contains (ename, centroid, closest edge) for each object
					;Reorder based on the entrance
					(setq id 1)
					(foreach obj objlist
						(setq id_str (chr (+ 64 id)))
						(addSiteID (car obj))
						(setSiteID (car obj) (strcat *siteid* "_" labels "_" id_str))
						;(print (strcat *siteid* "_" label "_" id_str))
						(setq id (+ id 1))
					)
				);end progn
				(prompt "No outline polyline found, ending\n");No outline found
			);End if
		)
	)
)

;Description:
;Set the site id of objects, following the path of a polyline selected or drawn by the user.
;Arguments:
;layname: Name of the layer
;parentlayer: Name of the outline layer
;mode: "let" or "num", to specify whether the labels use A-Z or 0, 1, 2...
;isclose: Whether or not to close the polygons after they've been labelled
(defun id_layer_line (layname label mode isclose / objlist outlinegon id id_str)
	(if (not (null (setq objlist (ssget "X" (buildSelfilter (list "LWPOLYLINE") (list layname) nil)))))
		(progn
			(if isclose (pc objlist))
			(setq objlist (LM:ss->ent objlist))
			;Sort Clockwise
			;Create an edgelist
			(setq path (LM:ss->ent(entsel)))
			(if (not (null path))
				(progn
					(setq objlist (sort_path objlist path));Now contains (ename, centroid, closest edge) for each object
					;Reorder based on the entrance
					(setq id 1)
					(foreach obj objlist
						(cond
							((= mode "num")
								(cond
									((< id 9)(setq id_str (strcat "0" (itoa id))))
									((< id 99)(setq id_str (strcat "" (itoa id))))
								)
							)
							((= mode "let")
								(setq id_str (chr (+ 64 id)))
							)
						)
						(addSiteID (car obj))
						(setSiteID (car obj) (strcat *siteid* "_" label "_" id_str))
						;(print (strcat *siteid* "_" label "_" id_str))
						(setq id (+ id 1))
						(setq labelct (+ labelct 1))
					)
				);end progn
				(prompt "No outline polyline found, ending\n");No outline found
			);End if
		)
	)
)