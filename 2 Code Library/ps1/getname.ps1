#Find Name of a school from its number
function FindNum($num) {
	$MasterPath = '\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files'
	$folderlist = (gci '\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files' | ?{ $_.PSIsContainer -and -not $_.name.contains("0000")} | sort-object -property name)
	foreach ($folder in $folderlist){
		if((($folder.name -split(' - '))[0]) -eq $num){
			return (($folder.name -split(' - '))[1])
		}
	}
}

FindNum("0045") | Out-File -encoding ascii "H:\tmp.txt"

