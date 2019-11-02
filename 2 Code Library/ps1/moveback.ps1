#Move files from edited by Noah back to their original sdf folders. Will OVERWRITE any files left there.
$folderlist = (gci '\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files' | ?{ $_.PSIsContainer } | sort-object -property "name")
$filelist = (gci '\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files\0000 sdf\edited by Noah' | ?{-not  $_.PSIsContainer } | sort-object -property "name")
foreach ($f in $filelist){
	foreach($folder in $folderlist){
		if((($folder.name -split ' - ')[0]) -eq (($f.name -split '-')[0])){
			move-item $f.FullName ($folder.FullName + "\" + ($folder.name -split ' - ')[0] + " sdf\" + $f.name) -Force
			Write-Host $f sorted
		}
	}
}

