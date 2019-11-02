;Description
;This program will allow the user to convert a selection of circular Ellipses & Elliptical Arcs (that is, Ellipses or Elliptical Arcs with axes of equal length) into Circles & Arcs respectively, whilst retaining all properties of the original objects.
;
;The program will furthermore perform correctly with Ellipses & Elliptical Arcs constructed in any UCS, and should be supported on all versions of AutoCAD, on both a Windows & Mac OS.
;Author:Lee Mac, Copyright © 2013-www.lee-mac.com
;Version 1.1-2015-03-14
;- Incorporated 1e-3 tolerance on the ellipse axis ratio into the ssget selection filter.
(defun c:e2a ( / a b c e i m p q r s u v z )
	(if (setq s (ssget "X" '((0 . "ELLIPSE") (-4 . ">=") (40 . 0.999) (-4 . "<=") (40 . 1.001))))
		(repeat (setq i (sslength s))
			(setq e (entget (ssname s (setq i (1- i))))
				z (cdr (assoc 210 e))
				c (trans (cdr (assoc 10 e)) 0 z)
				p (trans (cdr (assoc 11 e)) 0 z)
				a (distance '(0.0 0.0) p)
				b (* a (cdr (assoc 40 e)))
				r (angle '(0.0 0.0) p)
				u (cdr (assoc 41 e))
				v (cdr (assoc 42 e))
				m (list (list (cos r) (- (sin r))) (list (sin r) (cos r)))
				p (mapcar '+ c (mxv m (list (* a (cos u)) (* b (sin u)))))
				q (mapcar '+ c (mxv m (list (* a (cos v)) (* b (sin v)))))
			)
			(if (if (equal p q 1e-8)
					(entmake
						(cons '(0 . "CIRCLE")
							(append (LM:defaultprops e)
								(list
									(cons010 c)
									(cons040 a)
									(assoc 210 e)
								)
							)
						)
					)
					(entmake
						(cons '(0 . "ARC")
							(append (LM:defaultprops e)
								(list
									(cons010 c)
									(cons040 a)
									(cons050 (angle c p))
									(cons051 (angle c q))
									(assoc 210 e)
								)
							)
						)
					)
				)
				(entdel (cdr (assoc -1 e)))
			)
		)
	)
	(princ)
)

;Description:
;Default Properties-Lee Mac
;Arguments:
;elist: list of data returned by entget
;Returns: a list of DXF properties for the supplied DXF data, substituting default values for absent DXF groups
(defun LM:defaultprops ( elist )
	(mapcar
		(function
			(lambda ( pair )
				(cond ((assoc (car pair) elist)) ( pair ))
			)
		)
	 '( (008 . "0")
			(006 . "BYLAYER")
			(039 . 0.0)
			(062 . 256)
			(048 . 1.0)
			(370 . -1)
		)
	)
)

;Description:
;Matrix x Vector - Vladimir Nesterovsky
;Arguments:
;m: nxn matrix
;v: vector in R^n
;Returns: cross product of matrix and vector
(defun mxv ( m v )
	(mapcar '(lambda ( r ) (apply '+ (mapcar '* r v))) m)
)