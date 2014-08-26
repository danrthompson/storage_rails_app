class StorageItemsController < ApplicationController
	before_action :verify_user_is_ready!

	def new
		@storage_item = StorageItem.new
	end

	def create
		@storage_item = StorageItem.create storage_params
	end

	def index
		@boxes_at_home = current_user.boxes_at_home
		# @boxes_at_home_array = (0..@boxes_at_home)
		@storage_items = StorageItem.where(user_id: current_user, left_storage_at: nil, delivery_request_id: nil).order(:item_type, :entered_storage_at)
		@num_storage_items = @storage_items.count;
		@storage_items_pending_delivery = StorageItem.where(user_id: current_user, left_storage_at: nil).where.not(delivery_request_id: nil).order(:item_type, :entered_storage_at)
	end

	private

	def storage_params
		params.require(:storage_item).permit(:image)
	end


end