module RequestProcessing
	extend ActiveSupport::Concern

	private

	def request_by_id!(params, user)
		request = Request.find(params[:id])
		if user.id == request.user_id
			return request
		else
			redirect_to new_user_session_url, alert: 'You do not have permission to edit this request.'
			return nil
		end
	end

	def redirect_if_too_late!(request)
		if (request.delivery_time - Time.now) > 1.day
			return false
		else
			redirect_to storage_items_url, alert: 'It is too close to the delivery time to edit this request.'
			return true
		end
	end

	def redirect_if_complete!(request)
		if request.completion_time.nil?
			return false
		else
			redirect_to storage_items_url, alert: 'This request has already been completed, so you cannot edit it.'
			return true
		end
	end
end