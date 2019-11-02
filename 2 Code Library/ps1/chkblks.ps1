$MasterPath = "\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files"
$folderlist = gci $MasterPath | ?{$_.PSIsContainer}
$path = "$MasterPath\0000 sdf\edited by Noah"
# Export list of drawings in each folder, then write lisp to check against what's in the merged drawing.
foreach ($f in gci $path | ?{$_.PSIsContainer}){
	$num = $f.name
	set-content "H:\Map 3d\3 exports\edited_dwgs_$f.txt" (gci "$path\$num" | ?{$_.name -like "*.dwg"})
}

set-content "H:\Map 3d\3 exports\edited_dwgs_S.txt" (gci "\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\B Buildings\B08 Drawings\ArcGIS\Site Plans\Roof monument done\Title Block Done\Landscape and Parking Done\Checked\Monument IDs done\Playground and Portables done\Checked" | ?{$_.name -like "*.dwg"})