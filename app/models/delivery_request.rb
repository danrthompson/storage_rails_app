class DeliveryRequest < ActiveRecord::Base
	include Requestable

	has_many :storage_items
end