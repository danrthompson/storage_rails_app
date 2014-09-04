
/////////////////////////////////////////////////////////////
// Validations
/////////////////////////////////////////////////////////////
$(document).ready(function() {

    $('#signup-form')
      .bootstrapValidator({
        // To use feedback icons, ensure that you use Bootstrap v3.1.0 or later
        feedbackIcons: {
            // valid: 'glyphicon glyphicon-ok',
            // invalid: 'glyphicon glyphicon-remove',
            // validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            'user[address_line_1]': {
                message: 'The address field is not valid',
                validators: {
                    notEmpty: {
                        message: 'The address field can\'t be empty'
                    },
                    stringLength: {
                        min: 10,
                        message: 'The address must be a real'
                    },
                }
            },
            'user[city]': {
                message: 'The city field is not valid',
                validators: {
                    notEmpty: {
                        message: 'The city is required'
                    },  
                    stringLength:{
                      min: 2,
                      message: "Valid city is required"
                    }
                }
            },
            'user[zip]': {
                message: 'The zip code field is not valid',
                validators: {
                    notEmpty: {
                        message: 'The zip code cannot be empty'
                    },
                    stringLength: {
                        min: 5,
                        max: 5,
                        message: ' valid zip required'
                    },
                }
            },
            'user[state]': {
                message: 'The state field is not valid',
                validators: {
                    notEmpty: {
                        message: '* state required.'
                    },
                    stringLength: {
                      min:2,
                      message: "Valid state required"
                    }
                }
            },
            'user[phone_number]': {
                message: 'The address field is not valid',
                validators: {
                    notEmpty: {
                        message: 'The phone number is required'
                    },
                    stringLength: {
                        min: 10,
                        message: 'The address must be a real phone number'
                    },
                }
            },
            'user[password_confirmation]': {
                message: 'The password_confirmation field is not valid',
                validators: {
                  identical: {
                      field: 'user[password]',
                      message: 'The password confirmation must match the password'
                  },
                  stringLength: {
                    min: 8,
                    message: 'The password must have at least 8 characters'
                  }
               }
            }
        }
    })
    .on('success.form.bv', function(e) {
        $('#errors').html('');
        console.log("EVERYTHING WORKS");
    })
    .on('error.form.bv', function() {
      console.log("EVERYTHING WORKS");
    });
});







// /////////////////////////////////////////////////////////////
// // Prevent "enter" button submission
// /////////////////////////////////////////////////////////////
// $(document).ready(function() {
//   $(".quantity-field").keydown(function(event){
//     if(event.keyCode == 13) {
//       event.preventDefault();
//       console.log("QUANTITY CHANGED");
//       var field = $(this);
//       var id = field.attr("id");
//       var idRoot = id.substr(4);
//       console.log("#num-"+idRoot+" span");
//       var orderEntrySpan = $('#num-'+idRoot+ " span");
//       refreshOrder(field.val(), orderEntrySpan);
//     }
//   });
//   $(window).resize(function(){

//   });
// });


// /////////////////////////////////////////////////////////////
// // Makes sure that div sizes are the same height
// /////////////////////////////////////////////////////////////
// function sizeEntriesTheSame(divName){
//   var maxHeight = 0;
//   var entries = $("." + divName);
//   entries.each(function(){
//     var thisHeight = $(this).height();
//     if (thisHeight > maxHeight){
//       maxHeight = thisHeight;
//     } 
//   });
//   entries.css("height", maxHeight);
//   console.log("reset size");
// }


// /////////////////////////////////////////////////////////////
// // Increment Text Field
// /////////////////////////////////////////////////////////////
// $(".btn-inc").click(function(){
//   console.log("button clicked");
//   var id = $(this).attr('id');

//   // update text field - incrememnt by one
//   var field = $("#txt-"+id);
//   var val = $(field).val();
//   val = +val + 1;
//   $(field).val(val);

//   // update subtotal text
//   var orderEntrySpan = $('#num-'+id+" span");
//   console.log("#num-"+id+" span");
//   refreshOrder(val, orderEntrySpan);
// });


// /////////////////////////////////////////////////////////////
// // Changes quantity, updates field when text manually changed
// /////////////////////////////////////////////////////////////
// $(".quantity-field").change(function(){
//   console.log("QUANTITY CHANGED");
//   var field = $(this);
//   var id = field.attr("id");
//   var idRoot = id.substr(4);
//   console.log("#num-"+idRoot+" span");
//   var orderEntrySpan = $('#num-'+idRoot+ " span");
//   refreshOrder(field.val(), orderEntrySpan);
// });


// /////////////////////////////////////////////////////////////
// // Rewrites values in Order Summary Field
// /////////////////////////////////////////////////////////////
// function refreshOrder(val, orderEntrySpan){
//   console.log("REFERESHING ORDER FOR" + orderEntrySpan);
//   orderEntrySpan.html(parseInt(val));
//   var orderEntry = orderEntrySpan.parent();
  
//   if (val == 0) orderEntry.addClass('hidden');
//   else orderEntry.removeClass('hidden');
  
//   updatePackingItemsTotal();
//   updatePickupTotal();
// }


// /////////////////////////////////////////////////////////////
// // Overwrites subtotal for packing Items
// /////////////////////////////////////////////////////////////
// function updatePackingItemsTotal(){

