class DeliveryRequest < Request
	has_many :storage_items
	accepts_nested_attributes_for :storage_items, allow_destroy: true

	before_validation :normalize_delivery_time

	validates :delivery_time, presence: true
	validates :box_quantity, :wardrobe_box_quantity, :bubble_quantity, :tape_quantity, absence: true
	validate :delivery_time_is_available, unless: :skip_delivery_validation?
	validate :no_other_deliveries?

	def price
		sum = 0
		self.storage_items.each do |item|
			sum += item.price
		end
		if sum >= 10 then return sum else return 10 end
	end

	def skip_delivery_validation?
		if self.skip_delivery_validation == true or self.skip_delivery_validation == '1'
			true
		else
			false
		end
	end

	rails_admin do
		edit do
			include_all_fields
			field :skip_delivery_validation, :boolean
		end
	end

	private

	def no_other_deliveries?
		return unless self.user
		if self.user.delivery_requests.where(completion_time: nil).where.not(id: self.id).count > 0
			errors.add(:delivery_time, 'cannot be added while there is a pending delivery.')
			return false
		else
			return true
		end
	end
end