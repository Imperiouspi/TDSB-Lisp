;Will automatically run when any document is opened in Autocad, if the folder containing this file is among the "support files" specified in autocad settings.

(vl-load-com)
(load "access")
(load "batchexr")
(load "BATCHLISP")
(load "batchref")
(load "catch22")
(load "chgunits")
(load "deldupvertex")
(load "entrance_ids")
(load "exportrooms")
(load "ids")
(load "ids_2")
(load "label2")
(load "merge")
(load "monumentids")
(load "newroomid")
;(load "Original Site Plan Lisp\\siteplan-utils") ;Uncomment to load the original site plan library.
(load "prepmerge")
(load "search")
(load "SelectFiles")
(load "sitealign")
(load "util")
(print)

(setq osm (getvar "osmode"))
; (testforextralayers)

;;Uncomment to turn on all layers and freeze sdf and SDF_IMPORT
; (command "._-layer" "_on" "*" "")
; (if (not (null (tblsearch "Layer" "sdf")))
; 	(command "_.layer" "_freeze" "sdf" "")
; )

; (if (not (null (tblsearch "Layer" "SDF_IMPORT")))
; 	(command "_.layer" "_freeze" "SDF_IMPORT" "")
; )

; (setq fakeoutline nil) ;From batchexr. Indicates whether gross area outline was already present or added by the program.

;;Uncomment this section for aligning floor plans
; (setvar "insunits" 1)
; (command "regenauto" "1")
; (command "._-layer" "_on" "*" "")
; 
; (setq f (open "H:\\Map 3d\\3 exports\\caught22.txt" "a"))
; (if (not (null (tblsearch "Layer" "22")))
; 	(progn (write-line (getvar "dwgname") f)
; 	(if (null (ssget "X" (list (cons 8 "22"))))
; 		(progn(setlayer "0")
; 		(command "laydel" "N" "22" "" "Y"))
; 	))
; )
; (if (not (null (tblsearch "Layer" "sdf")))
; 	(command "_.layer" "_freeze" "sdf" "")
; )

; (if (not (null (tblsearch "Layer" "SDF_IMPORT")))
; 	(command "_.layer" "_freeze" "SDF_IMPORT" "")
; )
; (close f)
; (command "_.zoom" "e")
; (c:begin)
; (print "Enter STOP to detach\n")

(if (vl-string-search "-A" (getvar "dwgname"))
	(c:fax)
)
;Below: Wrapper functions for easy commands.

;Description:
;Shortcut for <a href="#C:EXPORTNEWIDS">C:EXPORTNEWIDS</a>
(defun C:EXR ()
	(c:exportnewids)
)

;Description:
;Zoom to extents, close and save shortcut.
(defun C:CS ()
	(c:stop)
	(command "_.zoom" "e")
	(command "qsave")
	(command ".close" "N")
)
;Description:
;Reset osnap to preferred settings. This number is in "H:\\Map 3d\\config.txt".
(defun C:RSNAP()
	(setq f (open "H:\\Map 3d\\config.txt" "r"))
	(setvar "osmode" (atoi (read-line f)))
	(close f)
)

;Description:
;Set the configuration file "H:\\Map 3d\\config.txt" to store the correct osnap number for the preffered settings. Get with <a href="#C:GETCONFIG">GETCONFIG</a>, set osnap to this value with <a href="#C:RSNAP">RSNAP</a>.
(defun C:SETCONFIG ()
	(initget 5)
	(setq a (getint "Enter new OSNAP configuration number"))
	(setq f (open "H:\\Map 3d\\config.txt" "w"))
	(write-line (itoa a) f)
	(close f)
)

;Description:
;Return the current osnap configuration stored in "H:\\Map 3d\\config.txt". Set with <a href="#C:SETCONFIG">SETCONFIG</a>, set osnap to this value with <a href="#C:RSNAP">RSNAP</a>.
(defun C:GETCONFIG ()	
	(setq f (open "H:\\Map 3d\\config.txt" "r"))
	(print (read-line f))
	(close f)
)

;Description:
;Display entity data. Prompts to select an object.
(defun C:EPROP()
	(entget (c:ename))
)
;Description:
;Retrieve entity name. Prompts to select an object.
;Returns: Selected entity name.
(defun C:ENAME()
	(ssname (ssget) 0)
)


;Description:
;Insert property line label and portable label without copying them in. Command for <a href="#insertextralabels">insertextralabels</a>
(defun C:PORTPROP ()
	(insertextralabels)
)

;Description:
;Shortcut for <a href="#C:LABELLAYER">LABELLAYER</a>
(defun C:LL ()
	(C:LABELLAYER)
)