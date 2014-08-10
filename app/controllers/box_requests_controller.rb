class BoxRequestsController < ApplicationController
	before_action :authenticate_user!

	def new
		@box_request = BoxRequest.new
	end

	def create

	end
end