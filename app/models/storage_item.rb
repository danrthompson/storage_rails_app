class StorageItem < ActiveRecord::Base
	def self.item_types
		{box: 5.0, medium: 7.5, large: 10.0, extra_large: 20.0}
	end

	has_attached_file :image, default_url: 'https://s3.amazonaws.com/storage_rails_app_dev/images/1419618-unicorn2.jpg'
	belongs_to :user
	belongs_to :delivery_request
	belongs_to :pickup_request

	validates :user_id, :item_type, presence: true
	validates :item_type, inclusion: { in: self.item_types.keys, message: 'must be a real type.' }
	validates_attachment :image, size: { less_than: 1.megabytes }, content_type: { content_type: /\Aimage\/.*\Z/ }

	def price
		StorageItem.item_types[self.item_type]
	end
end