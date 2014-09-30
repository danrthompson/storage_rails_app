class PickupRequestsController < ApplicationController
	include ParamExtraction
	include RequestProcessing

	before_action :verify_user_is_ready!

	def new
		@pickup_request = PickupRequest.new
		@user = current_user
	end

	def edit
		@user = current_user
		@pickup_request = request_update_verification(params, @user)
		return if @pickup_request.nil?
		render action: :new
	end

	def update
		@user = current_user
		@pickup_request = request_by_id!(params, @user)
	end

	def create
		@user = current_user
		@user.update(user_address_params(params))

		@pickup_request = PickupRequest.new(create_pickup_request_params(params))
		@pickup_request.user_id = @user.id
		
		if @pickup_request.valid? and @user.valid?
			@pickup_request.save!
			redirect_to @pickup_request and return
		else
			flash.now[:alert] = 'Sorry, there were some errors that you need to correct.'
			render action: :new and return
		end
	end

	def show
		@user = current_user
		@pickup_request = PickupRequest.find(params[:id])
		redirect_to new_user_session_url and return if @user.id != @pickup_request.user_id
	end

	private

	def request_update_verification(params, user)
		pickup_request = request_by_id!(params, user)
		return nil if pickup_request.nil?
		return nil if redirect_if_complete!(pickup_request)
		return nil if redirect_if_too_late!(pickup_request)
		return pickup_request
	end
end