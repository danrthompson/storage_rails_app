class PickupRequestsController < ApplicationController
	before_action :verify_user_is_ready!

	def new
		@pickup_request = PickupRequest.new
		@num_boxes = params[:num_boxes].to_i
		@user = current_user
	end

	def create
		render text: params and return
	end

	def show
		@user = current_user
		@pickup_request = PickupRequest.find(params[:id])
	end
end