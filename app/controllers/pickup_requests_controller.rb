class PickupRequestsController < ApplicationController
	include ParamExtraction

	before_action :verify_user_is_ready!

	def new
		@pickup_request = PickupRequest.new
		@user = current_user
	end

	def create
		@user = current_user

		@pickup_request = PickupRequest.new(create_pickup_request_params(params))
		@pickup_request.user = @user

		@user.update(user_address_params(params))
		if @pickup_request.valid? and @user.valid?
			@pickup_request.save!
			redirect_to @pickup_request and return
		else
			render action: :new and return
		end
	end

	def show
		@user = current_user
		@pickup_request = PickupRequest.find(params[:id])
		redirect_to new_user_session_url and return if @user != @pickup_request.user
	end
end