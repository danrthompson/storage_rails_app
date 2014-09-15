class StaticPagesController < ApplicationController
	before_action :no_user!, only: [:homepage]

	def homepage

	end

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
end