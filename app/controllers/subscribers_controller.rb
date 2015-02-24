class SubscribersController < ApplicationController
	include ParamExtraction

	def create
		@user = User.new
		@subscriber = Subscriber.create create_subscriber_params(params)
		if @subscriber.valid?
			success_message = 'You should receive a promo code in your email inbox soon!'
			begin
				redirect_to(:back, notice: success_message)
			rescue ActionController::RedirectBackError
				redirect_to({controller: :static_pages, action: :homepage}, notice: success_message)
			end
		else
			failure_message = @subscriber.errors.full_messages.first
			begin
				redirect_to(:back, alert: failure_message)
			rescue ActionController::RedirectBackError
				redirect_to({controller: :static_pages, action: :homepage}, alert: failure_message)
			end
		end
	end
end