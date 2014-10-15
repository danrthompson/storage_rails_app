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
//= require pikaday
//= require gnmenu
//= require turbolinks
//= require bootstrap
//= require bootstrapValidator
//= require custom
// require syn-dashboard
// require classie
// require nivo-lightbox
// require stellar

// On document load
$(function() { 
  $(".loadingOnClick").click(function(){
    $(this + " ").attr("disabled", true);
    // $(this).html("Loading...");
  });

  $(".disableOnClick").click(function(e){
    $(".disableOnClick").attr("disabled", true);
  });
});

function hideParentWhenNotUsed(classId){
  var objectToHide = $("." + classId);
  objectToHide.each(function(){
      if ($(this).html()) $(this).parent().show();
      else $(this).parent().hide();     
  });
}; 

function hideParentWhenZero(classId){
  var objectToHide = $("." + classId);
  objectToHide.each(function(){
      if ($(this).html() != "0") $(this).parent().show();
      else $(this).parent().hide();     
  });
}; 


/////////////////////////////////////////////////////////////
// Makes sure required fields are filled out on address/delivery page
/////////////////////////////////////////////////////////////
function valQuantityAndAddress(formID, buttonID, fieldClass){
  var formValid = checkFormValidation(formID, buttonID); 
  if (formValid) return makeSureQuantityEntered(fieldClass, buttonID);
}

function valQuantityAddrDelivery(formID, buttonID, fieldClass, datepickerID, timeFieldId){
  if (valQuantityAndAddress(formID, buttonID, fieldClass)) {
    validatePickup(datepickerID, timeFieldId, buttonID);
  } 
}

function valAddrDelivery(formID, buttonID, datepickerID, timeFieldId){
  if (checkFormValidation(formID, buttonID)) return validatePickup(datepickerID, timeFieldId, buttonID);
  else return false;
}
// Validates address form
function checkFormValidation(formID, buttonID){
  // console.log("checking form");
  $(formID).data('bootstrapValidator').validate();
  if ($(formID).data('bootstrapValidator').isValid()){
      $(buttonID).removeAttr("disabled");    
      return true;
  } else{
    $(buttonID).attr("disabled", "disabled"); 
    return false;
  }
}

// Makes sure user selects at least one item
function makeSureQuantityEntered(fieldClass, buttonID){
  // console.log("checking quanitity");
  total = 0;
  $(fieldClass).each(function(){
    var fieldVal = $(this).val();
    if ((fieldVal)){
      total = total + parseInt(fieldVal);   
    }
  });
  if (total > 0){
    $(buttonID).removeAttr("disabled");
    return true;
  } else{
    $(buttonID).attr("disabled", "disabled"); 
    return false;
  }

}

// Makes sure pickup day and time is selected
function validatePickup(datepickerID, timeFieldId, buttonID){
  // console.log("checking pickup");
  if(($(datepickerID).val().length > 0) && ($(timeFieldId).val().length > 0)) {
    $(buttonID).removeAttr("disabled"); 
    return true;
  }
  else {
    $(buttonID).attr("disabled", true); 
    return false;
  }
}

// SUMS DELIVERY ITEMS

function sumItemList(itemClass, displayId){
  sumTotal = 0;
  $(itemClass).each(function(){
    sumTotal += parseInt($(this).html());
  });
  $(displayId).html("$" + sumTotal);
}

////////////////
// DatePicker Functions
////////////////

function updateDropdownDates(datePickerField, dropdownID, available_delivery_times){
  var val = $(datePickerField).val();
  console.log("Value:" + val);

  $(dropdownID + " option").each(function() {
      $(this).remove();
  });
  
  if (!available_delivery_times) return;
  var times = available_delivery_times[val];
  // console.log("about to iterate");
  $.each( times, function(value) {
    // console.log (dropdownID +":"+ value);
     $(dropdownID)
       .append($("<option></option>")
       .attr("value",value)
       .text(value + ":00"));
  });
}

/////////////////
// Change To "Loading" On Button Click
/////////////////

function loadingOnClick(className){

  $(className).html("Loading...");
  $(className).attr("disabled", true);
}