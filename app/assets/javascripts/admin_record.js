
$(document).ready(function(){
  $(".form-control").on('input', function(){
    $("#record-complete").attr("disabled", "disabled"); 
  });

  $(".delete_checkbox").change(function(){
    $("#record-complete").attr("disabled", "disabled"); 
  });

  $(".image_uploader").change(function(){
    $("#record-complete").attr("disabled", "disabled"); 
  });


});

$(".details-btn").click(function(){
  var id = $(this).attr("id");
  var details = $("#" + id + "-details");
  console.log(id+"-details");
  if ($(details).hasClass("hidden")) {
    $("#" + id + " h1").html("Hide Details");
    $(details).removeClass("hidden");
  }
  else {
    $("#" + id + " h1").html("View Details");
    $(details).addClass("hidden");
  }
});

$(document).ready(function(){
  $('form').on('click', '.add_fields', function(e){
    var time = new Date().getTime();
    var regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    e.preventDefault();
  });
});