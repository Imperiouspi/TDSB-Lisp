$path = "H:\Map 3d\1 Documentation\Auto-gen Documentation\Processes"

gci $path -Recurse | ?{$_.Fullname -like "*.txt"} | %{(Get-Content $_.Fullname) + "`n"} | Set-Content "$path\AllProcesses.txt"