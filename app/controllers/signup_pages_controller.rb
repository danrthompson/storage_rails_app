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
		@packing_supplies_request = PackingSuppliesRequest.new

		if @user.valid? and @pickup_request.valid?
			@pickup_request.save
			begin

				# put your own credentials here 
				account_sid = 'ACda3cd5ce74576762c3a0e1afffad264e' 
				auth_token = '7a3e64418237ff2405b3a3fc60d1cbd9' 
				message = 'You have a new user signup: ' + @user.first_name + " " + @user.last_name + ". Email: " + @user.email
				
				# set up a client to talk to the Twilio REST API 
				@client = Twilio::REST::Client.new account_sid, auth_token 		 
				
				# To Daniel H.
				@client.account.messages.create({
					:from => '+17209033991', 
					:to => '720-404-5623', 
					:body => message,  
				})

				# To Maggie
				@client.account.messages.create({
					:from => '+17209033991', 
					:to => '210-410-5804', 
					:body => message,  
				})

				# To Hillary
				@client.account.messages.create({
					:from => '+17209033991', 
					:to => '720-422-3354', 
					:body => message,  
				})

				# To Dan T.
				@client.account.messages.create({
					:from => '+17209033991', 
					:to => '814-288-7620', 
					:body => message,  
				})


				# UserMailer.delay.welcome_email(@user.id)
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
			@user.update(user_add_payment(params))
		rescue Stripe::CardError => e
			flash.now[:alert] = e.message
			render action: :show and return
		end
		if @user.valid?	and @user.ready?
			# UserMailer.delay.confirm_pickup_email(@pickup_request.id)
			redirect_to @pickup_request and return
		end
		render action: :show
	end

	private

	def user_but_no_cc_info!
		redirect_to new_user_session_url and return unless current_user
		redirect_to storage_items_url(current_user.id) and return if current_user and current_user.ready? 
	end
end