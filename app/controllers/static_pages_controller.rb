class StaticPagesController < ApplicationController

	def homepage

	end

	def about
		@user = current_user
	end
end