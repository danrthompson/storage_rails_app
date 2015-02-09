SMALL_ITEM_BASE_PRICE = 7.0
MEDIUM_ITEM_BASE_PRICE = 15.0
LARGE_ITEM_BASE_PRICE = 30.0
EXTRA_LARGE_ITEM_BASE_PRICE = 50.0
ALWAYS_DISCOUNT = 0.25

est_extract_base_price_and_volume_discount = ->
	small_item_quantity = parseInt($('#estimator_small_items').val(), 10) || 0
	medium_item_quantity = parseInt($('#estimator_medium_items').val(), 10) || 0
	large_item_quantity = parseInt($('#estimator_large_items').val(), 10) || 0
	extra_large_item_quantity = parseInt($('#estimator_extra_large_items').val(), 10) || 0

	base_price = small_item_quantity * SMALL_ITEM_BASE_PRICE + medium_item_quantity * MEDIUM_ITEM_BASE_PRICE + large_item_quantity * LARGE_ITEM_BASE_PRICE + extra_large_item_quantity * EXTRA_LARGE_ITEM_BASE_PRICE
	
	volume_discount = null
	if base_price < 10
		volume_discount = 0.0
	else if base_price < 20
		volume_discount = 0.05
	else if base_price < 40
		volume_discount = 0.1
	else if base_price < 80
		volume_discount = 0.15
	else if base_price < 120
		volume_discount = 0.2
	else if base_price < 160
		volume_discount = 0.25
	else
		volume_discount = 0.3

	[base_price, volume_discount]

est_calculate_duration_discount = (duration) ->
	duration_discount = null
	if duration < 3
		duration_discount = 0.0
	else if duration < 6
		duration_discount = 0.05
	else if duration < 10
		duration_discount = 0.1
	else if duration < 13
		duration_discount = 0.15
	else if duration < 19
		duration_discount = 0.2
	else if duration < 25
		duration_discount = 0.25
	else
		duration_discount = 0.3

	duration_discount

est_update_all_fields = (base_price, volume_discount, duration_discount, gross_price, final_price, total_savings) ->
	$('#estimator_base_price').text('$' + base_price.toFixed(2))
	$('#estimator_volume_discount').text((volume_discount * 100.0) + '%')
	$('#estimator_duration_discount').text((duration_discount * 100.0) + '%')
	$('#estimator_gross_price').text('$' + gross_price.toFixed(2))
	$('#estimator_final_price').text('$' + final_price.toFixed(2))
	$('#estimator_total_savings').text('$' + total_savings.toFixed(2))

est_initialize_estimator = ->
	$('form').bind('keyup change', ->
		base_price_and_volume_discount = est_extract_base_price_and_volume_discount()
		
		base_price = base_price_and_volume_discount[0]
		volume_discount = base_price_and_volume_discount[1]
		duration = parseInt($('#estimator_how_long').val(), 10) || 0
		duration_discount = est_calculate_duration_discount(duration)
		gross_price = base_price * (1.0 - volume_discount) * (1.0 - duration_discount)
		final_price = gross_price * (1.0 - ALWAYS_DISCOUNT)
		total_savings = base_price - final_price

		est_update_all_fields(base_price, volume_discount, duration_discount, gross_price, final_price, total_savings)
	)


$ ->
	est_initialize_estimator()