class PickupRequest < Request
	has_many :storage_items

	validates :box_quantity, :bubble_quantity, :tape_quantity, :poster_tube_quantity, :wardrobe_box_quantity, absence: true
end