class SignupPagesController < ApplicationController
	include ParamExtraction

	before_action :no_user!, only: [:new, :create]
	before_action :user_but_no_cc_info!, only: [:show, :add_payment]

	def new
		@packing_supplies_request = PackingSuppliesRequest.new
		@pickup_request = PickupRequest.new
		@user = User.new
	end

	def create
		@user = User.create new_user_params(params)
		@packing_supplies_request = PackingSuppliesRequest.new(create_packing_supplies_request_params(params))
		@pickup_request = PickupRequest.new(create_pickup_request_params(params))
		@packing_supplies_request.user = @user
		@pickup_request.user = @user

		if @user.valid? and (@packing_supplies_request.valid? or not @packing_supplies_request.is_real?) and (@pickup_request.valid? or not @pickup_request.is_real?)
			@packing_supplies_request.save
			@pickup_request.save
			# Mails out welcome email to users
	#         UserMailer.welcome_email(@user).deliver
			begin
				UserMailer.new_customer().deliver
				sign_in @user
				redirect_to confirm_signup_pages_url(@user.id) and return
			rescue Errno::ECONNREFUSED
				sign_in @user
				redirect_to confirm_signup_pages_url(@user.id), alert: 'Error with sending welcome email.' and return
			end
		else
			@user.destroy
			@packing_supplies_request = PackingSuppliesRequest.new unless @packing_supplies_request.is_real?
			@pickup_request = PickupRequest.new unless @pickup_request.is_real?
			flash.now[:alert] = 'Sorry, there were some errors that you need to correct.'
			render action: :new and return
		end
	end

	def show
		@user = User.find(params[:id])
		redirect_to new_user_session_url and return if @user.id != current_user.id
		@packing_supplies_request = @user.packing_supplies_requests.first
		@pickup_request = @user.pickup_requests.first
		@temp_pickup = PickupRequest.new
	end

	def add_payment
		@user = User.find(params[:id])
		redirect_to new_user_session_url and return if @user.id != current_user.id
		begin
			@user.update(user_cc_params(params))
		rescue Stripe::CardError => e
			flash.now[:alert] = e.message
			render action: :show and return
		end
		if @user.valid?	
			redirect_to storage_items_url and return if @user.ready?
		end
		render action: :show
	end

	private



	def user_but_no_cc_info!
		redirect_to new_user_session_url and return unless current_user
		redirect_to storage_items_url(current_user.id) and return if current_user and current_user.ready? 
	end
end