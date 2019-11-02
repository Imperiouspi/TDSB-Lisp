;Test file. Ignore.

(vl-load-com)
(setq scale (getreal "Scale factor: "))
(setq a (ssget))
(setq countervar 0)
(while countervar < (sslength a)
  (setq obj (vlax-ename->vla-object (ssname a countervar)))
  (setq origin (vlax-3d-point 0 0 0))
  (setq pos (assoc 10 (entget (ssname a countervar))))
  (setq newpos (vlax-3d-point (* (- scale 1) (cadr pos)) (* (- scale 1) (caddr pos)) (* (- scale 1 )(cadddr pos))))
  (vla-move obj origin newpos)
  (setq countervar (+ 1 countervar))
)