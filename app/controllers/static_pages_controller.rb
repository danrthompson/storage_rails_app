class StaticPagesController < ApplicationController
	before_action :no_ready_users!, only: [:homepage]

	def about
		@user = current_user
	end

	def contact
		@user = current_user
	end

	def faq
		@user = current_user
	end

	def feedback
		@user = current_user
	end

	def not_found
		render status: 404
	end

	def server_error
		render status: 500
	end

	private

	def no_ready_users!
		redirect_to storage_items_url and return if current_user and current_user.ready?
	end
end