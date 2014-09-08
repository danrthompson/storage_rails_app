class SignupPagesController < ApplicationController
	include ParamExtraction

	before_action :no_user, only: [:new, :create]
	before_action :user_but_no_cc_info, only: [:show, :add_payment]

	def new
		@packing_supplies_request = PackingSuppliesRequest.new
		@user = User.new
	end

	def create
		@user = User.new user_address_params(params)
		@packing_supplies_request = PackingSuppliesRequest.new(create_packing_supplies_request_params(params))
		@packing_supplies_request.valid?
		if @user.valid? and @packing_supplies_request.errors.count == 1 then
			@user.save!
			@packing_supplies_request.user = @user
			@packing_supplies_request.save!
			sign_in @user
			redirect_to confirm_signup_pages_url(@user.id) and return
		end
		render action: :new and return
	end

	def show
		@user = User.find(params[:id])
		redirect_to new_user_session_url and return if @user.id != current_user.id
		@packing_supplies_request = @user.packing_supplies_requests.first
		@delivery_date = @packing_supplies_request.delivery_time.strftime("%B %d at %l:%m %p")
	end

	def add_payment
		@user = User.find(params[:id])
		redirect_to new_user_session_url and return if @user.id != current_user.id
		@user.update(user_cc_params(params))
		redirect_to storage_items_url and return if @user.ready?
		redirect_to confirm_signup_pages_url(@user.id) and return
	end

	private

	def no_user
		redirect_to confirm_signup_pages_url(current_user.id) and return if current_user and not current_user.ready?
		redirect_to storage_items_url and return if current_user and current_user.ready?
	end

	def user_but_no_cc_info
		redirect_to new_user_session_url and return unless current_user
		redirect_to storage_items_url(current_user.id) and return if current_user and current_user.ready? 
	end
end