class AdminPagesController < ApplicationController
	before_action :authenticate_admin!

	def admin_page

	end

	private

	def authenticate_admin!
		if not (current_user and current_user.admin)
			redirect_to not_found_path and return
		end
	end

end