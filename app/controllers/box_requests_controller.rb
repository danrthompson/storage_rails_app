class BoxRequestsController < ApplicationController
	before_action :authenticate_user!

	def new
		@box_request = BoxRequest.new
		@user = current_user
	end

	def create
		render text: params and return
		@box_request = BoxRequest.new(params[:box_request])
		@box_request.user = current_user
		@box_request.save
		if @box_request
			redirect_to @box_request
		end			
	end

	def show

	end
end