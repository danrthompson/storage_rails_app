class DeliveryRequest < Request
	has_many :storage_items

	validates :box_quantity, :wardrobe_box_quantity, :bubble_quantity, :tape_quantity, absence: true

	def price
		return 25.0 if self.storage_items.any? { |item| item.item_type.in? ['large', 'extra_large'] }
		15.0
	end
end