var files = document.getElementsByClassName("file")

//Sidebar
var sbar = document.getElementById("sidebar")
var sbarindex = document.getElementById("indexbar")
for (var i = 0; i < files.length; i++) {
	fname = files[i].innerText.split("\n")[0].split(".ps1")[0]
	title = document.createElement("a")
	title.href = "#".concat(fname,".ps1")
	title.className = "qlink sbarlink"
	if(fname.includes("\\")){
		fname = fname.split("\\").pop()
	}
	title.innerHTML = fname.concat(".ps1")

	sbar.insertBefore(title,sbarindex)
}