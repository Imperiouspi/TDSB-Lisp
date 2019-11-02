;A collection of functions to help debug a drawing.

;Turn polylines to red if they have not been included in the export. (checked against their new room id)
(defun missedpl ( / )
	(LM:startundo (LM:acdoc))
	(setq roomlist (LM:ss->ent (ssget "_W" (getpoint) (getpoint) (list (cons 8 "tdsb-smsc-net area") (cons 0 "LWPOLYLINE")))))
	(setq savedpath (LM:browseforfolder "Select a folder to export to" "" 0))
	(if (not (null savedpath))
		(progn
			(setq f (open (strcat savedpath "\\export2.csv") "r"))
		)
	)
	(setq fulltext "")

	(while (not (null (setq text (read-line f))))
		(setq fulltext (strcat text " \n" fulltext))
	)
	(foreach room roomlist
		(if (not (null (ade_odgetfield room "4" "room_id2" 0)))
			(if (not (vl-string-search (ade_odgetfield room "4" "room_id2" 0) fulltext))
				(setcolor (entget room) '(255 0 0))
			)
			(setcolor (entget room) '(255 255 0))
		)
	)
	(LM:endundo (LM:acdoc))
)

;Check for labels that don't have the properties DOOR#, DOORNAME, or ROOMUSAGE. 
;I don't remember why this was useful, but it'll change the block colour to red.
(defun brokenlabel ( / )
	(setq boundaryp1 (getpoint))
	(setq boundaryp2 (getpoint))
	(setq blockSS (ssadd))
	(setq blockSS (LM:ss->ent
			(ssget "_W" boundaryp1 boundaryp2
			  (list (cons -4 "<or") (cons 8 "0") (cons 8 "tdsb-smsc-roomlabels") (cons -4 "or>")
			    (cons -4 "<or") (cons 2 "smsc-room label-large")(cons 2 "smsc-room label-medium")
			    (cons 2 "smsc-room label-small")(cons -4 "or>")))))
	(foreach block blockSS
		(if (or (null (LM:getattributevalue block "DOOR#"))
			(null (LM:getattributevalue block "DOORNAME"))
			(null (LM:getattributevalue block "ROOMUSAGE")))
			(setcolor (entget block) '(255 0 0))
		)
	)
)

;Check if parking points have all found their proper outlines. If they have not, their colour will be red.
(defun outlinenotfound ()
	(setq pllist (LM:ss->ent (ssget "X" (buildSelfilter (list "POINT") (list "tdsb-smsc-parking points") nil))))
	(foreach pl pllist
		(if (not (null (vl-string-search "OUTLINE NOT FOUND" (ade_odgetfield pl "2" "site_id" 0))))
			(setcolor (entget pl) '(255 0 0))
		)
	)
)

;Reset the color of each parking point to its original one. Only works after outlinenotfound has been run.
(defun resetpoints ()
	(mapcar 'resetcolor (mapcar 'entget (LM:ss->ent (ssget "X" (list (cons 8 "tdsb-smsc-parking points"))))))
	(print)
)

;Check if a point is in an outline. Verifies the function of (testpt).
(defun C:checkin ()
	(prompt "Get Point")
	(setq pt (ssname (SsgeT) 0))
	(setq c (cdr (assoc 10 (entget pt))))
	(prompt "Get Outline")
	(princ (= 1 (rem (testpt (nth 0 c) (nth 1 c) (LM:ent->pts (ssname (ssget)0) 50)) 2)))
)

;Check how many parking points have not been assigned a number correctly.
(defun nonumber ()
	(setq count 0)
	(setq pllist (LM:ss->ent (ssget "X" (buildSelfilter (list "POINT") (list "tdsb-smsc-parking points") nil))))
	(foreach pl pllist
		(if (not (null (wcmatch (ade_odgetfield pl "2" "site_id" 0) "*_A,*_B,*_C")))
			(setq count (+ count 1))
		)
	)
	count
)

;Clear the site id of every parking point.
(defun clearid ()
	(setq count 0)
	(setq pllist (LM:ss->ent (ssget "X" (buildSelfilter (list "POINT") (list "tdsb-smsc-parking points") nil))))
	(foreach pl pllist
		(setSiteID pl "")
	)
	count
)

;Run a check as the last process.
;Run SMN again, and fix the forest id (should be fixed on new runs)
(defun c:chk ()
	(c:smn)
	(fixforestid)
)

;Replace site ids that were labelled GRASS with GRSS instead, and replace _9 with _09 as it should be.
;Returns: number of GRASS labels fixed.
(defun fixforestid ( / )
	(setq count 0)
	(setq pllist (LM:ss->ent (ssget "X" (buildSelfilter (list "LWPOLYLINE") (list "tdsb-smsc-landscape") nil))))
	(foreach pl pllist
		(if (not (null (wcmatch (ade_odgetfield pl "2" "site_id" 0) "*GRASS*")))
			(progn
				(setSiteID pl (vl-string-subst "GRSS" "GRASS" (ade_odgetfield pl "2" "site_id" 0)))
				(setq count (+ count 1))
				(if (wcmatch (ade_odgetfield pl "2" "site_id" 0) "*GRASS_9*")
					(setSiteID pl (vl-string-subst "_09" "_9" (ade_odgetfield pl "2" "site_id" 0)))
				)
			)
		)
	)
	count
)