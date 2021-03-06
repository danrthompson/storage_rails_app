class StorageItem < ActiveRecord::Base
	@item_not_delivered = false

	def self.always_discount
		0.15
	end

	def self.item_types
		{'small' => 7.0, 'medium' => 15.0, 'large' => 30.0, 'extra_large' => 50.0}
	end

	def self.volume_discounts
		[
			[10, 0.0],
			[85, 0.0],
			[100, 0.1],
			[180, 0.15],
			[225, 0.20],
			[350, 0.25],
			[500 , 0.3]
		]
	end

	def self.duration_discounts
		[
			[3, 0.0],
			[6, 0.00],
			[10, 0.10],
			[13, 0.15],
			[19, 0.2],
			[25, 0.25],
			[1000000, 0.3]
		]
	end

	def self.calculate_duration_discount(duration)
		self.duration_discounts.each do |discount_group|
			return discount_group[1] if duration < discount_group[0]
		end
	end

	def self.calculate_volume_discount(base_price)
		self.volume_discounts.each do |discount_group|
		  return discount_group[1] if base_price < discount_group[0]
		end
	end

	has_attached_file :image
	has_paper_trail
	belongs_to :user
	belongs_to :driver, class_name: 'User'
	belongs_to :delivery_request
	belongs_to :pickup_request

	before_create :add_user_item_number

	validates :user_id, :item_type, :pickup_request_id, presence: true
	validates :item_type, inclusion: { in: self.item_types.keys.map { |item| item.to_s }, message: 'must be a real type.' }
	validates_attachment :image, size: { less_than: 10.megabytes }, content_type: { content_type: /\Aimage\/.*\Z/ }
	validate :if_entered_storage_then_must_have_title_and_image

	before_save :remove_delivery_request_if_item_not_delivered

	def item_not_delivered=(item_not_delivered)
		attribute_will_change!(:item_not_delivered)
		@item_not_delivered = if item_not_delivered and item_not_delivered.to_i == 1 then true else false end
	end

	def item_not_delivered
		if @item_not_delivered then @item_not_delivered else false end
	end

	def price
		StorageItem.item_types[self.item_type]
	end

	def discounted_price
		discount = self.discount.to_f
		if discount and discount > 0
			self.price*((100.0 - discount) / 100.0)
		else
			self.price
		end
	end

	def correct_low_duration_discount(new_discount, old_discount, months)
		discount_diff = new_discount - old_discount
		amount_to_credit = self.discounted_price * months * discount_diff * 100.0 * -1.0

		Stripe::InvoiceItem.create(
			customer: self.user.stripe_user.id,
			amount: amount_to_credit.to_i,
			currency: "usd",
			description: "One-time setup fee"
		)
	end

	def calculate_duration_discount
		return nil if (not self.entered_storage_at) or self.left_storage_at

		planned_duration_discount = StorageItem.calculate_duration_discount(self.planned_duration)

		now = Time.zone.now
		entered = self.entered_storage_at
		months_since_entered_storage = (now.year - entered.year) * 12 + now.month - entered.month - (now.day >= entered.day ? 0 : 1)
		current_duration_discount = StorageItem.calculate_duration_discount(months_since_entered_storage)

		if current_duration_discount <= planned_duration_discount
			planned_duration_discount
		else
			correct_low_duration_discount(current_duration_discount, planned_duration_discount, months_since_entered_storage)
			self.planned_duration = months_since_entered_storage
			self.save
			current_duration_discount
		end
	end

	def delivery_price
		case self.item_type
		when "small"
		  return 5
		when "medium"
		  return 12
		when "large"
		  return 20
		when "extra_large"
		  return 40
		else
		  return "ERROR"
		end
	end

	def image_url
		if self.image?
			self.image.url
		else
			small_option = 'https://s3.amazonaws.com/storage_rails_app_dev/images/small-item.png'
			medium_option = 'https://s3.amazonaws.com/storage_rails_app_dev/images/med-item.png'
			large_option = 'https://s3.amazonaws.com/storage_rails_app_dev/images/large-item.png'
			extra_large_option = 'https://s3.amazonaws.com/storage_rails_app_dev/images/xlg-item.png'
			case_statement_item_types(small_option, medium_option, large_option, extra_large_option)
		end
	end

	def get_title
		if self.title.blank?
			small_option = 'Standard Box'
			medium_option = 'Medium Item'
			large_option = 'Large Item'
			extra_large_option = 'XL Item'
			case_statement_item_types(small_option, medium_option, large_option, extra_large_option)
		else
			self.title
		end
	end

	def get_description
		if self.description.blank?
			'Click "edit" to give this item a description'
		else
			self.description
		end
	end

	def rails_admin_label
		"ID: #{self.id} | USER: #{self.user.name} | TITLE: #{self.title}"
	end

	rails_admin do
		object_label_method do
			:rails_admin_label
		end
		list do
			field :id
			field :user
			field :item_type
			field :created_at
			field :updated_at
			field :image, :string do
				formatted_value do
					bindings[:view].tag(:img, {src: bindings[:object].image_url, style: 'max-height: 100px;'})
				end
			end
		end
		show do
			field :id
			field :user
			field :item_type
			field :image, :string do
				formatted_value do
					bindings[:view].tag(:img, {src: bindings[:object].image_url, style: 'max-height: 500px;'})
				end
			end
			field :title
			field :description
			field :entered_storage_at
			field :left_storage_at
			field :delivery_request
			field :pickup_request
			field :user_item_number
			field :notes
			field :storage_location
			field :discount
			field :driver
			field :planned_duration
		end
	end

	private

	def if_entered_storage_then_must_have_title_and_image
		unless self.entered_storage_at.blank?
			errors.add :title, 'must not be blank.' if self.title.blank?
			errors.add :image, 'must be present.' unless self.image?
		end
	end

	def remove_delivery_request_if_item_not_delivered
		if self.item_not_delivered == true
			self.delivery_request = nil
		end
	end

	def add_user_item_number
		User.transaction do
			user = User.lock.find(self.user_id)
			self.user_item_number = user.storage_item_number
			user.storage_item_number += 1
			user.save
		end
	end

	def case_statement_item_types(small_option, medium_option, large_option, extra_large_option)
		case self.item_type
		when 'small'
			small_option
		when 'medium'
			medium_option
		when 'large'
			large_option
		when 'extra_large'
			extra_large_option
		else
			nil
		end
	end
end
