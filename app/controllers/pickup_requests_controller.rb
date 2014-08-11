class PickupRequestsController < ApplicationController

	def new
		@pickup_request = PickupRequest.new;
	end

end