class PickupRequestsController < ApplicationController
	before_action :authenticate_user!

	def new
		@pickup_request = PickupRequest.new;
	end

	def create
		render text: params and return
	end

end