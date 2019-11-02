var files = document.getElementsByClassName("file")

//Sidebar
var sbar = document.getElementById("sidebar")
var sbarindex = document.getElementById("indexbar")
for (var i = 0; i < files.length; i++) {
	fname = files[i].innerText.split("\n")[0].split(".lsp")[0]
	title = document.createElement("a")
	title.href = "#".concat(fname,".lsp")
	title.className = "qlink sbarlink"
	if(fname.includes("\\")){
		fname = fname.split("\\").pop()
	}
	title.innerHTML = fname.concat(".lsp")

	sbar.insertBefore(title,sbarindex)
}

var funcs = [].slice.call(document.getElementsByClassName("function"));
funcs.sort(function(a,b){
	return a.textContent.replace("c:","").replace("C:","").split(" (")[0].localeCompare(b.textContent.replace("c:","").replace("C:","").split(" (")[0])
});

//Index
var ind = document.getElementById("index")

for(var i = 0; i < funcs.length; i++){
	name = funcs[i].textContent.split(" (")[0]

    wrap = document.createElement("tr")
	funccell = document.createElement("td")
    func = document.createElement("a")
    filecell = document.createElement("td")
    file = document.createElement("a")
    file.innerHTML = funcs[i].parentElement.parentElement.firstChild.textContent
	func.innerHTML = name.concat("\n")
	// if(i > 1){
	// 	if(funcs[i-1].textContent.split(" (")[0] == name){
	// 		func.innerHTML = name.concat(" (", funcs[i].parentElement.parentElement.firstChild.textContent,")\n")
	// 		prev.innerHTML = prev.innerHTML.concat(" (", funcs[i-1].parentElement.parentElement.firstChild.textContent,")\n")
	// 	}
	// }

	func.href = "#".concat(name)
	func.className = "qlink indexlink"
    file.href = "#".concat(funcs[i].parentElement.parentElement.firstChild.textContent)
    file.className = "qlink indexlink"
	
    wrap.className = "indrow"

    funccell.appendChild(func)
    wrap.appendChild(funccell)
    filecell.appendChild(file)
    wrap.appendChild(filecell)
    ind.appendChild(wrap)
	// prev = func
}