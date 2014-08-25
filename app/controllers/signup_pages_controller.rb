class SignupPagesController < ApplicationController

	def new
		@box_request = BoxRequest.new
		@user = User.new
	end

	def create
		@user = User.create!(params[:user].permit(:email, :address_line_1, :address_line_2, :city, :state, :zip, :special_instructions, :phone_number, :password, :password_confirmation))
		@box_request = @user.box_requests.build(params[:signup].permit(:box_quantity, :wardrobe_box_quantity, :bubble_wrap_quantity, :file_box_quantity, :poster_tube_quantity))
		# @box_request.delivery_time = 
		@box_request.save!
	end

	def show

	end

	def add_payment

	end

end