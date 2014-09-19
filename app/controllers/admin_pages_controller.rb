class AdminPagesController < ApplicationController
	before_action :authenticate_admin!

	def admin
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
		render text: 'pickup' and return
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

	private

	def authenticate_admin!
		if not (current_user and current_user.admin)
			redirect_to not_found_path and return
		end
	end

end