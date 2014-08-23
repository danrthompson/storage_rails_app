// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs

//= require gnmenu
//= require turbolinks
// require bootstrap
// require classie
// require nivo-lightbox
// require stellar
// require custom
// require syn-dashboard



$("#signup-first-btn").click(function(){
	console.log("moving on to the second");
	$("#signup-first").hide();
	$("#signup-second").hide();
	window.scrollTo(0,0);
})


$("#signup-second-btn").click(function(e){
	e.preventDefault()
	console.log("moving on to the second");
	$("#signup-second").hide();
	$("#signup-third").hide();
	window.scrollTo(0,0);
})


$("#signup-third-btn").click(function(){
	console.log("moving on to the second");
	$("#signup-third").hide();
	$("#signup-fourth").show();
	window.scrollTo(0,0);
})



