@set_height_to_highest_height = (parent, selector) ->
	elements = $(parent).find(selector)
	max_height = Math.max.apply(null, elements.map(->
		return $(this).height()
	).get())
	elements.height(max_height)

@fix_pricing_boxes_height = (parent) ->
	set_height_to_highest_height(parent, '.pricing-title')
	set_height_to_highest_height(parent, '.pricing-info')
