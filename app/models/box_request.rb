class BoxRequest < Request
	validates :box_quantity, :wardrobe_box_quantity, :bubble_quantity, :file_box_quantity, :poster_tube_quantity, numericality: { greater_than_or_equal_to: 0, only_integer: true }
	validates :couch_quantity, absence: true
	validate :includes_at_least_one_item

	def self.one_time_item_price(item_type)
		case item_type
		when 'bubble'
			4.0
		when 'file_box'
			5.0
		when 'poster_tube'
			6.0
		else
			nil
		end
	end

	def one_time_price
		total = 0.0
		['bubble', 'file_box', 'poster_tube'].each do |item|
			total += self.send("#{item}_quantity") * BoxRequest.one_time_item_price(item)
		end
		total
	end

	def monthly_price
		total = 0.0
		StorageItem.box_types.each do |item|
			total += self.send("#{item}_quantity") * StorageItem.item_price(item)
		end
		total
	end

	protected

	def includes_at_least_one_item
		unless (StorageItem.box_types + @@packing_items).any? { |item_type| self.send("#{item_type}_quantity") > 0 }
			errors.add :box_quantity, 'and all other quantities are zero.'
		end
	end
end