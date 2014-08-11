class BoxRequestsController < ApplicationController
	before_action :authenticate_user!

	def new
		@box_request = BoxRequest.new
		@user = current_user
	end

	def create
		render text: params and return
	end
end