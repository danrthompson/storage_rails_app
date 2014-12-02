class PickupRequest < Request
	attr_reader :small_item_quantity, :medium_item_quantity, :large_item_quantity, :extra_large_item_quantity

	has_many :storage_items
	accepts_nested_attributes_for :storage_items, allow_destroy: true

	after_initialize :make_quantities_zero_not_nil
	before_validation :normalize_delivery_time
	after_create :create_associated_storage_items

	validates :delivery_time, presence: true
	validates :box_quantity, :bubble_quantity, :tape_quantity, :wardrobe_box_quantity, absence: true
	validate :delivery_time_is_available, unless: :skip_delivery_validation
	validate :no_other_pickups?

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

	def is_real?
		unless self.storage_items.count > 0 or self.small_item_quantity > 0 or self.medium_item_quantity > 0 or self.large_item_quantity > 0 or self.extra_large_item_quantity > 0
			errors.add(:small_item_quantity, 'and all other quantities are 0.')
			return false
		else
			return true
		end
	end

	def make_quantities_zero_not_nil
		['small', 'medium', 'large', 'extra_large'].each { |item| self.send("#{item}_item_quantity=", 0) if self.send("#{item}_item_quantity").nil? }
	end

	private

	def no_other_pickups?
		if self.user.pickup_requests.where(completion_time: nil).where.not(id: self.id).count > 0
			errors.add(:delivery_time, 'cannot be added while there is a pending pickup.')
			return false
		else
			return true
		end
	end

	def create_associated_storage_items
		puts "\n\n\n\n\n10"
		basic_storage_item_values = {user: self.user, pickup_request: self}

		small_storage_item_values = basic_storage_item_values.clone
		small_storage_item_values[:item_type] = 'small'

		medium_storage_item_values = basic_storage_item_values.clone
		medium_storage_item_values[:item_type] = 'medium'

		large_storage_item_values = basic_storage_item_values.clone
		large_storage_item_values[:item_type] = 'large'

		extra_large_storage_item_values = basic_storage_item_values.clone
		extra_large_storage_item_values[:item_type] = 'extra_large'
		puts "\n\n\n\n\n11"

		self.small_item_quantity.times { StorageItem.create!(small_storage_item_values) } unless self.small_item_quantity.nil?
		self.medium_item_quantity.times { StorageItem.create!(medium_storage_item_values) } unless self.medium_item_quantity.nil?
		self.large_item_quantity.times { StorageItem.create!(large_storage_item_values) } unless self.large_item_quantity.nil?
		self.extra_large_item_quantity.times { StorageItem.create!(extra_large_storage_item_values) } unless self.extra_large_item_quantity.nil?
		puts "\n\n\n\n\n12"

	end
end