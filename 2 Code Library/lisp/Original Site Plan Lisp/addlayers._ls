;Description
;Add a set of layers into a document.

(load "Downloaded\\OutlineObjectsV1-1")
(defun c:updatelayers ()
	(setq clyr (getvar "clayer"))
	(LM:startundo (LM:acdoc))
	(command "._Layer" "_Make" "tdsb-smsc-building hidden" "_Color" 10 "tdsb-smsc-building hidden" "_LT" "ACAD_ISO03W100" "tdsb-smsc-building hidden" "")
	(command "._Layer" "_Make" "tdsb-smsc-building canopy" "_Color" 10 "tdsb-smsc-building canopy" "_LT" "ACAD_ISO03W100" "tdsb-smsc-building canopy" "")
	(command "._Layer" "_Make" "tdsb-smsc-gate" "_Color" 1 "tdsb-smsc-gate" "_LT" "ACAD_ISO03W100" "tdsb-smsc-gate" "")
	(command "._Layer" "_Make" "tdsb-smsc-landscape planters" "_Color" 8 "tdsb-smsc-landscape planters" "_LT" "Continuous" "tdsb-smsc-landscape planters" "")
	(command "._Layer" "_Make" "tdsb-smsc-playground playscape" "_Color" 6 "tdsb-smsc-playground playscape" "_LT" "Continuous" "tdsb-smsc-playground playscape" "")
	(command "._Layer" "_Make" "tdsb-smsc-police safety plan pl" "_Color" 181 "tdsb-smsc-police safety plan pl" "_LT" "ACAD_ISO03W100" "tdsb-smsc-police safety plan pl" "")
	(command "._Layer" "_Make" "tdsb-smsc-roof equip" "_Color" 253 "tdsb-smsc-roof equip" "_LT" "Continuous" "tdsb-smsc-roof equip" "")
	(command "._Layer" "_Make" "tdsb-smsc-accessibility green pg" "_Color" 92 "tdsb-smsc-accessibility green pg" "_LT" "Continuous" "tdsb-smsc-accessibility green pg" "")
	(command "._Layer" "_Make" "tdsb-smsc-accessibility green pl" "_Color" 92 "tdsb-smsc-accessibility green pl" "_LT" "ACAD_ISO03W100" "tdsb-smsc-accessibility green pl" "")
	(command "._Layer" "_Make" "tdsb-smsc-solar panels" "_Color" 4 "tdsb-smsc-solar panels" "_LT" "Continuous" "tdsb-smsc-solar panels" "")
	(command "._Layer" "_Make" "tdsb-smsc-cityroad" "_Color" 253 "tdsb-smsc-cityroad" "_LT" "Continuous" "tdsb-smsc-cityroad" "")
	(command "._Layer" "_Make" "tdsb-smsc-parking points" "_Color" 60 "tdsb-smsc-parking points" "_LT" "Continuous" "tdsb-smsc-parking points" "")
	(command "._Layer" "_Make" "tdsb-smsc-playground soccerfield" "_Color" 64 "tdsb-smsc-playground soccerfield" "_LT" "Continuous" "tdsb-smsc-playground soccerfield" "")
 	(command "._Layer" "_Make" "tdsb-smsc-playground soccerfield 2" "_Color" 43 "tdsb-smsc-playground soccerfield 2" "_LT" "ACAD_ISO03W100" "tdsb-smsc-playground soccerfield 2" "")
 	(command "._Layer" "_Make" "tdsb-smsc-playground baseball diamond" "_Color" 4 "tdsb-smsc-playground baseball diamond" "_LT" "Continuous" "tdsb-smsc-playground baseball diamond" "")
 	(command "._Layer" "_Make" "tdsb-smsc-playground baseball diamond 2" "_Color" 143 "tdsb-smsc-playground baseball diamond 2" "_LT" "ACAD_ISO03W100" "tdsb-smsc-playground baseball diamond 2" "")
	(command "._Layer" "_Make" "tdsb-smsc-landscape" "_Color" 94 "tdsb-smsc-landscape" "_LT" "Continuous" "tdsb-smsc-landscape" "")
)