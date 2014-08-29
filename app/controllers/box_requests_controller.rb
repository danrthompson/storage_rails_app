class BoxRequestsController < ApplicationController
	include ParamExtraction

	before_action :verify_user_is_ready!

	def new
		@box_request = BoxRequest.new
		@user = current_user
	end

	def create
		@user = current_user
		@box_request = BoxRequest.new(create_box_request_params(params))
		@box_request.user = @user
		@user.update(user_address_params(params))
		if @box_request.valid? and @user.valid? then
			@box_request.save!
			redirect_to @box_request and return
		else
			render action: :new and return
		end
	end

	def show
		@user = current_user
		@box_request = BoxRequest.find(params[:id])
		redirect_to new_user_session_url and return if @user != @box_request.user
	end
end