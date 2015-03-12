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


  disableSubmitOnClick();
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

////////////////////////////////
// Disables button after being clicked
////////////////////////////////
function grayOutButtonOnClick(btnID){
  // $(btnID).click(function(e){
  //     if ($(this).hasClass("aldready_clicked")){
  //       console.log("double click");
  //       return false;
  //     }
  //     $(this).css("opacity", "0.2");
  //     $(this).val("loading...");
  //     $(this).addClass("aldready_clicked");
  //   });
}

function disableSubmitOnClick(){
  $('form').bind('submit', function(e){
    // e.preventDefault();
    var button = $(this).find('input[type=submit]');
    if (button.hasClass("already_clicked")){
      console.log("double click");
      return false;
    }
    if ($(".has-error").size() > 0){
      return false;
    }
    button.css("opacity", "0.2");
    button.val("Loading...");
    button.addClass("already_clicked");
    return true;
  });
}


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

function sumItemList(itemClass, displayId, endText){
  sumTotal = 0;
  $(itemClass).each(function(){
    sumTotal += parseInt($(this).html());
  });
  $(displayId).html("$" + sumTotal + endText);
}

////////////////
// DatePicker Functions
////////////////

function updateDropdownDates(datePickerField, dropdownID, available_delivery_times){
  var val = $(datePickerField).val();
  console.log("Value:" + val);
  console.log(available_delivery_times);

  $(dropdownID + " option").each(function() {
      $(this).remove();
  });


  
  if (!available_delivery_times){
    $(dropdownID)
      .append($("<option></option>")
      .text("There is no value"));
    return;
  }

  var times = available_delivery_times[val];
  var startTime = 0;
  var endTime = 0;
  var FirstAMPM = "AM";
  var SecondAMPM = "AM";
  $(dropdownID)
     .append($("<option></option>").text("Choose a time window"));

  $.each(times, function(index, value) {
    startTime = value;
    endTime = startTime + 1;



    if (startTime == 0){
      startTime = "12";
      endTime = "1";
    } else if (startTime > 0 && startTime < 12){
      // console.log("yo!: endTime" + endTime + " startTime:" + startTime);
      if(endTime == 12 || startTime == 11){
        // console.log("at least it got here");
        SecondAMPM = " PM";
      }    
    } else if (startTime == 12){
      FirstAMPM = " PM";
      SecondAMPM = " PM"
      endTime = endTime -12;
    } else if (startTime > 12){
      FirstAMPM = " PM";
      SecondAMPM = " PM";
      startTime = startTime - 12;
      endTime = endTime - 12; 
      if(endTime == 12){
        SecondAMPM = " AM";
      }
    }


    $(dropdownID)
       .append($("<option></option>")
       .attr("value",value)
       .text(startTime + ":00" + FirstAMPM+ " - "+ + endTime + ":00 " + SecondAMPM));
  });
  // $(dropdownID)
  //    .append($("<option class=\"half-opacity\"></option>")
  //    .text("Need a different time? Call us!"));
}

/////////////////
// Offers promotional discounts for overlapping deliveries
/////////////////
function highlightDeliveryDiscounts(arrayOfDates, classToAdd){
  var a = $(".datepicker tbody td");
  for (var i = 0; i < arrayOfDates.length; i++) {
    console.log("hi" + " " + i);
      var j = arrayOfDates[i];
    a.each(function(){
      var p = $(this).text();
      if (p == j){
        console.log("j:" + j + " P:" + p);
        $(this).addClass(classToAdd);
      }
    });
  }
};





/////////////////
// Change To "Loading" On Button Click
/////////////////

function loadingOnClick(className){

  $(className).html("Loading...");
  $(className).attr("disabled", true);
}


