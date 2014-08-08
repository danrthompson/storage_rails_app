class StorageItem < ActiveRecord::Base
	@@item_types = %w(box couch)

	has_attached_file :image, default_url: 'https://s3.amazonaws.com/storage_rails_app_dev/images/1419618-unicorn2.jpg'
	belongs_to :user
	belongs_to :delivery_request

	validates :entered_storage_at, :user_id, :item_type, presence: true
	validates :item_type, inclusion: { in: @@item_types, message: 'must be a real type.' }
	validates_attachment :image, size: { less_than: 1.megabytes }, content_type: { content_type: /\Aimage\/.*\Z/ }

	def self.item_types
		@@item_types
	end

	def price(item_type)
		case item_type
		when 'box'
			5.0
		when 'couch'
			20.0
		else
			nil
		end
	end
end