class SignupPagesController < ApplicationController

	def new
		@box_request = BoxRequest.new
		@user = User.new
	end

	def create
		render text: params
	end

end