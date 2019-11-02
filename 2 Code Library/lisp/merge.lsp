;Commands to merge drawings into one as blocks.
;Mergecad can be used for site plans and general drawings. Mergefloors will add blocks to layers specifying which floor it represents. (0-floor#)

;Description
;Import selected drawings as blocks on the current layer.
(defun C:MERGECAD ( / flist ct)
	(if (not (null (setq flist (LM:getfiles "Select Drawings" "\\\\TDSBSHARES\\facilities_silo\\Facility-Services\\Standards-Comp-Envir\\Staff\\Record Drawing Master Files\\0000 sdf\\edited by Noah" "dwg"))))
		(progn
			(setq ct 0)
			(foreach f flist
				(command "_-INSERT" f "0,0" "1" "" "" "")
			)
		)
	)
)

;Description:
;Import selected drawings exploded onto the current layer.
(defun C:MERGEXCAD ( / flist ct)
	(if (not (null (setq flist (LM:getfiles "Select Drawings" "\\\\TDSBSHARES\\facilities_silo\\Facility-Services\\Standards-Comp-Envir\\Staff\\Record Drawing Master Files\\0000 sdf\\edited by Noah" "dwg"))))
		(progn
			(setq ct 0)
			(foreach f flist
				(command "_-INSERT" (strcat "*" f) "0,0" "1" "" "" "")
			)
		)
	)
)

;Description:
;Replace each same-named drawing with the newly selected file. Matches site id and floor. (first 6 characters)
(defun C:REPLACECAD ( / blks flist ct id SS1)
	(setq blks (LM:ss->ent (ssget "X" '((0 . "INSERT")))))
	(if (not (null (setq flist (LM:getfiles "Select Drawings" "\\\\TDSBSHARES\\facilities_silo\\Facility-Services\\Standards-Comp-Envir\\Staff\\Record Drawing Master Files\\0000 sdf\\edited by Noah" "dwg"))))
		(progn
			(setq ct 0)
			(foreach f flist
				(setq id (substr (vl-filename-base f) 1 6))
				(foreach block blks
					(if (not (null (entget block)))
						(if (wcmatch (cdr (assoc 2 (entget block))) (strcat id "*"))
							(progn
								(setq SS1 (ssget "X" (list '(0 . "INSERT") (assoc 2 (entget block)))))
								(command "erase" ss1 "")
								(command "-purge" "B"  "N" (cdr (assoc 2 (entget block))))
								(command "_regenall")
							)
						)
					)
				)
				(command "_-INSERT" (strcat "" f) "0,0" "1" "" "" "")
			)
		)
	)
)

;Description
;Import selected drawings as blocks, seperating each onto the appropriate layer (e.g. 0-1 for first floor, 0-2 for second, etc.)
(defun C:MERGEFLOORS ( / flist ct clay fname dsh und floor_num)
	(if (not (null	(setq flist (LM:getfiles "Select Drawings" "H:\\Map 3d\\Test Drawings\\sdf" "dwg"))));"\\\\TDSBSHARES\\facilities_silo\\Facility-Services\\Standards-Comp-Envir\\Staff\\Record Drawing Master Files\\0000 sdf" "dwg"))))
		(progn 
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
						(command "_-INSERT" (strcat "" f) "0,0" "1" "" "" "")
					)
				)
			)
		)
	)
)

;Description:
;Meant to automate floor labelling, like batchlisp.
;doesn't work.
(defun C:FLOORNUM (extlist flist ct clay fname dsh und floor_num extsel)
	(setvar "sdi" 1)
	(setq extlist '(
		("B" "B1" "B2" "Ba" "Bb" "Bc" "bd")
		("1" "1a" "1b" "1c" "1d" "1e" "1f" "1g" "1h" "1i" "1j" "1k" "1l" "1o" "1p" "1q" "1r" "1s" "1t")
		("2" "2a" "2b" "2c" "2d" "22")
		("3" "3a" "3b")
		("4" "4a")
		("5" "5a")
		("6" "6a")
		("M" "Ma" "Mb")
		("BM" "BMa")
		("GM")
		("1M" "1Ma")
		("2M" "2Ma")
		("3M")
		("Fb")
		("G")
		("P" "P1" "P2")
		("PH" "PHb" "PHc"))
	)
	(if (not (null	(setq flist (LM:getfiles "Select Drawings" "\\\\TDSBSHARES\\facilities_silo\\Facility-Services\\Standards-Comp-Envir\\Staff\\Record Drawing Master Files\\0000 sdf\\edited by Noah" "dwg"))))
		(progn
			(setq ct 0)
			(setq clay (getvar "clayer"))
			(foreach f flist
				(setq fname (vl-filename-base f))
				(if (not (wcmatch fname "*-R*"))
					(progn
						(setq dsh (vl-string-search "-" fname))
						(cond 
							((setq und (vl-string-search "_" fname))
								(setq floor_num (substr fname (+ 2 dsh) (- und dsh 1)))
							)
							(T
								(setq floor_num (substr fname (+ 2 dsh)))
							)
						)
					)
				)
				(setq extsel "whoops")
				(foreach ext extlist
					(if (not (null (member floor_num ext)))
						(setq extsel (car ext))
					)
				)
				(setvar "filedia" 0)
				(command "_qsave")
				(if(> (getvar "dbmod") 0)	
					(progn (close (open (strcat "H:\\Map 3d\\exports\\floor_" extsel ".dwg") "w"))
					  (command ".open" "Y" (strcat "H:\\Map 3d\\exports\\floor_" extsel ".dwg") "" ""))
					(progn (close (open (strcat "H:\\Map 3d\\exports\\floor_" extsel ".dwg") "w"))
					  (command ".open" (strcat "H:\\Map 3d\\exports\\floor_" extsel ".dwg") "" ""))
				)
				(command "_-INSERT" (strcat "" f) "0,0" "1" "" "" "")
			)

		)
	)
	(setvar "sdi" 0)
	(setvar filedia 1)
)
