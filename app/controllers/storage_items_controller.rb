class StorageItemsController < ApplicationController
	include ParamExtraction

	before_action :verify_user_is_ready!

	def edit
		@storage_item = StorageItem.find(params[:id])
		redirect_to new_user_session_url and return unless @storage_item.user_id == current_user.id
		@user = current_user
	end

	def update
		@storage_item = StorageItem.find(params[:id])
		redirect_to new_user_session_url and return unless @storage_item.user_id == current_user.id
		@storage_item.update(update_storage_item_params(params))
		redirect_to storage_items_url
	end

	def index
		@user = current_user

		@has_existing_pickup = (@user.pickup_requests.where(completion_time: nil).count > 0)
		@existing_pickup = @user.pickup_requests.where(completion_time: nil)
		@has_existing_delivery = (@user.delivery_requests.where(completion_time: nil).count > 0)
		@existing_delivery = (@user.delivery_requests.where(completion_time: nil))

		# Items At Home
		@items_at_home = StorageItem.where(user_id: current_user.id, entered_storage_at: nil).count
		@boxes_at_home = StorageItem.where(user_id: current_user.id, item_type: 'small', entered_storage_at: nil)
		@medium_items_at_home = StorageItem.where(user_id: current_user.id, item_type: 'medium', entered_storage_at: nil)
		@large_items_at_home = StorageItem.where(user_id: current_user.id, item_type: 'large', entered_storage_at: nil)
		@extra_large_items_at_home = StorageItem.where(user_id: current_user.id, item_type: 'extra_large', entered_storage_at: nil)

		# Items in Storage
		@storage_items = StorageItem.where(user_id: current_user.id, left_storage_at: nil, delivery_request_id: nil).where.not(entered_storage_at: nil).order(:item_type, :entered_storage_at)
		@num_storage_items = @storage_items.count
		@num_boxes_in_storage = StorageItem.where(user_id: current_user.id, item_type: 'small').where.not(entered_storage_at: nil).count
		@num_medium_items_in_storage = StorageItem.where(user_id: current_user.id, item_type: 'medium').where.not(entered_storage_at: nil).count
		@num_large_items_in_storage = StorageItem.where(user_id: current_user.id, item_type: 'large').where.not(entered_storage_at: nil).count
		@num_extra_large_items_in_storage = StorageItem.where(user_id: current_user.id, item_type: 'extra_large').where.not(entered_storage_at: nil).count
		
		@storage_items_pending_delivery = StorageItem.where(user_id: current_user.id, left_storage_at: nil).where.not(delivery_request_id: nil, entered_storage_at: nil).order(:item_type, :entered_storage_at)
	end


end