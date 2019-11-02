;Just a test, ignore this.

(setq sel nil)
(while (null sel)
	(initget 7 "Undo")
	(setq sel(entsel (strcat "Select " "a1" " or press u to undo (currently broken)")))
)
(= sel "Undo")