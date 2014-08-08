class BoxRequest < Request
	validates :box_quantity, numericality: { greater_than: 0, only_integer: true }
	validates :couch_quantity, absence: true
end