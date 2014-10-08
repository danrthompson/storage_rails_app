class AdminPagesController < ApplicationController
	include ParamExtraction

	before_action :authenticate_admin!

	def admin
		@user = current_user
		@pending_pickup_requests = PickupRequest.where(completion_time: nil).order(:delivery_time)
		@pending_packing_supplies_requests = PackingSuppliesRequest.where(completion_time: nil).order(:delivery_time)
		@pending_delivery_requests = DeliveryRequest.where(completion_time: nil).order(:delivery_time)
	end

	def complete_packing_supplies_request
		packing_supplies_request = PackingSuppliesRequest.find(params[:id])
		Stripe::Charge.create(amount: packing_supplies_request.price * 100, currency: 'usd', customer: packing_supplies_request.user.stripe_customer_identifier, description: "Packing supplies shipped on #{Time.now.strftime('%m/%d')}", statement_description: "QUICKBOX SHPMT")
		packing_supplies_request.update(completion_time: Time.now, driver_id: current_user.id)
		redirect_to :admin, notice: 'Packing supplies request marked shipped' and return
	end

	def complete_pickup_request
		pickup_completion_time = Time.now
		pickup_request = PickupRequest.find(params[:id])
		pickup_request.update(complete_pickup_request_params(params))
		pickup_request.completion_time = pickup_completion_time
		pickup_request.driver = current_user
		monthly_cost = 0.0
		pickup_request.storage_items.each do |item|
			item.entered_storage_at = pickup_completion_time
			item.save
			monthly_cost += item.price
		end
		stripe_user = pickup_request.user.stripe_user
		if stripe_user.subscriptions.first
			subscription = stripe_user.subscriptions.first
			subscription.quantity += monthly_cost * 100
			subscription.save
			Stripe::Invoice.create(customer: stripe_user.id)
		else
			subscription = stripe_user.subscriptions.create(plan: 'plan_1', quantity: monthly_cost * 100)
		end
		pickup_request.save
		redirect_to :admin, notice: 'Pickup request marked complete.' and return
	end

	def complete_delivery_request
		delivery_completion_time = Time.now
		delivery_request = DeliveryRequest.find(params[:id])
		monthly_cost = 0.0
		delivery_request.storage_items.each do |item|
			item.left_storage_at = delivery_completion_time
			monthly_cost += item.price
			item.save!
		end
		stripe_user = delivery_request.user.stripe_user
		subscription = stripe_user.subscriptions.first
		subscription.quantity -= monthly_cost * 100
		subscription.save
		Stripe::Charge.create(amount: delivery_request.price * 100, currency: 'usd', customer: stripe_user.id, description: "Quickbox delivery on #{Time.now.strftime('%m/%d')}", statement_description: "QUICKBOX DLVRY")

		delivery_request.completion_time = delivery_completion_time
		delivery_request.save
		redirect_to :admin, notice: 'Delivery request marked complete' and return
	end

	def assign_driver
		@request = Request.find(params[:id])
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