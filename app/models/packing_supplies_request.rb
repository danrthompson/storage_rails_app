class PackingSuppliesRequest < Request
	after_initialize :make_quantities_zero_not_nil

	validates :box_quantity, :wardrobe_box_quantity, :bubble_quantity, :tape_quantity, :poster_tube_quantity, numericality: { greater_than_or_equal_to: 0, only_integer: true }
	validate :includes_at_least_one_item

	def self.packing_items
		{bubble: 1.0, tape: 2.0, poster_tube: 3.0, box: 4.0, wardrobe_box: 5.0}
	end

	def self.delivery_price
		5.0
	end

	def price
		total = 0.0
		PackingSuppliesRequest.packing_items.each do |item, price|
			total += self.send("#{item}_quantity") * price
		end
		total + PackingSuppliesRequest.delivery_price
	end

	private

	def includes_at_least_one_item
		unless PackingSuppliesRequest.packing_items.keys.any? { |item| self.send("#{item}_quantity") > 0 }
			errors.add :box_quantity, 'and all other quantities are zero.'
		end
	end

	def make_quantities_zero_not_nil
		PackingSuppliesRequest.packing_items.keys.each { |item| self.send("#{item}_quantity=", 0) if self.send("#{item}_quantity").nil? }
	end
end