;Description:
;Convex Hull program from Lee Mac.
;Arguments:
;ss: Selection Set
;Returns: List of points describing the convex hull.
(defun convexhull (ss / pts eg o)
	(setq pts (list))
	(foreach e (LM:ss->ent ss)
		(if (and (= (cdr (assoc 0 (setq eg (entget e)))) "INSERT")
				(setq o (tblobjname "BLOCK" (cdr (assoc 2 eg))))
			)
			(while (and (not p) (setq o (entnext o)))
				;o = block entity
				;(print (entget o))
				(setq pts (append pts (getpoints o e)))
			)
			(setq pts (append pts (getpoints e nil)))
		)
	)
	(LM:ConvexHull pts)
)

;Description:
;Retrieve points from an object
;Arguments:
;obj: objects to get coordinates from
;blockobj: t or nil, is the object a block?
(defun getpoints (obj blockobj / typ tpts pts i)
	(setq typ (cdr (assoc 0 (entget obj))))
	(cond
		((= typ "LWPOLYLINE")
			(setq tpts (getmeshcoords obj))
			(setq i 0)
			(while (< i (- (length tpts) 1))
				(setq pts (append pts (list (list (nth i tpts) (nth (+ i 1) tpts)))))
				(setq i (+ 2 i))
			)
			(if (not (null blockobj))
				(setq pts 
					(mapcar '(lambda (pt) (apply '(lambda ( mat vec ) (mapcar '+ (mxv mat pt) vec)) (refgeom blockobj))) pts)
				)
			)
		)
		((= typ "LINE")
			(setq pts (list (cdr (assoc 10 (entget obj))) (cdr (assoc 11 (entget obj)))))
		)
	)
	pts
)

;Description:
;Return a list of points describing the convex hull of an object
;Arguments:
;lst: a list of points describing an object
;Returns: a new list of points describing the convex hull
(defun LM:ConvexHull ( lst / ch p0 )
	(cond
		((< (length lst) 4) lst)
		((setq p0 (car lst))
			(foreach p1 (cdr lst)
				(if (or (< (cadr p1) (cadr p0))
						(and (equal (cadr p1) (cadr p0) 1e-8) (< (car p1) (car p0)))
					)
					(setq p0 p1)
				)
			)
			(setq lst
				(vl-sort lst
					(function
						(lambda ( a b / c d )
							(if (equal (setq c (angle p0 a)) (setq d (angle p0 b)) 1e-8)
								(< (distance p0 a) (distance p0 b))
								(< c d)
							)
						)
					)
				)
			)
			(setq ch (list (caddr lst) (cadr lst) (car lst)))
			(foreach pt (cdddr lst)
				(setq ch (cons pt ch))
				(while (and (caddr ch) (LM:Clockwise-p (caddr ch) (cadr ch) pt))
					(setq ch (cons pt (cddr ch)))
				)
			)
			ch
		)
	)
)

;Description:
;Lee Mac - Returns T if p1,p2,p3 are clockwise oriented or collinear
;Arguments:
;p1: point
;p2: point
;p3: point
(defun LM:Clockwise-p ( p1 p2 p3 )
    (<  (-  (* (- (car  p2) (car  p1)) (- (cadr p3) (cadr p1)))
            (* (- (cadr p2) (cadr p1)) (- (car  p3) (car  p1)))
        )
        1e-8
    )
)

;Description:
;gile - Returns a list whose first item is a 3x3 transformation matrix and second item the object insertion point in its parent (xref, block or space)
;Arguments:
;ent: ename of object
;Returns: a fancy matrix and an insertion point
(defun refgeom ( ent / ang enx mat ocs )
   (setq enx (entget ent)
         ang (cdr (assoc 050 enx))
         ocs (cdr (assoc 210 enx))
   )
   (list
       (setq mat
           (mxm
               (mapcar '(lambda ( v ) (trans v 0 ocs t))
                  '(
                       (1.0 0.0 0.0)
                       (0.0 1.0 0.0)
                       (0.0 0.0 1.0)
                   )
               )
               (mxm
                   (list
                       (list (cos ang) (- (sin ang)) 0.0)
                       (list (sin ang) (cos ang)     0.0)
                      '(0.0 0.0 1.0)
                   )
                   (list
                       (list (cdr (assoc 41 enx)) 0.0 0.0)
                       (list 0.0 (cdr (assoc 42 enx)) 0.0)
                       (list 0.0 0.0 (cdr (assoc 43 enx)))
                   )
               )
           )
       )
       (mapcar '- (trans (cdr (assoc 10 enx)) ocs 0)
           (mxv mat (cdr (assoc 10 (tblsearch "block" (cdr (assoc 2 enx))))))
       )
   )
)

;Description:
;Matrix Transpose  -  Doug Wilson
;Arguments:
;m: nxn matrix
;Returns: the transpose of m
(defun trp ( m )
   (apply 'mapcar (cons 'list m))
)

;Description:
;Matrix x Matrix  -  Vladimir Nesterovsky
;Arguments:
;m: nxn matrix
;n: nxn matrix
;Returns: the product of m and n
(defun mxm ( m n )
   ((lambda ( a ) (mapcar '(lambda ( r ) (mxv a r)) m)) (trp n))
)

;Description:
;Matrix x Vector  -  Vladimir Nesterovsky
;Arguments:
;m: nxn matrix
;v: vector in R^n
;Returns: the cross product of m and a vector
(defun mxv ( m v )
   (mapcar '(lambda ( r ) (apply '+ (mapcar '* r v))) m)
)

;Description:
;Create a convex hull out of a selection set.
;Arguments:
;ss: A selection set from which to create the hull
;Returns: the polyline describing the hull
(defun makehull (ss / l)
	(setq l (convexhull (ss)))
	(entmakex
		(append
			(list
				'(000 . "LWPOLYLINE")
				'(100 . "AcDbEntity")
				'(100 . "AcDbPolyline")
				(cons 90 (length l))
				'(070 . 1)
			)
			(mapcar '(lambda ( x ) (cons 10 x)) l)
		)
	)
)