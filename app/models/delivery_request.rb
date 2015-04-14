class DeliveryRequest < Request
	has_many :storage_items
	has_paper_trail
	accepts_nested_attributes_for :storage_items, allow_destroy: true

	after_create :send_confirmation_email, :send_text_to_confirm_delivery_time

	validates :proposed_date, :proposed_times, presence: true, unless: :delivery_time?
	validates :box_quantity, :wardrobe_box_quantity, :bubble_quantity, :tape_quantity, absence: true
	validate :no_other_deliveries?


	def send_confirmation_email
		if Rails.env.production?
			unless self.skip_confirm_request_email == true or self.skip_confirm_request_email == '1'
				$customerio.track(
					self.user_id,
					"delivery_created",
					delivery_time_string: self.best_delivery_time.strftime("%B %d"),
					delivery_time: self.best_delivery_time.at_beginning_of_day.to_i
				)
			end
		end
	end

	def price
		unless self.delivery_fee.blank? or self.delivery_fee < 0
			return self.delivery_fee
		end
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

		unless (not self.delivery_fee.blank? and self.delivery_fee == 0)
			Stripe::Charge.create(amount: (self.price * 100).to_i, currency: 'usd', customer: self.user.stripe_user.id, description: "Quickbox delivery on #{Time.zone.now.strftime('%m/%d')}", statement_description: "DELIVERY FEE")
		end

		self.save
		nil
	end

	rails_admin do
		show do
			field :user
			field :proposed_times
			field :proposed_date
			field :delivery_time
			field :driver_name
			field :driver_notes
			field :user_address
			field :delivery_fee
			field :tire_request
			field :one_time_payment
			field :completion_time
			field :driver
			field :type
			field :storage_items
		end
		edit do
			field :user
			field :proposed_times
			field :proposed_date
			field :delivery_time
			field :driver_name
			field :driver_notes
			field :skip_delivery_validation
			field :skip_confirm_request_email
			field :delivery_fee
			field :tire_request
			field :one_time_payment
			field :completion_time
			field :driver
			field :type
			field :storage_items do
				nested_form false
			end
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
