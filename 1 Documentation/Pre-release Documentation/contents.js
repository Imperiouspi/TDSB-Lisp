var files = document.getElementsByClassName("file")
var sbar = document.getElementById("sidebar")
for (var i = 0; i < files.length; i++) {
	fname = files[i].innerText.split("\n")[0].split(".lsp")[0]
	title = document.createElement("a")
	title.innerHTML = fname.concat(".lsp")
	title.href = "#".concat(fname,".lsp")
	title.className = "qlink sbarlink"

	sbar.appendChild(title)
}

var funcs = document.getElementsByClassName("function")
var ind = document.getElementById("index")

for(var i = 0; i < funcs.length; i++){
	name = funcs[i].textContent.split(" (")[0]

	item = document.createElement("a")
	item.innerHTML = name.concat("\n")
	item.href = "#".concat(name)
	item.className = "qlink indexlink"

	ind.appendChild(item)
}