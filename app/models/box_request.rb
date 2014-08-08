class BoxRequest < ActiveRecord::Base

	validates :user_id, :delivery_time, presence: true
	validates :box_quantity, numericality: { greater_than: 0, only_integer: true }

	belongs_to :user
	belongs_to :driver, class_name: 'User'

end