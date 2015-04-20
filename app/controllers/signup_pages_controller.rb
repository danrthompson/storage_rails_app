class SignupPagesController < ApplicationController
	include ParamExtraction

	before_action :no_user!, only: [:select_items, :post_select_items, :create]
	before_action :user_but_no_cc_info!, only: [:show, :add_payment]


	def post_select_items
		if params[:skip_pickup_request]
			@user = User.new(estimator_skip_pickup_request: true)
		else
			@user = User.new select_items_params(params)
			@user.estimator_skip_pickup_request = false
		end
		@subscriber = Subscriber.new
		render :new
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
			redirect_to signup_add_payment_url and return
		else
			@user.destroy
			@user = User.new create_user_params(params)
			@user.valid?
			flash.now[:alert] = 'Sorry, there were some errors that you need to correct.'
			render action: :new and return
		end
	end

	def show
		@user = current_user
		@pickup_request = PickupRequest.new
	end

	def add_payment
		@user = current_user
		@pickup_request = PickupRequest.new
		@user.update(user_add_payment_no_cc(params))
		begin
			@user.update(user_just_cc_params(params))
		rescue Stripe::CardError => e
			@user.valid?
			@user.add_readiness_errors
			flash.now[:alert] = e.message
			render action: :show and return
		end
		user_valid_and_ready = @user.valid? and @user.ready?
		unless user_valid_and_ready
			@user.add_readiness_errors
		end
		pickup_created = false
		unless @user.estimator_skip_pickup_request
			@pickup_request = PickupRequest.new create_pickup_request_params(params)
			@pickup_request.user = @user
			@pickup_request.small_item_quantity = @user.estimator_small_item_quantity
			@pickup_request.medium_item_quantity = @user.estimator_medium_item_quantity
			@pickup_request.large_item_quantity = @user.estimator_large_item_quantity
			@pickup_request.extra_large_item_quantity = @user.estimator_extra_large_item_quantity
			@pickup_request.duration = @user.estimator_duration
			unless @pickup_request.valid?
				@user.not_ready = true
				@user.save
				render action: :show and return
			end
			@pickup_request.save
			@user.not_ready = nil
			@user.save
			pickup_created = true
		end
		if user_valid_and_ready
			if pickup_created
				redirect_to @pickup_request and return
			else
				redirect_to storage_items_url and return
			end
		end
		render action: :show and return
	end

	private

	def user_but_no_cc_info!
		redirect_to new_user_session_url and return unless current_user
		redirect_to storage_items_url and return if current_user and current_user.ready?
	end
end
