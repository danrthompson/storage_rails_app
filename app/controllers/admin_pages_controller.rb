class AdminPagesController < ApplicationController
	before_action :authenticate_admin!

	def admin
		@user = current_user
		@pending_pickup_requests = PickupRequest.where(completion_time: nil).order(:delivery_time)
		@pending_packing_supplies_requests = PackingSuppliesRequest.where(completion_time: nil).order(:delivery_time)
		@pending_delivery_requests = DeliveryRequest.where(completion_time: nil).order(:delivery_time)
	end

	def complete_packing_supplies_request
		PackingSuppliesRequest.update(params[:id], completion_time: Time.now, driver_id: current_user.id)
		redirect_to :admin, notice: 'Packing supplies request marked shipped' and return
	end

	def complete_pickup_request
		pickup_request = PickupRequest.find(params[:id])
		pickup_request.update(complete_pickup_request_params(params))
		pickup_request.completion_time = Time.now
		pickup_request.driver = current_user
		pickup_request.save
		redirect_to admin_record_pickup_request_url(pickup_request.id) and return
	end

	def complete_delivery_request
		delivery_completion_time = Time.now
		delivery_request = DeliveryRequest.find(params[:id])
		delivery_request.storage_items.each do |item|
			item.left_storage_at = delivery_completion_time
			item.save!
		end
		delivery_request.update(completion_time: delivery_completion_time)
		redirect_to :admin, notice: 'Delivery request marked complete' and return
	end

	def record_pickup_request
		@pickup_request = PickupRequest.find(params[:id])
	end

	def record_delivery_request
		@delivery_request = DeliveryRequest.find(params[:id])
	end

	def record_packing_supplies_request
		@packing_supplies_request = PackingSuppliesRequest.find(params[:id])
	end

	private

	def authenticate_admin!
		if not (current_user and current_user.admin)
			redirect_to not_found_path and return
		end
	end

end