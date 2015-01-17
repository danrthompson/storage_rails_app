$(document).ready(function() {
   // Recalculate field when "+" button clicked
    $('.quantity-field').on('input', function() {
      console.log("QUANTITY CHANGED");
      var field = $(this);
      var id = field.attr("id");
      var idRoot = id.substr(4);
      console.log("#num-"+idRoot+" span");
      var orderEntrySpan = $('#num-'+idRoot+ " span");
      refreshOrder(field.val(), orderEntrySpan);
    });

    setSidebarPosition();




    // var scrollTop = $(window).scrollTop(),
    // elementOffset = $('#my-element').offset().top,
    // distance      = (elementOffset - scrollTop);

});

$(document).scroll(setSidebarPosition);
window.onresize = function(event) {
  setSidebarPosition();
}

function setSidebarPosition(){
  console.log("setting position");
  $("#estimator-sidebar").css({"position": "static", "bottom":"", "left":offsetLeft});

  var scrolledHeight = $(document).scrollTop();
  var scrolledPlusWindow = scrolledHeight + window.innerHeight;
  var fixedHeaderHeight = $('#fixed-header').height();
  var headerHeight = $('#top-header').height();

  var footerOffset = $('footer').offset().top;
  var offset = $("#estimator-sidebar").offset();
  var offsetLeft = offset.left;
  var offsetTop = offset.top;

  if (offsetTop > $(window).height()){
    $("#estimator-sidebar").css({"position": "static", "bottom":"", "left":offsetLeft});
  } else {
    if (scrolledPlusWindow<footerOffset) {
      $("#estimator-sidebar").css({"position": "fixed", 'top': fixedHeaderHeight + 10 + Math.max(headerHeight - scrolledHeight, 0), "left":offsetLeft});
    } else {
      $("#estimator-sidebar").css({"position": "fixed", 'bottom': (10+(scrolledPlusWindow-footerOffset))+'px', 'top': '', "left":offsetLeft});
    }
  }

  // }
}
  ///////////////////////////////
  $("#by-item-btn").click(function(){
    console.log("clicked!");
    var entries = $("#small-entries-list");
    var categories = $("#entries-category-list");

    if (entries.hasClass("hidden")){
          $("#by-category-btn").toggleClass("third-opacity");
          $(this).toggleClass("third-opacity");
    
          $("#by-category-btn").toggleClass("gray-bg");
          $(this).toggleClass("gray-bg");
    
          $("#by-category-btn").toggleClass("blue-bg");
          $(this).toggleClass("blue-bg");
    
          entries.toggleClass("hidden");   
          categories.toggleClass("hidden");    
     }
    });

  $("#by-category-btn").click(function(){
    console.log("cat clicked!");
    var categories = $("#entries-category-list");
    var entries = $("#small-entries-list");
    if (categories.hasClass("hidden")){
          $("#by-item-btn").toggleClass("third-opacity");
          $(this).toggleClass("third-opacity");
    
          $("#by-item-btn").toggleClass("gray-bg");
          $(this).toggleClass("gray-bg");
    
          $("#by-item-btn").toggleClass("blue-bg");
          $(this).toggleClass("blue-bg");
    
          entries.toggleClass("hidden");   
          categories.toggleClass("hidden");    
        }
        
    
  });


  /////////////////////////////////////////////////////////////
  // Increment Text Field
  /////////////////////////////////////////////////////////////
  $(".btn-inc").click(function(){
    console.log("button clicked");
    var id = $(this).attr('id');

    // update text field - incrememnt by one
    var field_name = "#txt-"+id;
    var field = $(field_name);
    var val = $(field).val();
    val = +val + 1;
    $(field).val(val);

    // console.log(field_name);
    switch(field_name) {
      case "#txt-small":
        var itemVal = $("#txt-parcel").val();
        // console.log("itemVal:" + itemVal);
        $("#txt-parcel").val(+itemVal + 1);
        break;
      case "#txt-medium":
        var itemVal = $("#txt-barrel").val();
        $("#txt-barrel").val(+itemVal + 1);
        break;
      case "#txt-large":
        var itemVal = $("#txt-crate").val();
        $("#txt-crate").val(+itemVal + 1);
        break;
      case "#txt-extra_large":
        var itemVal = $("#txt-elephant").val();
        $("#txt-elephant").val(+itemVal + 1);
        break;
    }
    // update subtotal text
    var orderEntrySpan = $('#num-'+id+" span");
    // console.log("#num-"+id+" span");
    refreshOrder(val, orderEntrySpan);
  });

  //////////
  // BOX BUTTON CLICK
  // VERY REPETITIVE BUT ITS 3AM AND IM TOO TIRED TO THINK
  //////////
  $(".small-inc").click(function(){
    var id = $(this).attr('id');
    reactToIncButton("small", id);
  });

  $(".medium-inc").click(function(){
    var id = $(this).attr('id');
    reactToIncButton("medium", id);
  });

  $(".large-inc").click(function(){
    var id = $(this).attr('id');
    reactToIncButton("large", id);
  });

  $(".xl-inc").click(function(){
    var id = $(this).attr('id');
    var field = $("#txt-"+id);
    var val2 = $(field).val();
    val2 = +val2 + 1;
    $(field).val(val2);
    var field = $("#txt-extra_large");
    var resutVal = sumFieldsFor(".xl-txt");
    $(field).val(resutVal);
    var orderEntrySpan = $('#num-'+ "extra_large"+ " span");
    refreshOrder(field.val(), orderEntrySpan);
  });

  $(".5x10-inc").click(function(){
    var id = $(this).attr('id');
    reactToIncButton("5x10", id);
  });
  $(".10x10-inc").click(function(){
    var id = $(this).attr('id');
    reactToIncButton("10x10", id);
  });
  $(".10x20-inc").click(function(){
    var id = $(this).attr('id');
    reactToIncButton("10x20", id);
  });


  function reactToIncButton(fieldType, id){
    var field = $("#txt-"+id);
    var val2 = $(field).val();
    val2 = +val2 + 1;
    $(field).val(val2);
    var field = $("#txt-" + fieldType);
    var resutVal = sumFieldsFor("."+ fieldType +"-txt");
    $(field).val(resutVal);
    var orderEntrySpan = $('#num-'+ fieldType + " span");
    refreshOrder(field.val(), orderEntrySpan);
  }


  $('.small-txt').on('input', function() {
    var field = $("#txt-small");
    var resutVal = sumFieldsFor(".small-txt");
    $(field).val(resutVal);
    var orderEntrySpan = $('#num-'+ "small"+ " span");
    refreshOrder(field.val(), orderEntrySpan);
  });

  $('.medium-txt').on('input', function() {
    readFieldUpdateAll("medium");
    // var field = $("#txt-medium");
    // var resutVal = sumFieldsFor(".medium-txt");
    // $(field).val(resutVal);
    // var orderEntrySpan = $('#num-'+ "medium"+ " span");
    // refreshOrder(field.val(), orderEntrySpan);
  });

  $('.large-txt').on('input', function() {
    readFieldUpdateAll("large");
    // var field = $("#txt-large");
    // var resutVal = sumFieldsFor(".large-txt");
    // $(field).val(resutVal);
    // var orderEntrySpan = $('#num-'+ "large"+ " span");
    // refreshOrder(field.val(), orderEntrySpan);
  });


  $('.xl-txt').on('input', function() {
    var field = $("#txt-extra_large");
    var resutVal = sumFieldsFor(".xl-txt");
    $(field).val(resutVal);
    var orderEntrySpan = $('#num-'+ "extra_large"+ " span");
    refreshOrder(field.val(), orderEntrySpan);
  });

  fieldsSum = 0;
  function sumFieldsFor(txt_field){
    fieldsSum = 0;
    var objects = $(txt_field);
    objects.each(function(){
      var fieldVal = parseInt($(this).val());
      if (!isNaN(fieldVal)) fieldsSum = +fieldsSum + fieldVal;
    });
    return fieldsSum;
  }

  function readFieldUpdateAll(itemType){
    var field = $("#txt-" + itemType);
    var resutVal = sumFieldsFor("." + itemType + "-txt");
    $(field).val(resutVal);
    var orderEntrySpan = $('#num-'+ itemType + " span");
    refreshOrder(field.val(), orderEntrySpan);
  }

  /////////////////////////////////////////////////////////////
  // Changes quantity, updates field when text manually changed
  /////////////////////////////////////////////////////////////
  $('.quantity-field').on('input', function() {
    console.log("QUANTITY CHANGED");
    var field = $(this);
    var id = field.attr("id");
    var idRoot = id.substr(4);
    console.log("#num-"+idRoot+" span");
    var orderEntrySpan = $('#num-'+idRoot+ " span");
    refreshOrder(field.val(), orderEntrySpan);

  });



  /////////////////////////////////////////////////////////////
  // Rewrites values in Order Summary Field for pickups and deliveries
  /////////////////////////////////////////////////////////////
  function refreshOrder(val, orderEntrySpan){
    console.log("REFERESHING ORDER FOR" + orderEntrySpan);
    orderEntrySpan.html(parseInt(val));
    var orderEntry = orderEntrySpan.parent();
    
    if (val == 0) orderEntry.addClass('hidden');
    else orderEntry.removeClass('hidden');
    
    // updatePackingItemsTotal();
    updatePickupTotal();
  }

  ////////////////////////////
  ///// If the page refreshes (in the event of an error) this redraws the summary of items listed before.
  ////////////////////////////
  function refreshAllOrders(){
    var resutVal = $("#txt-small").val();
    if(resutVal > 0){
      var orderEntrySpan = $('#num-'+ "small"+ " span");
      refreshOrder(resutVal, orderEntrySpan);
    } else console.log("Result Val:" + resutVal);
    
    resutVal = $("#txt-medium").val();
    if(resutVal > 0){
      orderEntrySpan = $('#num-'+ "medium"+ " span");
      refreshOrder(resutVal, orderEntrySpan);
    } else console.log("Result Val:" + resutVal);

    resutVal = $("#txt-large").val();
    if(resutVal > 0){
      orderEntrySpan = $('#num-'+ "large"+ " span");
      refreshOrder(resutVal, orderEntrySpan);
    }else console.log("Result Val:" + resutVal);

    resutVal = $("#txt-extra_large").val();
    if(resutVal > 0){
      orderEntrySpan = $('#num-'+ "extra_large"+ " span");
      refreshOrder(resutVal, orderEntrySpan);
    }else console.log("Result Val:" + resutVal);



  }
  /////////////////////////////////////////////////////////////
  // Overwrites subtotal for packing Items.
  // Hides delivery field if no items selected
  /////////////////////////////////////////////////////////////
  function updatePackingItemsTotal(){

    // Number of Boxes
    var numStdBox = $('#txt-stdbox').val();
    var numWarBox = $('#txt-warbox').val();
    var numBubble = $('#txt-bubble').val();
    var numTape = $('#txt-tape').val();
    console.log(numStdBox + "numStdBox");

    // Pricing Per Box
    var STDBOX_PRICE =  6.50;
    var WARDROBE_BOX_PRICE =  12.00;
    var BUBBLE_WRAP_PRICE =  4.50;
    var TAPE_PRICE =  9.50;
    var POSTER_TUBE_PRICE =  10.00;

    var total = (numStdBox * STDBOX_PRICE) + (numWarBox * WARDROBE_BOX_PRICE) + (numBubble * BUBBLE_WRAP_PRICE) + (numTape * TAPE_PRICE);
    console.log("total:" + total);
    $('#order-subtotal').text("$" + total);
    if ((total > 1) && ($("#delivery-time").hasClass("hidden"))) {
      $("#delivery-time").toggleClass("hidden");
      
      // Allow user to continue on
      if (!$("#packing-instructions").hasClass("hidden")){
        $("#packing-instructions").toggleClass("hidden");
        // $("#signup-second-btn").removeAttr("disabled");
      }

    }
    else if ((total < 1 ) && !($("#delivery-time").hasClass("hidden"))){
      $("#delivery-time").toggleClass("hidden");
    }
  }


  /////////////////////////////////////////////////////////////
  // Overwrites subtotal for pickup order
  // Hides delivery field if no items selected
  /////////////////////////////////////////////////////////////
  function updatePickupTotal(){
    console.log("updating pickup total");
    // Number of Boxes
    var numBox = $('#txt-small').val();
    var numMedium = $('#txt-medium').val();
    var numLarge = $('#txt-large').val();
    var numXLarge = $('#txt-extra_large').val();
    // var num5x10 = $('#txt-5x10').val();
    // var num10x10 = $('#txt-10x10').val();
    // var num10x20 = $('#txt-10x20').val();
    console.log("numBox "+ numBox);
    console.log("numMedium "+ numMedium);
    console.log("numLarge "+ numLarge);
    console.log("numXLarge "+ numXLarge);


    // Pricing Per Box
    var BOX_PRICE =  5.00;
    var MEDIUM_PRICE =  12.00;
    var LARGE_PRICE =  25.00;
    var XLARGE_PRICE =  40.00;
    var FIVETEN_PRICE = 75.00;
    var TENTEN_PRICE = 140.00;
    var TENTWNTY_PRICE = 250.00;

    var total = (numBox * BOX_PRICE) + (numMedium * MEDIUM_PRICE) + (numLarge * LARGE_PRICE) + (numXLarge * XLARGE_PRICE);

    // var total = (numBox * BOX_PRICE) + (numMedium * MEDIUM_PRICE) + (numLarge * LARGE_PRICE) + (numXLarge * XLARGE_PRICE) + (num5x10 * FIVETEN_PRICE) + (num10x10 * TENTEN_PRICE) + (num10x20 * TENTWNTY_PRICE);
    console.log("total:" + total);
    $('#pickup-subtotal').text("$" + total+"/month");
    if ((total > 1) && ($("#pickup-time").hasClass("hidden"))){
      $("#pickup-time").toggleClass("hidden");
      
      // Allow user to continue on
      if (!$("#pickup-deliv-instructions").hasClass("hidden")){
        $("#pickup-deliv-instructions").toggleClass("hidden");
        // $("#signup-second-btn").removeAttr("disabled");
      }
    }
    else if ((total < 1 ) && !($("#pickup-time").hasClass("hidden"))){
      $("#delivery-time").toggleClass("hidden");
    }
    

  }



