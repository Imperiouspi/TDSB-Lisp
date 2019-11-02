$(function (){
	$("#mainsearch").autocomplete({
		source: index,
		select: function(event, ui){
			window.open(ui.item.source, "_parent")
		}
	}).autocomplete( "instance" )._renderItem = function( ul, item ) {
		selected = document.searchform.search.value
		bolded = item.label.split("")
		for (var i = 0; i < bolded.length - 1; i++) {
			if(selected.toLowerCase().includes(bolded[i].toLowerCase())){
				bolded[i] = "<b>" + bolded[i] + "</b>"
			}
		}
  		return $("<li>")
  			.append("<a class=\"reflink\" href=" + item.source + ">" + bolded.join("") + "</a>")
  				.appendTo( ul )
  		};
});