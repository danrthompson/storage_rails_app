class StorageItem < ActiveRecord::Base
	def self.item_types
		{'small' => 5.0, 'medium' => 12.0, 'large' => 25.0, 'extra_large' => 40.0}
	end

	has_attached_file :image
	belongs_to :user
	belongs_to :delivery_request
	belongs_to :pickup_request

	before_create :add_user_item_number

	validates :user_id, :item_type, :pickup_request_id, presence: true
	validates :item_type, inclusion: { in: self.item_types.keys.map { |item| item.to_s }, message: 'must be a real type.' }
	validates_attachment :image, size: { less_than: 1.megabytes }, content_type: { content_type: /\Aimage\/.*\Z/ }

	def price
		StorageItem.item_types[self.item_type]
	end

	def delivery_price
		case self.item_type
		when "box"
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
			box_option = 'https://s3.amazonaws.com/storage_rails_app_dev/images/small-item.png'
			medium_option = 'https://s3.amazonaws.com/storage_rails_app_dev/images/med-item.png'
			large_option = 'https://s3.amazonaws.com/storage_rails_app_dev/images/large-item.png'
			extra_large_option = 'https://s3.amazonaws.com/storage_rails_app_dev/images/xlg-item.png'
			case_statement_item_types(box_option, medium_option, large_option, extra_large_option)
		end
	end

	def get_title
		if self.title.blank?
			box_option = 'Standard Box'
			medium_option = 'Medium Item'
			large_option = 'Large Item'
			extra_large_option = 'XL Item'
			case_statement_item_types(box_option, medium_option, large_option, extra_large_option)
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

	private

	def add_user_item_number
		self.user_item_number = self.user.storage_item_number
		self.user.storage_item_number += 1
		self.user.save
	end

	def case_statement_item_types(box_option, medium_option, large_option, extra_large_option)
		case self.item_type
		when 'box'
			box_option
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