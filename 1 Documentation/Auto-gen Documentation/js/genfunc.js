document.write(`
<div class="file" id="acad.lsp">acad.lsp
<div class="fdesc">Will auto run when AutoCAD starts, as long as it's in a support file path. Uncomment to load ArcGIS for AutoCAD, which should load automatically without this code.<br>
</div>
</div>
<div class="file" id="acaddoc.lsp">acaddoc.lsp
<div class="fdesc">Will automatically run when any document is opened in Autocad, if the folder containing this file is among the "support files" specified in autocad settings.<br>
</div>
<div class="par">
<div class="function" id="C:EXR">C:EXR ()
</div>

<div class="desc"> Shortcut for <a href="#C:EXPORTNEWIDS">C:EXPORTNEWIDS</a><br>
</div>

</div>

<div class="par">
<div class="function" id="C:CS">C:CS ()
</div>

<div class="desc"> Zoom to extents, close and save shortcut.<br>
</div>

</div>

<div class="par">
<div class="function" id="C:RSNAP">C:RSNAP ()
</div>

<div class="desc"> Reset osnap to preferred settings. This number is in "H:\\Map 3d\\config.txt".<br>
</div>

</div>

<div class="par">
<div class="function" id="C:SETCONFIG">C:SETCONFIG ()
</div>

<div class="desc"> Set the configuration file "H:\\Map 3d\\config.txt" to store the correct osnap number for the preffered settings. Get with <a href="#C:GETCONFIG">GETCONFIG</a>, set osnap to this value with <a href="#C:RSNAP">RSNAP</a>.<br>
</div>

</div>

<div class="par">
<div class="function" id="C:GETCONFIG">C:GETCONFIG ()
</div>

<div class="desc"> Return the current osnap configuration stored in "H:\\Map 3d\\config.txt". Set with <a href="#C:SETCONFIG">SETCONFIG</a>, set osnap to this value with <a href="#C:RSNAP">RSNAP</a>.<br>
</div>

</div>

<div class="par">
<div class="function" id="C:EPROP">C:EPROP ()
</div>

<div class="desc"> Display entity data. Prompts to select an object.<br>
</div>

</div>

<div class="par">
<div class="function" id="C:ENAME">C:ENAME ()
</div>

<div class="desc"> Retrieve entity name. Prompts to select an object.<br>
</div>

<div class = "ret">Returns: Selected entity name.</div>

</div>

<div class="par">
<div class="function" id="C:PORTPROP">C:PORTPROP ()
</div>

<div class="desc"> Insert property line label and portable label without copying them in. Command for <a href="#insertextralabels">insertextralabels</a><br>
</div>

</div>

<div class="par">
<div class="function" id="C:LL">C:LL ()
</div>

<div class="desc"> Shortcut for <a href="#C:LABELLAYER">LABELLAYER</a><br>
</div>

</div>

</div>
<div class="file" id="access.lsp">access.lsp
<div class="fdesc">Functions to transfer and geocode the accessibility plan automatically. Copies from the floor plan, and aligns to a geocoded sdf file.<br>
</div>
<div class="par">
<div class="function" id="C:COPYACCESS">C:COPYACCESS ()
</div>

<div class="desc"> Copy the contents of the "Access" Tab<br>\
 Troubleshooting: Make sure the "Access" Tab exists. Make sure plan is in paper space not model space. <br>
</div>

</div>

<div class="par">
<div class="function" id="C:PASTENOROTATE">C:PASTENOROTATE ()
</div>

<div class="desc"> Insert and fix accessibility plan without automatically aligning it.<br>
</div>

</div>

<div class="par">
<div class="function" id="C:PASTEACCESS">C:PASTEACCESS ()
</div>

<div class="desc"> Insert, fix, and align the accessility plan into an sdf file.<br>\
 Matches the convex hull of the accessibility plan's polylines to the convex hull of the floor plan's gross area polyline. <br>\
 Troubleshooting: Sometimes it fails. Do it manually, it'll be faster than debugging. If there's a large red line, that's a good indicator of failure.<br>
</div>

</div>

<div class="par">
<div class="function" id="C:PASTEASPECTACCESS">C:PASTEASPECTACCESS ()
</div>

<div class="desc"> First iteration of pasteAccess. Aligns with a simple rectangle/aspect ratio check. Not very accurate, replaced by the convex hull method.<br>
</div>

</div>

<div class="par">
<div class="function" id="explode">explode (ss)
</div>

<div class="desc"> Runs the default EXPLODE command that also sets the weird "qaflags" properly, whatever they're for.<br>
</div>

<div class="vars">Arguments:<br>\
ss: Selection set to explode<br></div>

</div>

<div class="par">
<div class="function" id="getaspectratio">getaspectratio (points)
</div>

<div class="desc"> Calculate the aspect ratio of a rectangle described by the two points.<br>
</div>

<div class="vars">Arguments:<br>\
points: list of two points<br></div>

<div class = "ret">Returns: Aspect ratio as a decimal</div>

</div>

<div class="par">
<div class="function" id="getaccessbounds">getaccessbounds ()
</div>

<div class="desc"> Get the bounding box of the "access" block<br>
</div>

<div class = "ret">Returns: Bounding Box described by two points</div>

</div>

<div class="par">
<div class="function" id="testoverlap">testoverlap (plf \
pla)
</div>

<div class="desc"> Find the % overlap of two polylines<br>
</div>

<div class="vars">Arguments:<br>\
plf: floor outline polyline<br>\
pla: accessibility outline polyline<br></div>

<div class = "ret">Returns: % overlap between the polylines, as a decimal</div>

</div>

<div class="par">
<div class="function" id="getvcenter">getvcenter (ss)
</div>

<div class="desc"> Get the center of a selection set, returned as a list (vector)<br>
</div>

<div class="vars">Arguments:<br>\
ss: Selection set<br></div>

<div class = "ret">Returns: Center of ss, as a list</div>

</div>

<div class="par">
<div class="function" id="C:ATTDEF2TEXT">C:ATTDEF2TEXT ()
</div>

<div class="desc"> Changes attdef entities (attributes that haven't been put into a block) into dtext in the whole drawing<br>\
 Source: https://forums.augi.com/showthread.php?40372-change-exploded-block-attribute-tags-to-text<br>
</div>

</div>

<div class="par">
<div class="function" id="C:FAXESS">C:FAXESS ()
</div>

<div class="desc"> Fix the accessibility drawing. Move doors and stairs to "tdsb-smsc-accessibility red", and burst all blocks.<br>
</div>

</div>

<div class="par">
<div class="function" id="C:FAX">C:FAX ()
</div>

<div class="desc"> Shortcut for <a href="#c:faxess">faxess</a>, because I'm really lazy.<br>
</div>

</div>

</div>
<div class="file" id="batchexr.lsp">batchexr.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="C:AEXR">C:AEXR ()
</div>

<div class="desc"> Stands for Auto EXport Rooms. Will automatically label rooms, and should fix polyface meshes too.<br>
</div>

</div>

<div class="par">
<div class="function" id="C:NEXR">C:NEXR ()
</div>

<div class="desc"> Stands for Not EXport Rooms. Will export rooms, but will not set/overwrite any site ids.<br>
</div>

</div>

</div>
<div class="file" id="BATCHLISP.lsp">BATCHLISP.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="C:BATCHLISP">C:BATCHLISP ()
</div>

<div class="desc"> Program to create a script file to run a selected AutoLisp program on all drawings selected.<br>\
 Copyright 2004-2006 by JefferyPSanders.com All rights reserved. Please send all comments or suggestions to jps@jefferypsanders.com<br>\
 Usage: run BATCHLISP. Select files, select script, press run.<br>\
 Notes:<br>\
 1. This program requires the SELECTFILES routine by JefferyPSanders.com<br>\
 2. The AutoLisp file selected must be defined to use the same name to <br>\
 run the program as it's file name.<br>\
 Example: MYPROG.lsp must be defined as C:MYPROG() not C:MYP()<br>\
 3. The autolisp program cannot accept parameters.<br>
</div>

</div>

</div>
<div class="file" id="batchref.lsp">batchref.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="C:XREFFLOORS">C:XREFFLOORS ()
</div>

<div class="desc"> Add all lower floors as an xref to the current drawing. Used to align broken master files.<br>
</div>

</div>

</div>
<div class="file" id="catch22.lsp">catch22.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="C:CATCH22">C:CATCH22 ()
</div>

<div class="desc"> Find all files that still contain the "22" layer, and output them to <a href="file:///H:\\Map 3d\\3 exports\\caught22.txt"> caught22.txt </a>. <br>
</div>

</div>

<div class="par">
<div class="function" id="C:BEGIN">C:BEGIN ()
</div>

<div class="desc"> Check alignment of a drawing. Attaches "All Site Plans" as an xref to the current drawing. If offset, try fixing units and reattaching.<br>
</div>

</div>

<div class="par">
<div class="function" id="C:STOP">C:STOP ()
</div>

<div class="desc"> Detaches "All Site Plans" xref.<br>
</div>

</div>

</div>
<div class="file" id="chgunits.lsp">chgunits.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="C:CHGUNITS">C:CHGUNITS ()
</div>

<div class="desc"> Change units of the current drawing to inches. Should correct offset drawings.<br>
</div>

</div>

</div>
<div class="file" id="del-layer.lsp">del-layer.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="delbylayer">delbylayer ()
</div>

<div class="desc"> Delete all elements on a single layer. Downloaded, but slightly edited to work automatically.<br>
</div>

</div>

</div>
<div class="file" id="Ellipse2ArcV1-1.lsp">Ellipse2ArcV1-1.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="C:E2A">C:E2A ()
</div>

<div class="desc"> This program will allow the user to convert a selection of circular Ellipses & Elliptical Arcs (that is, Ellipses or Elliptical Arcs with axes of equal length) into Circles & Arcs respectively, whilst retaining all properties of the original objects.<br>\
 <br>\
 The program will furthermore perform correctly with Ellipses & Elliptical Arcs constructed in any UCS, and should be supported on all versions of AutoCAD, on both a Windows & Mac OS.<br>\
 Author:Lee Mac, Copyright � 2013-www.lee-mac.com<br>\
 Version 1.1-2015-03-14<br>\
 - Incorporated 1e-3 tolerance on the ellipse axis ratio into the ssget selection filter.<br>
</div>

</div>

<div class="par">
<div class="function" id="LM:defaultprops">LM:defaultprops (elist)
</div>

<div class="desc"> Default Properties-Lee Mac<br>
</div>

<div class="vars">Arguments:<br>\
elist: list of data returned by entget<br></div>

<div class = "ret">Returns: a list of DXF properties for the supplied DXF data, substituting default values for absent DXF groups</div>

</div>

<div class="par">
<div class="function" id="mxv">mxv (m \
v)
</div>

<div class="desc"> Matrix x Vector - Vladimir Nesterovsky<br>
</div>

<div class="vars">Arguments:<br>\
m: nxn matrix<br>\
v: vector in R^n<br></div>

<div class = "ret">Returns: cross product of matrix and vector</div>

</div>

</div>
<div class="file" id="entrance_ids.lsp">entrance_ids.lsp
<div class="fdesc">Works, however the labels are sometimes on the wrong elevation, which causes problems.<br>
</div>
<div class="par">
<div class="function" id="C:ENTRANCE_IDS">C:ENTRANCE_IDS ()
</div>

<div class="desc"> Command to run <a href="#label_entrance">label_entrance</a><br>
</div>

</div>

<div class="par">
<div class="function" id="label_entrance">label_entrance (layer \
label)
</div>

<div class="vars">Arguments:<br>\
layer: Where to find the police safety labels and triangles.<br>\
label: 4-letter code for site_id field<br></div>

</div>

<div class="par">
<div class="function" id="find_entrance_tri">find_entrance_tri (label \
triangles)
</div>

<div class="vars">Arguments:<br>\
label: which label, as an ename<br>\
triangles: list of triangle enames.<br></div>

</div>

<div class="par">
<div class="function" id="find_pl">find_pl (tri)
</div>

<div class="vars">Arguments:<br>\
tri: triangle to search around.<br></div>

<div class = "ret">Returns: the ename of the leader line (if found), or nil</div>

</div>

<div class="par">
<div class="function" id="min_dist_btwn_objects_pl">min_dist_btwn_objects_pl (tri \
label \
pl)
</div>

<div class="desc"> Find the minimum distance between two objects, with a polyline leader pointing between them.<br>
</div>

<div class="vars">Arguments:<br>\
tri: The object (as used, a triangle to label the entrance)<br>\
label: The other object (as used, an entrance label)<br>\
pl: the polyline leader between the two objects<br></div>

<div class = "ret">Returns: 1000000 if the leader does not point to the label, or 0 if it does.</div>

</div>

<div class="par">
<div class="function" id="min_dist_btwn_objects">min_dist_btwn_objects (tri \
label)
</div>

<div class="desc"> Find the minimum distance between two objects<br>
</div>

<div class="vars">Arguments:<br>\
tri: The object (as used, a triangle to label the entrance)<br>\
label: The other object (as used, an entrance label)<br></div>

<div class = "ret">Returns: The minimum distance between the traingle and label, as a float.</div>

</div>

<div class="par">
<div class="function" id="dist_line_to_line">dist_line_to_line (l1 \
l2)
</div>

<div class="desc"> Find the minimum distance between two line segments, described by two points<br>
</div>

<div class="vars">Arguments:<br>\
l1: segment 1<br>\
l2: segment 2<br></div>

<div class = "ret">Returns: distance between the lines</div>

</div>

<div class="par">
<div class="function" id="disttosegment">disttosegment (a \
b \
p)
</div>

<div class="desc"> Distance from a point to a segment ab<br>
</div>

<div class="vars">Arguments:<br>\
a: first point of the segment<br>\
b: second point of the segment<br>\
p: point<br></div>

<div class = "ret">Returns: distance, as a float</div>

</div>

<div class="par">
<div class="function" id="v-">v- (v1 \
v2)
</div>

<div class="desc"> Perform vector subtraction<br>
</div>

<div class="vars">Arguments:<br>\
v1: vector 1<br>\
v2: vector 2<br></div>

<div class = "ret">Returns: v1 - v2</div>

</div>

<div class="par">
<div class="function" id="v+">v+ (v1 \
v2)
</div>

<div class="desc"> Perform vector addition<br>
</div>

<div class="vars">Arguments:<br>\
v1: vector 1<br>\
v2: vector 2<br></div>

<div class = "ret">Returns: v1 + v2</div>

</div>

<div class="par">
<div class="function" id="v++">v++ (vlist)
</div>

<div class="desc"> Perform vector addition on a list of vectors<br>
</div>

<div class="vars">Arguments:<br>\
vlist: a list of vectors<br></div>

<div class = "ret">Returns: v1 + v2 + v3...</div>

</div>

<div class="par">
<div class="function" id="v*">v* (v \
a)
</div>

<div class="desc"> Multiplies a vector by a scalar<br>
</div>

<div class="vars">Arguments:<br>\
v: vector<br>\
a: scalar<br></div>

<div class = "ret">Returns: v * a</div>

</div>

<div class="par">
<div class="function" id="dot">dot (l1 \
l2)
</div>

<div class="desc"> Perform dot multiplication<br>
</div>

<div class="vars">Arguments:<br>\
l1: vector 1<br>\
l2: vector 2<br></div>

<div class = "ret">Returns: l1 · l2</div>

</div>

<div class="par">
<div class="function" id="vl">vl (v)
</div>

<div class="desc"> Find the length of a vector (vl stands for Vector Length). All it does is v · v.<br>
</div>

<div class="vars">Arguments:<br>\
v: the vector<br></div>

<div class = "ret">Returns: v · v, the length of vector v</div>

</div>

<div class="par">
<div class="function" id="get_number">get_number (label)
</div>

<div class="desc"> Retrieve the number from the attributes of the exterior door label, formatting it to be ready for the monument id.<br>
</div>

<div class="vars">Arguments:<br>\
label: from where the number is retrieved.<br></div>

<div class = "ret">Returns: the id, formatted as XX.</div>

</div>

<div class="par">
<div class="function" id="highlight_nozoom">highlight_nozoom ()
</div>

<div class="desc"> Highlight an object by drawing a rounding box<br>\
 obj: the object<br>
</div>

</div>

<div class="par">
<div class="function" id="flag">flag (arg)
</div>

<div class="desc"> Flag a drawing as bad for some reason. Written to flagged_site.csv.<br>
</div>

<div class="vars">Arguments:<br>\
arg: The reason the site is bad, a short phrase usually.<br></div>

</div>

<div class="par">
<div class="function" id="C:UNDOALL">C:UNDOALL ()
</div>

<div class="desc"> Reset a file back to the state when it was first opened, undoing everything possible.<br>
</div>

</div>

<div class="par">
<div class="function" id="move_to_tri_center">move_to_tri_center (txt)
</div>

<div class="desc"> Move the text to the center of the traingle.<br>
</div>

<div class="vars">Arguments:<br>\
txt: the text object to be moved onto the entrance triangle<br></div>

</div>

<div class="par">
<div class="function" id="center_tri">center_tri (tri)
</div>

<div class="desc"> Find the center of the triangle. Takes an average of all points, so only accurate for regular polygons.<br>
</div>

<div class="vars">Arguments:<br>\
tri: the triangle.<br></div>

<div class = "ret">Returns: a 3d vla point.</div>

</div>

</div>
<div class="file" id="Exportalllabels.lsp">Exportalllabels.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="C:EXPORTROOMIDS">C:EXPORTROOMIDS ()
</div>

<div class="desc"> Write all room labels into all_ids.csv.<br>
</div>

</div>

</div>
<div class="file" id="exportrooms.lsp">exportrooms.lsp
<div class="fdesc">This file contains functions written while assigning room ids.<br>\
The use of these functions takes place in "newroomid.lsp"<br>
</div>
<div class="par">
<div class="function" id="getlabel">getlabel (areae)
</div>

<div class="desc"> Try to find label contained in the room.<br>
</div>

<div class="vars">Arguments:<br>\
areae: an entity name<br></div>

<div class = "ret">Returns: a list in the form (New ID (placeholder only), Old Room ID, Door Number, Door Name, Room Use, Label entity name). All properties except new id from the found label.</div>

</div>

<div class="par">
<div class="function" id="testpt">testpt (x \
y \
ptlist)
</div>

<div class="desc"> Ray Test, to figure out whether a point x y is in the polygon.<br>\
 To obtain ptlist, use the function (LM:ent->pts) written by Lee Mac in utils.lsp<br>
</div>

<div class="vars">Arguments:<br>\
x: x coordinate of point to test<br>\
y: y coordinate of point to test<br>\
ptlist: list of points defining polygon. Either 2d or 3d.<br></div>

<div class = "ret">Returns: count of how many lines were intersected with the ray test. If it is odd, the point is inside. If it is even, the point is outside the polyline.</div>

</div>

<div class="par">
<div class="function" id="intersect">intersect (m \
b \
py1 \
py2 \
x \
y)
</div>

<div class="desc"> Test intersection of a ray from point x,y along the x axis, to the line segment defined by slope m, intersect b, and between points py1 and py2.<br>
</div>

<div class="vars">Arguments:<br>\
m: slope of line<br>\
b: y-intercept of line<br>\
py1: end point of line<br>\
py2: end point of line<br>\
x: x-coord of point to test<br>\
y: y-coord of point to test<br></div>

<div class = "ret">Returns: T if the ray intersects, nil if not.</div>

</div>

<div class="par">
<div class="function" id="getorigin">getorigin (ent)
</div>

<div class="desc"> Get the origin of a label, the left corner of the bottommost block.<br>\
 Hardcoded to work with four types of blocks.<br>
</div>

<div class="vars">Arguments:<br>\
ent: block ename<br></div>

<div class = "ret">Returns: origin in a list (x y)</div>

</div>

<div class="par">
<div class="function" id="beginexport">beginexport (default)
</div>

<div class="desc"> Set up the export for the rooms. Opens a folder selection dialog, and opens a file "export2.csv" in append mode in that folder.<br>\
 Append mode will not overwrite existing contents.<br>
</div>

<div class="vars">Arguments:<br>\
default: boolean. Use the default directory if True (H:\\Map 3d\\3 exports).<br></div>

<div class = "ret">Returns: the folder path where it is saved. No folder was selected if nil returned.</div>

</div>

<div class="par">
<div class="function" id="write_export">write_export (siteid \
newid \
roomid \
doornum \
doorname \
roomuse)
</div>

<div class="desc"> Write the values to the export file. File defined as variable "f" outside the function (bad form sorry).<br>
</div>

<div class="vars">Arguments:<br>\
siteid: the Facility number, or site id of the building<br>\
newid: the new room id added to the room<br>\
roomid: the old room id for the room<br>\
doornum: Door Number, if it were retrieved from the label.<br>\
doorname: Door Name if it was retrieved from the label.<br>\
roomuse: "Used As", as specified in the label.<br></div>

</div>

</div>
<div class="file" id="findvertex.lsp">findvertex.lsp
<div class="par">
<div class="function" id="search">search ()
</div>

</div>

<div class="par">
<div class="function" id="next">next ()
</div>

</div>

</div>
<div class="file" id="hull.lsp">hull.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="convexhull">convexhull (ss)
</div>

<div class="desc"> Convex Hull program from Lee Mac.<br>
</div>

<div class="vars">Arguments:<br>\
ss: Selection Set<br></div>

<div class = "ret">Returns: List of points describing the convex hull.</div>

</div>

<div class="par">
<div class="function" id="getpoints">getpoints (obj \
blockobj)
</div>

<div class="desc"> Retrieve points from an object<br>
</div>

<div class="vars">Arguments:<br>\
obj: objects to get coordinates from<br>\
blockobj: t or nil, is the object a block?<br></div>

</div>

<div class="par">
<div class="function" id="LM:ConvexHull">LM:ConvexHull (lst)
</div>

<div class="desc"> Return a list of points describing the convex hull of an object<br>
</div>

<div class="vars">Arguments:<br>\
lst: a list of points describing an object<br></div>

<div class = "ret">Returns: a new list of points describing the convex hull</div>

</div>

<div class="par">
<div class="function" id="LM:Clockwise-p">LM:Clockwise-p (p1 \
p2 \
p3)
</div>

<div class="desc"> Lee Mac - Returns T if p1,p2,p3 are clockwise oriented or collinear<br>
</div>

<div class="vars">Arguments:<br>\
p1: point<br>\
p2: point<br>\
p3: point<br></div>

</div>

<div class="par">
<div class="function" id="refgeom">refgeom (ent)
</div>

<div class="desc"> gile - Returns a list whose first item is a 3x3 transformation matrix and second item the object insertion point in its parent (xref, block or space)<br>
</div>

<div class="vars">Arguments:<br>\
ent: ename of object<br></div>

<div class = "ret">Returns: a fancy matrix and an insertion point</div>

</div>

<div class="par">
<div class="function" id="trp">trp (m)
</div>

<div class="desc"> Matrix Transpose  -  Doug Wilson<br>
</div>

<div class="vars">Arguments:<br>\
m: nxn matrix<br></div>

<div class = "ret">Returns: the transpose of m</div>

</div>

<div class="par">
<div class="function" id="mxm">mxm (m \
n)
</div>

<div class="desc"> Matrix x Matrix  -  Vladimir Nesterovsky<br>
</div>

<div class="vars">Arguments:<br>\
m: nxn matrix<br>\
n: nxn matrix<br></div>

<div class = "ret">Returns: the product of m and n</div>

</div>

<div class="par">
<div class="function" id="mxv">mxv (m \
v)
</div>

<div class="desc"> Matrix x Vector  -  Vladimir Nesterovsky<br>
</div>

<div class="vars">Arguments:<br>\
m: nxn matrix<br>\
v: vector in R^n<br></div>

<div class = "ret">Returns: the cross product of m and a vector</div>

</div>

<div class="par">
<div class="function" id="makehull">makehull (ss)
</div>

<div class="desc"> Create a convex hull out of a selection set.<br>
</div>

<div class="vars">Arguments:<br>\
ss: A selection set from which to create the hull<br></div>

<div class = "ret">Returns: the polyline describing the hull</div>

</div>

</div>
<div class="file" id="ids.lsp">ids.lsp
<div class="fdesc">Functions to add monument ids to various features on site plans. Functions can be called by themselves, but are called in "monumentids.lsp".<br>\
Generally follow form:<br>\
(id_feature "Layer Name" "List of four letter codes associated with layer")<br>
</div>
<div class="par">
<div class="function" id="C:IDS">C:IDS ()
</div>

<div class="desc"> Add a facility id to every object.<br>
</div>

</div>

<div class="par">
<div class="function" id="C:NEWFIELDS">C:NEWFIELDS ()
</div>

<div class="desc"> Adds the facility number in site_id object data, to any object that does not already have a site id.<br>
</div>

</div>

<div class="par">
<div class="function" id="C:FAC_ID">C:FAC_ID ()
</div>

<div class="desc"> Adds the facility number in site_id object data, to any object that does not already have a site id.<br>
</div>

</div>

<div class="par">
<div class="function" id="id_layer">id_layer (layname \
label \
mode \
isclose)
</div>

<div class="desc"> Add Monument ID to a generic layer.<br>\
 If in numbered mode, will set id as facility#_XXXX_NUM, where NUM is a two digit number. The first feature will be assigned _01<br>\
 If in letter mode, will set id as facility#_XXXX_Y, where Y is a single letter. The first feature will be assigned _A<br>
</div>

<div class="vars">Arguments:<br>\
layname: string. layer name of feature<br>\
label: string. four letter code associated with layer (e.g. "GRSS" or "WALK" or "ROOF")<br>\
mode: string. "num" to use number mode, and "let" to use letter mode. <br>\
isclose: bool. should this layer be automatically closed during execution?<br></div>

</div>

<div class="par">
<div class="function" id="id_layer_child">id_layer_child (layname \
parentlayer \
label \
mode \
isclose \
byhand)
</div>

<div class="desc"> Label the layer based on their outline (e.g. playscape label from playground outline).<br>
</div>

<div class="vars">Arguments:<br>\
layname: Name of the layer<br>\
parentlayer: Name of the outline layer<br>\
label: 4-letter code for the layer. This method only accepts a string<br>\
mode: "let" or "num", to specify whether the labels use A-Z or 0, 1, 2...<br>\
isclose: Whether or not to close the polygons after they've been labelled<br>\
byhand: label with a polyline path (T), or automatically (nil).<br></div>

</div>

<div class="par">
<div class="function" id="id_forest">id_forest (layname \
labels)
</div>

<div class="desc"> Add id to the landscape layer. If a landscape layer exists, will ask whether any forests exist (usually none do on sites).<br>\
 If a forest is present on site, will loop through all landscape polylines and ask if each one is a forest feature.<br>\
 It tries to highlight each polyline with a white box as it goes, and zooms to each one, but the white box is erased by a redraw and is not always visible.<br>
</div>

<div class="vars">Arguments:<br>\
layname: "tdsb-smsc-landscape".<br>\
labels: List of labels associated with the forest ("FRST")<br></div>

</div>

<div class="par">
<div class="function" id="id_field">id_field (layname \
label \
layname \
labels \
layname \
labels \
layname \
labels)
</div>

<div class="desc"> Add id to the playscapes. Looks for a surrounding playground outline, and then adds the id in the form: Facitilty#_PLAY_X##<br>\
 Unfortunately, this is unreliable, and also does not correctly increase index as new playscapes are found within playground outlines, so it was done by hand rather than bother fixing this code.<br>\
 To fix: A list of values, length = # of playground outlines, and keep track of how many playscapes have been found in each.<br>\
 	OR follow the form of id_parking, and loop through outlines and check which playscapes are inside.<br>\
 If a playscape was not inside, it was labelled as: Facitilty#_PLAY_##, clockwise from enterance 1.<br>\
 Not used, do it manually.<br>\
 Add id to parking points. For each parking lot, it distinguishes all disabled parking spaces (with (chgdspl)), and then assigns ids clockwise as normal.<br>\
 Add Ids to portables. This is found in model space, and was assumed to be in a "smsc-room label-small" block. This is inconsistent, and is probably better done by hand.<br>\
 Labels by distance to the building outline centroid. Includes "[layname] 2" to use for soccerfields and baseball diamonds.<br>
</div>

<div class="vars">Arguments:<br>\
layname: "tdsb-smsc-playground outline"<br>\
label: list. ("PLAY")<br>\
Arguments:<br>\
layname: "tdsb-smsc-parking points"<br>\
labels: list. ("PARK" "DSPL")<br>\
Arguments:<br>\
layname: "tdsb-smsc-portables"<br>\
labels: ""<br>\
Arguments:<br>\
layname: layer name to label<br>\
labels: list of 4 letter codes to add to the label.<br></div>

</div>

<div class="par">
<div class="function" id="id_layer_line">id_layer_line (layname \
parentlayer \
mode \
isclose)
</div>

<div class="desc"> Set the site id of objects, following the path of a polyline selected or drawn by the user.<br>
</div>

<div class="vars">Arguments:<br>\
layname: Name of the layer<br>\
parentlayer: Name of the outline layer<br>\
mode: "let" or "num", to specify whether the labels use A-Z or 0, 1, 2...<br>\
isclose: Whether or not to close the polygons after they've been labelled<br></div>

</div>

</div>
<div class="file" id="ids_2.lsp">ids_2.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="id_by_line">id_by_line (layname \
label \
mode \
nodel)
</div>

<div class="desc"> Add monument ids based on a polyline specified or drawn by the user.<br>
</div>

<div class="vars">Arguments:<br>\
layname: Name of the layer<br>\
label: 4-letter code for the layer. This method only accepts a string<br>\
mode: "let" or "num", to specify whether the labels use A-Z or 0, 1, 2...<br>\
nodel: T to not delete the polyline after the objects have been id'd.<br></div>

</div>

<div class="par">
<div class="function" id="id_by_line_child">id_by_line_child (layname \
parentlayer \
label \
mode \
nodel)
</div>

<div class="desc"> Labels a layer based on the outline of those objects, following a line. For example, playscapes inside a playground. The playground is A, so the playscapes are A01. Not used by any layer as of 2019-08-05<br>
</div>

<div class="vars">Arguments:<br>\
layname: Name of the layer<br>\
parentlayer: Name of the outline layer<br>\
label: 4-letter code for the layer. This method only accepts a string<br>\
mode: "let" or "num", to specify whether the labels use A-Z or 0, 1, 2...<br>\
nodel: T to not delete the polyline after the objects have been id'd.<br></div>

</div>

<div class="par">
<div class="function" id="id_set_by_line">id_set_by_line (ss \
layname \
label \
mode \
nodel)
</div>

<div class="desc"> Add monument ids based on a polyline specified or drawn by the user. Accepts a selection set rather than a layer name.<br>
</div>

<div class="vars">Arguments:<br>\
ss: selection of objects to label<br>\
layname: Name of the layer<br>\
label: 4-letter code for the layer. This method only accepts a string<br>\
mode: "let" or "num", to specify whether the labels use A-Z or 0, 1, 2...<br>\
nodel: T to not delete the polyline after the objects have been id'd.<br></div>

</div>

<div class="par">
<div class="function" id="id_by_line_child_parking">id_by_line_child_parking (layname \
parentlayer \
label \
mode \
nodel)
</div>

<div class="desc"> A modification of id_by_line_child, adapted to include identifying accessible parking.<br>
</div>

<div class="vars">Arguments:<br>\
layname: Name of the layer<br>\
parentlayer: Name of the outline layer<br>\
label: 4-letter code for the layer. This method only accepts a string<br>\
mode: "let" or "num", to specify whether the labels use A-Z or 0, 1, 2...<br>\
nodel: T to not delete the polyline after the objects have been id'd.<br></div>

</div>

<div class="par">
<div class="function" id="id_by_hand">id_by_hand (layname \
label \
mode \
on)
</div>

<div class="desc"> ID the specified layer by hand. Can accept a list of labels, will ask which label to apply for each polyline. Enter "D" to stop labelling. <br>
</div>

<div class="vars">Arguments:<br>\
layname: Name of the layer<br>\
label: 4-letter code for the layer. This method can accept a list of labels.<br>\
mode: "let" or "num", to specify whether the labels use A-Z or 0, 1, 2...<br>\
on: A list of layers that should be displayed while labelling by hand.<br></div>

</div>

<div class="par">
<div class="function" id="id_soccer_posts">id_soccer_posts (layname \
parentlayer \
label \
mode \
isclose)
</div>

<div class="desc"> Label the soccer posts. Will either find which field it's in, or will find the closest field.<br>
</div>

<div class="vars">Arguments:<br>\
layname: Name of the layer<br>\
parentlayer: Name of the outline layer<br>\
label: 4-letter code for the layer. This method only accepts a string<br>\
mode: "let" or "num", to specify whether the labels use A-Z or 0, 1, 2...<br>\
isclose: Whether or not to close the polygons after they've been labelled<br></div>

</div>

<div class="par">
<div class="function" id="id_portables_2">id_portables_2 (layname \
label)
</div>

<div class="desc"> Loop through each portable and ask user for an id for each.<br>
</div>

<div class="vars">Arguments:<br>\
layname: the name of the layer the portables are on<br>\
label: Label for site id. Unused, but needed for compatibility with SMN<br></div>

</div>

<div class="par">
<div class="function" id="ZmObj">ZmObj (ss)
</div>

<div class="desc"> Zoom to a selection set's extents<br>\
 Source: <a href="https://www.cadtutor.net/forum/topic/10334-zoom-to-selected-objects/?do=findComment&comment=83856">https://www.cadtutor.net/forum/topic/10334-zoom-to-selected-objects/?do=findComment&comment=83856</a><br>
</div>

<div class="vars">Arguments:<br>\
ss: a selection set<br></div>

</div>

<div class="par">
<div class="function" id="get_closest">get_closest (object \
targets)
</div>

<div class="desc"> Find the closest target to the object.<br>
</div>

<div class="vars">Arguments:<br>\
object: the object, an ename<br>\
targets: a list of enames<br></div>

<div class = "ret">Returns: the ename of the closest target to object.</div>

</div>

<div class="par">
<div class="function" id="sort_by_segment">sort_by_segment (a \
b)
</div>

<div class="desc"> Comparison function to sort along a line segment<br>
</div>

<div class="vars">Arguments:<br>\
a: a list containing relevant information, specifically which line segment and where along the line it is.<br>\
b: a list containing relevant information, specifically which line segment and where along the line it is.<br></div>

</div>

<div class="par">
<div class="function" id="get_obj_point">get_obj_point (obj)
</div>

<div class="desc"> Pass any object to find the "origin" for that object type. Polyline uses center, points are their own origin, Text uses the text base, Lines use the midpoint.<br>
</div>

<div class="vars">Arguments:<br>\
obj: object to find origin of<br></div>

<div class = "ret">Returns: Origin point of object. In form (x y z)</div>

</div>

<div class="par">
<div class="function" id="point_on_segment">point_on_segment (p \
a \
b)
</div>

<div class="desc"> Find the closest point on a line segment.<br>
</div>

<div class="vars">Arguments:<br>\
p: Point<br>\
a: Start of the segment<br>\
b: End of the segment<br></div>

<div class = "ret">Returns: the point on the segment that "p" is closest to.</div>

</div>

<div class="par">
<div class="function" id="sortbydist">sortbydist (objlist \
outlinegon)
</div>

<div class="desc"> Sort objects based on how far away they are from the center of the polygon<br>
</div>

<div class="vars">Arguments:<br>\
objlist: list of objects<br>\
outlinegon: polyline to measure distance from<br></div>

</div>

</div>
<div class="file" id="label2.lsp">label2.lsp
<div class="fdesc">Helps label rooves, rewritten from Original Site Plan Lisp\\helper.lsp. No longer depends on anything from that folder.<br>
</div>
<div class="par">
<div class="function" id="C:ROOF">C:ROOF ()
</div>

<div class="desc"> Command to run <a href="#helper2">helper2</a>. See <a href="Process-Documentation.html#RoofPlan">Roof Plan Documentation</a> for how to use it.<br>
</div>

</div>

<div class="par">
<div class="function" id="helper2">helper2 ()
</div>

<div class="desc"> Label roof parapet lines and canopy lines. Run through <a href="#C:ROOF">ROOF</a>. See <a href="Process-Documentation.html#RoofPlan">Roof Plan Documentation</a> for how to use it.<br>
</div>

</div>

<div class="par">
<div class="function" id="createSections2">createSections2 ()
</div>

<div class="desc"> Create "sections" list, color sections<br>
</div>

</div>

<div class="par">
<div class="function" id="isolate">isolate ()
</div>

<div class="desc"> Turn on only savedlayer (set by the gui) and the text layer for savedlayer.<br>
</div>

</div>

<div class="par">
<div class="function" id="labelLayers2">labelLayers2 ()
</div>

<div class="desc"> label room sections.<br>
</div>

</div>

<div class="par">
<div class="function" id="fixlabel2">fixlabel2 ()
</div>

<div class="desc"> Fix any roof id, replacing old monument id with the new one. Only the section and section number need by specified (i.e. "A4")<br>
</div>

</div>

<div class="par">
<div class="function" id="saveid">saveid ()
</div>

<div class="desc"> Save the id entered in the fixlabel box before closing the box.<br>
</div>

</div>

<div class="par">
<div class="function" id="redolabel">redolabel ()
</div>

<div class="desc"> Actually reset the label specified in "fixid".<br>
</div>

</div>

<div class="par">
<div class="function" id="PSC">PSC (poly)
</div>

<div class="desc"> To determine whether a Polyline of any type Crosses itSelf.<br>\
 With 3D Polylines, must have true intersection in 3D, not apparent in 2D.<br>
</div>

<div class="vars">Arguments:<br>\
poly: entity to be examined<br></div>

<div class = "ret">Returns: T if self-crossing, nil if not.</div>

</div>

<div class="par">
<div class="function" id="C:FIXALL">C:FIXALL ()
</div>

<div class="desc"> Fix all ids in a selection set after they were all set to use facility number 0388 rather than the correct one.<br>
</div>

</div>

<div class="par">
<div class="function" id="getSelection">getSelection ()
</div>

<div class="desc"> Ask for a selection of polylines<br>
</div>

<div class = "ret">Returns: A selection set.</div>

</div>

<div class="par">
<div class="function" id="placeText">placeText (selection \
id \
savedlayer)
</div>

<div class="desc"> code from <a href="https://www.cadtutor.net/forum/topic/96-lisp-for-marks-centroids-of-closed-polylines/">https://www.cadtutor.net/forum/topic/96-lisp-for-marks-centroids-of-closed-polylines/</a><br>\
 Place text "id" on "savedlayer" in the center of "selection"<br>
</div>

<div class="vars">Arguments:<br>\
selection: a selection set.<br>\
id: a string to place at the center of each polyline in selection.<br>\
savedlayer: layer on which id will be placed.<br></div>

</div>

<div class="par">
<div class="function" id="getlayer">getlayer (sel_list \
layer)
</div>

<div class="desc"> Filter a selection set objects by layer.<br>
</div>

<div class="vars">Arguments:<br>\
sel_list: Selection set, the list to filter<br>\
layer: String, name of layer to filter for.<br></div>

<div class = "ret">Returns: Filtered selection set.</div>

</div>

<div class="par">
<div class="function" id="getschoolnum">getschoolnum ()
</div>

<div class="desc"> Retrieve the facility id from the document name (assuming the facility id is the first 4 characters of the name)<br>
</div>

</div>

</div>
<div class="file" id="merge.lsp">merge.lsp
<div class="fdesc">Commands to merge drawings into one as blocks.<br>\
Mergecad can be used for site plans and general drawings. Mergefloors will add blocks to layers specifying which floor it represents. (0-floor#)<br>
</div>
<div class="par">
<div class="function" id="C:MERGECAD">C:MERGECAD ()
</div>

<div class="desc"> Import selected drawings as blocks on the current layer.<br>
</div>

</div>

<div class="par">
<div class="function" id="C:MERGEXCAD">C:MERGEXCAD ()
</div>

<div class="desc"> Import selected drawings exploded onto the current layer.<br>
</div>

</div>

<div class="par">
<div class="function" id="C:REPLACECAD">C:REPLACECAD ()
</div>

<div class="desc"> Replace each same-named drawing with the newly selected file. Matches site id and floor. (first 6 characters)<br>
</div>

</div>

<div class="par">
<div class="function" id="C:MERGEFLOORS">C:MERGEFLOORS ()
</div>

<div class="desc"> Import selected drawings as blocks, seperating each onto the appropriate layer (e.g. 0-1 for first floor, 0-2 for second, etc.)<br>
</div>

</div>

<div class="par">
<div class="function" id="C:FLOORNUM">C:FLOORNUM ()
</div>

<div class="desc"> Meant to automate floor labelling, like batchlisp.<br>\
 doesn't work.<br>
</div>

</div>

</div>
<div class="file" id="monumentids.lsp">monumentids.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="C:SMN">C:SMN ()
</div>

<div class="desc"> Originally just a shortcut for site_mon_nums, but now also does some cleaning.<br>\
 Merges "parking point" into "parking points"<br>\
 Also runs NEWFIELDS to add site ids to anything not assigned in the normal procedure.<br>
</div>

</div>

<div class="par">
<div class="function" id="list_layers">list_layers ()
</div>

<div class = "ret">Returns the master list of layers, functions, labels, and arguments, for execution of monument labelling.</div>

</div>

<div class="par">
<div class="function" id="site_mon_nums">site_mon_nums ()
</div>

<div class="desc"> Add monument ids to all features<br>
</div>

</div>

<div class="par">
<div class="function" id="C:LABELLAYER">C:LABELLAYER ()
</div>

<div class="desc"> User selects a layer from a dropdown list, and this functions runs the correct method to label it, or asks for a new layer if no method is specified for that layer.<br>
</div>

</div>

<div class="par">
<div class="function" id="saveLayer">saveLayer ()
</div>

<div class="desc"> Save layer name when DCL is closed<br>
</div>

</div>

<div class="par">
<div class="function" id="sortclockwise">sortclockwise (arealist \
outlinelist)
</div>

<div class="desc"> Redirects to gensortclockwise (for compatibility). Sort a list of areas.<br>
</div>

<div class="vars">Arguments:<br>\
arealist: List of entities to be sorted<br>\
outlinelist: List of points<br></div>

<div class = "ret">Returns: sorted list</div>

</div>

<div class="par">
<div class="function" id="sortclockwisePt">sortclockwisePt (pointlist \
outlinelist)
</div>

<div class="desc"> Redirects to gensortclockwise (for compatibility). Sort a list of points.<br>
</div>

<div class="vars">Arguments:<br>\
pointlist: List of points to be sorted<br>\
outlinelist: List of points<br></div>

<div class = "ret">Returns: sorted list</div>

</div>

<div class="par">
<div class="function" id="gensortclockwise">gensortclockwise (arealist \
pointlist \
outlinelist)
</div>

<div class="vars">Arguments:<br>\
arealist: List of entity names to be sorted<br>\
pointlist: List of centroids (dotted pairs: (x . y))<br>\
outlinelist: List of points<br></div>

<div class = "ret">Returns: sorted list</div>

</div>

<div class="par">
<div class="function" id="isCounterClockwise">isCounterClockwise (alist)
</div>

<div class="desc"> Test if list of points is mostly counterclockwise.<br>
</div>

<div class="vars">Arguments:<br>\
alist: List of points<br></div>

<div class = "ret">Returns: T or nil</div>

</div>

<div class="par">
<div class="function" id="gbo">gbo ()
</div>

<div class="desc"> Get building outline<br>
</div>

<div class = "ret">Returns: Selection set of building outlines</div>

</div>

<div class="par">
<div class="function" id="find_closest">find_closest (apoint \
apointlist)
</div>

<div class="desc"> Find closest edge (described by two points) to a point<br>
</div>

<div class="vars">Arguments:<br>\
apoint: the point<br>\
apointlist: list of points that describes edges<br></div>

<div class = "ret">Returns: integer, index of closest edge from apointlist</div>

</div>

<div class="par">
<div class="function" id="disttoline">disttoline (x0 \
y0 \
x1 \
x2 \
y1 \
y2)
</div>

<div class="desc"> Distance from point to line<br>
</div>

<div class="vars">Arguments:<br>\
x0: point x<br>\
y0: point y<br>\
x1: beginning x-coord<br>\
x2: end x-coord<br>\
y1: beginning y-coord<br>\
y2: end y-coord<br></div>

<div class = "ret">Returns: real, distance</div>

</div>

<div class="par">
<div class="function" id="testorder">testorder (Ret1 \
Ret2)
</div>

<div class="vars">Arguments:<br>\
Ret1: list, containing (object, centroid, index of closest edge)<br>\
Ret2: other list, same format as ret1<br></div>

<div class = "ret">Returns: T or nil</div>

</div>

<div class="par">
<div class="function" id="dist">dist (p1 \
p2)
</div>

<div class="desc"> Distance between two points. Only tests x and y, not z, but will work with a 3d point.<br>
</div>

<div class="vars">Arguments:<br>\
p1: point 1.<br>\
p2: point 2.<br></div>

<div class = "ret">Returns: real, distance between points</div>

</div>

<div class="par">
<div class="function" id="highlight">highlight (obj)
</div>

<div class="desc"> Highlight an object by drawing a rounding box, and zooming to the object<br>
</div>

<div class="vars">Arguments:<br>\
obj: the object<br></div>

</div>

<div class="par">
<div class="function" id="buildSelfilter">buildSelfilter (types \
layers \
blocknames)
</div>

<div class="desc"> Builds a filter for ssget. Filter will select any objects that share any of the traits given.<br>
</div>

<div class="vars">Arguments:<br>\
types: list of object types (e.g. LWPOLYLINE, POINT, or INSERT)<br>\
layers: list of layers<br>\
blocknames: list of blocks<br></div>

<div class = "ret">Returns: list of strings</div>

</div>

<div class="par">
<div class="function" id="chgdspl">chgdspl (pointlist)
</div>

<div class="desc"> Change parking points DSPL. Based on distance to closest icon. Changes the layer to "tdsb-smsc-parking points u".<br>
</div>

<div class="vars">Arguments:<br>\
pointlist: list of parking points in the drawing<br></div>

<div class = "ret">Returns: count of points changed</div>

</div>

<div class="par">
<div class="function" id="change_layer">change_layer (obj \
newlayer)
</div>

<div class="vars">Arguments:<br>\
obj: object to move<br>\
newlayer: layer to place object on<br></div>

</div>

<div class="par">
<div class="function" id="make_layer">make_layer (layername \
colour \
linetype)
</div>

<div class="vars">Arguments:<br>\
layername: Name of the layer<br>\
colour: Colour of the new layer<br>\
linetype: Linetype of the new layer. "Continuous" is a good default.<br></div>

</div>

</div>
<div class="file" id="newroomid.lsp">newroomid.lsp
<div class="fdesc">Built alongisde exportrooms.lsp<br>\
Functions proceeded with nri: are written as such to avoid conflicts with "monumentids" function definitions, as some were redifined there to be more general.<br>\
nri stands for "new room id". <br>\
Swap "X" for "X" for drawings not individual<br>
</div>
<div class="par">
<div class="function" id="C:EXPORTNEWIDS">C:EXPORTNEWIDS ()
</div>

<div class="desc"> Export and find room ids and labels, assign new monument ids to the rooms.<br>\
 USE:<br>\
 1. Specify folder to export to<br>\
 2. Specify two points that define the boundary of the site.<br>\
 3. Select the polygon that is entrance 1 of the building.<br>\
 4. It will go through each room. It highlights each room with a red box, and also highlights the label it thinks belongs to that room.<br>\
 5. If the label is correct, press ENTER to move on. If it is incorrect, type L and then select the correct label.<br>\
 6. Enter "B" to go to previous room, press R to redraw highlight boxes (they will disappear on any screen redraw)<br>\
 7. After completing each room, it will automatically create "export2.csv" in the folder chosen, and will write the data to that.<br>
</div>

</div>

<div class="par">
<div class="function" id="nri:sortclockwise">nri:sortclockwise (arealist \
outlinelist)
</div>

<div class="desc"> Sort the list of entities in arealist clockwise, following outlinelist.<br>
</div>

<div class="vars">Arguments:<br>\
arealist: list of entity names to be sorted<br>\
outlinelist: list of entity names. Each represents an outline the polygons should be sorted by.<br></div>

<div class = "ret">Returns: a sorted list of arealist, in the form (room, centroid, index of closest edge)</div>

</div>

<div class="par">
<div class="function" id="nri:isCounterClockwise">nri:isCounterClockwise (alist)
</div>

<div class="desc"> Calculate if a list of points (alist) is mostly counterclockwise.<br>
</div>

<div class="vars">Arguments:<br>\
alist: a list of points in the form ((x1 y1 z1) (x2 y2 z2) (x3 y3 z3)...)<br></div>

<div class = "ret">Returns: T if counterclockwise, nil otherwise.</div>

</div>

<div class="par">
<div class="function" id="nri:find_closest">nri:find_closest (apoint \
apointlist)
</div>

<div class="desc"> Find the closest line defined in apointlist to the point apoint.<br>
</div>

<div class="vars">Arguments:<br>\
apoint: dotted pair (x . y)<br>\
apointlist: a list of points, each in the form (x y z). Each sequential pair of points defines an edge, but different polygons are defined by the value -1 in between their list of points.<br></div>

<div class = "ret">Returns: the index of the closest line in apointlist.</div>

</div>

<div class="par">
<div class="function" id="disttoline">disttoline (x0 \
y0 \
x1 \
y1 \
x2 \
y2)
</div>

<div class="desc"> Minimum distance (length of perpendicular line) from point x0 y0 to line segment x1 y1 to x2 y2<br>
</div>

<div class="vars">Arguments:<br>\
x0: x of p1<br>\
y0: y of p1<br>\
x1: x-coord of the starting point<br>\
y1: y-coord of the starting point<br>\
x2: x-coord of the ending point<br>\
y2: y-coord of the ending point<br></div>

<div class = "ret">Returns: Minimum distance from point to line.</div>

</div>

<div class="par">
<div class="function" id="nri:testorder">nri:testorder (ret1 \
ret2)
</div>

<div class="desc"> Test if the order of object ret1 is correct relative to ret2.<br>
</div>

<div class="vars">Arguments:<br>\
ret1: list in the form of (room, centroid, index of closest edge)<br>\
ret2: list in the form of (room, centroid, index of closest edge)<br></div>

<div class = "ret">Returns: T if: the index of the edge ret1 is closest to is larger than that of ret2. OR if they are on the same edge, T if ret1 is closer to the beginning of the edge than ret2 is.</div>

</div>

<div class="par">
<div class="function" id="dist">dist (p1 \
p2)
</div>

<div class="desc"> Distance between point 1 and point 2.<br>
</div>

<div class="vars">Arguments:<br>\
p1: list. (x y z)<br>\
p2: list. (x y z)<br></div>

<div class = "ret">Returns: Distance.</div>

</div>

<div class="par">
<div class="function" id="nri:getblockSS">nri:getblockSS ()
</div>

<div class="desc"> Finds a selection set of all labels in the boundary. Requires that variables boundaryp1 and boundaryp2 are pre-defined. Written for convenience.<br>
</div>

<div class = "ret">Returns: Selection Set of all labels in bounds.</div>

</div>

<div class="par">
<div class="function" id="nri:highlight">nri:highlight (label)
</div>

<div class="desc"> Highlight an object by zooming to it, and surrounding it with a box.<br>
</div>

<div class="vars">Arguments:<br>\
label: the object to be highlghted.<br></div>

</div>

<div class="par">
<div class="function" id="testforpface">testforpface ()
</div>

<div class="desc"> Test for polyface meshes. On net area and gross area layers.<br>
</div>

<div class = "ret">Returns: number of meshes. Also presents an alert if some are present.</div>

</div>

<div class="par">
<div class="function" id="removepface">removepface ()
</div>

<div class="desc"> Replaces polyface meshes with polylines. Will exit runtime, with an alert reminding the user to check the new polylines.<br>
</div>

</div>

<div class="par">
<div class="function" id="getmeshcoords">getmeshcoords (ename)
</div>

<div class="desc"> Get coordinates of a polyface mesh. (or any object).<br>
</div>

<div class="vars">Arguments:<br>\
ename: entity name of mesh.<br></div>

<div class = "ret">Returns: list of coordinates. (x0 y0 z0 x1 y1 z1...)</div>

</div>

<div class="par">
<div class="function" id="sortcoords">sortcoords (coords)
</div>

<div class="desc"> Sort Coordinates clockwise. This is good enough, and should eliminate most weird conversion errors.<br>\
 <a href="https://www.cadtutor.net/forum/topic/59260-sort-selected-entities-by-shortest-distance-between-start-coordinates-of-each-entity/">(SRC)</a><br>
</div>

<div class="vars">Arguments:<br>\
coords: list of coordinates<br></div>

<div class = "ret">Returns: sorted list of coordinates</div>

</div>

<div class="par">
<div class="function" id="plpface">plpface (pface)
</div>

<div class="desc"> Add polyline with the same coordinates as a poylface mesh. (side note: likely works with any object)<br>
</div>

<div class="vars">Arguments:<br>\
pface: entity name<br></div>

<div class = "ret">Returns: new polyline.</div>

</div>

<div class="par">
<div class="function" id="makePL">makePL (coords)
</div>

<div class="desc"> Create a polyline from a list of points.<br>
</div>

<div class="vars">Arguments:<br>\
coords: list of points<br></div>

<div class = "ret">Returns: new polyline</div>

</div>

</div>
<div class="file" id="prepmerge.lsp">prepmerge.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="C:PM">C:PM ()
</div>

<div class="desc"> Shortcut function to run <a href="#c:prepmerge">PREPMERGE</a> command<br>
</div>

</div>

<div class="par">
<div class="function" id="C:PREPMERGE">C:PREPMERGE ()
</div>

<div class="desc"> Clean up the drawing.<br>\
  - purge <br>\
  - remove sdf layer<br>\
  - fix circles<br>\
  - Remove arcs and ellipses<br>\
  - test for polyface meshes/2d polylines<br>\
  - test for extra layers<br>
</div>

</div>

<div class="par">
<div class="function" id="testforextralayers">testforextralayers ()
</div>

<div class="desc"> Test if current drawing has any layers not in the standard list.<br>
</div>

<div class = "ret">Returns: T if there are extra layers.</div>

</div>

<div class="par">
<div class="function" id="C:RFC">C:RFC ()
</div>

<div class="desc"> Shortcut for <a href="#removepface_noalert">removing polyface meshes</a>, and 2D polylines.<br>
</div>

</div>

<div class="par">
<div class="function" id="removepface_noalert">removepface_noalert ()
</div>

<div class="desc"> copy of <a href="#removepface">removepface</a>, but with no alert message at the end.<br>
</div>

</div>

</div>
<div class="file" id="search.lsp">search.lsp
<div class="fdesc">A collection of functions to help debug a drawing.<br>
</div>
<div class="par">
<div class="function" id="missedpl">missedpl ()
</div>

<div class="desc"> Turn polylines to red if they have not been included in the export. (checked against their new room id)<br>
</div>

</div>

<div class="par">
<div class="function" id="brokenlabel">brokenlabel ()
</div>

<div class="desc"> Check for labels that don't have the properties DOOR#, DOORNAME, or ROOMUSAGE. <br>\
 I don't remember why this was useful, but it'll change the block colour to red.<br>
</div>

</div>

<div class="par">
<div class="function" id="outlinenotfound">outlinenotfound ()
</div>

<div class="desc"> Check if parking points have all found their proper outlines. If they have not, their colour will be red.<br>
</div>

</div>

<div class="par">
<div class="function" id="resetpoints">resetpoints ()
</div>

<div class="desc"> Reset the color of each parking point to its original one. Only works after outlinenotfound has been run.<br>
</div>

</div>

<div class="par">
<div class="function" id="c:checkin">c:checkin ()
</div>

<div class="desc"> Check if a point is in an outline. Verifies the function of (testpt).<br>
</div>

</div>

<div class="par">
<div class="function" id="nonumber">nonumber ()
</div>

<div class="desc"> Check how many parking points have not been assigned a number correctly.<br>
</div>

<div class = "ret">Returns: count of how many points not assigned.</div>

</div>

<div class="par">
<div class="function" id="clearid">clearid ()
</div>

<div class="desc"> Clear the site id of every parking point.<br>
</div>

<div class = "ret">Returns: 0</div>

</div>

<div class="par">
<div class="function" id="c:chk">c:chk ()
</div>

<div class="desc"> Run a check as the last process.<br>\
 Run SMN again, and fix the forest id (should be fixed on new runs)<br>
</div>

</div>

<div class="par">
<div class="function" id="fixforestid">fixforestid ()
</div>

<div class="desc"> Replace site ids that were labelled GRASS with GRSS instead, and replace _9 with _09 as it should be.<br>
</div>

<div class = "ret">Returns: number of GRASS labels fixed.</div>

</div>

<div class="par">
<div class="function" id="c:mia">c:mia ()
</div>

<div class="desc"> Command for <a href="#misaligned">misaligned</a>.<br>
</div>

</div>

<div class="par">
<div class="function" id="misaligned">misaligned ()
</div>

<div class="desc"> Asks for two boundary points. Writes all site ids to misalign.csv. This was caused by the units not assigned correctly to these drawings. They were in a group in the corner of the map.<br>
</div>

</div>

<div class="par">
<div class="function" id="c:export_ids">c:export_ids ()
</div>

<div class="desc"> Export all facility ids. Can be easily modified to export all site ids too. Writes drawing name and ids.<br>
</div>

</div>

</div>
<div class="file" id="selectfiles.lsp">selectfiles.lsp
<div class="fdesc">Version 1.0		 3/25/04<br>\
--- Allows multiple selection of any type of file. <br>\
		Returns a list of the file names including the path.<br>\
--- Usage:<br>\
		(selectfiles filePath Extension verifyDrives)<br>\
--- Other notes of interest:<br>\
		Selecting the "."	in the directory list box will take you back to the root.<br>\
		Selecting the ".." in the directory list box will take you up a directory. <br>\
--- This program is offered as is without warranty.	<br>\
		Feel free to modify,copy,destroy,sell,buy,rent,make fun of, tease or set fire to.<br>\
		If you modify the program please remove the version number and my email address.<br>\
		Please send comments or suggestions to jps@jefferypsanders.com<br>
</div>
<div class="par">
<div class="function" id="UpdateDialog">UpdateDialog ()
</div>

<div class="desc"> Function to fill in the directories and files in the dialog box<br>
</div>

</div>

<div class="par">
<div class="function" id="UpdateDrives">UpdateDrives ()
</div>

<div class="desc"> Function to update the dialog box when a directory is clicked<br>
</div>

</div>

<div class="par">
<div class="function" id="UpdateDirectory">UpdateDirectory ()
</div>

<div class="desc"> Function to update the dialog box when a directory is clicked<br>
</div>

</div>

<div class="par">
<div class="function" id="saveVars">saveVars ()
</div>

<div class="desc"> Function to save the selections from the dialog box<br>
</div>

<div class = "ret">Returns: the file list</div>

</div>

<div class="par">
<div class="function" id="findDrives">findDrives (dList)
</div>

<div class="desc"> Function to find all of the available drive<br>
</div>

<div class="vars">Arguments:<br>\
dList: list of drives<br></div>

<div class = "ret">Returns: the list of verified files</div>

</div>

<div class="par">
<div class="function" id="SelectFiles">SelectFiles (filePath \
Extension \
verifyDrives)
</div>

<div class="desc"> Main function to select multiple drawings<br>
</div>

<div class="vars">Arguments:<br>\
filePath: Complete path as string.	Example: "C://ACAD". Use nil for current directory<br>\
Extension: DOSsy filter as a string. Example: "*.dwg". All wildcards accepted.<br>\
verifyDrives: Integer value of 1 will verify all drives before adding them to the dialog box drop down list. Any other value will skip drive verification and all drives will show up in the list. No error will occur if the user selects a drive that is unavailable. IMPORTANT NOTE: Drive verification can be slow if you have a lot of drives with files and folders.<br></div>

<div class = "ret">Returns: the list of files if they exist, else return nil</div>

</div>

</div>
<div class="file" id="sitealign.lsp">sitealign.lsp
<div class="fdesc">A set of commands used when aligning site plans to the map.<br>
</div>
<div class="par">
<div class="function" id="C:PREPALIGN">C:PREPALIGN ()
</div>

<div class="desc"> A set of commands to prep a drawing to be ready to align the site plan<br>\
 Changes units, adds several layers, converts circles to polylines, and then changes the colour and line type of certain layers.<br>
</div>

</div>

<div class="par">
<div class="function" id="C:FIXCIRCLES">C:FIXCIRCLES ()
</div>

<div class="desc"> Change all circles to polylines.<br>
</div>

</div>

<div class="par">
<div class="function" id="C:STRACE">C:STRACE ()
</div>

<div class="desc"> Add "SITE PLAN TRACE" to the drawing, or get rid of it if already attached.<br>
</div>

</div>

<div class="par">
<div class="function" id="getxref">getxref ()
</div>

<div class="desc"> Retrieve a list of xrefs.<br>
</div>

<div class = "ret">Returns: List of all xrefs in the drawing.</div>

</div>

<div class="par">
<div class="function" id="C:FC">C:FC ()
</div>

<div class="desc"> Shortcut for <a href="#c:fixcircles">FIXCIRCLES</a><br>
</div>

</div>

</div>
<div class="file" id="testpoint.lsp">testpoint.lsp
<div class="fdesc">A script written to test the testpt function. Now defunct.<br>
</div>
<div class="par">
<div class="function" id="C:TESTPT">C:TESTPT ()
</div>

<div class="desc"> Asks for point and polyline, tests if point is in the polyline.<br>
</div>

</div>

</div>
<div class="file" id="testssorder.lsp">testssorder.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="C:TESTCOLOR">C:TESTCOLOR ()
</div>

</div>

</div>
<div class="file" id="util.lsp">util.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="addlayer">addlayer (name \
clr \
linetype)
</div>

<div class="desc"> Add layer to the document<br>
</div>

<div class="vars">Arguments:<br>\
name: Name of layer<br>\
clr: Color of layer<br>\
linetype: Type of line (Common linetypes: "ACAD_ISO03W100", "Continuous")<br></div>

<div class = "ret">Returns: nothing</div>

</div>

<div class="par">
<div class="function" id="setlayer">setlayer (lyr)
</div>

<div class="desc"> Set the current layer. Often used to reset the current layer after some operation that changes it.<br>
</div>

<div class="vars">Arguments:<br>\
lyr: layer to set to<br></div>

<div class = "ret">Returns: nothing</div>

</div>

<div class="par">
<div class="function" id="C:ISOM">C:ISOM ()
</div>

<div class="desc"> Shortcut to quickly isolate the "misc" layer<br>
</div>

</div>

<div class="par">
<div class="function" id="new_isolate">new_isolate (layer)
</div>

<div class="desc"> Isolate "layer"<br>
</div>

<div class="vars">Arguments:<br>\
layer: layer to isolate (string)<br></div>

</div>

<div class="par">
<div class="function" id="C:TYPES">C:TYPES ()
</div>

<div class="desc"> Return the type of an object. User will be prompted for the object<br>
</div>

</div>

<div class="par">
<div class="function" id="addODTable">addODTable (e \
tblname \
field)
</div>

<div class="desc"> Add a table with a character field<br>
</div>

<div class="vars">Arguments:<br>\
e: Entity to add data to<br>\
tblname: Name of table (e.g. "2" or "3")<br>\
field: title of field in table. ("site_id" or "room_id" have been used)<br></div>

</div>

<div class="par">
<div class="function" id="addintODTable">addintODTable (e \
tblname \
field)
</div>

<div class="desc"> Add an table with an integer field<br>
</div>

<div class="vars">Arguments:<br>\
e: Entity to add data to<br>\
tblname: Name of table (e.g. "2" or "3")<br>\
field: title of field in table. ("site_id" or "room_id" have been used)<br></div>

</div>

<div class="par">
<div class="function" id="addoldRoomID">addoldRoomID (e)
</div>

<div class="desc"> Attach old Rom ID table.<br>
</div>

<div class="vars">Arguments:<br>\
e: entity name<br></div>

</div>

<div class="par">
<div class="function" id="addSiteID">addSiteID (e)
</div>

<div class="desc"> Attach a site id to e<br>
</div>

<div class="vars">Arguments:<br>\
e: entity name<br></div>

</div>

<div class="par">
<div class="function" id="addnewRoomID">addnewRoomID (e)
</div>

<div class="desc"> Attach a new rood id to e<br>
</div>

<div class="vars">Arguments:<br>\
e: entity name<br></div>

</div>

<div class="par">
<div class="function" id="setoldRoomID">setoldRoomID (e \
id)
</div>

<div class="desc"> Set old room id to a new value. This should likely not be used, it will overwrite data with no way to retrieve it.<br>
</div>

<div class="vars">Arguments:<br>\
e: entity name<br>\
id: new id to set<br></div>

</div>

<div class="par">
<div class="function" id="setSiteID">setSiteID (e \
id)
</div>

<div class="desc"> Set the site id/monument number<br>
</div>

<div class="vars">Arguments:<br>\
e: entity name<br>\
id: new id to set<br></div>

</div>

<div class="par">
<div class="function" id="setnewRoomID">setnewRoomID (e \
id)
</div>

<div class="desc"> Set the new room id<br>
</div>

<div class="vars">Arguments:<br>\
e: entity name<br>\
id: new id to set<br></div>

</div>

<div class="par">
<div class="function" id="point">point (x \
y)
</div>

<div class="desc"> Draw a point at (x, y)<br>
</div>

<div class="vars">Arguments:<br>\
x: x-coord of point<br>\
y: y-coord of point<br></div>

</div>

<div class="par">
<div class="function" id="pointvector">pointvector (alist)
</div>

<div class="desc"> Wrapper function to pass a list instead of coordinates to (point). List should be in the form (x y ...)<br>
</div>

<div class="vars">Arguments:<br>\
alist: list of coordinates.<br></div>

</div>

<div class="par">
<div class="function" id="replace">replace (alist \
pos \
newitem)
</div>

<div class="desc"> Replace an index in a list with a new item.<br>
</div>

<div class="vars">Arguments:<br>\
alist: the list<br>\
pos: the index to be replaced (starting from 0)<br>\
newitem: the item to be inserted.<br></div>

<div class = "ret">Returns: the new list with the extra item.</div>

</div>

<div class="par">
<div class="function" id="mergeSS">mergeSS (ss1 \
ss2)
</div>

<div class="desc"> Add ss2 to ss1<br>
</div>

<div class="vars">Arguments:<br>\
ss1: selection set<br>\
ss2: selection set.<br></div>

<div class = "ret">Returns: merged selection set. Order not guaranteed.</div>

</div>

<div class="par">
<div class="function" id="C:FIXERR">C:FIXERR ()
</div>

<div class="desc"> Command to detect errors with <a href="#finderr">finderr</a>.<br>
</div>

</div>

<div class="par">
<div class="function" id="C:BOUNDFIXROOM">C:BOUNDFIXROOM ()
</div>

<div class="desc"> Command to find errors in a merged file with <a href="#findROOMerr">findROOMerr</a>.<br>
</div>

</div>

<div class="par">
<div class="function" id="C:FIXROOM">C:FIXROOM ()
</div>

<div class="desc"> Find broken net area polygons. Broken if the getcenter method fails.<br>
</div>

<div class = "ret">Returns: count of wrong rooms.</div>

</div>

<div class="par">
<div class="function" id="finderr">finderr ()
</div>

<div class="desc"> Find errors in a file. Looks through entire file for polylines where (getcenter) fails (i.e. returns (-1 . -1)). It will fail if (vla-AddRegion) fails.<br>\
 This might happen because:<br>\
 1. The polyline is not closed<br>\
 2. The polyline may have self-intersecting or overlapping geometry. Look for vertices that are on top of other vertices, or edges that lay on top of others.<br>\
 Polylines that have failed will be turned grey (specifically (120 120 120))<br>\
 Will only look at polylines contained in the layers specified by lolist.<br>
</div>

<div class = "ret">Returns: number of failed polylines.</div>

</div>

<div class="par">
<div class="function" id="findselerr">findselerr (ss)
</div>

<div class="desc"> Same as finderr, but will only search the selection set passed to it.<br>
</div>

<div class="vars">Arguments:<br>\
ss: selection set to search.<br></div>

<div class = "ret">Returns: count of broken lines.</div>

</div>

<div class="par">
<div class="function" id="findROOMerr">findROOMerr ()
</div>

<div class="desc"> Will search the layer "tdsb-smsc-net area" to find broken polylines. Will either ask for a boundary specified by two points, or will use the ones passed to it.<br>\
 Acts the same as finderr, but will also close polylines automatically.<br>\
 p1: point in the form (x y z).<br>\
 p2: point in the form (x y z).<br>
</div>

<div class = "ret">Returns: count of broken lines.</div>

</div>

<div class="par">
<div class="function" id="*error*">*error* (msg)
</div>

<div class="desc"> Produces error messages for SMN.<br>
</div>

<div class="vars">Arguments:<br>\
msg: Error Message. Automatically passed on error.<br></div>

</div>

<div class="par">
<div class="function" id="setcolor">setcolor (e \
ncolor)
</div>

<div class="desc"> Set the color of an entity to (R G B).<br>
</div>

<div class="vars">Arguments:<br>\
e: entity name<br>\
ncolor: a list of integers from 0 to 255. (R G B)<br></div>

</div>

<div class="par">
<div class="function" id="resetcolor">resetcolor (e)
</div>

<div class="desc"> Reset the entity's color to its original one. Will only work after (setcolor) is called.<br>
</div>

<div class="vars">Arguments:<br>\
e: entity name<br></div>

</div>

<div class="par">
<div class="function" id="PSS">PSS ()
</div>

<div class="desc"> Move to first paperspace<br>
</div>

</div>

<div class="par">
<div class="function" id="MSS">MSS ()
</div>

<div class="desc"> Move to model space<br>
</div>

</div>

<div class="par">
<div class="function" id="asin">asin (y)
</div>

<div class="desc"> From AfraLisp (<a href="https://www.afralisp.net/archive/Tips/code20.htm)">https://www.afralisp.net/archive/Tips/code20.htm</a>)<br>\
 asin<br>\
 -1<=y<=1<br>
</div>

<div class="vars">Arguments:<br>\
y: ratio<br></div>

<div class = "ret">Returns: inverse sin in radians</div>

</div>

<div class="par">
<div class="function" id="acos">acos (y)
</div>

<div class="desc"> From AfraLisp (<a href="https://www.afralisp.net/archive/Tips/code20.htm)">https://www.afralisp.net/archive/Tips/code20.htm</a>)<br>\
 acos<br>\
 -1<=y<=1<br>
</div>

<div class="vars">Arguments:<br>\
y: ratio<br></div>

<div class = "ret">Returns: inverse cos in radians</div>

</div>

<div class="par">
<div class="function" id="getcenter">getcenter (selection)
</div>

<div class="desc"> code converted from <a href="https://www.cadtutor.net/forum/topic/96-lisp-for-marks-centroids-of-closed-polylines/">https://www.cadtutor.net/forum/topic/96-lisp-for-marks-centroids-of-closed-polylines</a><br>\
 WILL ONLY RETURN CENTER OF LAST POLYLINE IN SELECTION SET, so don't bother passing more that one object in the set.<br>
</div>

<div class="vars">Arguments:<br>\
selection: a selection set.<br></div>

<div class = "ret">Returns: the center of the last object in the selection set</div>

</div>

<div class="par">
<div class="function" id="avgCentroid">avgCentroid (p)
</div>

<div class="desc"> This will return the centroid of a set of points, as a fast approximation of the centroid of a polygon.<br>\
 This is not the same as the centroid of a polygon, if sides are made of more than two points.<br>
</div>

<div class="vars">Arguments:<br>\
p: entity name<br></div>

<div class = "ret">Returns: a list (x y)</div>

</div>

<div class="par">
<div class="function" id="C2P:nogui">C2P:nogui (clist)
</div>

<div class="desc"> Convert a circle to a 2-point polyline.<br>
</div>

<div class="vars">Arguments:<br>\
clist: list of circles.<br></div>

</div>

<div class="par">
<div class="function" id="Table">Table ()
</div>

<div class="desc"> Written By Michael Puckett. Used to find layers.<br>
</div>

</div>

<div class="par">
<div class="function" id="LM:ss->ent">LM:ss->ent (ss)
</div>

<div class="desc"> Converts a SelectionSet to a list of Entities<br>\
 Author: Lee Mac, Copyright © 2011: www.lee-mac.com<br>
</div>

<div class="vars">Arguments:<br>\
ss: Valid SelectionSet (Pickset) <br></div>

<div class = "ret">Returns: List of Entity names, else nil</div>

</div>

<div class="par">
<div class="function" id="LM:startundo">LM:startundo (doc)
</div>

<div class="desc"> Start Undo-Lee Mac<br>\
 Opens an Undo Group.<br>
</div>

<div class="vars">Arguments:<br>\
doc: VLA active document object (use (LM:acdoc))<br></div>

</div>

<div class="par">
<div class="function" id="LM:endundo">LM:endundo (doc)
</div>

<div class="desc"> End Undo-Lee Mac<br>\
 Closes an Undo Group.<br>
</div>

<div class="vars">Arguments:<br>\
doc: VLA active document object (use (LM:acdoc))<br></div>

</div>

<div class="par">
<div class="function" id="LM:acdoc">LM:acdoc ()
</div>

<div class="desc"> Active Document-Lee Mac<br>
</div>

<div class = "ret">Returns: the VLA Active Document Object</div>

</div>

<div class="par">
<div class="function" id="LM:vl-getattributevalue">LM:vl-getattributevalue (blk \
tag)
</div>

<div class="desc"> Get Attribute Value-Lee Mac<br>
</div>

<div class="vars">Arguments:<br>\
blk: [vla] VLA Block Reference Object<br>\
tag: [str] Attribute TagString<br></div>

<div class = "ret">Returns: [str] Attribute value, else nil if tag is not found.</div>

</div>

<div class="par">
<div class="function" id="LM:vl-setattributevalue">LM:vl-setattributevalue (blk \
tag \
val)
</div>

<div class="desc"> Set Attribute Value-Lee Mac<br>\
 Sets the value of the first attribute with the given tag found within the block, if present.<br>
</div>

<div class="vars">Arguments:<br>\
blk: [vla] VLA Block Reference Object<br>\
tag: [str] Attribute TagString<br>\
val: [str] Attribute Value<br></div>

<div class = "ret">Returns: [str] Attribute value if successful, else nil.</div>

</div>

<div class="par">
<div class="function" id="LM:vl-getattributevalues">LM:vl-getattributevalues (blk)
</div>

<div class="desc"> Get Attribute Values-Lee Mac<br>
</div>

<div class="vars">Arguments:<br>\
blk: [vla] VLA Block Reference Object<br></div>

<div class = "ret">Returns: [lst] Association list of ((<tag> . <value>) ... )</div>

</div>

<div class="par">
<div class="function" id="LM:vl-setattributevalues">LM:vl-setattributevalues (blk \
lst)
</div>

<div class="desc"> Set Attribute Values-Lee Mac<br>\
 Sets attributes with tags found in the association list to their associated values.<br>
</div>

<div class="vars">Arguments:<br>\
blk: [vla] VLA Block Reference Object<br>\
lst: [lst] Association list of ((<tag> . <value>) ... )<br></div>

<div class = "ret">Returns: nil</div>

</div>

<div class="par">
<div class="function" id="LM:getattributevalue">LM:getattributevalue (blk \
tag)
</div>

<div class="desc"> Get Attribute Value-Lee Mac<br>
</div>

<div class="vars">Arguments:<br>\
blk: [ent] Block (Insert) Entity Name<br>\
tag: [str] Attribute TagString<br></div>

<div class = "ret">Returns: [str] Attribute value, else nil if tag is not found.</div>

</div>

<div class="par">
<div class="function" id="LM:getattributevalue">LM:getattributevalue (blk \
tag)
</div>

<div class="desc"> Get Attribute Value-Lee Mac<br>
</div>

<div class="vars">Arguments:<br>\
blk: [ent] Block (Insert) Entity Name<br>\
tag: [str] Attribute TagString<br></div>

<div class = "ret">Returns: [str] Attribute value, else nil if tag is not found.</div>

</div>

<div class="par">
<div class="function" id="LM:setattributevalue">LM:setattributevalue (blk \
tag \
val)
</div>

<div class="desc"> Set Attribute Value-Lee Mac<br>\
 Sets the value of the first attribute with the given tag found within the block, if present.<br>
</div>

<div class="vars">Arguments:<br>\
blk: [ent] Block (Insert) Entity Name<br>\
tag: [str] Attribute TagString<br>\
val: [str] Attribute Value<br></div>

<div class = "ret">Returns: [str] Attribute value if successful, else nil.</div>

</div>

<div class="par">
<div class="function" id="LM:setattributevalue">LM:setattributevalue (blk \
tag \
val)
</div>

<div class="desc"> Set Attribute Value-Lee Mac<br>\
 Sets the value of the first attribute with the given tag found within the block, if present.<br>
</div>

<div class="vars">Arguments:<br>\
blk: [ent] Block (Insert) Entity Name<br>\
tag: [str] Attribute TagString<br>\
val: [str] Attribute Value<br></div>

<div class = "ret">Returns: [str] Attribute value if successful, else nil.</div>

</div>

<div class="par">
<div class="function" id="LM:getattributevalues">LM:getattributevalues (blk)
</div>

<div class="desc"> Get Attribute Values-Lee Mac<br>
</div>

<div class="vars">Arguments:<br>\
blk: [ent] Block (Insert) Entity Name<br></div>

<div class = "ret">Returns: [lst] Association list of ((<tag> . <value>) ... )</div>

</div>

<div class="par">
<div class="function" id="LM:getattributevalues">LM:getattributevalues (blk)
</div>

<div class="desc"> Get Attribute Values-Lee Mac<br>
</div>

<div class="vars">Arguments:<br>\
blk: [ent] Block (Insert) Entity Name<br></div>

<div class = "ret">Returns: [lst] Association list of ((<tag> . <value>) ... )</div>

</div>

<div class="par">
<div class="function" id="LM:setattributevalues">LM:setattributevalues (blk \
lst)
</div>

<div class="desc"> Set Attribute Values-Lee Mac<br>\
 Sets attributes with tags found in the association list to their associated values.<br>
</div>

<div class="vars">Arguments:<br>\
blk: [ent] Block (Insert) Entity Name<br>\
lst: [lst] Association list of ((<tag> . <value>) ... )<br></div>

<div class = "ret">Returns: nil</div>

</div>

<div class="par">
<div class="function" id="LM:setattributevalues">LM:setattributevalues (blk \
lst)
</div>

<div class="desc"> Set Attribute Values-Lee Mac<br>\
 Sets attributes with tags found in the association list to their associated values.<br>
</div>

<div class="vars">Arguments:<br>\
blk: [ent] Block (Insert) Entity Name<br>\
lst: [lst] Association list of ((<tag> . <value>) ... )<br></div>

<div class = "ret">Returns: nil</div>

</div>

<div class="par">
<div class="function" id="LM:ent->pts">LM:ent->pts (ent \
acc)
</div>

<div class="desc"> Entity to Point List-Lee Mac<br>
</div>

<div class="vars">Arguments:<br>\
ent: [ent] Entity name to be described by point list (POINT/LINE/ARC/CIRCLE/LWPOLYLINE/POLYLINE/ELLIPSE/SPLINE)<br>\
acc: [num] Positive number determining the point density for non-linear objects<br></div>

<div class = "ret">Returns a list of points describing or approximating the supplied entity, else nil if the entity is not supported.</div>

</div>

<div class="par">
<div class="function" id="LM:browseforfolder">LM:browseforfolder (msg \
dir \
bit)
</div>

<div class="vars">Arguments:<br>\
msg: [str] message to display at top of dialog<br>\
dir: [str] [optional] root directory (or nil)<br>\
bit: [int] bit-coded flag specifying dialog display settings<br></div>

<div class = "ret">Returns: [str] Selected folder filepath, else nil.</div>

</div>

<div class="par">
<div class="function" id="LM:GetInsideAngle">LM:GetInsideAngle ()
</div>

</div>

<div class="par">
<div class="function" id="pc">pc (sel)
</div>

<div class="desc"> Polyline Close-Lee Mac<br>\
 Closes all polylines in a selection.<br>
</div>

<div class="vars">Arguments:<br>\
sel: selection set<br></div>

</div>

<div class="par">
<div class="function" id="opc">opc ()
</div>

</div>

<div class="par">
<div class="function" id="LM:sublst">LM:sublst (lst \
idx \
len)
</div>

<div class="desc"> Sublst :  Lee Mac<br>\
 The list analog of the substr function<br>
</div>

<div class="vars">Arguments:<br>\
lst: [lst] List from which sublist is to be returned<br>\
idx: [int] Zero-based index at which to start the sublist<br>\
len: [int] Length of the sublist or nil to return all items following idx<br></div>

</div>

<div class="par">
<div class="function" id="LM:getfiles">LM:getfiles (msg \
def \
ext \
 Returns)
</div>

<div class="desc"> Version 1.6 - 2016-03-21	<br>\
 An analog of the 'getfiled' function for multiple file selection.<br>\
 File count label added by Noah Cassidy<br>\
 CAN HANDLE UP TO 525 FILES added to the box at once<br>\
 Author:  Lee Mac, Copyright © 2012 :  www.lee-mac.com<br>
</div>

<div class="vars">Arguments:<br>\
msg: [str/nil] Dialog box label<br>\
def: [str/nil] Default directory<br>\
ext: [str/nil] File extension filter (e.g. "dwg<br>\
 Returns:  List of selected files, else nil<br></div>

</div>

<div class="par">
<div class="function" id="LM:getfiles:listbox">LM:getfiles:listbox ()
</div>

</div>

<div class="par">
<div class="function" id="LM:getfiles:listfiles">LM:getfiles:listfiles ()
</div>

</div>

<div class="par">
<div class="function" id="LM:getfiles:checkredirect">LM:getfiles:checkredirect ()
</div>

</div>

<div class="par">
<div class="function" id="LM:getfiles:sort">LM:getfiles:sort ()
</div>

</div>

<div class="par">
<div class="function" id="LM:getfiles:sortlist">LM:getfiles:sortlist ()
</div>

</div>

<div class="par">
<div class="function" id="LM:getfiles:groupbyfunction">LM:getfiles:groupbyfunction ()
</div>

</div>

<div class="par">
<div class="function" id="LM:getfiles:splitstring">LM:getfiles:splitstring ()
</div>

</div>

<div class="par">
<div class="function" id="LM:getfiles:browseforfolder">LM:getfiles:browseforfolder ()
</div>

</div>

<div class="par">
<div class="function" id="LM:getfiles:full->relative">LM:getfiles:full->relative ()
</div>

</div>

<div class="par">
<div class="function" id="LM:getfiles:str->lst">LM:getfiles:str->lst ()
</div>

</div>

<div class="par">
<div class="function" id="LM:getfiles:updatefilelist">LM:getfiles:updatefilelist ()
</div>

</div>

<div class="par">
<div class="function" id="LM:getfiles:updateselected">LM:getfiles:updateselected ()
</div>

</div>

<div class="par">
<div class="function" id="LM:getfiles:updir">LM:getfiles:updir ()
</div>

</div>

<div class="par">
<div class="function" id="LM:getfiles:fixdir">LM:getfiles:fixdir ()
</div>

</div>

<div class="par">
<div class="function" id="LM:getfiles:removeitems">LM:getfiles:removeitems ()
</div>

</div>

<div class="par">
<div class="function" id="LM:ssboundingbox">LM:ssboundingbox (sel)
</div>

<div class="desc"> Selection Set Bounding Box:  Lee Mac<br>
</div>

<div class="vars">Arguments:<br>\
sel: [sel] Selection set for which to return bounding box<br></div>

<div class = "ret">Returns a list of the lower-left and upper-right WCS coordinates of a</div>

</div>

</div>
<div class="title">Original Site Plan Lisp Functions</div>
<div class="file" id="Original Site Plan Lisp\\addlayers.lsp">Original Site Plan Lisp\\addlayers.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="C:UPDATELAYERS">C:UPDATELAYERS ()
</div>

<div class="desc"> Add a set of layers into a document.<br>\
 <br>
</div>

</div>

</div>
<div class="file" id="Original Site Plan Lisp\\colorLines.lsp">Original Site Plan Lisp\\colorLines.lsp
<div class="fdesc">Utility functions written during roof id labelling. Most copied to "utils" in new library of functions.<br>
</div>
<div class="par">
<div class="function" id="C:COLORLINES">C:COLORLINES ()
</div>

<div class="desc"> debug/testing command<br>
</div>

</div>

<div class="par">
<div class="function" id="getSelection">getSelection ()
</div>

<div class="desc"> Ask for a selection of polylines<br>
</div>

<div class = "ret">Returns: A selection set.</div>

</div>

<div class="par">
<div class="function" id="getlayer">getlayer (sel_list \
layer)
</div>

<div class="desc"> Filter a selection set objects by layer.<br>
</div>

<div class="vars">Arguments:<br>\
sel_list: Selection set, the list to filter<br>\
layer: String, name of layer to filter for.<br></div>

<div class = "ret">Returns: Filtered selection set.</div>

</div>

<div class="par">
<div class="function" id="setcolor">setcolor (e \
ncolor)
</div>

<div class="desc"> Set the color of an entity.<br>
</div>

<div class="vars">Arguments:<br>\
e: NOT JUST AN ENAME. Pass in the list returned by (entget ename)<br>\
ncolor: a list, (r g b)<br></div>

</div>

<div class="par">
<div class="function" id="resetcolor">resetcolor (e)
</div>

<div class="desc"> Reset color of the entity. Only works after (setcolor) has been run.<br>
</div>

<div class="vars">Arguments:<br>\
e: same as setcolor. Use (entget ename) as the argument.<br></div>

</div>

<div class="par">
<div class="function" id="setlayer">setlayer ()
</div>

<div class="desc"> Set the current layer as lyr. Will add the layer if it does not already exist.<br>
</div>

</div>

<div class="par">
<div class="function" id="Table">Table ()
</div>

<div class="desc"> Written By Michael Puckett. Used to find layers.<br>
</div>

</div>

<div class="par">
<div class="function" id="placeText">placeText (selection \
id \
savedlayer)
</div>

<div class="desc"> code from <a href="https://www.cadtutor.net/forum/topic/96-lisp-for-marks-centroids-of-closed-polylines/">https://www.cadtutor.net/forum/topic/96-lisp-for-marks-centroids-of-closed-polylines/</a><br>\
 Place text "id" on "savedlayer" in the center of "selection"<br>
</div>

<div class="vars">Arguments:<br>\
selection: a selection set.<br>\
id: a string to place at the center of each polyline in selection.<br>\
savedlayer: layer on which id will be placed.<br></div>

</div>

<div class="par">
<div class="function" id="addODTable">addODTable (e \
tblname \
field)
</div>

<div class="desc"> Add an object data table to an object e.<br>
</div>

<div class="vars">Arguments:<br>\
e: entity name to add od table to<br>\
tblname: String. Name of Object Data table to add<br>\
field: String. Name of field to add to table. (e.g. room_id or "0")<br></div>

</div>

<div class="par">
<div class="function" id="addSiteID">addSiteID (e)
</div>

<div class="desc"> Attach a site id to entity e<br>
</div>

<div class="vars">Arguments:<br>\
e: entity name<br></div>

</div>

<div class="par">
<div class="function" id="setSiteID">setSiteID (e \
id)
</div>

<div class="desc"> Set the site Id to entity e, with text id.<br>
</div>

<div class="vars">Arguments:<br>\
e: entity name<br>\
id: id to insert in "site_id" field<br></div>

</div>

<div class="par">
<div class="function" id="getschoolnum">getschoolnum ()
</div>

<div class="desc"> Retrieve the facility id from the document name (assuming the facility id is the first 4 characters of the name)<br>
</div>

</div>

<div class="par">
<div class="function" id="LM:ss->ent">LM:ss->ent (ss)
</div>

<div class="desc"> Converts a SelectionSet to a list of Entities<br>\
 Author: Lee Mac, Copyright � 2011 - www.lee-mac.com<br>
</div>

<div class="vars">Arguments:<br>\
ss: Valid SelectionSet (Pickset)<br></div>

<div class = "ret">Returns: List of Entity names, else nil</div>

</div>

</div>
<div class="file" id="Original Site Plan Lisp\\ConvexHull.lsp">Original Site Plan Lisp\\ConvexHull.lsp
<div class="fdesc">Convex Hull  -  Lee Mac<br>\
Implements the Graham Scan Algorithm to return the Convex Hull of a list of points.<br>
</div>
<div class="par">
<div class="function" id="LM:ConvexHull">LM:ConvexHull (lst)
</div>

<div class="desc"> Create a convew hull from a list of points.<br>
</div>

<div class="vars">Arguments:<br>\
lst: a list of points describing a polygon<br></div>

<div class = "ret">Returns: A list of points, describing a convex hull.</div>

</div>

<div class="par">
<div class="function" id="LM:Clockwise-p">LM:Clockwise-p (p1 \
p2 \
p3)
</div>

<div class="desc"> Clockwise-p  -  Lee Mac<br>
</div>

<div class="vars">Arguments:<br>\
p1: point<br>\
p2: point<br>\
p3: point<br></div>

<div class = "ret">Returns: T if p1,p2,p3 are clockwise oriented or collinear</div>

</div>

</div>
<div class="file" id="Original Site Plan Lisp\\helper.lsp">Original Site Plan Lisp\\helper.lsp
<div class="fdesc">Helps label rooves. Early days of learning lisp and autolisp, so it's not particularly efficient.<br>
</div>
<div class="par">
<div class="function" id="helper">helper ()
</div>

<div class="desc"> Controls DCL<br>
</div>

</div>

<div class="par">
<div class="function" id="saveLayer">saveLayer ()
</div>

<div class="desc"> Save layer when DCL is closed<br>
</div>

</div>

<div class="par">
<div class="function" id="createSections">createSections ()
</div>

<div class="desc"> Create "sections" list, color sections<br>
</div>

</div>

<div class="par">
<div class="function" id="isolate">isolate ()
</div>

<div class="desc"> Turn on only savedlayer (set by the gui) and the text layer for savedlayer.<br>
</div>

</div>

<div class="par">
<div class="function" id="labelLayers">labelLayers ()
</div>

<div class="desc"> label room sections.<br>
</div>

</div>

<div class="par">
<div class="function" id="export">export ()
</div>

<div class="desc"> export sections and od to csv file<br>
</div>

</div>

<div class="par">
<div class="function" id="options">options ()
</div>

<div class="desc"> Load options window. Unused.<br>
</div>

</div>

<div class="par">
<div class="function" id="saveoptions">saveoptions ()
</div>

<div class="desc"> Save options<br>
</div>

</div>

<div class="par">
<div class="function" id="fixlabel">fixlabel ()
</div>

<div class="desc"> Fix any roof id, replacing old monument id with the new one. Only the section and section number need by specified (i.e. "A4")<br>
</div>

</div>

<div class="par">
<div class="function" id="saveid">saveid ()
</div>

<div class="desc"> Save the id entered in the fixlabel box before closing the box.<br>
</div>

</div>

<div class="par">
<div class="function" id="redolabel">redolabel ()
</div>

<div class="desc"> Actually reset the label specified in "fixid".<br>
</div>

</div>

<div class="par">
<div class="function" id="PSC">PSC (poly)
</div>

<div class="desc"> To determine whether a Polyline of any type Crosses itSelf.<br>\
 With 3D Polylines, must have true intersection in 3D, not apparent in 2D.<br>
</div>

<div class="vars">Arguments:<br>\
poly: entity to be examined<br></div>

<div class = "ret">Returns: T if self-crossing, nil if not.</div>

</div>

<div class="par">
<div class="function" id="C:FIXALL">C:FIXALL ()
</div>

<div class="desc"> Fix all ids in a selection set after they were all set to use facility number 0388 rather than the correct one.<br>
</div>

</div>

</div>
<div class="file" id="Original Site Plan Lisp\\movescale.lsp">Original Site Plan Lisp\\movescale.lsp
<div class="fdesc">Scale space between labels to new size for 11x17 view.<br>
</div>
<div class="par">
<div class="function" id="C:SCNMOVE">C:SCNMOVE ()
</div>

<div class="desc"> Get a selection of objects, and scale the distance between them. Used to scale 8.5x11 labels into the 11x17 paperspace.<br>
</div>

</div>

<div class="par">
<div class="function" id="C:COPYADDR">C:COPYADDR ()
</div>

<div class="desc"> Copies the properties of the 8.5x11 title block into the 11x17 title block<br>
</div>

</div>

</div>
<div class="file" id="Original Site Plan Lisp\\mp.lsp">Original Site Plan Lisp\\mp.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="C:MPOINT">C:MPOINT ()
</div>

<div class="desc"> Draw a point at the midpoint of two points.<br>
</div>

</div>

</div>
<div class="file" id="Original Site Plan Lisp\\OutlineObjectsV1-1.lsp">Original Site Plan Lisp\\OutlineObjectsV1-1.lsp
<div class="fdesc">A Lee Mac file, but slightly edited. Also contains startundo and endundo, before they were moved to utils. Main function never used. See file for documentation.<br>
</div>
<div class="par">
<div class="function" id="C:OUTLINE">C:OUTLINE ()
</div>

</div>

<div class="par">
<div class="function" id="LM:outline">LM:outline ()
</div>

</div>

<div class="par">
<div class="function" id="LM:ssboundingbox">LM:ssboundingbox ()
</div>

</div>

<div class="par">
<div class="function" id="LM:startundo">LM:startundo ()
</div>

</div>

<div class="par">
<div class="function" id="LM:endundo">LM:endundo ()
</div>

</div>

<div class="par">
<div class="function" id="LM:acdoc">LM:acdoc ()
</div>

</div>

</div>
<div class="file" id="Original Site Plan Lisp\\siteplan-utils.lsp">Original Site Plan Lisp\\siteplan-utils.lsp
<div class="fdesc">Pointed to by acaddoc in the new lisp library. Loads all useful functions from old library, and adds shortcuts.<br>
</div>
<div class="par">
<div class="function" id="C:MPO">C:MPO ()
</div>

<div class="desc"> Run c:mpoint<br>
</div>

</div>

<div class="par">
<div class="function" id="C:UPLAY">C:UPLAY ()
</div>

<div class="desc"> Run c:updatelayers<br>
</div>

</div>

<div class="par">
<div class="function" id="insertextralabels">insertextralabels ()
</div>

<div class="desc"> Insert property line and portable label blocks into the drawing.<br>
</div>

</div>

</div>
<div class="title">Downloaded Lisp Functions</div>
<div class="file" id="Original Site Plan Lisp\\Downloaded\\CirclePolylineSwap.lsp">Original Site Plan Lisp\\Downloaded\\CirclePolylineSwap.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="C:C2P">C:C2P ()
</div>

<div class="desc"> CirclePolylineSwap.lsp [command names: C2P & P2C]<br>\
 Two commands, to convert in both directions between a Circle and a circular<br>\
 (two-equal-arc-segment closed) Polyline, such as the Donut command makes.<br>\
 Both commands:<br>\
 1. ask User to select again if they miss, pick an incorrect object type, or pick an<br>\
 	object on a locked Layer<br>\
 2. remove selected/converted object, but can easily be edited to retain it<br>\
 3. account for different Coordinate Systems<br>\
 4. retain non-default/non-Bylayer color, linetype, linetype scale, lineweight,<br>\
 	and/or thickness.<br>\
 See additional notes above each command's definition.<br>\
 Kent Cooper, May 2011<br>\
 <br>\
 C2P<br>\
 To convert a selected Circle to a two-equal-arc-segment closed zero-<br>\
 width Polyline circle [Donut w/ equal inside & outside diameters],<br>\
 which can then be modified as desired [given width, etc.], since Pedit<br>\
 will not accept selection of a Circle.<br>\
 <br>
</div>

</div>

<div class="par">
<div class="function" id="C:P2C">C:P2C ()
</div>

<div class="desc"> To convert a selected closed two-equal-arc-segment global-width circular<br>\
   Polyline [Donut] to a true Circle.If selected Polyline has non-zero global<br>\
 width, offers User option to draw Circle along center-line or along inside or<br>\
 outside edge of width, and retains choice as default for next use.<br>\
 Works on both old-style "heavy" and newer "lightweight" Polylines.<br>\
 [Will not work on one with more than two segments, or with two unequal-<br>\
 included-angle segments, even if truly circular.]<br>\
 <br>
</div>

</div>

</div>
<div class="file" id="Original Site Plan Lisp\\Downloaded\\del-layer.lsp">Original Site Plan Lisp\\Downloaded\\del-layer.lsp
<div class="par">
<div class="function" id="delbylayer">delbylayer ()
</div>

</div>

</div>
<div class="file" id="Original Site Plan Lisp\\Downloaded\\multiple enclosing rectangle.lsp">Original Site Plan Lisp\\Downloaded\\multiple enclosing rectangle.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="multiple_enclosing_rectangle">multiple_enclosing_rectangle (settoenclose)
</div>

<div class="desc"> Bounding box alternative<br>
</div>

<div class="vars">Arguments:<br>\
settoenclose: a selection set to draw a box around<br></div>

</div>

<div class="par">
<div class="function" id="C:MER">C:MER ()
</div>

<div class="desc"> Command to run <a href="#multiple_enclosing_rectangle">multiple_enclosing_rectangle</a>.<br>
</div>

</div>

</div>
<div class="file" id="Original Site Plan Lisp\\Downloaded\\OutlineObjectsV1-1.lsp">Original Site Plan Lisp\\Downloaded\\OutlineObjectsV1-1.lsp
<div class="par">
<div class="function" id="C:OUTLINE">C:OUTLINE ()
</div>

</div>

<div class="par">
<div class="function" id="LM:outline">LM:outline ()
</div>

</div>

<div class="par">
<div class="function" id="LM:ssboundingbox">LM:ssboundingbox ()
</div>

</div>

<div class="par">
<div class="function" id="LM:startundo">LM:startundo ()
</div>

</div>

<div class="par">
<div class="function" id="LM:endundo">LM:endundo ()
</div>

</div>

<div class="par">
<div class="function" id="LM:acdoc">LM:acdoc ()
</div>

</div>

</div>
<div class="file" id="Original Site Plan Lisp\\Downloaded\\Sel_by_OD__US.lsp">Original Site Plan Lisp\\Downloaded\\Sel_by_OD__US.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="C:SEL_BY_OD">C:SEL_BY_OD ()
</div>

</div>

</div>
<div class="file" id="Original Site Plan Lisp\\Downloaded\\WriteCSV-V1-1.lsp">Original Site Plan Lisp\\Downloaded\\WriteCSV-V1-1.lsp
<div class="fdesc"> Write CSV  -  Lee Mac<br>\
 Writes a matrix list of cell values to a CSV file.<br>\
 lst - [lst] list of lists, sublist is row of cell values<br>\
 csv - [str] filename of CSV file to write<br>\
 Returns T if successful, else nil<br>\
edited by Noah Cassidy on 19/09/18<br>
</div>
<div class="par">
<div class="function" id="LM:writecsv">LM:writecsv ()
</div>

</div>

<div class="par">
<div class="function" id="appendcsv">appendcsv ()
</div>

</div>

<div class="par">
<div class="function" id="LM:lst->csv">LM:lst->csv ()
</div>

</div>

<div class="par">
<div class="function" id="LM:csv-addquotes">LM:csv-addquotes ()
</div>

</div>

</div>
`)
