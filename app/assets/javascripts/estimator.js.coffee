DiscountSlider = (update_slider) ->
  current_value = 0
  possible_values = [['1 - 2 months', 1], ['3 - 5 months', 3], ['6 - 9 months', 6], ['10 - 12 months', 10], ['13 - 18 months', 13], ['19 - 24 months', 19], ['25 or more months', 25]]
  min_value = 0
  max_value = possible_values.length - 1
  inc: ->
    if current_value < max_value
      current_value += 1
      update_slider(this)
  dec: ->
    if current_value > min_value
      current_value -= 1
      update_slider(this)
  duration: ->
    possible_values[current_value][1]
  duration_string: ->
    possible_values[current_value][0]

est_extract_base_price_and_volume_discount = ->
	small_item_quantity = parseInt($('#pickup_request_small_item_quantity').val(), 10) || 0
	medium_item_quantity = parseInt($('#pickup_request_medium_item_quantity').val(), 10) || 0
	large_item_quantity = parseInt($('#pickup_request_large_item_quantity').val(), 10) || 0
	extra_large_item_quantity = parseInt($('#pickup_request_extra_large_item_quantity').val(), 10) || 0

	base_price = small_item_quantity * small_item_base_price + medium_item_quantity * medium_item_base_price + large_item_quantity * large_item_base_price + extra_large_item_quantity * extra_large_item_base_price

	volume_discount = 0.0

	for discount_option in volume_discounts
		if base_price < discount_option[0]
			volume_discount = discount_option[1]
			break

	[base_price, volume_discount]

est_calculate_duration_discount = (duration) ->
	duration_discount = 0.0

	for discount_option in duration_discounts
		if duration < discount_option[0]
			duration_discount = discount_option[1]
			break

	duration_discount

est_update_sidebar_fields = (base_price, volume_discount, duration_discount, gross_price, final_price, total_savings) ->
	$('#estimator_base_price').text('$' + base_price.toFixed(2))
	$('#estimator_volume_discount').text((volume_discount * 100.0) + '%')
	$('#estimator_duration_discount').text((duration_discount * 100.0) + '%')
	$('#estimator_gross_price').text('$' + gross_price.toFixed(2))
	$('#estimator_final_price').text('$' + final_price.toFixed(2))
	$('#estimator_total_savings').text('$' + total_savings.toFixed(2))

est_update_slider = (slider) ->
	$('#pickup_request_duration_value').text(slider.duration_string())
	$('#pickup_request_duration').val(slider.duration()).change()

est_recalculate = ->
	base_price_and_volume_discount = est_extract_base_price_and_volume_discount()
	
	base_price = base_price_and_volume_discount[0]
	volume_discount = base_price_and_volume_discount[1]
	duration = parseInt($('#pickup_request_duration').val(), 10) || 0
	duration_discount = est_calculate_duration_discount(duration)
	gross_price = base_price * (1.0 - volume_discount) * (1.0 - duration_discount)
	final_price = gross_price * (1.0 - always_discount)
	total_savings = base_price - final_price

	est_update_sidebar_fields(base_price, volume_discount, duration_discount, gross_price, final_price, total_savings)

est_initialize_estimator = (slider) ->
	$('form').bind('keyup change', ->
		est_recalculate()
	)
	$('#pickup_request_duration_minus').click ->
		slider.dec()
		false
	$('#pickup_request_duration_plus').click ->
		slider.inc()
		false

est_fix_pricing_boxes_height = ->
	highest_height = Math.max.apply(null, $('.pricing-info').map(->
		return $(this).height()
	).get())
	$('.pricing-info').height(highest_height)

$ ->
	slider = DiscountSlider(est_update_slider)
	est_initialize_estimator(slider)
	estimator_page = $('#estimator-page')
	est_fix_pricing_boxes_height() unless estimator_page.hasClass('hidden')
	$('#estimate-now').click ->
		estimator_page.removeClass('hidden')
		est_fix_pricing_boxes_height()
