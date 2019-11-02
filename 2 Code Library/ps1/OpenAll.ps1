#View All files in the folder. Configured for H:\\Map 3d\\edited by Noah.
$MasterPath = "\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files"
foreach ($f in (gci "H:\Map 3d\edited by Noah" | ?{-not $_.PSIsContainer} | ?{$_.extension -eq ".dwg"} | sort-object)){
    ii "H:\Map 3d\edited by Noah\$f"
    Write-Host "$f opened - Press any key to continue..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}

