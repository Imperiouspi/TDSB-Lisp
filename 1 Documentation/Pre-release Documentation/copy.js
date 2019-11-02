var pars = document.getElementsByClassName("function")
console.log(document)
for (var i = pars.length - 1; i >= 0; i--) {
	var but = document.createElement("button")
	but.innerHTML = "copy to clipboard"
	but.addEventListener("click", clipcopy(pars[i].innerHTML))
	but.onClick = "clipcopy()"
	//pars[i].appendChild(but)
}

function clipcopy(listtocopy){
	
}