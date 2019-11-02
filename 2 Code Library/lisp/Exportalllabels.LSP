;Description:
;Write all room labels into all_ids.csv.
(defun C:EXPORTROOMIDS ()
	(setq labels (LM:ss->ent(nri:getblockSS)))
	(setq savedpath "H:\\Map 3d\\3 exports")
	(setq f (open (strcat savedpath "\\export3.csv") "a"))
	(foreach lab labels
		(write_export (substr (getvar "dwgname") 1 4) "" "0" (LM:getattributevalue lab "DOOR#") (LM:getattributevalue lab "DOORNAME") (LM:getattributevalue lab "ROOMUSAGE"))
		
	)
	(close f)
)