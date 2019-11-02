#Count Roof plans in Master Files\\site number\\number
$MasterPath = "\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files"
$folderlist = gci $MasterPath | ?{$_.PSIsContainer}
$list = @()
foreach ($folder in $folderlist){
	$num = ($folder.name -split ' - ')[0]
	if((test-path -literalpath "$MasterPath\$folder\$num\$num-R.dwg") -and -not (test-path -literalpath "$MasterPath\$folder\$num-ST.dwg") -and -not (test-path -literalpath "$MasterPath\$folder\$num-Roof.dwg")){
		$list += $num
	}
}
$list | clip

