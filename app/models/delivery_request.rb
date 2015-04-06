class DeliveryRequest < Request
	has_many :storage_items
	has_paper_trail
	accepts_nested_attributes_for :storage_items, allow_destroy: true

	after_create :send_confirmation_email, :send_text_to_confirm_delivery_time

	validates :proposed_date, :proposed_times, presence: true
	validates :box_quantity, :wardrobe_box_quantity, :bubble_quantity, :tape_quantity, absence: true
	validate :no_other_deliveries?


	def send_confirmation_email
		if Rails.env.production?
			unless self.skip_confirm_request_email == true or self.skip_confirm_request_email == '1'
				$customerio.track(
					self.user_id,
					"delivery_created",
					delivery_time_string: self.delivery_time.strftime("%B %d at %l:%M %p"),
					delivery_time: self.delivery_time.to_i
				)
			end
		end
	end

	def price
		sum = 0
		self.storage_items.each do |item|
			sum += item.price
		end
		if sum >= 25 then return sum else return 25 end
	end

	def skip_delivery_validation?
		if self.skip_delivery_validation == true or self.skip_delivery_validation == '1'
			true
		else
			false
		end
	end

	def complete(current_user)
		delivery_completion_time = Time.zone.now

		self.skip_delivery_validation = true
		self.completion_time = delivery_completion_time
		self.driver = current_user
		self.storage_items.each do |item|
			item.left_storage_at = delivery_completion_time
			item.save
			unless item.valid?
				return item.errors.full_messages.first
			end
		end

		self.user.update_subscription_price

		Stripe::Charge.create(amount: (self.price * 100).to_i, currency: 'usd', customer: self.user.stripe_user.id, description: "Quickbox delivery on #{Time.zone.now.strftime('%m/%d')}", statement_description: "DELIVERY FEE")

		self.save
		nil
	end

	rails_admin do
		edit do
			include_all_fields
			field :skip_delivery_validation, :boolean
			field :skip_confirm_request_email, :boolean
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
