class DeliveryRequestsController < ApplicationController
	before_action :verify_user_is_ready!

	def new
		@delivery_request = DeliveryRequest.new
		item_ids = params[:ids].split(',').map { |x| x.to_i }
		@requested_boxes = StorageItem.where(user: current_user, id: item_ids)
		@user = current_user
		# render text: params and return
	end

	def create
		# render text: params and return
		redirect_to @delivery_request

	end

	def show
		
	end
end