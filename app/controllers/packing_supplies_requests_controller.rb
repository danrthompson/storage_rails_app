class PackingSuppliesRequestsController < ApplicationController
	include ParamExtraction
	include RequestProcessing

	before_action :verify_user_is_ready!

	def new
		@packing_supplies_request = PackingSuppliesRequest.new
		@user = current_user
	end

	def edit
		@user = current_user
		@packing_supplies_request = request_update_verification(params, @user)
		return if @packing_supplies_request.nil?
		render action: :new
	end

	def update
		@user = current_user
		@user.update(user_address_params(params))

		@packing_supplies_request = request_update_verification(params, @user)
		return if @packing_supplies_request.nil?
		@packing_supplies_request.update(create_packing_supplies_request_params(params))

		if @packing_supplies_request.valid? and @user.valid?
			redirect_to @packing_supplies_request and return
		else
			flash.now[:alert] = 'Sorry, there were some errors that you need to correct.'
			render action: :new and return
		end
	end

	def create
		@user = current_user
		@user.update(user_address_params(params))

		@packing_supplies_request = PackingSuppliesRequest.new(create_packing_supplies_request_params(params))
		@packing_supplies_request.user_id = @user.id

		if @packing_supplies_request.valid? and @user.valid?
			@packing_supplies_request.save!
			redirect_to @packing_supplies_request and return
		else
			flash.now[:alert] = 'Sorry, there were some errors that you need to correct.'
			render action: :new and return
		end
	end

	def show
		@user = current_user
		@packing_supplies_request = PackingSuppliesRequest.find(params[:id])
		redirect_to new_user_session_url and return if @user.id != @packing_supplies_request.user_id
	end

	private

	def request_update_verification(params, user)
		packing_supplies_request = request_by_id!(params, user)
		return nil if packing_supplies_request.nil?
		return nil if redirect_if_complete!(packing_supplies_request)
		return packing_supplies_request
	end
end