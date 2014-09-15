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
		redirect_to @storage_item
	end

	def show
		redirect_to :storage_items and return
	end

	def index
		@user = current_user

		# Items At Home
		@items_at_home = StorageItem.where(user_id: current_user.id, entered_storage_at: nil).count
		@boxes_at_home = StorageItem.where(user_id: current_user.id, item_type: 'box', entered_storage_at: nil)
		@medium_items_at_home = StorageItem.where(user_id: current_user.id, item_type: 'medium', entered_storage_at: nil)
		@large_items_at_home = StorageItem.where(user_id: current_user.id, item_type: 'large', entered_storage_at: nil)
		@extra_large_items_at_home = StorageItem.where(user_id: current_user.id, item_type: 'extra_large', entered_storage_at: nil)

		# Items in Storage
		@storage_items = StorageItem.where(user_id: current_user.id, left_storage_at: nil, delivery_request_id: nil).where.not(entered_storage_at: nil).order(:item_type, :entered_storage_at)
		@num_storage_items = @storage_items.count
		@num_boxes_in_storage = StorageItem.where(user_id: current_user.id, item_type: 'box').where.not(entered_storage_at: nil).count
		@num_medium_items_in_storage = StorageItem.where(user_id: current_user.id, item_type: 'medium').where.not(entered_storage_at: nil).count
		@num_large_items_in_storage = StorageItem.where(user_id: current_user.id, item_type: 'large').where.not(entered_storage_at: nil).count
		@num_extra_large_items_in_storage = StorageItem.where(user_id: current_user.id, item_type: 'extra_large').where.not(entered_storage_at: nil).count
		
		@storage_items_pending_delivery = StorageItem.where(user_id: current_user.id, left_storage_at: nil).where.not(delivery_request_id: nil, entered_storage_at: nil).order(:item_type, :entered_storage_at)
	end


end