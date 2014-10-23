class SignupPagesController < ApplicationController
	include ParamExtraction

	before_action :no_user!, only: [:new, :create]
	before_action :user_but_no_cc_info!, only: [:show, :add_payment]

	def new
		@packing_supplies_request = PackingSuppliesRequest.new
		@pickup_request = PickupRequest.new
		@user = User.new
	end

	def fast_signup
		redirect_to({controller: :static_pages, action: :homepage}, notice: 'You must pick a date and time for your pickup.') and return unless params[:pickup_request] and not params[:pickup_request][:posted_delivery_date].blank? and not params[:pickup_request][:posted_delivery_time].blank?
		@packing_supplies_request = PackingSuppliesRequest.new
		@pickup_request = PickupRequest.new(fast_signup_params(params))
		@user = User.new
		render :new
	end

	def create
		@user = User.create create_user_params(params)
		@pickup_request = PickupRequest.new(create_pickup_request_params(params))
		@pickup_request.user = @user

		if @user.valid? and @pickup_request.valid?
			@pickup_request.save
			# Mails out welcome email to users
			# UserMailer.welcome_email(@user).deliver
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
			@user = User.new create_user_params(params)
			@user.valid?
			flash.now[:alert] = 'Sorry, there were some errors that you need to correct.'
			render action: :new and return
		end
	end

	def show
		@user = User.find(params[:id])
		redirect_to new_user_session_url and return if @user.id != current_user.id
		@pickup_request = @user.pickup_requests.first
	end

	def add_payment
		@user = User.find(params[:id])
		@pickup_request = @user.pickup_requests.first
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