class DeliveryRequest < Request
	has_many :storage_items

	before_validation :normalize_delivery_time

	validates :delivery_time, presence: true
	validates :box_quantity, :wardrobe_box_quantity, :bubble_quantity, :tape_quantity, absence: true
	validate :delivery_time_is_available

	def price
		return 25.0 if self.storage_items.any? { |item| item.item_type.in? ['large', 'extra_large'] }
		15.0
	end
end