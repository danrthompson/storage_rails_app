class SignupPagesController < ApplicationController
	include ParamExtraction

	before_action :no_user!, only: [:new, :create]
	before_action :user_but_no_cc_info!, only: [:select_items, :post_select_items, :show, :add_payment]

	def new
		@user = User.new
		@subscriber = Subscriber.new
	end

	def create
		@user = User.create create_user_params(params)
		@subscriber = Subscriber.new

		if @user.valid?
			sign_in @user
			Analytics.identify(
		    user_id: @user.id.to_s,
		    traits: {
		      name: @user.name,
		      email: @user.email,
		      created_at: Time.zone.now
		    })
			Analytics.track(
			  user_id: @user.id.to_s,
			  event: 'Signed Up'
			)
			redirect_to signup_select_items_url(@user.id) and return
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
		@track_conversion = false
		if @user.conversion_tracked.blank?
			@track_conversion = true
			@user.update_column(:conversion_tracked, true)
		end
		@pickup_request = PickupRequest.new
	end

	def post_select_items
		@user = User.find(params[:id])
		redirect_to new_user_session_url and return if @user.id != current_user.id

		@pickup_request = PickupRequest.new select_items_params(params)
		render :show
	end

	def add_payment
		@user = User.find(params[:id])
		redirect_to new_user_session_url and return if @user.id != current_user.id
		@pickup_request = PickupRequest.new create_pickup_request_params(params)
		@pickup_request.user = @user
		pickup_valid = @pickup_request.valid?
		@user.update(user_add_payment_no_cc(params))
		begin
			@user.update(user_just_cc_params(params))
		rescue Stripe::CardError => e
			@user.valid?
			@user.add_readiness_errors
			flash.now[:alert] = e.message
			render action: :show and return
		end
		if @user.valid?	and @user.ready? and pickup_valid
			@pickup_request.save
			redirect_to @pickup_request and return
		end
		@user.add_readiness_errors
		render action: :show and return
	end

	private

	def user_but_no_cc_info!
		redirect_to new_user_session_url and return unless current_user
		redirect_to storage_items_url(current_user.id) and return if current_user and current_user.ready? 
	end
end