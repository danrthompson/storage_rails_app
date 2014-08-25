class DeliveryRequest < Request
	has_many :storage_items

	validates :box_quantity, :wardrobe_box_quantity, :bubble_quantity, :file_box_quantity, :poster_tube_quantity, :couch_quantity, absence: true
	
end