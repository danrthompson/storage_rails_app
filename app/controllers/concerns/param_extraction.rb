module ParamExtraction
	extend ActiveSupport::Concern

	def user_address_params(params)
		params.require(:user).permit(:email, :address_line_1, :address_line_2, :city, :state, :zip, :special_instructions, :phone_number, :password, :password_confirmation)
	end

	def create_box_request_params(params)
		params.require(:signup).permit(:box_quantity, :wardrobe_box_quantity, :bubble_quantity, :file_box_quantity, :poster_tube_quantity, :posted_delivery_time, :posted_delivery_date)
	end
end