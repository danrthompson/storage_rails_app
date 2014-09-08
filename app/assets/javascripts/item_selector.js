
  /////////////////////////////////////////////////////////////
  // Increment Text Field
  /////////////////////////////////////////////////////////////
  $(".btn-inc").click(function(){
    console.log("button clicked");
    var id = $(this).attr('id');

    // update text field - incrememnt by one
    var field = $("#txt-"+id);
    var val = $(field).val();
    val = +val + 1;
    $(field).val(val);

    // update subtotal text
    var orderEntrySpan = $('#num-'+id+" span");
    console.log("#num-"+id+" span");
    refreshOrder(val, orderEntrySpan);
  });


  /////////////////////////////////////////////////////////////
  // Changes quantity, updates field when text manually changed
  /////////////////////////////////////////////////////////////
  $(".quantity-field").change(function(){
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
    
    updatePackingItemsTotal();
    updatePickupTotal();
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

    // Pricing Per Box
    var STDBOX_PRICE =  6.50;
    var WARDROBE_BOX_PRICE =  12.00;
    var BUBBLE_WRAP_PRICE =  4.50;
    var TAPE_PRICE =  9.50;
    var POSTER_TUBE_PRICE =  10.00;

    var total = (numStdBox * STDBOX_PRICE) + (numWarBox * WARDROBE_BOX_PRICE) + (numBubble * BUBBLE_WRAP_PRICE) + (numTape * TAPE_PRICE);
    console.log("total:" + total);
    $('#order-subtotal').text("$" + total+"/m");
    if ((total > 1) && ($("#delivery-time").hasClass("hidden"))) {
      $("#delivery-time").toggleClass("hidden");
      
      // Allow user to continue on
      if (!$("#pickup-deliv-instructions").hasClass("hidden")){
        $("#pickup-deliv-instructions").toggleClass("hidden");
        $("#signup-second-btn").removeAttr("disabled");
      }

    }
  }


  /////////////////////////////////////////////////////////////
  // Overwrites subtotal for pickup order
  // Hides delivery field if no items selected
  /////////////////////////////////////////////////////////////
  function updatePickupTotal(){
    // Number of Boxes
    var numBox = $('#txt-box').val();
    var numMedium = $('#txt-medium').val();
    var numLarge = $('#txt-large').val();
    var numXLarge = $('#txt-extra_large').val();

    // Pricing Per Box
    var BOX_PRICE =  5.00;
    var MEDIUM_PRICE =  12.00;
    var LARGE_PRICE =  20.00;
    var XLARGE_PRICE =  40.00;


    var total = (numBox * BOX_PRICE) + (numMedium * MEDIUM_PRICE) + (numLarge * LARGE_PRICE) + (numXLarge * XLARGE_PRICE);
    console.log("total:" + total);
    $('#pickup-subtotal').text("$" + total+"/m");
    if ((total > 1) && ($("#pickup-time").hasClass("hidden"))){
      $("#pickup-time").toggleClass("hidden");
      
      // Allow user to continue on
      if (!$("#pickup-deliv-instructions").hasClass("hidden")){
        $("#pickup-deliv-instructions").toggleClass("hidden");
        $("#signup-second-btn").removeAttr("disabled");
      }
    }
  }

