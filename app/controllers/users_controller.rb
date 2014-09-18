class UsersController < ApplicationController
	include ParamExtraction

	before_action :verify_user_is_ready!

	def edit
		redirect_to new_user_session_url and return if current_user.id != params[:id].to_i
		@user = current_user
	end

	def update
		@user = current_user
		new_user_values = edit_user_params(params)

		signin_changed = if new_user_values['email'] != @user.email or not new_user_values['password'].blank? then true else false end
		
		@user.update(new_user_values)
		sign_in @user, bypass: true if signin_changed
		# errors
		redirect_to edit_user_url @user
	end
end