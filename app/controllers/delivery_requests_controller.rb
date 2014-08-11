class DeliveryRequestsController < ApplicationController
	before_action :authenticate_user!

	def new
		@delivery_request = DeliveryRequest.new
	end

	def create

	end
end