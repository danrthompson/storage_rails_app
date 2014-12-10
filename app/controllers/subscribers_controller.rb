class SubscribersController < ApplicationController
	include ParamExtraction

	def create
		@subscriber = Subscriber.create create_subscriber_params(params)
		if @subscriber.valid?
			redirect_to({controller: :static_pages, action: :homepage}, notice: 'You have been subscribed to our newsletter!')
		else
			render 'static_pages/homepage'
		end
	end
end