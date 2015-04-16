class AdminPagesController < ApplicationController
	include ParamExtraction

	before_action :authenticate_admin!

	def post_sign_in_as_user
		@user = User.where(sign_in_as_user_params(params)).first
		redirect_to admin_sign_in_as_user_url, alert: 'User does not exist.' and return unless @user
		sign_in @user
		redirect_to storage_items_url and return
	end

	def sign_in_as_user
		@user = User.new
	end

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
		Stripe::Charge.create(amount: (packing_supplies_request.price * 100).to_i, currency: 'usd', customer: packing_supplies_request.user.stripe_customer_identifier, description: "Packing supplies shipped on #{Time.zone.now.strftime('%m/%d')}", statement_description: "PACKING SUPPLIE")
		packing_supplies_request.update(completion_time: Time.zone.now, driver_id: current_user.id)
		redirect_to :admin, notice: 'Packing supplies request marked shipped' and return
	end

	def complete_pickup_request
		@pickup_request = PickupRequest.find(params[:id])
		error = @pickup_request.complete(current_user)
		if error
			flash.now[:alert] = error
			render :record_pickup_request and return
		end
		redirect_to :admin, notice: 'Pickup request marked complete.' and return
	end

	def complete_delivery_request
		@delivery_request = DeliveryRequest.find(params[:id])
		error = @delivery_request.complete(current_user)
		if error
			flash.now[:alert] = error
			render :record_delivery_request and return
		end
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
