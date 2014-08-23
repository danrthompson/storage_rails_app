class SignupPagesController < ApplicationController

	def new
		@box_request = BoxRequest.new
		@user = current_user
	end

end