class StaticPagesController < ApplicationController
	before_action :no_user!, only: [:homepage]

	def homepage
		@pickup_request = PickupRequest.new
		@temp_pickup = PickupRequest.new
	end

	def about
		@user = current_user
	end

	def contact
		@user = current_user
	end

	def faq
		@user = current_user
	end

	def feedback
		@user = current_user
	end

	def email_example
		@user = current_user
		
		user_pickup_requests = @user.pickup_requests.where(completion_time: nil)
		user_delivery_requests = @user.delivery_requests.where(completion_time: nil)

		@pickup_request = user_pickup_requests.first
		@delivery_request = user_delivery_requests.first
	end
end