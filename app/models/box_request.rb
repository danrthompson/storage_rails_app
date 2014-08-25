class BoxRequest < Request
	validates :box_quantity, :wardrobe_box_quantity, :bubble_quantity, :file_box_quantity, :poster_tube_quantity, numericality: { greater_than_or_equal_to: 0, only_integer: true }
	validates :couch_quantity, absence: true
	validate :includes_at_least_one_item

	protected

	def includes_at_least_one_item
		unless (StorageItem.box_types + @@packing_items).any? { |item_type| self.send("#{item_type}_quantity") > 0 }
			errors.add :box_quantity, 'and all other quantities are zero.'
		end
	end
end