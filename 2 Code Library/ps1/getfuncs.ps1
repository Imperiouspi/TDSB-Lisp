#Automatically generate documentation for lisp and powershell files.

$path = "H:\Map 3d\2 Code Library\lisp"
$list = @()
$ct = @() #content array
$fdesc = @() #file description
$desc = @() #function description
$vars = @() #variable list
$ret = "" #"Returns" string
$ofs = "\`n"
$r = 1
$rr = 1

#Reset index
Set-Content "H:\Map 3d\1 Documentation\Auto-gen Documentation\js\index.js" "index = ["

#Lisp Files first. Manually retrieves each folder.
$files = gci $path -Filter "*.lsp" | sort-object
$files += gci "$path\Original Site Plan Lisp" -Filter "*.lsp" | sort-object
$files += gci "$path\Original Site Plan Lisp\Downloaded" -Filter "*.lsp" | sort-object

#First line of javascript
$ct += "document.write(``"

#Loop through all files
foreach($f in $files){
	$mark = 0
	#Retrieve all content up to and including the function definition.
	$list = get-content $f.FullName | ?{$_ -like "(defun*" -or $_ -like ";*" -or $_ -like ""}
	#Find comments at the top of the file, as long as it's not a function description.
	if(($list[0] -eq (get-content $f.FullName)[0]) -and ($list[0] -notlike ";Description*")){
		#Loop until a blank line is found. Breaks if no blank line after function description.
		while(($next = $list[$mark]) -notlike ""){
				$fdesc += ($next -split ";")[1] + "<br>"
				$mark +=1
		}
	}

	#filter out "ignore" files.
	if(($fdesc -notlike "*ignore*") -or ($fdesc.length -eq 0)){
		Write-Host $f.FullName
		$count = 0
		$mark = 0

		#Add directory names to the beginning of file names
		if($f.directory.name -eq "Original Site Plan Lisp"){
			if($r -ne 0){
				$ct += "<div class=`"title`">Original Site Plan Lisp Functions</div>"
				$r = 0
			}
			$filename = $f.directory.name + "\\" + [io.path]::GetFileNameWithoutExtension($f.FullName);	
		}
		elseif($f.directory.name -eq "Downloaded"){
			if($rr -ne 0){
				$ct += "<div class=`"title`">Downloaded Lisp Functions</div>"
				$rr = 0
			}
			$filename = ($f.directory.FullName.split('\'))[-2] + "\\" + $f.directory.name + "\\" + [io.path]::GetFileNameWithoutExtension($f.FullName)
		}
		else{
			$filename = [io.path]::GetFileNameWithoutExtension($f.FullName)
		}

		#index
		Add-Content "H:\Map 3d\1 Documentation\Auto-gen Documentation\js\index.js" "{source:`"Lisp-Documentation.html#$filename.lsp`",value:`"$filename.lsp`"},"
		#Add filename and fdesc to content array, but only if fdesc exists.
		if($fdesc[-1] -eq "<br>"){
			$ct += "<div class=`"file`" id=`"$filename.lsp`">$filename.lsp"
		}
		else{
			$ct += "<div class=`"file`" id=`"$filename.lsp`">$filename.lsp`n<div class=`"fdesc`">$fdesc`n</div>"
		}
		$fdesc = @()

		#loop through the rest of the content.
		$ignore = $False
		foreach($line in $list){
			if($line -like ";ignore*"){
				$ignore = $True
			}

			#Find Description heading. Loop until it finds argument, returns, or the function definition.
			if($line -like ";Description*"){
				$mark = $count + 1
				while((($next = $list[$mark]) -notlike "(defun*") -and (($next) -notlike ";Returns*") -and (($next)-notlike ";Arguments*")){
					$desc += " " + ($next -split ";")[1] + "<br>"
					$mark +=1
				}
			}
			
			#Find Arguments heading. Loop until it finds returns or the function definition.
			if($line -like ";Arguments*"){
				$vars += "Arguments:<br>"
				$mark = $count + 1
				while((($next = $list[$mark]) -notlike ";Returns*") -and ($next -notlike "(defun*")){
					$vars += ($next -split ";")[1] + "<br>"
					$mark +=1
				}
			}
			
			#Find Returns heading. Only a single line.
			if($line -like ";Returns*" ){
				$ret = ($line -split ";")[1]
			}
			
			#Find function definition. Add Description, Arguments, and Returns to the content array, as well as the function heading.
			if($line -like "(defun*"){
				if (-not $ignore){
					$name = ($line -split " " -split("\("))[2]
					$varlist = $vars | ?{$_ -notlike "Arguments:<br>"} | %{($_ -split ": ")[0] + " "}
					$varlist = "$varlist".Trim()

					Add-Content "H:\Map 3d\1 Documentation\Auto-gen Documentation\js\index.js" "{source:`"Lisp-Documentation.html#$name`", value:`"$name`", file:`"$filename`"},"
					$ct += "<div class=`"par`">`n<div class=`"function`" id=`"$name`">$name ($varlist)`n</div>`n"
					if($desc -ne ""){
						$ct += "<div class=`"desc`">$desc`n</div>`n"
					}
					if($vars -ne ""){
						$ct += "<div class=`"vars`">$vars</div>`n"
					}
					if($ret -ne ""){
						$ct += "<div class = `"ret`">$ret</div>`n"
					}
					$ct += "</div>`n"
					$ret = ""
					$vars = @()
					$desc = @()
				}
				$ignore = $False
			}
			$count += 1
		}
		$ct += "</div>"
	}
	else{
		$fdesc = @()
		$ret = ""
		$vars = @()
		$desc = @()
	}
}
$ct += "``)"
$ofs = " "
#Write content to genfunc.js.
Set-Content -Path "H:\Map 3d\1 Documentation\Auto-gen Documentation\js\genfunc.js" -Value $ct

#Powershell Documentation
$path = "H:\Map 3d\2 Code Library\ps1"
$list = @()
$ct = @()
$fdesc = @()
$ofs = "`n"

#Get all ps1 files. Only in top level folder.
$files = gci $path -Filter "*.ps1" | sort-object
#Same process as lisp, but only gets top level (fdesc) comments.
$ct += "document.write(``"
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
		Add-Content "H:\Map 3d\1 Documentation\Auto-gen Documentation\js\index.js" "{source:`"PS-Documentation.html#$filename`", value:`"$filename`"},"
		if($fdesc[-1] -eq "<br>"){
			$ct += "<div class=`"file`" id=`"$filename`">$filename"
		}
		else{
			$ct += "<div class=`"file`" id=`"$filename`">$filename`n<div class=`"fdesc`">$fdesc`n</div>"
		}
		$fdesc = @()
		$ct += "</div>"
	}
	else{
		$fdesc = @()
	}
}
$ct += "``)"
$ofs = " "
Set-Content -Path "H:\Map 3d\1 Documentation\Auto-gen Documentation\js\ps1func.js" -Value $ct

#Add Processes to Index
Add-Content "H:\Map 3d\1 Documentation\Auto-gen Documentation\js\index.js" (get-content "H:\Map 3d\1 Documentation\Auto-gen Documentation\Process-Documentation.html" | ?{$_ -like '*class="par procname">*'} | %{"{source:`"Process-Documentation.html#" + $_.split('>')[1] + "`", value: `"" + $_.split('>')[1] + "`"},"})
$content = Get-Content "H:\Map 3d\1 Documentation\Auto-gen Documentation\js\index.js"
$content[-1] = $content[-1] -replace '(.*),(.*)', '$1]$2'
Set-Content "H:\Map 3d\1 Documentation\Auto-gen Documentation\js\index.js" $content
