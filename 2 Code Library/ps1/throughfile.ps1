#Seperate files from extralayers.csv and pface.csv. Only sort of works, seemed to miss some files. Will then open each of them in turn.

$last = 0
$list = get-content "H:\Map 3d\3 exports\extralayers.csv"
$list2 = get-content "H:\Map 3d\3 exports\pface.csv"

#move ok items to done
foreach ($f in (gci "H:\Map 3d\edited by Noah\" | ?{-not $_.PSIsContainer} | ?{$_.name -like "*.dwg"})){
    if(-not ($list2 -Contains $f.name)){ #-and (-not ($list2 -Contains $f.name))
        Move-item "H:\Map 3d\edited by Noah\$f" "H:\Map 3d\edited by Noah\Done\$f"
    }
}


#Open each wrong layer
# $ind = 0
# foreach ($f in $list){
#     if(-not ($f.contains(";"))){
#         ii "H:\Map 3d\edited by Noah\$f"
#         Write-Host "$f opened - Press any key to continue..."
#         $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
#         $list[$ind] = "; $f"
#         set-content "H:\Map 3d\3 exports\extralayers.csv" ($list -join "`n")
#     }
#     $ind = $ind + 1
# }

$ind = 0
foreach ($f in $list2){
    if(-not ($f.contains(";"))){
        ii "H:\Map 3d\edited by Noah\$f"
        Write-Host "$f opened - Press any key to continue..."
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        $list2[$ind] = "; $f"
        set-content "H:\Map 3d\3 exports\pface.csv" ($list2 -join "`n")
    }
    $ind = $ind + 1
}

