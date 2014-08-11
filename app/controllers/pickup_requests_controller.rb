class PickupRequestsController < ApplicationController

	def new
		@pickup_request = PickupRequest.new;
	end

	def create
		render text: params and return
	end

end