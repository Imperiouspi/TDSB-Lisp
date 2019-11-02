#Build the script to automate the accessibility geocoding process. Unreliable.
$MasterPath = "\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files"
$scr = "H:\Map 3d\2 Code Library\autoalign.scr"
$done = gci "$MasterPath\0000 sdf\Accessibility" | select -expand basename
set-content $scr "vlide`n(setvar `"sdi`" 1)`n(setvar `"filedia`" 0)`n(setq copy nil)"
foreach ($site in (gci $MasterPath | ?{$_.PSIsContainer} | ?{$_.name -notlike "0000*"} | sort-object)) {
	$num = $site.name.split(" - ")[0]
	if(($num -as[int] -le 500) -and ($num -as[int] -ge 300) -and ($num -ne "0143")){
		$path = $site.FullName
		$sdfs = (gci "$path\$num sdf" | ?{$_.extension -eq ".dwg"})
		foreach ($fplan in (gci "$path\$num" | ?{$_.name -notlike "*-R*"} | ?{$_.name -notlike "*-S*"} | ?{$_.extension -eq ".dwg"})){
			$matches = @()
			foreach ($sdf in $sdfs){
				if($sdf.basename -eq ($fplan.basename.split("_")[0])){
					$matches += $sdf
					Write-Host "Match" $fplan.name " " $sdf.name
				}
			}
			$match = $matches[0]
			$fname = $fplan.FullName
			if(($done -notcontains ($match.basename + "-A")) -and ($match.FullName -ne "") -and ($match -ne $null)){
				$match = $match.FullName
				add-content $scr "(if(> (getvar `"dbmod`") 0)(command `".open`" `"Y`" `"$fname`")(command `".open`" `"$fname`"))`nCOPYACCESS`n(if(> (getvar `"dbmod`") 0)(command `".open`" `"Y`" `"$match`")(command `".open`" `"$match`"))`n(c:pasteaccess)"
			}
		}
	}
}
add-content $scr "(setvar `"filedia`" 1)`n(setvar `"sdi`" 0)"
set-content $scr ((get-content $scr) -replace "\\", "\\")