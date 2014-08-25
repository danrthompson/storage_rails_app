class SignupPagesController < ApplicationController
	before_action :no_user, only: [:new, :create]
	before_action :user_but_no_cc_info, only: [:show, :add_payment]

	def new
		@box_request = BoxRequest.new
		@user = User.new
	end

	def create
		@user = User.new(params.require(:user).permit(:email, :address_line_1, :address_line_2, :city, :state, :zip, :special_instructions, :phone_number, :password, :password_confirmation))
		@box_request = BoxRequest.new(params.require(:signup).permit(:box_quantity, :wardrobe_box_quantity, :bubble_quantity, :file_box_quantity, :poster_tube_quantity, :posted_delivery_time, :posted_delivery_date))
		@box_request.valid?
		if @user.valid? and @box_request.errors.count == 1 then
			@user.save!
			@box_request.user = @user
			@box_request.save!
			sign_in @user
			redirect_to signup_pages_confirm_url(@user.id) and return
		end
		render action: :new and return
	end

	def show
		@user = User.find(params[:id])
		redirect_to new_user_session_url and return if @user.id != current_user.id
		@box_request = @user.box_requests.first
	end

	def add_payment
		@user = User.find(params[:id])
		redirect_to new_user_session_url and return if @user.id != current_user.id
		@user.update(params.require(:user).permit(:cc_name, :cc_number, :exp_month, :exp_year))
		redirect_to storage_items_url and return if @user.ready?
		redirect_to signup_pages_confirm_url(@user.id) and return
	end

	private

	def no_user
		redirect_to signup_pages_confirm_url(current_user.id) and return if current_user and not current_user.ready?
		redirect_to storage_items_url and return if current_user and current_user.ready?
	end

	def user_but_no_cc_info
		redirect_to new_user_session_url and return unless current_user
		redirect_to storage_items_url(current_user.id) and return if current_user and current_user.ready? 
	end
end