//   // Number of Boxes
//   var numStdBox = $('#txt-stdbox').val();
//   var numWarBox = $('#txt-warbox').val();
//   var numBubble = $('#txt-bubble').val();
//   var numFileBox = $('#txt-filebox').val();
//   var numTube = $('#txt-tube').val();

//   // Pricing Per Box
//   var STDBOX_PRICE =  6.50;
//   var WARDROBE_BOX_PRICE =  12.00;
//   var BUBBLE_WRAP_PRICE =  4.50;
//   var FILE_BOX_PRICE =  9.50;
//   var POSTER_TUBE_PRICE =  10.00;


//   var total = (numStdBox * STDBOX_PRICE) + (numWarBox * WARDROBE_BOX_PRICE) + (numBubble * BUBBLE_WRAP_PRICE) + (numFileBox * FILE_BOX_PRICE) + (numTube * POSTER_TUBE_PRICE);
//   console.log("total:" + total);
//   $('#order-subtotal').text("$" + total+"/m");
//   if (total < 1) $("#delivery-time").hide();

// }


// /////////////////////////////////////////////////////////////
// // Overwrites subtotal for packing Items
// /////////////////////////////////////////////////////////////
// function updatePickupTotal(){
//   // Number of Boxes
//   var numBox = $('#txt-box').val();
//   var numMedium = $('#txt-medium').val();
//   var numLarge = $('#txt-large').val();
//   var numXLarge = $('#txt-extra_large').val();

//   // Pricing Per Box
//   var BOX_PRICE =  5.00;
//   var MEDIUM_PRICE =  12.00;
//   var LARGE_PRICE =  20.00;
//   var XLARGE_PRICE =  40.00;


//   var total = (numBox * BOX_PRICE) + (numMedium * MEDIUM_PRICE) + (numLarge * LARGE_PRICE) + (numXLarge * XLARGE_PRICE);
//   console.log("total:" + total);
//   $('#pickup-subtotal').text("$" + total+"/m");
//   if (total < 1) $("#pickup-time").hide();
// }


// /////////////////////////////////////////////////////////////
// // Segues between on-screen, hidden "pages"
// /////////////////////////////////////////////////////////////
// function moveFromTo(fromDiv, toDiv){
//   $(fromDiv).toggleClass("hidden");
//   $(toDiv).toggleClass("hidden");
//   window.scrollTo(0,0);
// }


// /////////////////////////////////////////////////////////////
// // Signup Button Flow - Forward
// /////////////////////////////////////////////////////////////
// $("#signup-first-btn").click(function(){
//   $("#lets-doit").parent().hide();
//   moveFromTo("#signup-first", "#signup-second");
// })

// $("#signup-second-btn").click(function(e){
//   e.preventDefault();
//   moveFromTo("#signup-second", "#signup-third");
// })

// $("#signup-third-btn").click(function(e){
//   e.preventDefault();
//   moveFromTo("#signup-third", "#signup-fourth");
// })

// $("#signup-fourth-btn").click(function(e){
//   e.preventDefault();
//   moveFromTo("#signup-fourth", "#signup-fifth");
// })


// /////////////////////////////////////////////////////////////
// // Back Buttons
// /////////////////////////////////////////////////////////////

// $("#signup-second-back").click(function(){
//   $("#lets-doit").parent().show();
//   moveFromTo("#signup-second", "#signup-first");
// })

// $("#signup-third-back").click(function(){
//   moveFromTo("#signup-third", "#signup-second");
// })

// $("#signup-fourth-back").click(function(e){
//   e.preventDefault();
//   moveFromTo("#signup-fourth", "#signup-third");
// })

// $("#signup-fourth-back").click(function(){
//   moveFromTo("#signup-fifth", "#signup-fourth");
// })


// /////////////////////////////////////////////////////////////
// // Validations
// /////////////////////////////////////////////////////////////
// $(document).ready(function() {
//     $('#signup-form').bootstrapValidator({
//         // To use feedback icons, ensure that you use Bootstrap v3.1.0 or later
//         feedbackIcons: {
//             valid: 'glyphicon glyphicon-ok',
//             invalid: 'glyphicon glyphicon-remove',
//             validating: 'glyphicon glyphicon-refresh'
//         },
//         fields: {
//             'user[address_line_1]': {
//                 message: 'The address field is not valid',
//                 validators: {
//                     notEmpty: {
//                         message: 'The address is required and cannot be empty'
//                     },
//                     stringLength: {
//                         min: 10,
//                         message: 'The address must be a real address'
//                     },
//                 }
//             },
//             email: {
//                 validators: {
//                     notEmpty: {
//                         message: 'The email address is required and cannot be empty'
//                     },
//                     emailAddress: {
//                         message: 'The email address is not a valid'
//                     }
//                 }
//             },
//             password: {
//                 validators: {
//                     notEmpty: {
//                         message: 'The password is required and cannot be empty'
//                     },
//                     different: {
//                         field: 'username',
//                         message: 'The password cannot be the same as username'
//                     },
//                     stringLength: {
//                         min: 8,
//                         message: 'The password must have at least 8 characters'
//                     }
//                 }
//             },
//             birthday: {
//                 validators: {
//                     notEmpty: {
//                         message: 'The date of birth is required'
//                     },
//                     date: {
//                         format: 'YYYY/MM/DD',
//                         message: 'The date of birth is not valid'
//                     }
//                 }
//             },
//             gender: {
//                 validators: {
//                     notEmpty: {
//                         message: 'The gender is required'
//                     }
//                 }
//             }
//         }
//     });
// });
