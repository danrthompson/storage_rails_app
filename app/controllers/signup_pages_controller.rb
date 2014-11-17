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
		@user = User.create create_user_params(params)
		# @pickup_request = PickupRequest.new(create_pickup_request_params(params))
		# @pickup_request.user = @user
		@packing_supplies_request = PackingSuppliesRequest.new

		# if @user.valid? and @pickup_request.valid?
		if @user.valid?
			begin
				# UserMailer.delay.welcome_email(@user.id)
				sign_in @user
				redirect_to signup_select_items_url(@user.id) and return
			rescue Errno::ECONNREFUSED
				sign_in @user
				redirect_to signup_select_items_url(@user.id), alert: 'Error with sending welcome email.' and return
			end
		else
			@user.destroy
			@user = User.new create_user_params(params)
			@user.valid?
			flash.now[:alert] = 'Sorry, there were some errors that you need to correct.'
			render action: :new and return
		end
	end

	def select_items
		@user = User.find(params[:id])
		@pickup_request = PickupRequest.new
	end

	def post_select_items
		render text: params and return
	end

	def show
		@user = User.find(params[:id])
		redirect_to new_user_session_url and return if @user.id != current_user.id
		@pickup_request = PickupRequest.new
	end

	def add_payment
		@user = User.find(params[:id])
		@pickup_request = PickupRequest.new create_pickup_request_params(params)
		@pickup_request.user = @user
		redirect_to new_user_session_url and return if @user.id != current_user.id
		unless @pickup_request.valid?
			render action: :show and return
		end
		begin
			@user.update(user_add_payment(params))
		rescue Stripe::CardError => e
			flash.now[:alert] = e.message
			render action: :show and return
		end
		if @user.valid?	and @user.ready? and @pickup_request.valid?
			@pickup_request.save
			UserMailer.delay.confirm_pickup_email(@pickup_request.id)
			redirect_to @pickup_request and return
		end
		@user.add_readiness_errors
		render action: :show
	end

	private

	def user_but_no_cc_info!
		redirect_to new_user_session_url and return unless current_user
		redirect_to storage_items_url(current_user.id) and return if current_user and current_user.ready? 
	end
end