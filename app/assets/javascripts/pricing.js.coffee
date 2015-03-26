$ ->
	parent_selector = '#pricing-section'
	est_fix_pricing_boxes_height(parent_selector)
	$( window ).resize ->
		est_fix_pricing_boxes_height(parent_selector)