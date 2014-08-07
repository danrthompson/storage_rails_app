class StorageItemsController < ApplicationController

	def new
		@storage_item = StorageItem.new
	end

	def create
		@storage_item = StorageItem.create storage_params
	end

	private

	def storage_params
		params.require(:storage_item).permit(:image)
	end

end