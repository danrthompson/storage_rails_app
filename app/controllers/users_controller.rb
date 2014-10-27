class UsersController < ApplicationController
	include ParamExtraction

	before_action :verify_user_is_ready!

	def edit
		redirect_to new_user_session_url and return if current_user.id != params[:id].to_i
		@user = current_user
		stripe_user = @user.stripe_user
		@user_last_4 = stripe_user.cards.first.last4
	end

	def update
		@user = current_user
		new_user_values = edit_user_params(params)

		signin_changed = if new_user_values['email'] != @user.email or not new_user_values['password'].blank? then true else false end
		
		begin
			@user.update(new_user_values)
		rescue Stripe::CardError => e
			redirect_to edit_user_url(@user), alert: e.message and return
		end
		sign_in @user, bypass: true if signin_changed
		if @user.valid?
			redirect_to edit_user_url @user and return
		else
			redirect_to edit_user_url(@user), alert: 'Sorry, there were some errors that you need to correct.'
		end
	end

	def referral
		@user = current_user
		
	end
end