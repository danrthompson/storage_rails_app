# scroll_to_element_with_header = (element) ->
#

$ ->
	$('.question').hide()
	$('.question_toggle').click ->
		$(this).siblings().first().slideToggle()
	$('.scroll-to-section').click ->
		$('html, body').animate({scrollTop: $($(this).attr('data_elemid')).offset().top - 80}, 1000)
