class AdminPagesController < ApplicationController
	include ParamExtraction

	before_action :authenticate_admin!

	def admin
		@user = current_user
		@pending_pickup_requests = PickupRequest.where(completion_time: nil).order(:delivery_time)
		@pending_pickup_requests_assigned = PickupRequest.where(completion_time: nil).where.not(driver_name: nil).order(:delivery_time)
		@pending_pickup_requests_unassigned = PickupRequest.where(completion_time: nil, driver_name: nil).order(:delivery_time)

		@pending_delivery_requests = DeliveryRequest.where(completion_time: nil).order(:delivery_time)
		@pending_delivery_requests_assigned = DeliveryRequest.where(completion_time: nil).where.not(driver_name: nil).order(:delivery_time)
		@pending_delivery_requests_unassigned = DeliveryRequest.where(completion_time: nil, driver_name: nil).order(:delivery_time)

		@pending_packing_supplies_requests = PackingSuppliesRequest.where(completion_time: nil).order(:delivery_time)
	end

	def assign_driver
		@request = Request.find(params[:id])
	end

	def update_assign_driver
		@request = Request.find(params[:id])
		@request.skip_delivery_validation = true
		@request.update(params.require(:request).permit(:driver_name, :driver_notes))
		redirect_to :admin, notice: 'Driver has been assigned to the request.' and return
	end

	def record_pickup_request
		@pickup_request = PickupRequest.find(params[:id])
	end

	def record_delivery_request
		@delivery_request = DeliveryRequest.find(params[:id])
	end

	def save_changes_pickup_request
		@pickup_request = PickupRequest.find(params[:id])
		@pickup_request.skip_delivery_validation = true
		@pickup_request.update(complete_pickup_request_params(params))
		if @pickup_request.valid?
			redirect_to({action: :record_pickup_request}, notice: 'Changes saved') and return
		else
			flash.now[:alert] = 'There were some errors that prevented saving'
			render action: :record_pickup_request and return
		end
	end

	def save_changes_delivery_request
		@delivery_request = DeliveryRequest.find(params[:id])
		@delivery_request.skip_delivery_validation = true
		@delivery_request.update(complete_delivery_request_params(params))
		if @delivery_request.valid?
			redirect_to({action: :record_delivery_request}, notice: 'Changes saved') and return
		else
			flash.now[:alert] = 'There were some errors that prevented saving.'
			render action: :record_delivery_request and return
		end
	end

	def complete_packing_supplies_request
		packing_supplies_request = PackingSuppliesRequest.find(params[:id])
		Stripe::Charge.create(amount: (packing_supplies_request.price * 100).to_i, currency: 'usd', customer: packing_supplies_request.user.stripe_customer_identifier, description: "Packing supplies shipped on #{Time.now.strftime('%m/%d')}", statement_description: "QUICKBOX SHPMT")
		packing_supplies_request.update(completion_time: Time.now, driver_id: current_user.id)
		redirect_to :admin, notice: 'Packing supplies request marked shipped' and return
	end

	def complete_pickup_request
		pickup_completion_time = Time.now
		@pickup_request = PickupRequest.find(params[:id])
		@pickup_request.skip_delivery_validation = true
		@pickup_request.completion_time = pickup_completion_time
		@pickup_request.driver = current_user
		monthly_cost = 0.0
		@pickup_request.storage_items.each do |item|
			item.entered_storage_at = pickup_completion_time
			item.save
			if not item.valid?
				flash.now[:alert] = item.errors.full_messages.first
				render :record_pickup_request and return
			end
			discount = item.discount.to_f
			if discount and discount > 0 and discount <= 1
				monthly_cost += item.price*(1.0 - discount)
			else
				monthly_cost += item.price
			end
		end
		stripe_user = @pickup_request.user.stripe_user
		if stripe_user.subscriptions.first
			subscription = stripe_user.subscriptions.first
			subscription.quantity += (monthly_cost * 100).to_i
			subscription.save
			Stripe::Invoice.create(customer: stripe_user.id)
		else
			subscription = stripe_user.subscriptions.create(plan: 'plan_1', quantity: (monthly_cost * 100).to_i)
		end
		
		@pickup_request.save
		# UserMailer.delay.pickup_receipt_email(@pickup_request.id)
		redirect_to :admin, notice: 'Pickup request marked complete.' and return
	end

	def complete_delivery_request
		delivery_completion_time = Time.now
		@delivery_request = DeliveryRequest.find(params[:id])
		@delivery_request.skip_delivery_validation = true
		@delivery_request.completion_time = delivery_completion_time
		@delivery_request.driver = current_user
		monthly_cost = 0.0
		@delivery_request.storage_items.each do |item|
			item.left_storage_at = delivery_completion_time
			discount = item.discount.to_f
			if discount and discount > 0 and discount <= 1
				monthly_cost += item.price*(1.0 - discount)
			else
				monthly_cost += item.price
			end
			item.save!
		end
		stripe_user = @delivery_request.user.stripe_user
		subscription = stripe_user.subscriptions.first
		subscription.quantity -= (monthly_cost * 100).to_i
		subscription.save
		Stripe::Charge.create(amount: (@delivery_request.price * 100).to_i, currency: 'usd', customer: stripe_user.id, description: "Quickbox delivery on #{Time.now.strftime('%m/%d')}", statement_description: "QUICKBOX DLVRY")

		@delivery_request.save
		# UserMailer.delay.delivery_receipt_email(@delivery_request.id)
		redirect_to :admin, notice: 'Delivery request marked complete' and return
	end

	def create_block_time
		ut = UnavailableTime.create(params.require(:unavailable_time).permit(:unavailable_date, :start_hour, :end_hour))
		if ut.valid?
			redirect_to :admin, notice: 'Time blocked out successfully' and return
		else
			redirect_to :admin, alert: 'There was an error with blocking out that time.' and return
		end
	end

	def block_time

	end

	private

	def authenticate_admin!
		if not (current_user and current_user.admin)
			redirect_to not_found_path and return
		end
	end

end