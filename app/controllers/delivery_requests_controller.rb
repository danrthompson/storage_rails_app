class DeliveryRequestsController < ApplicationController
	before_action :verify_user_is_ready!

	def new
		@delivery_request = DeliveryRequest.new
		item_ids = params[:ids].split(',').map { |x| x.to_i }
		@requested_boxes = StorageItem.where(user: current_user, id: item_ids)
		@user = current_user
	end

	def create
		@user = current_user
		@delivery_request = DeliveryRequest.new(create_delivery_request_params(params))
		@delivery_request.user = @user
		@user.update(user_address_params(params))
		if @delivery_request.valid? and @user.valid? then
			@delivery_request.save!
			redirect_to @delivery_request and return
		else
			render action: :new and return
		end
	end

	def show
		@user = current_user
		@delivery_request = DeliveryRequest.find(params[:id])
	end
end