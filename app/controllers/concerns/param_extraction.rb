module ParamExtraction
	extend ActiveSupport::Concern

	private

	def sign_in_as_user_params(params)
		params.require(:user).permit(:email)
	end

	def create_subscriber_params(params)
		params.require(:subscriber).permit(:email, :zip)
	end

	def select_items_params(params)
		params.require(:pickup_request).permit(:small_item_quantity, :medium_item_quantity, :large_item_quantity, :extra_large_item_quantity, :duration)
	end

	def fast_signup_params(params)
		params.require(:pickup_request).permit(:posted_delivery_date, :posted_delivery_time)
	end

	def complete_pickup_request_params(params)
		params.require(:pickup_request).permit(:driver_name, :driver_notes, :one_time_payment, storage_items_attributes: [:title, :description, :planned_duration, :image, :item_type, :_destroy, :id, :storage_location, :notes, :user_id, :pickup_request_id, :discount])
	end

	def complete_delivery_request_params(params)
		params.require(:delivery_request).permit(:driver_name, :driver_notes, storage_items_attributes: [:id, :item_not_delivered])
	end

	def create_user_params(params)
		params.require(:user).permit(:email, :password, :name, :phone_number)
	end

	def user_address_params(params)
		params.require(:user).permit(:address_line_1, :address_line_2, :city, :state, :zip, :special_instructions, :phone_number)
	end

	def user_add_payment_no_cc(params)
		params.require(:user).permit(:promo_code, :referrer, :address_line_1, :address_line_2, :city, :state, :zip, :special_instructions, :phone_number, :terms_of_service_accepted)
	end

	def user_just_cc_params(params)
		params.require(:user).permit(:cc_number, :cc_name, :exp_month, :exp_year, :cc_cvc)
	end

	def user_cc_params(params)
		params.require(:user).permit(:cc_number, :cc_name, :exp_month, :exp_year, :cc_cvc, :address_line_1, :address_line_2, :city, :state, :zip, :special_instructions, :phone_number)
	end

	def edit_user_params(params)
		params.require(:user).permit(:email, :address_line_1, :address_line_2, :city, :state, :zip, :special_instructions, :phone_number, :password, :password_confirmation, :cc_number, :cc_name, :exp_month, :exp_year, :cc_cvc, :name)
	end

	def create_packing_supplies_request_params(params)
		params.require(:packing_supplies_request).permit(:box_quantity, :wardrobe_box_quantity, :bubble_quantity, :tape_quantity)
	end

	def create_pickup_request_params(params)
		params.require(:pickup_request).permit(:proposed_date, :proposed_times, :small_item_quantity, :medium_item_quantity, :large_item_quantity, :extra_large_item_quantity, :duration)
	end

	def create_delivery_request_params(params)
		params.require(:delivery_request).permit(:posted_delivery_time, :posted_delivery_date)
	end

	def update_storage_item_params(params)
		params.require(:storage_item).permit(:title, :description, :image)
	end

	def edit_pickup_request_params(params)
		params.require(:pickup_request).permit(:posted_delivery_time, :posted_delivery_date)
	end
end
