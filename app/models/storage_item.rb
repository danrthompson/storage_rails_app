class StorageItem < ActiveRecord::Base
	def self.box_types
		%w(box wardrobe_box)
	end

	def self.item_types
		box_types + %w(couch)
	end

	has_attached_file :image, default_url: 'https://s3.amazonaws.com/storage_rails_app_dev/images/1419618-unicorn2.jpg'
	belongs_to :user
	belongs_to :delivery_request

	validates :entered_storage_at, :user_id, :item_type, presence: true
	validates :item_type, inclusion: { in: self.item_types, message: 'must be a real type.' }
	validates_attachment :image, size: { less_than: 1.megabytes }, content_type: { content_type: /\Aimage\/.*\Z/ }



	def price
		case self.item_type
		when 'box'
			5.0
		when 'couch'
			20.0
		else
			nil
		end
	end

	def delivery_price
		case self.item_type
		when 'box'
			2.00
		when 'couch'
			15.00
		else
			nil
		end
	end




end