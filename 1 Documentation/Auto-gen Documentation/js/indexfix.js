var files = document.getElementsByClassName("file")

//Sidebar
var sbar = document.getElementById("sidebar")
var sbarindex = document.getElementById("indexbar")
sbar.maxHeight = (files.length + 2) * files.height
sbar.paddingBottom = sbar.paddingBottom + files.height