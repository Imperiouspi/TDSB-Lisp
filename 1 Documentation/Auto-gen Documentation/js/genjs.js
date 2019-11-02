// Get the modal
var modal = document.getElementsByClassName("over")[0];

if(modal){
	modal.onclick = function() {
		modal.style.display = "none";
	}
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
	if (event.target == modal) {
		modal.style.display = "none";
	}
}

imgs = document.getElementsByTagName("img")
for (var i = imgs.length - 1; i >= 0; i--) {
	if(imgs[i].className != "overimg"){
		imgs[i].onclick = function() {
			modal.style.display = "flex";
			img = document.getElementsByClassName("overimg")[0]
			img.src = this.src
			link = document.getElementsByClassName("imglink")[0]
			link.href = this.src
		}
	}
}