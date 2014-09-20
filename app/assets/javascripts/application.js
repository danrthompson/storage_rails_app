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
  var formValid = enableButtonWhenValid(formID, buttonID); 
  if (formValid) makeSureQuantityEntered(fieldClass, buttonID);
}

function enableButtonWhenValid(formID, buttonID){
  $(formID).data('bootstrapValidator').validate();
  if ($(formID).data('bootstrapValidator').isValid()){
      $(buttonID).removeAttr("disabled");    
      return true;
  } else{
    $(buttonID).attr("disabled", "disabled"); 
    return false;
  }
}

function makeSureQuantityEntered(fieldClass, buttonID){
  var fieldsToSum = $(fieldClass);
  var total = 0;
  fieldsToSum.each(function(){
    total += parseInt($(this).val());
    if (total <= 0) $(buttonID).attr("disabled", "disabled");    
    else $(buttonID).removeAttr("disabled");    
  });
}



