(defun c:xreffloors ()
	(if (not (null	(setq flist (LM:getfiles "Select Drawings" "H:\\Map 3d\\Test Drawings\\sdf" "dwg"))));"\\\\TDSBSHARES\\facilities_silo\\Facility-Services\\Standards-Comp-Envir\\Staff\\Record Drawing Master Files\\0000 sdf" "dwg"))))
		(progn 
			(if (null (vl-position "4" (ade_odtablelist)))
				(ade_oddefinetab ;define table
					(list 
						(cons "tablename" "4")
						'("tabledesc" . "")
						(list "columns"
							( list 
								(cons "colname" "room_id2")
								'("coldesc" . "")
								'("coltype" . "character")
								'("defaultval" . "")
							)
						)
					)
				)
			)
			(setq ct 0)
			(setq clay (getvar "clayer"))
			(foreach f flist
				(setq fname (vl-filename-base f))
				(if (not (wcmatch fname "*-R*"))
					(progn
						(setq dsh (vl-string-search "-" fname))
						(cond 
							((setq und (vl-string-search "_" fname))
								(setq floor (strcat "0" (substr fname (+ 1 dsh) (- und dsh))))
							)
							(T
								(setq floor (strcat "0"(substr fname (+ 1 dsh))))
							)
						)
						(setlayer floor)
						(command "-xref" "a" (strcat "" f))
					)
				)
			)
		)
	)
)