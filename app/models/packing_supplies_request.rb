class PackingSuppliesRequest < Request
	has_paper_trail

	after_initialize :make_quantities_zero_not_nil

	validates :box_quantity, :wardrobe_box_quantity, :bubble_quantity, :tape_quantity, numericality: { greater_than_or_equal_to: 0, only_integer: true }
	validate :is_real?

	def self.packing_items
		{bubble: 6.0, tape: 4.0, box: 2.50, wardrobe_box: 10.0}
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


	def is_real?
		unless PackingSuppliesRequest.packing_items.keys.any? { |item| self.send("#{item}_quantity") > 0 }
			errors.add :box_quantity, 'and all other quantities are zero.'
			return false
		else
			return true
		end
	end

	private

	def make_quantities_zero_not_nil
		PackingSuppliesRequest.packing_items.keys.each { |item| self.send("#{item}_quantity=", 0) if self.send("#{item}_quantity").nil? }
	end
end