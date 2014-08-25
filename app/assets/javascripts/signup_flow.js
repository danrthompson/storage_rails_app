function moveFromTo(fromDiv, toDiv){
	$(fromDiv).hide();
	$(toDiv).show();
	window.scrollTo(0,0);
}

$("#signup-first-btn").click(function(){
	moveFromTo("#signup-first", "#signup-second");
})

$("#signup-second-btn").click(function(){
	moveFromTo("#signup-second", "#signup-third");
})

$("#signup-third-btn").click(function(){
	e.preventDefault();
	moveFromTo("#signup-third", "#signup-fourth");
})

$("#signup-second-back").click(function(){
	moveFromTo("#signup-second", "#signup-first");
})

$("#signup-third-back").click(function(e){
	e.preventDefault();
	moveFromTo("#signup-third", "#signup-second");
})

$("#signup-fourth-back").click(function(){
	e.preventDefault();
	moveFromTo("#signup-fourth", "#signup-third");
})






