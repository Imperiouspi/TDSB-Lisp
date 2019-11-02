;Description:
;Add all lower floors as an xref to the current drawing. Used to align broken master files.
(defun C:XREFFLOORS ( / flist ct clay fname dsh und floor_num)
	(if (not (null	(setq flist (LM:getfiles "Select Drawings" "\\\\TDSBSHARES\\facilities_silo\\Facility-Services\\Standards-Comp-Envir\\Staff\\Record Drawing Master Files\\0000 sdf\\Problems\\Offset" "dwg"))));"\\\\TDSBSHARES\\facilities_silo\\Facility-Services\\Standards-Comp-Envir\\Staff\\Record Drawing Master Files\\0000 sdf" "dwg"))))
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
								(setq floor_num (strcat "0" (substr fname (+ 1 dsh) (- und dsh))))
							)
							(T
								(setq floor_num (strcat "0"(substr fname (+ 1 dsh))))
							)
						)
						(setlayer floor_num)
						(command "-xref" "a" (strcat "" f) "g")
					)
				)
			)
		)
	)
)