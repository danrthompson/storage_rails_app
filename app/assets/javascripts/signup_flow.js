function moveFromTo(fromDiv, toDiv){
	$(fromDiv).hide();
	$(toDiv).show();
	window.scrollTo(0,0);
}



$("#signup-first-btn").click(function(){
	console.log("TESTETSTETSTSEETETETETTSTE");
	moveFromTo("#signup-first", "#signup-second");
	// console.log("moving on to the second");
	// $("#signup-first").hide();
	// $("#signup-second").show();
	// window.scrollTo(0,0);
})

$("#signup-second-btn").click(function(){
	console.log("moving on to the third");
	$("#signup-second").hide();
	$("#signup-third").show();
	window.scrollTo(0,0);
})


$("#signup-third-btn").click(function(e){
	e.preventDefault();
	console.log("moving on to the fourth");
	$("#signup-third").hide();
	$("#signup-fourth").show();
	window.scrollTo(0,0);
})


$("#signup-second-btn").click(function(){
	$("#signup-second").hide();
	$("#signup-third").show();
	window.scrollTo(0,0);
})
