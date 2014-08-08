class DeliveryRequest < Request
	has_many :storage_items

	validates :box_quantity, :couch_quantity, absence: true
end