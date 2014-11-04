class DeliveryRequestsController < ApplicationController
	include ParamExtraction
	include RequestProcessing

	before_action :verify_user_is_ready!

	def new
		@edit_page = false
		@delivery_request = DeliveryRequest.new
		@user = current_user
		@storage_items = StorageItem.where(user_id: current_user.id, left_storage_at: nil, delivery_request_id: nil).where.not(entered_storage_at: nil).order(:item_type, :entered_storage_at)
	end

	def edit
		@edit_page = true
		@user = current_user
		@delivery_request = request_update_verification(params, @user)
		@storage_items = StorageItem.where(user_id: current_user.id, left_storage_at: nil).where.not(entered_storage_at: nil).order(:item_type, :entered_storage_at)
		# @orginally_selected_item_ids = @delivery_request.storage_items.map {|item| item.id}
		return if @delivery_request.nil?
		render action: :new
	end

	def update
		@user = current_user
		@user.update(user_address_params(params))

		# Added this line bc was getting an error on post.
		@storage_items = StorageItem.where(user_id: current_user.id, left_storage_at: nil).where.not(entered_storage_at: nil).order(:item_type, :entered_storage_at)
		@delivery_request = request_update_verification(params, @user)
		return if @delivery_request.nil?
		@delivery_request.update(create_delivery_request_params(params))

		item_ids = params[:storage_item_entries][:storage_item_ids].split(',').map { |x| x.to_i }
		items_to_deliver = StorageItem.where(user_id: current_user.id, id: item_ids, left_storage_at: nil).where.not(entered_storage_at: nil)

		if @delivery_request.valid? and @user.valid? and items_to_deliver.count > 0 then
			@delivery_request.storage_items.delete_all
			items_to_deliver.update_all(delivery_request_id: @delivery_request.id)
			redirect_to @delivery_request and return
		else
			flash.now[:alert] = 'Sorry, there were some errors that you need to correct.'
			render action: :new and return
		end
	end

	def create
		@user = current_user
		@user.update(user_address_params(params))

		@delivery_request = DeliveryRequest.new(create_delivery_request_params(params))
		@delivery_request.user_id = @user.id
		item_ids = params[:storage_item_entries][:storage_item_ids].split(',').map { |x| x.to_i }
		items_to_deliver = StorageItem.where(user_id: current_user.id, id: item_ids, delivery_request_id: nil, left_storage_at: nil).where.not(entered_storage_at: nil)

		if @delivery_request.valid? and @user.valid? and items_to_deliver.count > 0 then
			@delivery_request.save!
			items_to_deliver.update_all(delivery_request_id: @delivery_request.id)
			UserMailer.delay.confirm_delivery_email(@delivery_request.id)
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
		@is_delivery = true
	end

	def destroy
		@user = current_user
		@delivery_request = DeliveryRequest.find(params[:id])
		redirect_to new_user_session_url and return if @user.id != @delivery_request.user_id
		redirect_to(storage_items_url, alert: 'It is too close to the delivery time to cancel this delivery request.') and return unless @delivery_request.time_to_edit
		@delivery_request.storage_items.clear
		@delivery_request.destroy
		redirect_to storage_items_url, notice: 'Delivery request cancelled.'
	end

	private

	def request_update_verification(params, user)
		delivery_request = request_by_id!(params, user)
		return nil if delivery_request.nil?
		return nil if redirect_if_complete!(delivery_request)
		return nil if redirect_if_too_late!(delivery_request)
		return delivery_request
	end
end