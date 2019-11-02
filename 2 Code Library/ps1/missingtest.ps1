#Find all floors that were missed in the complete export. Write to "3 exports\\Missing Floors.csv"
$MasterPath = '\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files';
$folderlist = (gci '\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files' | ?{ $_.PSIsContainer } | ?{-not $_.name.contains('[SOLD]')} | sort-object -property name);
$list = Get-Content "H:\Map 3d\3 exports\Complete Floor Export Cleaned.csv";
foreach ($folder in $folderlist){
	$num = (-split $folder.name)[0];
	if($num -ne "0000"){
		foreach ($file in (gci -literalPath "$MasterPath\$folder\$num sdf" | ?{$_.name.contains('.dwg') -or $_.name.contains('.DWG')} | ?{-not $_.name.contains('-R') -and -not $_.name.contains('-S')})){
			$in = 0;
			foreach($line in $list){
				if($in -eq 0){	
					$line_pl = ($line -split ',')[1];
					$line_site = ($line_pl -split '_')[0];
					$line_floor = ($line_pl -split '_')[1];
					$line_file_label = $line_site + '-' + $line_floor;
					if($file.name.contains($line_file_label)){
						$in = 1;
						$line_keep = $line_file_label;
					};
				}
			}; 
			if ($in -eq 0) {
				Write-Host $file.name;
				Add-Content -Path 'H:\Map 3d\3 exports\Missing Floors.csv' -Value $file.name;
			}
		};
	};
}

