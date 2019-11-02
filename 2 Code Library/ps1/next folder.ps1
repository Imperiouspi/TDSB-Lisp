#Ignore. Open sdf folder of each site in order, old version of moveback.ps1. Uncomment auto-move section and comment manual move to do it automatically.
$MasterPath = '\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files'
$folderlist = (gci '\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files' | ?{ $_.PSIsContainer } | sort-object -property name)
$filelist = (gci '\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files\0000 sdf\edited by Noah' -Filter '*.dwg' | sort-object -property name)
Foreach ($file in $filelist){
	foreach ($folder in $folderlist){
		if ($folder.name.contains(($file.name -split '-')[0])){
			$num = ($file.name -split '-')[0];
			
			#Manual Move
			if($oldnum -ne $num){
				#close old windows
				$a = (New-Object -comObject Shell.Application).Windows() | ?{ $_.FullName -ne $null} | ? { ($_.FullName.toLower() -like ('*explorer.exe')) -and ($_.LocationName -like '*sdf')};
				if ($a -ne $null){
					$a | % {$_.Quit()};
				}
				#open new ones
				ii -literalpath "$MasterPath\$folder\$num sdf";
				Write-Host "$num opened - Press any key to continue...";
				$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
			}

			# #Auto-move
			# if(test-path -literalpath "$MasterPath\$folder\$num sdf\$file"){
			# 	move-item -literalpath "$MasterPath\0000 sdf\edited by Noah\$file" "$MasterPath\$folder\$num sdf\$file" -force
			# 	Write-Host "Replaced $file"
			# }

			$oldnum = $num;
		}
	}
}

