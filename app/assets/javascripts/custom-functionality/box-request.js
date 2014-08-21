// Increment Text Field
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

$(".quantity-field").change(function(){
var field = $(this);
var id = field.attr("id");
var idRoot = id.substr(4);
console.log("#num-"+idRoot+" span");
var orderEntrySpan = $('#num-'+idRoot+ " span");
refreshOrder(field.val(), orderEntrySpan);
});


// Rewrites values in Order Summary Field
function refreshOrder(val, orderEntrySpan){
console.log("REFERESHING ORDER FOR" + orderEntrySpan);
orderEntrySpan.html(parseInt(val));
var orderEntry = orderEntrySpan.parent();

if (val == 0) orderEntry.addClass('hidden');
else orderEntry.removeClass('hidden');

updateBoxRequestTotal();
}


// Overwrites subtotal for box request
function updateBoxRequestTotal(){

// Number of Boxes
var numStdBox = $('#txt-stdbox').val();
var numWarBox = $('#txt-warbox').val();
var numBubble = $('#txt-bubble').val();
var numFileBox = $('#txt-filebox').val();
var numTube = $('#txt-tube').val();

// Pricing Per Box
var STDBOX_PRICE =  6.50;
var WARDROBE_BOX_PRICE =  12.00;
var BUBBLE_WRAP_PRICE =  4.50;
var FILE_BOX_PRICE =  9.50;
var POSTER_TUBE_PRICE =  10.00;


var total = (numStdBox * STDBOX_PRICE) + (numWarBox * WARDROBE_BOX_PRICE) + (numBubble * BUBBLE_WRAP_PRICE) + (numFileBox * FILE_BOX_PRICE) + (numTube * POSTER_TUBE_PRICE);
console.log("total:" + total);
$('#order-subtotal').text("$" + total+"/m");
}
