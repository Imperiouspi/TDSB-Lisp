#Open each site plan and matching sdf drawing. Skip any contained in the "0000 sdf\Accessibility" folder.
$MasterPath = "\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files"
$scr = "H:\Map 3d\2 Code Library\autoalign.scr"
$done = gci "$MasterPath\0000 sdf\Accessibility" | select -expand basename
foreach ($site in (gci $MasterPath | ?{$_.PSIsContainer} | ?{$_.name -notlike "0000*"} | sort-object)) {
	$num = $site.name.split(" - ")[0]
	if(($num -as[int] -le 2000) -and ($num -as[int] -ge 0)){
		$path = $site.FullName
		$sdfs = (gci "$path\$num sdf" | ?{$_.extension -eq ".dwg"})
		foreach ($fplan in (gci "$path\$num" | ?{$_.name -notlike "*-R*"} | ?{$_.name -notlike "*-S*"} | ?{$_.extension -eq ".dwg"})){
			$matches = @()
			foreach ($sdf in $sdfs){
				if($sdf.basename.contains($fplan.basename)){
					$matches += $sdf
				}
			}
			$match = $matches[0]
			$fname = $fplan.FullName
			if(($done -notcontains ($match.basename + "-A")) -and ($match.FullName -ne "") -and ($match -ne $null)){
				Write-Host "Match" $fplan.name " " $sdf.name
				ii $match.FullName
				ii $fplan.FullName
				$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
			}
			else{
				Write-Host "Skip $num"
			}
		}
	}
}

