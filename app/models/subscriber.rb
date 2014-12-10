class Subscriber < ActiveRecord::Base
	validates :email, :zip, presence: true
	validates :email, uniqueness: true
	validates :zip, numericality: {only_integer: true, greater_than_or_equal_to: 10000, less_than_or_equal_to: 99999}
end
