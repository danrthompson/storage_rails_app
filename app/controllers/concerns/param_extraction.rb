module ParamExtraction
	extend ActiveSupport::Concern

	private

	def user_cc_params(params)
		params.require(:user).permit(:cc_number, :cc_name, :exp_month, :exp_year)
	end

	def user_address_params(params)
		params.require(:user).permit(:email, :address_line_1, :address_line_2, :city, :state, :zip, :special_instructions, :phone_number, :password, :password_confirmation)
	end

	def create_packing_supplies_request_params(params)
		params.require(:packing_supplies_request).permit(:box_quantity, :wardrobe_box_quantity, :bubble_quantity, :tape_quantity, :posted_delivery_time, :posted_delivery_date)
	end

	def create_pickup_request_params(params)
		params.require(:pickup_request).permit(:small_item_quantity, :medium_item_quantity, :large_item_quantity, :extra_large_item_quantity, :posted_delivery_time, :posted_delivery_date)
	end

	def create_delivery_request_params(params)
		params.require(:delivery_request).permit(:posted_delivery_time, :posted_delivery_date)
	end

	def update_storage_item_params(params)
		params.require(:storage_item).permit(:title, :description, :image)
	end
end