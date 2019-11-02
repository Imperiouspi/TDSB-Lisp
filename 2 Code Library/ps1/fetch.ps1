#Retrieve all sdf floor plan drawings and put into "0000 sdf\\edited by Noah"
#After any keypress, then distribute those files into the floor-specific folders.
$MasterPath = "\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files"
$folderlist = gci $MasterPath | ?{$_.PSIsContainer}
$problist = gci -Path "$MasterPath\0000 sdf\Problems" -Filter "*.dwg" -Recurse | Select-Object -Property name

#Get all sdf files. Doesn't filter Roof or Site plans.
foreach ($folder in $folderlist){
	$num = ($folder.name -split ' - ')[0]
	if(-not ($num -like "*0000*")){
		foreach ($f in (gci "$MasterPath\$folder\$num sdf" -Filter "*.dwg")){
			if(-not ($problist -contains $f.name)){
				Write-Host Copying $f.name
				copy-item "$MasterPath\$folder\$num sdf\*.dwg" "$MasterPath\0000 sdf\edited by Noah"
			}
		}
	}
}
#Wait for keypress
Write-Host "Moved. Press any key to distribute"
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

#Move floors to folders. Ignores R and S.
get-childitem -Path  "$MasterPath\0000 sdf\edited by Noah\*" -Include *-1M*,*-1Ma* -Exclude *.bak | Move-Item -Destination "$MasterPath\0000 sdf\edited by Noah\1M"
get-childitem -Path  "$MasterPath\0000 sdf\edited by Noah\*" -Include *-2M*,*-2Ma* -Exclude *.bak | Move-Item -Destination "$MasterPath\0000 sdf\edited by Noah\2M"
get-childitem -Path  "$MasterPath\0000 sdf\edited by Noah\*" -Include *-3M* -Exclude *.bak | Move-Item -Destination "$MasterPath\0000 sdf\edited by Noah\3M"
get-childitem -Path  "$MasterPath\0000 sdf\edited by Noah\*" -Include *-BM*,*-BMa* -Exclude *.bak | Move-Item -Destination "$MasterPath\0000 sdf\edited by Noah\BM"
get-childitem -Path  "$MasterPath\0000 sdf\edited by Noah\*" -Include *-GM* -Exclude *.bak | Move-Item -Destination "$MasterPath\0000 sdf\edited by Noah\GM"
get-childitem -Path  "$MasterPath\0000 sdf\edited by Noah\*" -Include *-B*,*-B1*,*-B2*,*-Ba*,*-Bb*,*-Bc*,*-bd* -Exclude *.bak | Move-Item -Destination "$MasterPath\0000 sdf\edited by Noah\B"
get-childitem -Path  "$MasterPath\0000 sdf\edited by Noah\*" -Include *-1*,*-1a*,*-1b*,*-1c*,*-1d*,*-1e*,*-1f*,*-1g*,*-1h*,*-1i*,*-1j*,*-1k*,*-1l*,*-1o*,*-1p*,*-1q*,*-1r*,*-1s*,*-1t* -Exclude *.bak | Move-Item -Destination "$MasterPath\0000 sdf\edited by Noah\1"
get-childitem -Path  "$MasterPath\0000 sdf\edited by Noah\*" -Include *-2*,*-2a*,*-2b*,*-2c*,*-2d*,*-22* -Exclude *.bak | Move-Item -Destination "$MasterPath\0000 sdf\edited by Noah\2"
get-childitem -Path  "$MasterPath\0000 sdf\edited by Noah\*" -Include *-3*,*-3a*,*-3b* -Exclude *.bak | Move-Item -Destination "$MasterPath\0000 sdf\edited by Noah\3"
get-childitem -Path  "$MasterPath\0000 sdf\edited by Noah\*" -Include *-4*,*-4a* -Exclude *.bak | Move-Item -Destination "$MasterPath\0000 sdf\edited by Noah\4"
get-childitem -Path  "$MasterPath\0000 sdf\edited by Noah\*" -Include *-5*,*-5a* -Exclude *.bak | Move-Item -Destination "$MasterPath\0000 sdf\edited by Noah\5"
get-childitem -Path  "$MasterPath\0000 sdf\edited by Noah\*" -Include *-6*,*-6a* -Exclude *.bak | Move-Item -Destination "$MasterPath\0000 sdf\edited by Noah\6"
get-childitem -Path  "$MasterPath\0000 sdf\edited by Noah\*" -Include *-M*,*-Ma*,*-Mb* -Exclude *.bak | Move-Item -Destination "$MasterPath\0000 sdf\edited by Noah\M"
get-childitem -Path  "$MasterPath\0000 sdf\edited by Noah\*" -Include *-Fb* -Exclude *.bak | Move-Item -Destination "$MasterPath\0000 sdf\edited by Noah\Fb"
get-childitem -Path  "$MasterPath\0000 sdf\edited by Noah\*" -Include *-G* -Exclude *.bak | Move-Item -Destination "$MasterPath\0000 sdf\edited by Noah\G"
get-childitem -Path  "$MasterPath\0000 sdf\edited by Noah\*" -Include *-PH*,*-PHb*,*-PHc* -Exclude *.bak | Move-Item -Destination "$MasterPath\0000 sdf\edited by Noah\PH"
get-childitem -Path  "$MasterPath\0000 sdf\edited by Noah\*" -Include *-P*,*-P1*,*-P2* -Exclude *.bak | Move-Item -Destination "$MasterPath\0000 sdf\edited by Noah\P"

