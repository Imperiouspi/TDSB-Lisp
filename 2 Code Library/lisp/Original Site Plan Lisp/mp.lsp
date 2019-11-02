;Description:
;Draw a point at the midpoint of two points.
(defun C:MPOINT ()
	(setq p1 (getpoint))
  	(setq p2 (getpoint))
	(setq mp (list (/(+ (car p1) (car p2)) 2) (/(+ (cadr p1) (cadr p2)) 2) 0))
  	(command "point" mp)
)