;A script written to test the testpt function. Now defunct.

(load "util")

;Description:
;Asks for point and polyline, tests if point is in the polyline.
(defun C:TESTPT ( / count pt x y ent ptlist l i px1 py1 px2 py2 m b isIntersect)
  	(setq count 0)
	(setq pt (getpoint))
	(setq x (nth 0 pt))
	(setq y (nth 1 pt))
	(setq ent (car (entsel)))

	(setq ptlist (LM:ent->pts ent 50))
  	(setq l (length ptlist))
	(repeat (setq i (length ptlist))
		(setq px1 (nth 0 (nth (setq i (- i 1)) ptlist)))
		(setq py1 (nth 1 (nth i ptlist)))
	  	(if (/= i 0)
		  	(progn
				(setq px2 (nth 0 (nth (- i 1) ptlist)))
				(setq py2 (nth 1 (nth (- i 1) ptlist)))
			)
		  	(progn
			 	(setq px2 (nth 0 (nth (- l 1) ptlist)))
			  	(setq py2 (nth 1 (nth (- l 1) ptlist)))
			)
		)
		(setq m (/ (- py2 py1) (- px2 px1)))
	  	(setq b (- py1 (* m px1)))
	  	(setq isIntersect (intersect m b py1 py2 x y))
		(if isIntersect
			(setq count (+ count 1))
		)
	)
  	count
	;Last line
)