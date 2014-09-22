class DeliveryRequestsController < ApplicationController
	include ParamExtraction

	before_action :verify_user_is_ready!

	def new
		@delivery_request = DeliveryRequest.new
		@id_string = params[:ids]
		item_ids = @id_string.split(',').map { |x| x.to_i }
		@requested_boxes = StorageItem.where(user_id: current_user.id, id: item_ids)
		@user = current_user
		@storage_items = StorageItem.where(user_id: current_user.id, left_storage_at: nil, delivery_request_id: nil).where.not(entered_storage_at: nil).order(:item_type, :entered_storage_at)
	end

	def create
		@user = current_user
		@user.update(user_address_params(params))

		@delivery_request = DeliveryRequest.new(create_delivery_request_params(params))
		@delivery_request.user_id = @user.id
		item_ids = params[:ids].split(',').map { |x| x.to_i }
		items_to_deliver = StorageItem.where(user_id: current_user.id, id: item_ids, delivery_request_id: nil, left_storage_at: nil).where.not(entered_storage_at: nil)

		if @delivery_request.valid? and @user.valid? and items_to_deliver.count > 0 then
			@delivery_request.save!
			items_to_deliver.update_all(delivery_request_id: @delivery_request.id)
			redirect_to @delivery_request and return
		else
			flash.now[:alert] = 'Sorry, there were some errors that you need to correct.'
			render action: :new and return
		end
	end

	def show
		@user = current_user
		@delivery_request = DeliveryRequest.find(params[:id])
		redirect_to new_user_session_url and return if @user.id != @delivery_request.user_id
	end
end