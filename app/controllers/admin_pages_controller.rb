class AdminPagesController < ApplicationController
	before_action :authenticate_admin!

	def admin_page
		@packing_supplies_requests = PackingSuppliesRequest.where(completion_time: nil).order(:delivery_time)
		@pickup_requests = PickupRequest.where(completion_time: nil).order(:delivery_time)
		@delivery_requests = DeliveryRequest.where(completion_time: nil).order(:delivery_time)
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