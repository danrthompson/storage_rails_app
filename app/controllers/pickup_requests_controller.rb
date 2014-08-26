class PickupRequestsController < ApplicationController
	before_action :verify_user_is_ready!

	def new
		@pickup_request = PickupRequest.new
		@num_boxes = params[:num_boxes].to_i
		@user = current_user
	end

	def create
		@user = current_user
		@pickup_request = PickupRequest.new(create_pickup_request_params(params))
		@pickup_request.user = @user
		@user.update(user_address_params(params))
		if @pickup_request.valid? and @user.valid? then
			@pickup_request.save!
			redirect_to @pickup_request and return
		else
			render action: :new and return
		end
	end

	def show
		@user = current_user
		@pickup_request = PickupRequest.find(params[:id])
	end
end