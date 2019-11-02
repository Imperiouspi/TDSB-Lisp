#Ignore. Generate ps1 documentation. Merged into getfuncs master file.
$path = "H:\Map 3d\2 Code Library"
$list = @()
$ct = @()
$fdesc = @()
$ofs = "\`n"
$r = 1
$rr = 1

$files = gci $path -Filter "*.ps1" | sort-object

$ct += "document.write(``\"
foreach($f in $files){
	$filename = $f.name
	$mark = 0
	$list = get-content $f.FullName
	if($list[0] -eq (get-content $f.FullName)[0]){
		while(($next = $list[$mark]) -like "#*"){
				$fdesc += ($next -split "#")[1] + "<br>"
				$mark +=1
		}
	}

	if(($fdesc -notlike "*ignore*") -or ($fdesc.length -eq 0)){
		Write-Host $f.FullName
		$count = 0
		$mark = 0

		if($fdesc[-1] -eq "<br>"){
			$ct += "<div class=\`"file\`" id=\`"$filename\`">$filename\"
		}
		else{
			$ct += "<div class=\`"file\`" id=\`"$filename\`">$filename\`n<div class=\`"fdesc\`">$fdesc\`n</div>"
		}
		$fdesc = @()
		$ct += "</div>\"
	}
	else{
		$fdesc = @()
	}
}
$ct += "``)"
$ofs = " "
Set-Content -Path "H:\Map 3d\1 Documentation\Auto-gen Documentation\ps1func.js" -Value $ct

