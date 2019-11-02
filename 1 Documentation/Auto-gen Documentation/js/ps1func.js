document.write(`
<div class="file" id="buildaccess.ps1">buildaccess.ps1
<div class="fdesc">Build the script to automate the accessibility geocoding process. Unreliable.<br>
</div>
</div>
<div class="file" id="chkblks.ps1">chkblks.ps1
<div class="fdesc">
</div>
</div>
<div class="file" id="Count_R.ps1">Count_R.ps1
<div class="fdesc">Count Roof plans in Master Files\\site number\\number<br>
</div>
</div>
<div class="file" id="fetch.ps1">fetch.ps1
<div class="fdesc">Retrieve all sdf floor plan drawings and put into "0000 sdf\\edited by Noah"<br>
After any keypress, then distribute those files into the floor-specific folders.<br>
</div>
</div>
<div class="file" id="function tree.ps1">function tree.ps1
<div class="fdesc">Generate a primitive Dependency Graph<br>
</div>
</div>
<div class="file" id="genprocesssdoc.ps1">genprocesssdoc.ps1
<div class="fdesc">
</div>
</div>
<div class="file" id="getfuncs.ps1">getfuncs.ps1
<div class="fdesc">Automatically generate documentation for lisp and powershell files.<br>
</div>
</div>
<div class="file" id="getname.ps1">getname.ps1
<div class="fdesc">Find Name of a school from its number<br>
</div>
</div>
<div class="file" id="missingtest.ps1">missingtest.ps1
<div class="fdesc">Find all floors that were missed in the complete export. Write to "3 exports\\Missing Floors.csv"<br>
</div>
</div>
<div class="file" id="moveback.ps1">moveback.ps1
<div class="fdesc">Move files from edited by Noah back to their original sdf folders. Will OVERWRITE any files left there.<br>
</div>
</div>
<div class="file" id="nextfolder_noreplace.ps1">nextfolder_noreplace.ps1
<div class="fdesc">For accessibility procedure. Opens and place each folder window for each site<br>
</div>
</div>
<div class="file" id="openaccess.ps1">openaccess.ps1
<div class="fdesc">Open each site plan and matching sdf drawing. Skip any contained in the "0000 sdf\Accessibility" folder.<br>
</div>
</div>
<div class="file" id="OpenAll.ps1">OpenAll.ps1
<div class="fdesc">View All files in the folder. Configured for H:\\Map 3d\\edited by Noah.<br>
</div>
</div>
<div class="file" id="ps2bat.ps1">ps2bat.ps1
<div class="fdesc">This writes a .bat file to execute a ps1 file. It used to use base-64 encoding, but that has a limit on file size. Now it uses -executionpolicy bypass argument instead.<br>
Usage: ps2bat.bat [file name] arguments[true|false]<br>
Arguments: if you want to pass information to your ps script, this will add that handling to the batch file. Optional, defaults to false.<br>
</div>
</div>
<div class="file" id="sort files.ps1">sort files.ps1
<div class="fdesc">Script:<br>
</div>
</div>
<div class="file" id="SortToRedraw.ps1">SortToRedraw.ps1
<div class="fdesc">Sorts sdf files from "edited by Noah" back to their original location. Ignores sites in the redraw process, and puts them in a "redraw" folder instead.<br>
Full implementation not finished, but would follow this algorithm:<br>
 To sort files:<br>
 IF not redraw<br>
 	IF newer<br>
 		replace<br>
 	ELSE older<br>
 		edit<br>
 ELSE redraw<br>
 	IF above _2 Review/_1 finSDF<br>
 		IF newer<br>
 			replace<br>
 		ELSE older<br>
 			edit<br>
 	ELSE in _2 Review/_1 finSDF<br>
 		edit<br>
sort into redraw<br>
</div>
</div>
<div class="file" id="throughfile.ps1">throughfile.ps1
<div class="fdesc">Seperate files from extralayers.csv and pface.csv. Only sort of works, seemed to miss some files. Will then open each of them in turn.<br>
</div>
</div>
`)
