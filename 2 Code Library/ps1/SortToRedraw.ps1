#Sorts sdf files from "edited by Noah" back to their original location. Ignores sites in the redraw process, and puts them in a "redraw" folder instead.
#Full implementation not finished, but would follow this algorithm:
# To sort files:
# IF not redraw
# 	IF newer
# 		replace
# 	ELSE older
# 		edit
# ELSE redraw
# 	IF above _2 Review/_1 finSDF
# 		IF newer
# 			replace
# 		ELSE older
# 			edit
# 	ELSE in _2 Review/_1 finSDF
# 		edit
#sort into redraw
$folderlist = (gci '\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files' | ?{ $_.PSIsContainer })
$redrawlist = @()
Foreach($folder in $folderlist){
	if($folder.name.contains('redraw')){
		$redrawlist += ($folder.name -split ' ')[0]
	}
}
$filelist = (gci '\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files\0000 sdf\edited by Noah' -Filter "*.dwg")
Foreach($file in $filelist){
	if ($redrawlist -contains (($file.name -split '-')[0])) {
		move-item -Path $file.fullname -destination '\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files\0000 sdf\edited by Noah\redraw'
	}
}

#All used date formats! Date handling not implemented.
# options:
# 2018Aug08.dwg
# 2016.10.11.dwg
# 20170101.dwg
# 15.07.03.dwg