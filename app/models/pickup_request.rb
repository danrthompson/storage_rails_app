class PickupRequest < Request

	validates :box_quantity, :couch_quantity, numericality: { greater_than_or_equal_to: 0, only_integer: true }
	validate :includes_at_least_one_item

	protected

	def includes_at_least_one_item
		unless StorageItem.item_types.any? { |item_type| self.send("#{item_type}_quantity") > 0 }
			errors.add :box_quantity, 'and all other quantities are zero.'
		end
	end



end