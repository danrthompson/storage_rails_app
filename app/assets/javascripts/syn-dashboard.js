var numDeliveryItems = 0;
var numPickupItems = 0;

// Delivery Entry Selected
$(".delivery-entry").click(function() {
  $(this).toggleClass("selected-item");

  if($(this).hasClass("selected-item")){
  	numDeliveryItems = numDeliveryItems + 1;
    $('input:first', this).prop('checked', true);

  } else {
  	numDeliveryItems = numDeliveryItems - 1;
    $('input:first', this).prop('checked', false);

  }
  console.log("numDeliveryItems:" + numDeliveryItems);

  if (numDeliveryItems == 0) $("#delivery-button").attr("disabled", "disabled");
  else {
		console.log("Delivery BUTTON REMOVING DISABLED");
		$("#delivery-button").removeAttr("disabled"); 
		$(".pickup-entry").removeClass("selected-item");
		$("#pickup-button").attr("disabled", "disabled");
		numPickupItems = 0;  
   } 
});

// Pick Up Entry Selected
$(".pickup-entry").click(function() {
  $(this).toggleClass("selected-item");
  // $('input:first', this).toggleClass('hidden');
  $('input:first', this).prop('checked', true);

  if($(this).hasClass("selected-item")){
  	numPickupItems = numPickupItems + 1;
  } else {
  	numPickupItems = numPickupItems - 1;
  }
  console.log("numPickupItems:" + numPickupItems);

  if (numPickupItems == 0) $("#pickup-button").attr("disabled", "disabled");
  else {
	  console.log("pickup BUTTON REMOVING DISABLED");
	  $("#pickup-button").removeAttr("disabled");   
	  $(".delivery-entry").removeClass("selected-item");
	  $("#delivery-button").attr("disabled", "disabled");
	  numDeliveryItems = 0;
   } 
});

$("#pickup-button").click(function(){
	 console.log("disabled clicked");
	 $("#pickup-form").submit();
});

$("#delivery-button").click(function(){
	 console.log("disabled clicked");
	 $("#delivery-form").submit();
});
