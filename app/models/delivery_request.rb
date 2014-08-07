class DeliveryRequest < ActiveRecord::Base

	validates :user_id, :delivery_time, presence: true

	has_many :storage_items
	belongs_to :user

end