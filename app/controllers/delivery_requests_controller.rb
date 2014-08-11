class DeliveryRequestsController < ApplicationController
	before_action :authenticate_user!

	def new
		@delivery_request = DeliveryRequest.new
		# @numboxes = 
	end

	def create
		# render text: params and return
	end
end