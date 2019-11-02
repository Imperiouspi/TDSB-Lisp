;Description
;Stands for Auto EXport Rooms. Will automatically label rooms, and should fix polyface meshes too.
(defun C:AEXR ( / snapmode edgelist roomlist id outlinegon fakeoutline outlinebounds p1 p2 p3 p4 fakeouter roomlist siteid floor_num fname dsh und nameblockSS fullblocklist reply co j isfirst exportlist roomprop proplist roomnum newid exportlist missed total)
	(if (tblsearch "LAYER" "13")
		(command "._laymrg" "N" "13" "" "N" "0" "y" "")
	)
	(removepface)
	(setq checklist (nri:getblockSS))
	(setq snapmode (getvar 'osmode))
	(setvar "osmode" 4779)
	(setq edgelist nil)
	(setq roomlist nil)
	(if (= 0 (c:fixroom))
		(if (not (null (beginexport T)))
			(progn
				(setq roomlist (LM:ss->ent (ssget "X" (list (cons 8 "tdsb-smsc-net area") (cons 0 "LWPOLYLINE")))))
				(pc (ssget "X" (list (cons 8 "tdsb-smsc-net area") (cons 0 "LWPOLYLINE"))))
				(foreach room roomlist
					(if (setq id (ade_odgetfield room "room_id" "room_id" 0))
						(progn (addoldRoomID room)
						(setoldRoomID room id))
					)
				)
				;Sort Clockwise
				;Create an edgelist
				(setq outlinegon (LM:ss->ent (ssget "X" (list (cons 8 "tdsb-smsc-gross area") (cons 0 "LWPolyline")))));List of outline polygons
				(if (null outlinegon)
					(progn
						(setq fakeoutline T)
						(setq outlinebounds (LM:ssboundingbox (ssget "X" (list (cons 8 "tdsb-smsc-net area") (cons 0 "LWPOLYLINE")))))
						(setLayer "tdsb-smsc-gross area")
						(setq p1 (car outlinebounds))
						(setq p3 (cadr outlinebounds))
						(setq p2 (list (car p1) (cadr p3) (caddr p1)))
						(setq p4 (list (car p3) (cadr p1) (caddr p3)))
						(setq outlinebounds (list p1 p2 p3 p4))
						(setq fakeouter (makePL outlinebounds))
						(setq outlinegon (LM:ss->ent (ssget "X" (list (cons 8 "tdsb-smsc-gross area") (cons 0 "LWPolyline")))))
					)
				)

			  	(setq roomlist (nri:sortclockwise roomlist outlinegon));Now contains (ename, centroid, closest edge) for each room
				(setq siteid (substr (getvar "dwgname") 1 4))
				(setq floor_num nil)
				(setq fname (vl-filename-base (getvar "dwgname")))
				(setq dsh (vl-string-search "-" fname))
				(cond 
					((setq und (vl-string-search "_" fname))
						(setq floor_num (substr fname (+ 2 dsh) (- und dsh 1)))
					)
					(T
						(setq floor_num (substr fname (+ 2 dsh)))
					)
				)

				(setq nameblockSS (nri:getblockSS))
				(setq fullblocklist nameblockSS)
				(setq reply 7)
				(if (null nameblockSS)
					(setq reply (ACET-UI-MESSAGE "No blocks found. Continue?" "Room ID" (+ Acet:YESNO)))
					(setq reply 6)
				)
				(if (= reply 6)
					(progn
						(setq co 0)
						(foreach room roomlist
							(addSiteID (car room))
							(if (null (ade_odgetfield room "1" "room_id" 0))
								(progn
									(addoldRoomID (car room))
								)
							)
						)

						(setq j 0)
						(setq isfirst T)
						(setq exportlist '(0))
						(while (< j (length roomlist));Main loop
							(setq roomprop (nth j roomlist))
							
							(addSiteID (car roomprop))
							(setSiteID (car roomprop) siteid)

							(setq proplist (getlabel (car roomprop)))
							
							;Export and write new id
							(cond
								((< j 9)(setq roomnum (strcat "0" "0" (itoa (+ j 1)))))
								((< j 99)(setq roomnum (strcat "0" (itoa (+ j 1)))))
								((< j 999)(setq roomnum (itoa (+ j 1))))
							)
							(setq newid (strcat siteid "_" floor_num "_" roomnum))
							(addnewRoomID (car roomprop))
							(setnewRoomID (car roomprop) newid)
							(if (<= (length exportlist) j)
								(setq exportlist (append exportlist '(0)))
							)
							(setq exportlist (replace exportlist j (list newid (itoa (nth 1 proplist)) (nth 2 proplist) (nth 3 proplist) (nth 4 proplist))))
							(setq j (+ j 1))
						)

				  		(foreach item exportlist
							(write_export siteid (nth 0 item) (nth 1 item) (nth 2 item) (nth 3 item) (nth 4 item))
						)
						(close f)
						(if (not checklist)
							(progn (setq missed "0") (setq total "0"))
							(progn (setq missed (itoa (sslength checklist))) (setq total (itoa (sslength (nri:getblockss)))))
						)
						(alert (strcat "Labelling Complete. Missed " missed " labels of a total of " total "."))
						(setvar 'osmode snapmode)
						;(print)
					)
				)
				(if fakeoutline
					(entdel fakeouter)
				)
			);end progn
		);end if
		(alert "Fix polygons. Broken polylines are now 120,120,120 colour.")
	);end if
)

;Description
;Stands for Not EXport Rooms. Will export rooms, but will not set/overwrite any site ids.
(defun C:NEXR ( / snapmode edgelist roomlist id outlinegon fakeoutline outlinebounds p1 p2 p3 p4 fakeouter roomlist siteid floor_num fname dsh und nameblockSS fullblocklist reply co j isfirst exportlist roomprop proplist roomnum newid exportlist missed total)
	(if (tblsearch "LAYER" "13")
		(command "._laymrg" "N" "13" "" "N" "0" "y" "")
	)
	(removepface)
	(setq checklist (nri:getblockSS))
	(setq snapmode (getvar 'osmode))
	(setvar "osmode" 4779)
	(setq edgelist nil)
	(setq roomlist nil)
	(if (= 0 (c:fixroom))
		(if (not (null (beginexport T)))
			(progn
				(setq roomlist (LM:ss->ent (ssget "X" (list (cons 8 "tdsb-smsc-net area") (cons 0 "LWPOLYLINE")))))
				(pc (ssget "X" (list (cons 8 "tdsb-smsc-net area") (cons 0 "LWPOLYLINE"))))
				(foreach room roomlist
					(if (setq id (ade_odgetfield room "room_id" "room_id" 0))
						nil;(progn (addoldRoomID room))(setoldRoomID room id))
					)
				)
				;Sort Clockwise
				;Create an edgelist
				(setq outlinegon (LM:ss->ent (ssget "X" (list (cons 8 "tdsb-smsc-gross area") (cons 0 "LWPolyline")))));List of outline polygons
				(if (null outlinegon)
					(progn
						(setq fakeoutline T)
						(setq outlinebounds (LM:ssboundingbox (ssget "X" (list (cons 8 "tdsb-smsc-net area") (cons 0 "LWPOLYLINE")))))
						(setLayer "tdsb-smsc-gross area")
						(setq p1 (car outlinebounds))
						(setq p3 (cadr outlinebounds))
						(setq p2 (list (car p1) (cadr p3) (caddr p1)))
						(setq p4 (list (car p3) (cadr p1) (caddr p3)))
						(setq outlinebounds (list p1 p2 p3 p4))
						(setq fakeouter (makePL outlinebounds))
						(setq outlinegon (LM:ss->ent (ssget "X" (list (cons 8 "tdsb-smsc-gross area") (cons 0 "LWPolyline")))))
					)
				)

			  	(setq roomlist (nri:sortclockwise roomlist outlinegon));Now contains (ename, centroid, closest edge) for each room
				;(setq siteid (substr (getvar "dwgname") 1 4))
				(setq floor_num nil)
				(setq fname (vl-filename-base (getvar "dwgname")))
				(setq dsh (vl-string-search "-" fname))
				(cond 
					((setq und (vl-string-search "_" fname))
						(setq floor_num (substr fname (+ 2 dsh) (- und dsh 1)))
					)
					(T
						(setq floor_num (substr fname (+ 2 dsh)))
					)
				)

				(setq nameblockSS (nri:getblockSS))
				(setq fullblocklist nameblockSS)
				(setq reply 7)
				(if (null nameblockSS)
					(setq reply (ACET-UI-MESSAGE "No blocks found. Continue?" "Room ID" (+ Acet:YESNO)))
					(setq reply 6)
				)
				(if (= reply 6)
					(progn
						(setq co 0)
						(foreach room roomlist
							(addSiteID (car room))
							(if (null (ade_odgetfield room "1" "room_id" 0))
								(progn
									(addoldRoomID (car room))
								)
							)
						)

						(setq j 0)
						(setq isfirst T)
						(setq exportlist '(0))
						(while (< j (length roomlist));Main loop
							(setq roomprop (nth j roomlist))
							
							(addSiteID (car roomprop))
							;(setSiteID (car roomprop) siteid)

							(setq proplist (getlabel (car roomprop)))
							
							;Export and write new id
							(cond
								((< j 9)(setq roomnum (strcat "0" "0" (itoa (+ j 1)))))
								((< j 99)(setq roomnum (strcat "0" (itoa (+ j 1)))))
								((< j 999)(setq roomnum (itoa (+ j 1))))
							)
							(setq newid (strcat siteid "_" floor_num "_" roomnum))
							(addnewRoomID (car roomprop))
							;(setnewRoomID (car roomprop) newid)
							(if (<= (length exportlist) j)
								(setq exportlist (append exportlist '(0)))
							)
							(setq exportlist (replace exportlist j (list newid (itoa (nth 1 proplist)) (nth 2 proplist) (nth 3 proplist) (nth 4 proplist))))
							(setq j (+ j 1))
						)

				  		(foreach item exportlist
							(write_export siteid (nth 0 item) (nth 1 item) (nth 2 item) (nth 3 item) (nth 4 item))
						)
						(close f)
						(if (not checklist)
							(progn (setq missed "0") (setq total "0"))
							(progn (setq missed (itoa (sslength checklist))) (setq total (itoa (sslength (nri:getblockss)))))
						)
						(alert (strcat "Labelling Complete. Missed " missed " labels of a total of " total "."))
						(setvar 'osmode snapmode)
						;(print)
					)
				)
				(if fakeoutline
					(entdel fakeouter)
				)
			);end progn
		);end if
		(alert "Fix polygons. Broken polylines are now 120,120,120 colour.")
	);end if
)