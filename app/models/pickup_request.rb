class PickupRequest < Request
	attr_reader :small_item_quantity, :medium_item_quantity, :large_item_quantity, :extra_large_item_quantity

	has_many :storage_items

	before_validation :normalize_delivery_time
	after_create :create_associated_storage_items

	validates :delivery_time, presence: true
	validates :box_quantity, :bubble_quantity, :tape_quantity, :wardrobe_box_quantity, absence: true
	validate :delivery_time_is_available

	def small_item_quantity=(small_item_quantity)
		@small_item_quantity = small_item_quantity.to_i
	end

	def medium_item_quantity=(medium_item_quantity)
		@medium_item_quantity = medium_item_quantity.to_i
	end

	def large_item_quantity=(large_item_quantity)
		@large_item_quantity = large_item_quantity.to_i
	end

	def extra_large_item_quantity=(extra_large_item_quantity)
		@extra_large_item_quantity = extra_large_item_quantity.to_i
	end

	private

	def create_associated_storage_items
		basic_storage_item_values = {user: self.user, pickup_request: self}

		small_storage_item_values = basic_storage_item_values.clone
		small_storage_item_values[:item_type] = 'box'

		medium_storage_item_values = basic_storage_item_values.clone
		medium_storage_item_values[:item_type] = 'medium'

		large_storage_item_values = basic_storage_item_values.clone
		large_storage_item_values[:item_type] = 'large'

		extra_large_storage_item_values = basic_storage_item_values.clone
		extra_large_storage_item_values[:item_type] = 'extra_large'

		self.small_item_quantity.times { StorageItem.create!(small_storage_item_values) } unless self.small_item_quantity.nil?
		self.medium_item_quantity.times { StorageItem.create!(medium_storage_item_values) } unless self.medium_item_quantity.nil?
		self.large_item_quantity.times { StorageItem.create!(large_storage_item_values) } unless self.large_item_quantity.nil?
		self.extra_large_item_quantity.times { StorageItem.create!(extra_large_storage_item_values) } unless self.extra_large_item_quantity.nil?
	end
end