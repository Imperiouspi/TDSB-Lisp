;(ignore)This file is only around for archival purposes, and in case I mess anything up. It has been replaced by "exportrooms", and all functions defined here are also defined there.

(vl-load-com)
(load "util")

(defun C:EXROC ( / netareaSS blockLargeSS blockMediumSS blockSmallSS c blocklist roomidlist doornumlist doornamelist roomuselist areae in ptlist l blocke x y countin roomid doornum doorname roomuse )
	(setq netareaSS (ssget "X" (list (cons 8 "tdsb-smsc-net area") (cons 0 "LWPOLYLINE"))))
	(setq nameblockSS (ssadd))
	(setq blockLargeSS (ssget "X" (list (cons 8 "tdsb-smsc-roomlabels") (cons 2 "smsc-room label-large"))))
	(setq blockMediumSS(ssget "X" (list (cons 8 "tdsb-smsc-roomlabels") (cons 2 "smsc-room label-medium"))))
	(setq blockSmallSS(ssget "X" (list (cons 8 "tdsb-smsc-roomlabels") (cons 2 "smsc-room label-small"))))

	;Merge block selection sets into nameblockSS
	(setq c 0)
	(repeat (sslength blockLargeSS)
		(ssadd (ssname blockLargeSS c) nameblockSS)
		(setq c (+ 1 c))
	)
	(setq c 0)
	(repeat (sslength blockMediumSS)
		(ssadd (ssname blockMediumSS c) nameblockSS)
		(setq c (+ 1 c))
	)
	(setq c 0)
	(repeat (sslength blockSmallSS)
		(ssadd (ssname blockSmallSS c) nameblockSS)
		(setq c (+ 1 c))
	)
	(setq c 0)

	(setq blockSmallSS nil)
	(setq blockMediumSS nil)
	(setq blockLargeSS nil)
	
	(beginexport nil)

	(foreach areae (LM:ss->ent netareaSS)
		(setq blocklist nil)
		(setq in 0)
		(setq ptlist (LM:ent->pts areae 50))
		(setq l (length ptlist))

		(foreach blocke (LM:ss->ent nameblockSS)
			(setq origin (getorigin blocke))
			(setq x (nth 0 origin))
			(setq y (nth 1 origin))

			(setq countin (testpt x y ptlist))
			;If count is odd, point is inside.
			;Track how many labels are inside this block
			(if (= (rem countin 2) 1)
				(progn
					(setq in (+ in 1))
					(setq blocklist (cons blocke blocklist))
					(setq nameblockSS (ssdel blocke nameblockSS))
				)
			)
		)
		
		(cond
			( (= in 1)
				(setq roomid (ade_odgetfield areae "1" "room_id" 0));Get OD for room id
			 	(if (null roomid)
					(setq roomid -1)
				)
				(setq doornum (LM:getattributevalue (nth 0 blocklist) "DOOR#"));Get attributes
				(setq doorname (LM:getattributevalue (nth 0 blocklist) "DOORNAME"))
				(setq roomuse (LM:getattributevalue (nth 0 blocklist) "ROOMUSAGE"))
			)
			(T
				(setq roomid -1)
				(setq doornum "")
				(setq doorname "")
				(setq roomuse "")
			)
		)
		(write_export roomid doornum doorname roomuse)
	)
	(close f)
	(print)
)

;Ray Test
(defun testpt (x y ptlist / count px1 px2 py1 py2 m b isIntersect)
	(setq count 0)
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
		(if (/= px1 px2)
			(progn
				(setq m (/ (- py2 py1) (- px2 px1)))
				(setq b (- py1 (* m px1)))
				(setq isIntersect (intersect m b py1 py2 x y))
				(if isIntersect
					(setq count (+ count 1))
				)
			)
			(if (and (> px x) (or (and (> py1 y) (< py2 y)) (and (< py1 y) (> py2 y))))
				(setq count (+ count 1))
			)
		)
	)
	count
)

(defun getorigin (ent / ox oy ang labeltype scale x y)
	(setq ox (nth 0 (cdr (assoc 10 (entget ent)))));Bottom of line 4
	(setq oy (nth 1 (cdr (assoc 10 (entget ent)))))
	(setq ang (getpropertyvalue ent "Rotation"))
	;Get height of text based on block type
	(setq labeltype (cdr (assoc 2 (entget ent))))
	(setq scale (cdr (assoc 41 (entget ent))))
	(cond 
		((= labeltype "smsc-room label-large") (setq height 0.0703))
		((= labeltype "smsc-room label-medium") (setq height 0.0469))
		((= labeltype "smsc-room label-small") (setq height 0.0313))
	)
	(setq x (+ ox (* (cos (+ (/ pi 2) ang)) (* height scale 1.5))))
	(setq y (+ oy (* (sin (+ (/ pi 2) ang)) (* height scale 1.5))))
	;(point x y)
	(list x y)
)

(defun beginexport ( / savedpath text)
	(setq text "Room ID,Door Number,Door Name,Room Usage")
	(setq savedpath (LM:browseforfolder "Select a folder to export to" "" 0))
	(if (not (null savedpath))
		(progn
			(setq f (open (strcat savedpath "\\export.csv") "w"))
			(write-line text f)
		)
	)

)

(defun write_export (roomid doornum doorname roomuse / text)
	(setq text (strcat (itoa roomid) "," doornum "," doorname "," roomuse))
	(write-line text f)
)