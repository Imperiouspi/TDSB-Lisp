String.prototype.replaceAll = function(search, replacement) {
	var target = this;
	return target.replace(new RegExp(search, 'g'), replacement);
};

// The function actually applying the offset
function offsetAnchor() {
	if (location.hash.length !== 0 && !(document.getElementById(location.hash.substr(1)) == document.getElementById("main").lastChild.previousElementSibling)) {
		window.scroll(window.scrollX, window.scrollY - 85);
	}
}

function temphighlight() {
	$(document).ready(function() {
		if(location.hash != "#index" && location.hash != null && location.hash != ""){
			if(document.getElementById(location.hash.split("#")[1].replaceAll("%20"," ")).className == "function"){
				$(document.getElementById(location.hash.split("#")[1].replaceAll("%20"," ")).parentElement).effect("highlight", {}, 1500)
			}
			else{
				$(document.getElementById(location.hash.split("#")[1].replaceAll("%20"," "))).effect("highlight", {}, 1500)
			}
		}
	});
}

$(function(){
	temphighlight()
});

// Captures click events of all <a> elements with href starting with #
$(document).on('click', 'a[href^="#"]', function(event) {
	e = event;
	// Click events are captured before hashchanges. Timeout
	// causes offsetAnchor to be called after the page jump.
	window.setTimeout(function() {
		offsetAnchor();
		temphighlight();
	}, 0);
});

// Set the offset when entering page with hash present in the url
window.setTimeout(offsetAnchor, 0);

window.onscroll = function() {scrollFunction()};

//src: https://www.w3schools.com/howto/howto_js_scroll_to_top.asp
function scrollFunction() {
	if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
		document.getElementById("topbtn").style.display = "block";
	} else {
		document.getElementById("topbtn").style.display = "none";
	}
}

// When the user clicks on the button, scroll to the top of the document
function topFunction() {
	scrollTo(document.body, 0, 200); // For Safari
	scrollTo(document.documentElement, 0, 200); // For Chrome, Firefox, IE and Opera
}

//src: http://robertpenner.com/easing/
function scrollTo(element, to, duration) {
	var start = element.scrollTop,
		change = to - start,
		increment = 20;

	var animateScroll = function(elapsedTime) {        
		elapsedTime += increment;
		var position = easeInOut(elapsedTime, start, change, duration);                        
		element.scrollTop = position; 
		if (elapsedTime < duration) {
			setTimeout(function() {
				animateScroll(elapsedTime);
			}, increment);
		}
	};

	animateScroll(0);
}

function easeInOut(currentTime, start, change, duration) {
	currentTime /= duration / 2;
	if (currentTime < 1) {
		return change / 2 * currentTime * currentTime + start;
	}
	currentTime -= 1;
	return -change / 2 * (currentTime * (currentTime - 2) - 1) + start;
}
