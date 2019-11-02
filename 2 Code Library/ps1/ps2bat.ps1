#This writes a .bat file to execute a ps1 file. It used to use base-64 encoding, but that has a limit on file size. Now it uses -executionpolicy bypass argument instead.
#Usage: ps2bat.bat [file name] arguments[true|false]
#Arguments: if you want to pass information to your ps script, this will add that handling to the batch file. Optional, defaults to false.
param(
    [Parameter(position = 0)]$name, 
    [Parameter(position = 1)]$par = "false")

$curloc = get-location
set-location "H:\Map 3d\2 Lisp Library (Refactored)"
if($name -ne $null){
    $code = get-content -path ".\$name.ps1"
    if($null -ne $code){
        Write-Host "Converting $name"
        if($par -eq "true"){
            $contents = "set ARGS=%*`nset ARGS=%ARGS:`$=```$%`npowershell -executionpolicy bypass -file $name.ps1 %ARGS%"
        }
        else{
            $contents = "powershell -executionpolicy bypass -file $name.ps1"
        }
        set-content -path ".\$name.bat" -Value $contents
    }
}
set-location $curloc