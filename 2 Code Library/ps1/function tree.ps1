#Generate a primitive Dependency Graph
$Path = 'H:\Map 3d\2 Code Library\lisp'
$index = 'H:\Map 3d\1 Documentation\Auto-gen Documentation\js\index.js'
$funcs = @()
foreach ($file in (gci $Path -recurse | ?{$_ -like "*.lsp"})){
	$funcs = $funcs += ($file.name)
	$content = @()
	$dep = @()
	foreach ($line in (gc $file.fullname)){
		if($line -notmatch '\(defun'){
			#List of all functions in the file
			$newcontent = (Select-String '\(.*?( |$|\()' -input $line -AllMatches | % matches | % Value | %{"`t" + $_.Trim(' ()')})
			#Search index for matches
			foreach ($nc in $newcontent){
				$dep = $dep += Select-String ("value:`"" + [Regex]::Escape($nc).Trim("\t") + "`", file:`"(?<Filename>.*?)`"\},") -input (Select-String '.*Lisp-Documentation.html.*' -path $index -AllMatches | % matches | % Value) -AllMatches | Select -expand Matches | foreach {$_.groups["Filename"].value} | % {"`t`t$_.lsp"}
			}
			$dep = ($dep | Select -Unique)

			$content = $content += $newcontent
			$content = $content += $dep
			$dep = ""
			$newcontent = ""
		}
	}
	$funcs = $funcs += ($content | select -Unique)
	Write-Output "."
}

Set-Content "$Path\funclist.txt" $funcs