class PickupRequest < Request
	attr_accessor :duration
	attr_reader :small_item_quantity, :medium_item_quantity, :large_item_quantity, :extra_large_item_quantity

	has_many :storage_items
	has_paper_trail
	accepts_nested_attributes_for :storage_items, allow_destroy: true

	after_initialize :make_quantities_zero_not_nil
	after_create :create_associated_storage_items, :send_confirmation_email, :send_text_to_confirm_delivery_time

	validates :proposed_date, :proposed_times, presence: true, unless: :delivery_time?
	validates :box_quantity, :bubble_quantity, :tape_quantity, :wardrobe_box_quantity, absence: true
	validate :no_other_pickups?

	def send_confirmation_email
		if Rails.env.production?
			unless self.skip_confirm_request_email == true or self.skip_confirm_request_email == '1'
				$customerio.track(
					self.user_id,
					"pickup_created",
					delivery_time_string: self.best_delivery_time.strftime("%B %d"),
					delivery_time: self.best_delivery_time.to_i
				)
			end
			if self.user.tire_customer and self.tire_request != true and self.tire_request != '1'
				$customerio.track(
					self.user_id,
					"real_pickup_created",
					delivery_time_string: self.best_delivery_time.strftime("%B %d"),
					delivery_time: self.best_delivery_time.to_i
				)
			end
		end
	end

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

	def skip_delivery_validation?
		if self.skip_delivery_validation == true or self.skip_delivery_validation == '1'
			true
		else
			false
		end
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

	# implement better transaction support
	def complete(current_user)
		pickup_completion_time = Time.zone.now

		self.skip_delivery_validation = true
		self.completion_time = pickup_completion_time
		self.driver = current_user
		self.storage_items.each do |item|
			item.entered_storage_at = pickup_completion_time
			item.save
			unless item.valid?
				return item.errors.full_messages.first
			end
		end

		self.user.update_subscription_price(true)

		unless self.one_time_payment.blank? or self.one_time_payment == 0
			Stripe::Charge.create(amount: (self.one_time_payment * 100).to_i, currency: 'usd', customer: self.user.stripe_user.id, description: "One time payment for items picked up on #{Time.zone.now.strftime('%m/%d')}", statement_description: "PICKUP PAYMENT")
		end
		self.save
		nil
	end

	rails_admin do
		edit do
			include_all_fields
			field :skip_delivery_validation, :boolean
			field :skip_confirm_request_email, :boolean
			field :small_item_quantity, :integer
			field :medium_item_quantity, :integer
			field :large_item_quantity, :integer
			field :extra_large_item_quantity, :integer
		end
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
		basic_storage_item_values = {'user_id' => self.user.id, 'pickup_request_id' => self.id, 'planned_duration' => self.duration}

		small_storage_item_values = basic_storage_item_values.clone
		small_storage_item_values['item_type'] = 'small'

		medium_storage_item_values = basic_storage_item_values.clone
		medium_storage_item_values['item_type'] = 'medium'

		large_storage_item_values = basic_storage_item_values.clone
		large_storage_item_values['item_type'] = 'large'

		extra_large_storage_item_values = basic_storage_item_values.clone
		extra_large_storage_item_values['item_type'] = 'extra_large'

		self.small_item_quantity.times { StorageItem.delay.create!(small_storage_item_values) } unless self.small_item_quantity.nil?
		self.medium_item_quantity.times { StorageItem.delay.create!(medium_storage_item_values) } unless self.medium_item_quantity.nil?
		self.large_item_quantity.times { StorageItem.delay.create!(large_storage_item_values) } unless self.large_item_quantity.nil?
		self.extra_large_item_quantity.times { StorageItem.delay.create!(extra_large_storage_item_values) } unless self.extra_large_item_quantity.nil?
	end
end
