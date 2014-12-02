class SignupPagesController < ApplicationController
	include ParamExtraction

	before_action :no_user!, only: [:new, :create]
	before_action :user_but_no_cc_info!, only: [:select_items, :post_select_items, :show, :add_payment]

	def new
		@user = User.new
	end

	def create
		@user = User.create create_user_params(params)

		if @user.valid?
			begin
				# @user.send_welcome_email
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
		redirect_to new_user_session_url and return if @user.id != current_user.id
		@pickup_request = PickupRequest.new
	end

	def post_select_items
		@user = User.find(params[:id])
		redirect_to new_user_session_url and return if @user.id != current_user.id
		@pickup_request = PickupRequest.new select_items_params(params)
		# render text: "hello" and return

		render :show
	end

	def add_payment
		@user = User.find(params[:id])
		redirect_to new_user_session_url and return if @user.id != current_user.id
		@pickup_request = PickupRequest.new create_pickup_request_params(params)
		@pickup_request.user = @user
		unless @pickup_request.valid?
			render action: :show and return
		end
		begin
			@user.update(user_add_payment(params))
		rescue Stripe::CardError => e
			flash.now[:alert] = e.message
			render action: :show and return
		end
		if @user.valid?	and @user.ready?
			puts "\n\n\n\n\n6"
			@pickup_request.save
			puts "\n\n\n\n\n7"
			# UserMailer.delay.confirm_pickup_email(@pickup_request.id)
			redirect_to @pickup_request and return
		end
		puts "\n\n\n\n\n8"
		@user.add_readiness_errors
		puts "\n\n\n\n\n9"
		render action: :show
	end

	private

	def user_but_no_cc_info!
		redirect_to new_user_session_url and return unless current_user
		redirect_to storage_items_url(current_user.id) and return if current_user and current_user.ready? 
	end
end