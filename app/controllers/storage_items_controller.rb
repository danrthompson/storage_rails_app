class StorageItemsController < ApplicationController
	before_action authenticate_user!

	def new
		@storage_item = StorageItem.new
	end

	def create
		@storage_item = StorageItem.create storage_params
	end

	def index
		@boxes_at_home = current_user.boxes_at_home
		@storage_items = StorageItem.where(user_id: current_user, left_storage_at: nil, delivery_request_id: nil).order(:item_type, :entered_storage_at)
		@storage_items_pending_delivery = StorageItem.where(user_id: current_user, left_storage_at: nil).where.not(delivery_request_id: nil).order(:item_type, :entered_storage_at)
	end

	private

	def storage_params
		params.require(:storage_item).permit(:image)
	end

end