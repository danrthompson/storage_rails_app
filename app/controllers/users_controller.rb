class UsersController < ApplicationController
	include ParamExtraction

	def edit
		redirect_to new_user_session_url and return if current_user.id != params[:id]
		@user = current_user
	end

	def update
		# todo
	end
end