class SignupPagesController < ApplicationController
	before_action :no_user, only: [:new, :create]
	before_action :user_but_no_cc_info, only: [:show, :add_payment]

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

	private

	def no_user
		redirect_to action: :show if current_user
	end

	def user_but_no_cc_info
		redirect_to new_user_session_url unless current_user
		redirect_to storage_items_url if (current_user and current_user.cc_name and current_user.cc_number and current_user.exp_month and current_user.exp_year) 
	end

end