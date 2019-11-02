;Description:
;Modified Convex Hull program from Lee Mac.
(defun LM:ConvexHull ( lst / ch p0 )
    (cond
        (   (< (length lst) 4) lst)
        (   (setq p0 (car lst))
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