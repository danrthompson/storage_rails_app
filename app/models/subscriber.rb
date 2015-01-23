class Subscriber < ActiveRecord::Base
	has_paper_trail
	
	validates :email, presence: true
	validates :email, uniqueness: true
	validates :zip, numericality: {only_integer: true, greater_than_or_equal_to: 10000, less_than_or_equal_to: 99999}, allow_blank: true

	after_commit :identify_customerio

	def identify_customerio
		$customerio.identify(
			id: self.id + 100000,
			email: self.email,
			zip: self.zip,
			newsletter_subscriber: true,
			created_at: self.created_at.to_i,
			converted_to_regular_user: User.where(email: self.email).exists?,
		)
	end
end
