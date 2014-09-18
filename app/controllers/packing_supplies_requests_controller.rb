class PackingSuppliesRequestsController < ApplicationController
	include ParamExtraction

	before_action :verify_user_is_ready!

	def new
		@packing_supplies_request = PackingSuppliesRequest.new
		@user = current_user
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
			render action: :new and return
		end
	end

	def show
		@user = current_user
		@packing_supplies_request = PackingSuppliesRequest.find(params[:id])
		redirect_to new_user_session_url and return if @user.id != @packing_supplies_request.user_id
	end
end