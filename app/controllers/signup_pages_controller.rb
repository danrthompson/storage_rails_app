class SignupPagesController < ApplicationController
	before_action :no_user, only: [:new, :create]
	before_action :user_but_no_cc_info, only: [:show, :add_payment]

	def new
		@box_request = BoxRequest.new
		@user = User.new
	end

	def create
		binding.pry
		@user = User.new(params.require(:user).permit(:email, :address_line_1, :address_line_2, :city, :state, :zip, :special_instructions, :phone_number, :password, :password_confirmation))
		@box_request = BoxRequest.new(params.require(:signup).permit(:box_quantity, :wardrobe_box_quantity, :bubble_quantity, :file_box_quantity, :poster_tube_quantity, :posted_delivery_time, :posted_delivery_date))
		@box_request.valid?
		binding.pry
		if @user.valid? and @box_request.errors.count == 1 then
			@user.save!
			@box_request.user = @user
			@box_request.save!
			sign_in @user
			redirect_to action: :show, id: @user.id and return
		end
		render action: :new and return
	end

	def show
		@user = User.find(params[:id])
		redirect_to new_user_session_url if @user.id != current_user.id
		@box_request = @user.box_requests.first
	end

	def add_payment

	end

	private

	def no_user
		redirect_to action: :show, id: current_user.id if current_user
	end

	def user_but_no_cc_info
		redirect_to new_user_session_url unless current_user
		redirect_to storage_items_url if (current_user and current_user.cc_name and current_user.cc_number and current_user.exp_month and current_user.exp_year) 
	end

end