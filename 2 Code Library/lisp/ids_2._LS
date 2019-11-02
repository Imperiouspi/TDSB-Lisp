;Description:
;Add monument ids based on a polyline specified or drawn by the user.
;Arguments:
;layname: Name of the layer
;label: 4-letter code for the layer. This method only accepts a string
;mode: "let" or "num", to specify whether the labels use A-Z or 0, 1, 2...
;nodel: T to not delete the polyline after the objects have been id'd.
(defun id_by_line (layname label mode nodel / ans path objects results a b p x i d id id_str)
	(setlayer "tdsb-smsc-cityroad")
	(command "._-layer" "_off" "*" "" "")
	(command "._-layer" "_on" layname "" "")
	(command "._-layer" "_on" "tdsb-smsc-cityroad" "" "")
	(command "._-layer" "_on" "tdsb-smsc-property line" "" "")

	(while (not (progn
		;(initget "Path")
		;(setq ans (entsel (strcat layname "\nSelect a path or draw a [P]ath")))
		(setq ans "Path")
		(princ "Draw a Path: ")
		(if (null ans)
			nil
			(if (= "Path" ans)
				(progn (command "_.PLINE")
				(while (= (getvar "cmdnames") "PLINE")
					(command pause)
				)
				(setq path (entlast)))
				(if (= (type (nth 0 ans)) 'ENAME)
					(setq path (nth 0 ans))
				)
			)
		)
	)))
	(setq objects (ssget "X" (list (cons 410 "Model") (cons 8 layname))))
	(if (ssmemb path objects) (ssdel path objects))
	(setq objects (LM:ss->ent objects))
	(setq results (list))
	(foreach obj objects
		(setq mindist 100000)
		(setq i 0)
		(while (< i (- (length (setq pathlist (LM:ent->pts path 50))) 1))
			(setq a (nth i pathlist))
			(setq b (nth (1+ i) pathlist))
			(setq p (get_obj_point obj))
			(setq x (point_on_segment p a b))
			(if (< (setq d (vl (v- x p))) mindist)
				(progn
				(setq mindist d)
				(setq enddist (vl (v- x a)))
				(setq end i))
			)
			(setq i (1+ i))
		)
		(setq results (append results (list (list obj end enddist mindist (cdr (assoc 0 (entget obj)))))))
	)
	(setq results (vl-sort results 'sort_by_segment))
	(setq id 1)
	(foreach res results
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
		(addSiteID (car res))
		(setSiteID (car res) (strcat (substr (getvar "dwgname") 1 4) "_" label "_" id_str))
		;(print (strcat *siteid* "_" label "_" id_str))
		(setq id (+ id 1))
	)
	(if (null nodel) (entdel path))
	(command "._-layer" "_on" "*" "" "")
)

;Description:
;Labels a layer based on the outline of those objects, following a line. For example, playscapes inside a playground. The playground is A, so the playscapes are A01. Not used by any layer as of 2019-08-05
;Arguments:
;layname: Name of the layer
;parentlayer: Name of the outline layer
;label: 4-letter code for the layer. This method only accepts a string
;mode: "let" or "num", to specify whether the labels use A-Z or 0, 1, 2...
;nodel: T to not delete the polyline after the objects have been id'd.
(defun id_by_line_child (layname parentlayer label mode nodel / parents id_letter path)
	(setlayer "tdsb-smsc-cityroad")
	(command "._-layer" "_off" "*" "" "")
	(command "._-layer" "_on" layname "" "")
	(command "._-layer" "_on" "tdsb-smsc-cityroad" "" "")
	(command "._-layer" "_on" "tdsb-smsc-property line" "" "")
	(foreach lay parentlayer (command "._-layer" "_on" lay "" ""))
	(setq goodlist nil)
	(foreach parent (setq parents (LM:ss->ent (ssget "X" (list (cons 410 "Model") (cons 8 parentlayer)))))
		(highlight parent)
		(setq id_Letter (substr (ade_odgetfield parent "2" "site_id" 0) (strlen (ade_odgetfield parent "2" "site_id" 0))))
		(while (not (progn
			(initget "Path Skip")
			(setq ans (getkword (strcat layname "\nDraw a [P]ath, or [S]kip")))
			(if (= "Skip" ans)
				T
				(if (null ans)
					nil
					(if (= "Path" ans)
						(progn (command "_.PLINE")
						(while (= (getvar "cmdnames") "PLINE")
							(command pause)
						)
						(setq path (entlast)))
						(if (= (type (nth 0 ans)) 'ENAME)
							(setq path (nth 0 ans))
						)
					)
				)
			)
		)))
		(if (not (= "Skip" ans)) (progn
			(if (ssmemb path (setq objects (ssget "X" (list (cons 410 "Model") (cons 8 layname))))) (ssdel path objects))
			(setq objects (LM:ss->ent objects))
			(setq results (list))
			(foreach obj objects
				(if (= 1 (rem (testpt (nth 0 (get_obj_point obj)) (nth 1 (get_obj_point obj)) (LM:ent->pts parent 50)) 2))
					(progn (setq mindist 100000)
					(setq i 0)
					(while (< i (- (length (setq pathlist (LM:ent->pts path 50))) 1))
						(setq a (nth i pathlist))
						(setq b (nth (1+ i) pathlist))
						(setq p (get_obj_point obj))
						(setq x (point_on_segment p a b))
						(if (< (setq d (vl (v- x p))) mindist)
							(progn
							(setq mindist d)
							(setq enddist (vl (v- x a)))
							(setq end i))
						)
						(setq i (1+ i))
						(setq goodlist (append goodlist (list (car obj))))
					)
					(setq results (append results (list (list obj end enddist mindist (cdr (assoc 0 (entget obj))))))))
				)
			)
			(setq results (vl-sort results 'sort_by_segment))
			(setq id 1)
			(foreach res results
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
				(addSiteID (car res))
				(setSiteID (car res) (strcat (substr (getvar "dwgname") 1 4) "_" label "_" id_Letter id_str))
				;(print (strcat *siteid* "_" label "_" id_str))
				(setq id (+ id 1))
			)
			(if (null nodel) (entdel path))
		))
	)
	(foreach e (LM:ss->ent (ssget "X" (list (cons 8 layname))))
		(if (and (not (null goodlist)) (null (member e goodlist)))
			(progn 
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
				(addSiteID e)
				(setSiteID e (strcat (substr (getvar "dwgname") 1 4) "_" label "_" id_str))
				;(print (strcat *siteid* "_" label "_" id_str))
				(setq id (+ id 1))
			)
		)
	)
	(command "._-layer" "_on" "*" "" "")
)

;Description:
;Add monument ids based on a polyline specified or drawn by the user. Accepts a selection set rather than a layer name.
;Arguments:
;ss: selection of objects to label
;layname: Name of the layer
;label: 4-letter code for the layer. This method only accepts a string
;mode: "let" or "num", to specify whether the labels use A-Z or 0, 1, 2...
;nodel: T to not delete the polyline after the objects have been id'd.
(defun id_set_by_line (ss layname label mode nodel / ans path objects results a b p x i d id id_str)
	(setlayer "tdsb-smsc-cityroad")
	(command "._-layer" "_off" "*" "" "")
	(command "._-layer" "_on" layname "" "")
	(command "._-layer" "_on" "tdsb-smsc-cityroad" "" "")
	(command "._-layer" "_on" "tdsb-smsc-property line" "" "")

	(while (not (progn
		(initget "Path")
		(print (strcat layname ": Label the objects outside of the outlines. Draw a Path"))
		(setq ans "Path")
		(if (null ans)
			nil
			(if (= "Path" ans)
				(progn (command "_.PLINE")
				(while (= (getvar "cmdnames") "PLINE")
					(command pause)
				)
				(setq path (entlast)))
				(if (= (type (nth 0 ans)) 'ENAME)
					(setq path (nth 0 ans))
				)
			)
		)
	)))
	(setq objects ss)
	(if (ssmemb path objects) (ssdel path objects))
	(setq objects (LM:ss->ent objects))
	(setq results (list))
	(foreach obj objects
		(setq mindist 100000)
		(setq i 0)
		(while (< i (- (length (setq pathlist (LM:ent->pts path 50))) 1))
			(setq a (nth i pathlist))
			(setq b (nth (1+ i) pathlist))
			(setq p (get_obj_point obj))
			(setq x (point_on_segment p a b))
			(if (< (setq d (vl (v- x p))) mindist)
				(progn
				(setq mindist d)
				(setq enddist (vl (v- x a)))
				(setq end i))
			)
			(setq i (1+ i))
		)
		(setq results (append results (list (list obj end enddist mindist (cdr (assoc 0 (entget obj)))))))
	)
	(setq results (vl-sort results 'sort_by_segment))
	(setq id 1)
	(foreach res results
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
		(addSiteID (car res))
		(setSiteID (car res) (strcat (substr (getvar "dwgname") 1 4) "_" label "_" id_str))
		;(print (strcat *siteid* "_" label "_" id_str))
		(setq id (+ id 1))
	)
	(if (null nodel) (entdel path))
	(command "._-layer" "_on" "*" "" "")
)

;Description:
;A modification of id_by_line_child, adapted to include identifying accessible parking.
;Arguments:
;layname: Name of the layer
;parentlayer: Name of the outline layer
;label: 4-letter code for the layer. This method only accepts a string
;mode: "let" or "num", to specify whether the labels use A-Z or 0, 1, 2...
;nodel: T to not delete the polyline after the objects have been id'd.
(defun id_by_line_child_parking (layname parentlayer label mode nodel / parents id_letter path)
	(setlayer "tdsb-smsc-cityroad")
	(command "._-layer" "_off" "*" "" "")
	(command "._-layer" "_on" layname "" "")
	(command "._-layer" "_on" "tdsb-smsc-cityroad" "" "")
	(command "._-layer" "_on" "tdsb-smsc-property line" "" "")
	(command "._-layer" "_on" "tdsb-smsc-road" "" "")
	(command "._-layer" "_on" "tdsb-smsc-parking" "" "")
	(chgdspl (LM:ss->ent (ssget "X" (buildSelfilter (list "POINT") (list "tdsb-smsc-parking points" "tdsb-smsc-parking points u") nil))))
	(foreach parent (setq parents (LM:ss->ent (ssget "X" (list (cons 410 "Model") (cons 8 parentlayer)))))
		(highlight parent)
		(setq id_Letter (substr (ade_odgetfield parent "2" "site_id" 0) (strlen (ade_odgetfield parent "2" "site_id" 0))))
		(while (not (progn
			(initget "Path Skip")
			(setq ans (getkword (strcat layname "\nDraw a [P]ath, or [S]kip")))
			(if (= "Skip" ans)
				T
				(if (null ans)
					nil
					(if (= "Path" ans)
						(progn (command "_.PLINE")
						(while (= (getvar "cmdnames") "PLINE")
							(command pause)
						)
						(setq path (entlast)))
						(if (= (type (nth 0 ans)) 'ENAME)
							(setq path (nth 0 ans))
						)
					)
				)
			)
		)))
		(if (not (= "Skip" ans)) (progn
			(if (ssmemb path (setq objects (ssget "X" (buildSelfilter (list "POINT") (list "tdsb-smsc-parking points" "tdsb-smsc-parking points u") nil)))) (ssdel path objects))
			(setq objects (LM:ss->ent objects))
			(setq results (list))
			(foreach obj objects
				(if (= 1 (rem (testpt (nth 0 (get_obj_point obj)) (nth 1 (get_obj_point obj)) (LM:ent->pts parent 50)) 2))
					(progn (setq mindist 100000)
					(setq i 0)
					(while (< i (- (length (setq pathlist (LM:ent->pts path 50))) 1))
						(setq a (nth i pathlist))
						(setq b (nth (1+ i) pathlist))
						(setq p (get_obj_point obj))
						(setq x (point_on_segment p a b))
						(if (< (setq d (vl (v- x p))) mindist)
							(progn
							(setq mindist d)
							(setq enddist (vl (v- x a)))
							(setq end i))
						)
						(setq i (1+ i))
					)
					(setq results (append results (list (list obj end enddist mindist (cdr (assoc 0 (entget obj))))))))
				)
			)
			(setq results (vl-sort results 'sort_by_segment))
			(setq norm_id 1)
			(setq dspl_id 1)
			(foreach res results
				(if (= (cdr (assoc 8 (entget (car res)))) "tdsb-smsc-parking points u")
					(progn
						(setq id dspl_id)
						(setq lab (nth 1 label))
						(cond
							((= mode "num")
								(cond
									((< id 9)(setq id_str (strcat "00" (itoa id))))
									((< id 99)(setq id_str (strcat "0" (itoa id))))
									((< id 999)(setq id_str (strcat "" (itoa id))))
								)
							)
							((= mode "let")
								(setq id_str (chr (+ 64 id)))
							)
						)
						(addSiteID (car res))
						(setSiteID (car res) (strcat (substr (getvar "dwgname") 1 4) "_" lab "_" id_Letter id_str))
						(setq dspl_id (1+ dspl_id))
					)
					(progn
						(setq id norm_id)
						(setq lab (nth 0 label))
						(cond
							((= mode "num")
								(cond
									((< id 9)(setq id_str (strcat "00" (itoa id))))
									((< id 99)(setq id_str (strcat "0" (itoa id))))
									((< id 999)(setq id_str (strcat "" (itoa id))))
								)
							)
							((= mode "let")
								(setq id_str (chr (+ 64 id)))
							)
						)
						(addSiteID (car res))
						(setSiteID (car res) (strcat (substr (getvar "dwgname") 1 4) "_" lab "_" id_Letter id_str))
						(setq norm_id (1+ norm_id))
					)
				)
			)
			(if (null nodel) (entdel path))
		))
	)
	(command "._-layer" "_on" "*" "" "")
)

;Description:
;ID the specified layer by hand. Can accept a list of labels, will ask which label to apply for each polyline. Enter "D" to stop labelling. 
;Arguments:
;layname: Name of the layer
;label: 4-letter code for the layer. This method can accept a list of labels.
;mode: "let" or "num", to specify whether the labels use A-Z or 0, 1, 2...
;on: A list of layers that should be displayed while labelling by hand.
(defun id_by_hand (layname label mode on / objects label_ctr label_str id id_str ans lab)
	(setlayer "tdsb-smsc-cityroad")
	(command "._-layer" "_off" "*" "" "")
	(command "._-layer" "_on" layname "" "")
	(command "._-layer" "_on" "tdsb-smsc-cityroad" "" "")
	(command "._-layer" "_on" "tdsb-smsc-property line" "" "")
	(foreach lay on (command "._-layer" "_on" lay "" ""))

	(setq objects (LM:ss->ent (ssget "X" (list (cons 8 layname) (cons 410 "Model")))))

	(setq label_ctr nil)
	(dryw isl_ctr nil)
	;sort out the label: is it a list or a single one?
	(setq label_str "")
	(if (= (type label) 'STR)
		(progn (setq label_ctr (append label_ctr '(1))) (setq label_str label))
		(foreach str label (setq label_ctr (append label_ctr '(1))) (setq label_str (strcat label_str str " ")))
	)

	(if (= (type label) 'STR)
		nil
		(foreach str label (setq isl_ctr (append isl_ctr '(0))) (setq label_str (strcat label_str str " ")))
	)
	(setq done nil)
	(foreach obj objects
		(if (not done) (progn
		(initget label_str 1)
		(if (= (type label) 'STR)
			(progn
				(setq lab label)
				(setq id (nth 0 label_ctr))
			)
			(progn
				(setq lab (getkword (strcat "which label? " label_str)))
				(if (= lab "ISLAND")
					(setq id (nth (vl-position lab label) isl_ctr))
					(setq id (nth (vl-position lab label) label_ctr))
				)

			)
		)
		;get the id number
		(if (= lab "ISLAND")
			(setq mode "num")
			(setq isl_parent (car (entsel "Select Parent")))
		)
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
		(setq full_id (strcat (substr (getvar "dwgname") 1 4) "_" lab "_" id_str))
		(if (= lab "ISLAND")
			(progn
				(setq full_id (strcat (ade_odgetfield isl_parent "2" "site_id" 0) "I" id_str))
			)
		)
		
		(initget "Done")
		(while (null (setq ans (entsel (strcat layname ":\nSelect the polyline or [Done]: " id_str)))))
		(if (not done) (setq done (= ans "Done")))
		(if (not done) (progn
		(addSiteID (car ans))
		(setSiteID (car ans) full_id)
		(if (= (type label) 'STR)
			(progn
				(setq label_ctr (list (1+ (nth 0 label_ctr))))
			)
			(progn
				(if (= lab "ISLAND")
					(setq isl_ctr (replace isl_ctr (vl-position lab label) (1+ (nth (vl-position lab label) isl_ctr))))
					(setq label_ctr (replace label_ctr (vl-position lab label) (1+ (nth (vl-position lab label) label_ctr))))
				)
			)
		)))))
	)
	(command "._-layer" "_on" "*" "" "")
)

;Description:
;Label the soccer posts. Will either find which field it's in, or will find the closest field.
;Arguments:
;layname: Name of the layer
;parentlayer: Name of the outline layer
;label: 4-letter code for the layer. This method only accepts a string
;mode: "let" or "num", to specify whether the labels use A-Z or 0, 1, 2...
;isclose: Whether or not to close the polygons after they've been labelled
(defun id_soccer_posts (layname parentlayer label mode isclose / objlist outlinegon id id_str)
	(setq goodlist nil)
	(setq parents (ssget "X" (buildSelfilter (list "LWPOLYLINE") parentlayer nil)))
	(setq ids nil)
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
		(setq ids (append ids (list id)))
	);end foreach
	(setq id 1)

	(setq parents (LM:ss->ent (ssget "X" (buildSelfilter (list "LWPOLYLINE") parentlayer nil))))
	(foreach e (LM:ss->ent (ssget "X" (list (cons 8 layname))))
		(if (and (not (null goodlist)) (null (member e goodlist)))
			(progn
				(setq parent (get_closest e parents))
				(setq index (- (length parents) (length (member parent parents))))
				(setq id (nth index ids))
				(setq pid (substr (ade_odgetfield parent "2" "site_id" 0) (strlen (ade_odgetfield parent "2" "site_id" 0))))
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
				(addSiteID e)
				(setSiteID e (strcat (substr (getvar "dwgname") 1 4) "_" label "_" id_str))
				;(print (strcat *siteid* "_" label "_" id_str))
				(setq id (+ id 1))
				(setq ids (replace ids index id))
			)
		)
	)
);end defun

;Description:
;Loop through each portable and ask user for an id for each.
;Arguments:
;layname: the name of the layer the portables are on
;label: Label for site id. Unused, but needed for compatibility with SMN
(defun id_portables_2 (layname label)
	(command "._-layer" "_off" "*" "" "")
	(command "._-layer" "_on" layname "" "")
	(command "._-layer" "_on" "tdsb-smsc-cityroad" "" "")
	(command "._-layer" "_on" "tdsb-smsc-property line" "" "")
	(command "._-layer" "_on" "tdsb-smsc-building outline" "" "")
	(command "._-layer" "_on" "tdsb-smsc-stairs" "" "")
	(setq objs (ssget "X" (list (cons 8 layname) (cons 410 "Model"))))
	(zmobj (ssget "X" (list (cons -4 "<OR") (cons 8 "tdsb-smsc-portables") (cons 8 "tdsb-smsc-building outline") (cons -4 "OR>") (cons 410 "Model"))))
	(if (not (null objs))
		(progn (setq ans nil)
		(foreach e (LM:ss->ent objs)
			(if (not (= ans "Done"))
				(progn
				(redraw)
				(highlight_nozoom e)
				(initget 5 "Skip Done")
				(setq ans (getint "Enter the Portable ID or [S]kip or [D]one"))
				(cond
					((= ans "Skip"))
					((= ans "Done"))
					((= (type ans) (type 4))
						(setSiteID e (itoa ans))
					)
				))
			)
		))
	)
	(command "._-layer" "_on" "*" "" "")
)

;Description:
;Zoom to a selection set's extents
;Source: <a href="https://www.cadtutor.net/forum/topic/10334-zoom-to-selected-objects/?do=findComment&comment=83856">https://www.cadtutor.net/forum/topic/10334-zoom-to-selected-objects/?do=findComment&comment=83856</a>
;Arguments:
;ss: a selection set
(defun ZmObj  (ss / Minp Maxp lst)
 (vl-load-com)
 (foreach Obj (mapcar 'vlax-ename->vla-object
                (vl-remove-if 'listp
                  (mapcar 'cadr
                    (ssnamex ss))))
   (vla-getBoundingBox Obj 'Minp 'Maxp)
   (setq lst (cons
               (mapcar 'vlax-safearray->list
                 (list Minp Maxp)) lst)))
 (vla-ZoomWindow
   (vlax-get-acad-object)
     (vlax-3D-point
       (car (maxminpnt (mapcar 'car lst))))
       (vlax-3D-point
         (cadr (maxminpnt (mapcar 'cadr lst)))))
)

;Description:
;Find the closest target to the object.
;Arguments:
;object: the object, an ename
;targets: a list of enames
;Returns: the ename of the closest target to object.
(defun get_closest (object targets)
	(setq mindist 10000)
	(setq closest nil)
	(foreach target targets
		(if (< (setq d (dist (get_obj_point object) (get_obj_point target))) mindist)
			(progn (setq mindist d) (setq closest target))
		)
	)
	closest
)

;Description: 
;Comparison function to sort along a line segment
;Arguments:
;a: a list containing relevant information, specifically which line segment and where along the line it is.
;b: a list containing relevant information, specifically which line segment and where along the line it is.
(defun sort_by_segment (a b)
	(if (= (nth 1 a) (nth 1 b))
		(< (nth 2 a) (nth 2 b))
		(< (nth 1 a) (nth 1 b))
	)
)

;Description:
;Pass any object to find the "origin" for that object type. Polyline uses center, points are their own origin, Text uses the text base, Lines use the midpoint.
;Arguments:
;obj: object to find origin of
;Returns: Origin point of object. In form (x y z)
(defun get_obj_point (obj / ty pt pt1 pt2)
	(setq ty (cdr (assoc 0 (entget obj))))
	(cond 
		((= ty "LWPOLYLINE")
			(if (= (cdr (assoc 70 (entget obj))) 1)
				(setq pt (list (car (getcenter (ssadd obj))) (cdr (getcenter (ssadd obj))) 0.0))
				(setq pt (append (avgCentroid obj) (list 0.0)))
			)
		)
		((= ty "POINT")
			(setq pt (cdr (assoc 10 (entget obj))))
		)
		((= ty "TEXT")
			(setq pt (cdr (assoc 10 (entget obj))))
		)
		((= ty "INSERT")
			(setq pt (cdr (assoc 10 (entget obj))))
		)
		((= ty "LINE")
			(setq pt1 (cdr (assoc 10 (entget obj))))
			(setq pt2 (cdr (assoc 11 (entget obj))))
			(setq pt (v* (v+ pt1 pt2) 0.5))
		)
		((= ty "CIRCLE")
			(c:fc)
			(*error* "Circle found, but should now be fixed.")
		)
	)
	pt
)

;Description:
;Find the closest point on a line segment.
;Arguments:
;p: Point
;a: Start of the segment
;b: End of the segment
;Returns: the point on the segment that "p" is closest to.
(defun point_on_segment (p a b / x)
	(setq ab (v- b a))
	(setq ab_hat (v* ab (/ 1.0 (vl ab))))
	(setq x (v- a (v* ab_hat (dot (v- a p) ab))))
	(if (or (> (vl (v- x a)) (vl ab)) (> (vl (v- x b)) (vl ab)))
		(if (> (abs (vl (v- x a))) (abs (vl (v- x b))))
			(setq x b)
			(setq x a)
		)
	)
	x
)

;Description:
;Sort objects based on how far away they are from the center of the polygon
;Arguments:
;objlist: list of objects
;outlinegon: polyline to measure distance from
(defun sortbydist (objlist outlinegon / returnlist)
	(setq returnlist nil)
	;Get center of school (average centroids of the outlinegons)
	(setq c (v* (v++ (mapcar '(lambda (o) (getvcenter (ssadd o))) outlinegon)) (/ 1.0 (length outlinegon))))
	;Get distance to center from each object
	(foreach obj objlist
		(setq returnlist (append returnlist (list (list obj (dist (getvcenter (ssadd obj)) c)))))
	)
	;Sort by that distance
	(vl-sort returnlist '(lambda (a b) (< (nth 1 a) (nth 1 b))))
)