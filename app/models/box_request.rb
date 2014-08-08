class BoxRequest < ActiveRecord::Base
	include Requestable

	validates :box_quantity, numericality: { greater_than: 0, only_integer: true }
end