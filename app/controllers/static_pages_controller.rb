class StaticPagesController < ApplicationController
	before_action :no_user!, only: [:homepage]

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
end