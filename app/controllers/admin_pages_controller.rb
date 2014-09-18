class AdminPagesController < ApplicationController
	before_action :authenticate_admin!

	def admin_page
		
	end

	def complete_request
		request = Request.find(params[:id])
		request.completion_time = Time.now
		request.driver = current_user
		request.save
		redirect_to :admin_page and return
	end

	private

	def authenticate_admin!
		if not (current_user and current_user.admin)
			redirect_to not_found_path and return
		end
	end

end