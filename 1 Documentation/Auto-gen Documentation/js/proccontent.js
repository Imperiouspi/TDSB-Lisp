var procs = document.getElementsByClassName("procname")
document.getElementById('alphabetical').style.display = "none";
//Sidebar
var sbar = document.getElementById("sidebar")
var sbarindex = document.getElementById("indexbar")
for (var i = 0; i < procs.length; i++) {
	fname = procs[i].innerText.split("\n")[0]
	title = document.createElement("a")
	title.href = "#".concat(fname)
	title.className = "qlink sbarlink"
	if(fname.includes("\\")){
		fname = fname.split("\\").pop()
	}
	title.innerHTML = fname

	sbar.insertBefore(title,sbarindex)
}

function toggletable() {
	var a_table = document.getElementById('alphabetical');
	var o_table = document.getElementById('operation');
	if(a_table.style.display === "none"){
		a_table.style.display = "table";
		o_table.style.display = "none";
		document.getElementById("alpha").innerText = "Alphabetical";
	} else{
		a_table.style.display = "none";
		o_table.style.display = "table";
		document.getElementById("alpha").innerText = "Order of Operations";
	}
}