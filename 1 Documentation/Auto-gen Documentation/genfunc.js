document.write(`
<div class="file" id="acad.lsp">acad.lsp
<div class="fdesc">Will auto run when AutoCAD starts, as long as it's in a support file path.<br>
</div>
<div class="par">
<div class="function" id="S::startup">S::startup ()
</div>

</div>

</div>
<div class="file" id="acaddoc.lsp">acaddoc.lsp
<div class="fdesc">Will automatically run when any document is opened in Autocad, if the folder containing this file is among the "support files" specified in autocad settings.<br>
</div>
<div class="par">
<div class="function" id="c:exr">c:exr ()
</div>

<div class="desc"> Wrapping commands for functions<br>
</div>

</div>

<div class="par">
<div class="function" id="c:cs">c:cs ()
</div>

<div class="desc"> Zoom to extents, close and save shortcut.<br>
</div>

</div>

<div class="par">
<div class="function" id="c:rsnap">c:rsnap ()
</div>

<div class="desc"> Reset osnap to preferred settings.<br>
</div>

</div>

<div class="par">
<div class="function" id="c:eprop">c:eprop ()
</div>

<div class="desc"> Display entity data. Prompts to select an object.<br>
</div>

</div>

<div class="par">
<div class="function" id="c:ename">c:ename ()
</div>

<div class="desc"> Retrieve entity name. Prompts to select an object.<br>
</div>

<div class = "ret">Returns: Selected entity name.</div>

</div>

</div>
<div class="file" id="access.lsp">access.lsp
<div class="fdesc">Functions to transfer and geocode the accessibility plan automatically. Copies from the floor plan, and aligns to a geocoded sdf file.<br>
</div>
<div class="par">
<div class="function" id="c:copyAccess">c:copyAccess ()
</div>

<div class="desc"> Copy the contents of the "Access" Tab<br>\
 Troubleshooting: Make sure the "Access" Tab exists. Make sure plan is in paper space not model space. <br>
</div>

</div>

<div class="par">
<div class="function" id="c:pasteNoRotate">c:pasteNoRotate ()
</div>

<div class="desc"> Insert and fix accessibility plan without automatically aligning it.<br>
</div>

</div>

<div class="par">
<div class="function" id="c:pasteAccess">c:pasteAccess ()
</div>

<div class="desc"> Insert, fix, and align the accessility plan into an sdf file.<br>\
 Matches the convex hull of the accessibility plan's polylines to the convex hull of the floor plan's gross area polyline. <br>\
 Troubleshooting: Sometimes it fails. Do it manually, it'll be faster than debugging. If there's a large red line, that's a good indicator of failure.<br>
</div>

</div>

<div class="par">
<div class="function" id="c:pasteAspectAccess">c:pasteAspectAccess ()
</div>

<div class="desc"> First iteration of pasteAccess. Aligns with a simple rectangle/aspect ratio check. Not very accurate, replaced by the convex hull method.<br>
</div>

</div>

<div class="par">
<div class="function" id="explode">explode (ss)
</div>

<div class="desc"> Wrapper for the explode command that also sets the weird "qaflags" properly, whatever they're for.<br>
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
<div class="function" id="c:testov">c:testov ()
</div>

<div class="desc"> Get the bounding box of the "access" block<br>
</div>

<div class = "ret">Returns: Bounding Box described by two points</div>

</div>

<div class="par">
<div class="function" id="testoverlap">testoverlap (plf \
pla)
</div>

<div class="desc"> Find the %  of two polylines<br>
</div>

<div class="vars">Arguments:<br>\
plf: floor outline polyline<br>\
pla: accessibility outline polyline<br></div>

<div class = "ret">Returns: % overlap between the polylines, as a decimal</div>

</div>

<div class="par">
<div class="function" id="getvcenter">getvcenter ()
</div>

</div>

<div class="par">
<div class="function" id="c:AttDef2Text">c:AttDef2Text ()
</div>

<div class="desc"> Changes attdef entities (attributes that haven't been put into a block) into dtext in the whole drawing<br>\
 Source: https://forums.augi.com/showthread.php?40372-change-exploded-block-attribute-tags-to-text<br>
</div>

</div>

<div class="par">
<div class="function" id="c:faxess">c:faxess ()
</div>

<div class="desc"> Fix the accessibility drawing. Move doors and stairs to "tdsb-smsc-accessibility red", and burst all blocks.<br>
</div>

</div>

<div class="par">
<div class="function" id="c:fax">c:fax ()
</div>

<div class="desc"> Wrapper for faxess, because I'm really lazy.<br>
</div>

</div>

</div>
<div class="file" id="batchexr.lsp">batchexr.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="c:aexr">c:aexr ()
</div>

<div class="desc"> Stands for auto-exr. Will automatically label rooms, and should fix polyface meshes too.<br>
</div>

</div>

</div>
<div class="file" id="BATCHLISP.lsp">BATCHLISP.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="c:BATCHLISP">c:BATCHLISP ()
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
<div class="function" id="c:xreffloors">c:xreffloors ()
</div>

<div class="desc"> Add all lower floors as an xref to the current drawing. Used to align broken master files.<br>
</div>

</div>

</div>
<div class="file" id="batchrun.lsp">batchrun.lsp
</div>
<div class="file" id="catch22.lsp">catch22.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="c:catch22">c:catch22 ()
</div>

<div class="desc"> Find all files that still contain the "22" layer, and output them to <a href="file:///H:\\Map 3d\\3 exports\\caught22.txt"> caught22.txt </a>. <br>
</div>

</div>

<div class="par">
<div class="function" id="c:begin">c:begin ()
</div>

<div class="desc"> Check alignment of a drawing. Attaches "All Site Plans" as an xref to the current drawing. If offset, try fixing units and reattaching.<br>
</div>

</div>

<div class="par">
<div class="function" id="c:stop">c:stop ()
</div>

<div class="desc"> Detaches "All Site Plans" xref.<br>
</div>

</div>

</div>
<div class="file" id="chgunits.lsp">chgunits.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="c:chgunits">c:chgunits ()
</div>

<div class="desc"> Change units of the current drawing to inches. Should correct offset drawings.<br>
</div>

</div>

</div>
<div class="file" id="Ellipse2ArcV1-1.lsp">Ellipse2ArcV1-1.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="c:e2a">c:e2a ()
</div>

<div class="desc"> This program will allow the user to convert a selection of circular Ellipses & Elliptical Arcs (that is, Ellipses or Elliptical Arcs with axes of equal length) into Circles & Arcs respectively, whilst retaining all properties of the original objects.<br>\
 <br>\
 The program will furthermore perform correctly with Ellipses & Elliptical Arcs constructed in any UCS, and should be supported on all versions of AutoCAD, on both a Windows & Mac OS.<br>\
 Author:Lee Mac, Copyright © 2013-www.lee-mac.com<br>\
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
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="c:entrance_ids">c:entrance_ids ()
</div>

</div>

<div class="par">
<div class="function" id="label_entrance">label_entrance ()
</div>

<div class="desc"> layer: Where to find the police safety labels and triangles.<br>\
 label: 4-letter code for site_id field<br>
</div>

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

</div>

<div class="par">
<div class="function" id="min_dist_btwn_objects_pl">min_dist_btwn_objects_pl ()
</div>

</div>

<div class="par">
<div class="function" id="min_dist_btwn_objects">min_dist_btwn_objects ()
</div>

</div>

<div class="par">
<div class="function" id="dist_line_to_line">dist_line_to_line ()
</div>

</div>

<div class="par">
<div class="function" id="disttosegment">disttosegment ()
</div>

</div>

<div class="par">
<div class="function" id="v-">v- ()
</div>

</div>

<div class="par">
<div class="function" id="v+">v+ ()
</div>

</div>

<div class="par">
<div class="function" id="v++">v++ ()
</div>

</div>

<div class="par">
<div class="function" id="v*">v* ()
</div>

</div>

<div class="par">
<div class="function" id="dot">dot ()
</div>

</div>

<div class="par">
<div class="function" id="vl">vl ()
</div>

</div>

<div class="par">
<div class="function" id="get_number">get_number ()
</div>

</div>

<div class="par">
<div class="function" id="highlight_nozoom">highlight_nozoom ()
</div>

<div class="desc"> Highlight an object by drawing a rounding box<br>\
 obj: the object<br>
</div>

</div>

<div class="par">
<div class="function" id="flag">flag ()
</div>

</div>

<div class="par">
<div class="function" id="c:undoall">c:undoall ()
</div>

</div>

<div class="par">
<div class="function" id="move_to_tri_center">move_to_tri_center ()
</div>

</div>

<div class="par">
<div class="function" id="center_tri">center_tri ()
</div>

</div>

</div>
<div class="file" id="Exportalllabels.lsp">Exportalllabels.lsp
<div class="fdesc">Write all labels into export3.csv. Does not find site id, only writes 0140 currently.<br>
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
<div class="file" id="fixrockford.lsp">fixrockford.lsp
<div class="fdesc">Script written to quickly fix rockford (facility num 0075). For whatever reason, the old room id was contained in table 0 instead of 1, and so it was missed by the original program. <br>
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
<div class="function" id="c:ids">c:ids ()
</div>

</div>

<div class="par">
<div class="function" id="c:newfields">c:newfields ()
</div>

<div class="desc"> Adds the facility number in site_id object data, to any object that does not already have a site id.<br>
</div>

</div>

<div class="par">
<div class="function" id="c:fac_id">c:fac_id ()
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
isclose)
</div>

<div class="vars">Arguments:<br>\
layname: Name of the layer<br>\
parentlayer: Name of the outline layer<br>\
label: 4-letter code for the layer. This method only accepts a string<br>\
mode: "let" or "num", to specify whether the labels use A-Z or 0, 1, 2...<br>\
isclose: Whether or not to close the polygons after they've been labelled<br></div>

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
<div class="function" id="id_playscape">id_playscape (layname \
label)
</div>

<div class="desc"> Add id to the playscapes. Looks for a surrounding playground outline, and then adds the id in the form: Facitilty#_PLAY_X##<br>\
 Unfortunately, this is unreliable, and also does not correctly increase index as new playscapes are found within playground outlines, so it was done by hand rather than bother fixing this code.<br>\
 To fix: A list of values, length = # of playground outlines, and keep track of how many playscapes have been found in each.<br>\
 	OR follow the form of id_parking, and loop through outlines and check which playscapes are inside.<br>\
 If a playscape was not inside, it was labelled as: Facitilty#_PLAY_##, clockwise from enterance 1.<br>\
 Not used, do it manually.<br>
</div>

<div class="vars">Arguments:<br>\
layname: "tdsb-smsc-playground outline"<br>\
label: list. ("PLAY")<br></div>

</div>

<div class="par">
<div class="function" id="id_parking">id_parking (layname \
labels)
</div>

<div class="desc"> Defunct<br>\
 Add id to parking points. For each parking lot, it distinguishes all disabled parking spaces (with (chgdspl)), and then assigns ids clockwise as normal.<br>
</div>

<div class="vars">Arguments:<br>\
layname: "tdsb-smsc-parking points"<br>\
labels: list. ("PARK" "DSPL")<br></div>

</div>

<div class="par">
<div class="function" id="id_portables">id_portables (layname \
labels)
</div>

<div class="desc"> Add Ids to portables. This is found in model space, and was assumed to be in a "smsc-room label-small" block. This is inconsistent, and is probably better done by hand.<br>\
 Disabled. Do manually.<br>
</div>

<div class="vars">Arguments:<br>\
layname: "tdsb-smsc-portables"<br>\
labels: ""<br></div>

</div>

<div class="par">
<div class="function" id="id_field">id_field (layname \
labels)
</div>

<div class="desc"> Same as default id_XXXX but also includes "[layname] 2" to use for soccerfields and baseball diamonds.<br>
</div>

<div class="vars">Arguments:<br>\
layname: layer name to label<br>\
labels: list of 4 letter codes to add to the label. Will automatically add "2" to labels on the field_2 layers.<br></div>

</div>

<div class="par">
<div class="function" id="id_layer_line">id_layer_line (layname \
parentlayer \
mode \
isclose)
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

<div class="vars">Arguments:<br>\
layname: Name of the layer<br>\
parentlayer: Name of the outline layer<br>\
label: 4-letter code for the layer. This method only accepts a string<br>\
mode: "let" or "num", to specify whether the labels use A-Z or 0, 1, 2...<br>\
nodel: T to not delete the polyline after the objects have been id'd.<br></div>

</div>

<div class="par">
<div class="function" id="id_set_by_line">id_set_by_line (layname \
label \
mode \
nodel)
</div>

<div class="vars">Arguments:<br>\
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

<div class="vars">Arguments:<br>\
layname: Name of the layer<br>\
parentlayer: Name of the outline layer<br>\
label: 4-letter code for the layer. This method only accepts a string<br>\
mode: "let" or "num", to specify whether the labels use A-Z or 0, 1, 2...<br>\
isclose: Whether or not to close the polygons after they've been labelled<br></div>

</div>

<div class="par">
<div class="function" id="get_closest">get_closest ()
</div>

</div>

<div class="par">
<div class="function" id="sort_by_segment">sort_by_segment (a \
b)
</div>

<div class="vars">Arguments:<br>\
a: a list containing relevant information, specifically which line segment and where along the line it is.<br>\
b: a list containing relevant information, specifically which line segment and where along the line it is.<br></div>

</div>

<div class="par">
<div class="function" id="get_obj_point">get_obj_point (obj)
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

<div class="vars">Arguments:<br>\
objlist: list of objects<br>\
outlinegon: polyline to measure distance from<br></div>

</div>

</div>
<div class="file" id="merge.lsp">merge.lsp
<div class="fdesc">Commands to merge drawings into one as blocks.<br>\
Mergecad can be used for site plans and general drawings. Mergefloors will add blocks to layers specifying which floor it represents. (0-floor#)<br>
</div>
<div class="par">
<div class="function" id="c:mergeCAD">c:mergeCAD ()
</div>

<div class="desc"> Import selected drawings as blocks on the current layer.<br>
</div>

</div>

<div class="par">
<div class="function" id="c:mergexCAD">c:mergexCAD ()
</div>

<div class="desc"> Import selected drawings exploded onto the current layer.<br>
</div>

</div>

<div class="par">
<div class="function" id="c:replaceCAD">c:replaceCAD ()
</div>

<div class="desc"> Replace each same-named drawing with the newly selected file. Matches site id and floor. (first 6 characters)<br>
</div>

</div>

<div class="par">
<div class="function" id="c:mergeFloors">c:mergeFloors ()
</div>

<div class="desc"> Import selected drawings as blocks, seperating each onto the appropriate layer (e.g. 0-1 for first floor, 0-2 for second, etc.)<br>
</div>

</div>

<div class="par">
<div class="function" id="c:floornum">c:floornum ()
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
<div class="function" id="c:smn">c:smn ()
</div>

<div class="desc"> Originally just a shortcut for site_mon_nums, but now also does some cleaning.<br>\
 Merges "parking point" into "parking points"<br>\
 Also runs NEWFIELDS to add site ids to anything not assigned in the normal procedure.<br>
</div>

</div>

<div class="par">
<div class="function" id="list_layers">list_layers ()
</div>

</div>

<div class="par">
<div class="function" id="site_mon_nums">site_mon_nums ()
</div>

<div class="desc"> Add monument ids to all features<br>
</div>

</div>

<div class="par">
<div class="function" id="c:labellayer">c:labellayer ()
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

<div class="desc"> Change parking points DSPL. Based on distance to closest icon. changes the layer to "tdsb-smsc-parking points u".<br>
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
<div class="function" id="c:exportnewids">c:exportnewids ()
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

<div class="desc"> Test for polyface meshes. on net area and gross area layers.<br>
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
<div class="function" id="c:pm">c:pm ()
</div>

<div class="desc"> Wrapper function to run prepmerge command<br>
</div>

</div>

<div class="par">
<div class="function" id="c:prepmerge">c:prepmerge ()
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
<div class="function" id="c:rfc">c:rfc ()
</div>

<div class="desc"> Wrapper function for removing polyface meshes, and 2D polylines.<br>
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

<div class="desc"> Command wrapper for misaligned.<br>
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
<div class="function" id="c:prepalign">c:prepalign ()
</div>

<div class="desc"> A set of commands to prep a drawing to be ready to align the site plan<br>\
 Changes units, adds several layers, converts circles to polylines, and then changes the colour and line type of certain layers.<br>
</div>

</div>

<div class="par">
<div class="function" id="c:fixcircles">c:fixcircles ()
</div>

<div class="desc"> Change all circles to polylines.<br>
</div>

</div>

<div class="par">
<div class="function" id="c:strace">c:strace ()
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
<div class="function" id="c:fc">c:fc ()
</div>

<div class="desc"> command wrapper for (fixcircles)<br>
</div>

</div>

</div>
<div class="file" id="testpoint.lsp">testpoint.lsp
<div class="fdesc">A script written to test the testpt function. Now defunct.<br>
</div>
<div class="par">
<div class="function" id="c:testpt">c:testpt ()
</div>

<div class="desc"> Asks for point and polyline, tests if point is in the polyline.<br>
</div>

</div>

</div>
<div class="file" id="testssorder.lsp">testssorder.lsp
<div class="fdesc">Determine which order labels are grabbed when selecting them.<br>
</div>
<div class="par">
<div class="function" id="c:testcolor">c:testcolor ()
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
<div class="function" id="c:isom">c:isom ()
</div>

<div class="desc"> Wrapper to quickly isolate the "misc" layer<br>
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
<div class="function" id="c:types">c:types ()
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
<div class="function" id="c:fixerr">c:fixerr ()
</div>

<div class="desc"> Wrapper command to detect errors with finderr<br>
</div>

</div>

<div class="par">
<div class="function" id="c:boundfixroom">c:boundfixroom ()
</div>

<div class="desc"> Wrapper command to find errors in a merged file.<br>
</div>

</div>

<div class="par">
<div class="function" id="c:fixroom">c:fixroom ()
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
<div class="function" id="LM:ss->ent">LM:ss->ent (ss)
</div>

<div class="desc"> Converts a SelectionSet to a list of Entities<br>\
 Author: Lee Mac, Copyright Â© 2011: www.lee-mac.com<br>
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
 Author:  Lee Mac, Copyright Â© 2012 :  www.lee-mac.com<br>
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
<div class="function" id="c:updatelayers">c:updatelayers ()
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
<div class="function" id="c:colorLines">c:colorLines ()
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
 Author: Lee Mac, Copyright © 2011 - www.lee-mac.com<br>
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
<div class="function" id="c:label">c:label ()
</div>

<div class="desc"> wrapper function for command<br>
</div>

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
<div class="function" id="c:fixall">c:fixall ()
</div>

<div class="desc"> Fix all ids in a selection set after they were all set to use facility number 0388 rather than the correct one.<br>
</div>

</div>

</div>
<div class="file" id="Original Site Plan Lisp\\movescale.lsp">Original Site Plan Lisp\\movescale.lsp
<div class="fdesc">Scale space between labels to new size for 11x17 view.<br>
</div>
<div class="par">
<div class="function" id="c:scnmove">c:scnmove ()
</div>

<div class="desc"> Get a selection of objects, and scale the distance between them. Used to scale 8.5x11 labels into the 11x17 paperspace.<br>
</div>

</div>

<div class="par">
<div class="function" id="c:copyaddr">c:copyaddr ()
</div>

<div class="desc"> Copies the properties of the 8.5x11 title block into the 11x17 title block<br>
</div>

</div>

<div class="par">
<div class="function" id="c:portprop">c:portprop ()
</div>

<div class="desc"> Unfinished method to insert property line label and portable label without copying them in. They're blocks, so it's not this easy.<br>
</div>

</div>

</div>
<div class="file" id="Original Site Plan Lisp\\mp.lsp">Original Site Plan Lisp\\mp.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="c:mpoint">c:mpoint ()
</div>

<div class="desc"> Draw a point at the midpoint of two points.<br>
</div>

</div>

</div>
<div class="file" id="Original Site Plan Lisp\\OutlineObjectsV1-1.lsp">Original Site Plan Lisp\\OutlineObjectsV1-1.lsp
<div class="fdesc">A Lee Mac file, but slightly edited. Also contains startundo and endundo, before they were moved to utils. Main function never used. See file for documentation.<br>
</div>
<div class="par">
<div class="function" id="c:outline">c:outline ()
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
<div class="function" id="c:mpo">c:mpo ()
</div>

<div class="desc"> Run c:mpoint<br>
</div>

</div>

<div class="par">
<div class="function" id="c:uplay">c:uplay ()
</div>

<div class="desc"> Run c:updatelayers<br>
</div>

</div>

<div class="par">
<div class="function" id="insertextralabels">insertextralabels ()
</div>

</div>

</div>
<div class="title">Downloaded Lisp Functions</div>
<div class="file" id="Original Site Plan Lisp\\Downloaded\\CirclePolylineSwap.lsp">Original Site Plan Lisp\\Downloaded\\CirclePolylineSwap.lsp
<div class="fdesc">
</div>
<div class="par">
<div class="function" id="c:C2P">c:C2P ()
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
<div class="function" id="c:P2C">c:P2C ()
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
<div class="function" id="c:mer">c:mer ()
</div>

<div class="desc"> Wrapper for (multiple_enclosing_rectangles)<br>
</div>

</div>

</div>
<div class="file" id="Original Site Plan Lisp\\Downloaded\\OutlineObjectsV1-1.lsp">Original Site Plan Lisp\\Downloaded\\OutlineObjectsV1-1.lsp
<div class="par">
<div class="function" id="c:outline">c:outline ()
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
<div class="function" id="c:Sel_By_OD">c:Sel_By_OD ()
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
