class UserMailer < ActionMailer::Base
  default from: "team@quickbox.com"

	def welcome_email(user_id)
	  	@user = User.find(user_id)
	  	@url = "www.quickbox.com/"
	  	mail(to:@user.email, subject: "Welcome To QuickBox")
	end

	# def new_customer(email)
	# 	mail(to: email, subject: "You Have A New Customer")
	# end

	def confirm_pickup_email(pickup_request_id)
		@pickup_request = PickupRequest.find(pickup_request_id)
	end

	def confirm_delivery_email(delivery_request_id)
		@delivery_request = DeliveryRequest.find(delivery_request_id)
	end

	def delivery_reminder(delivery_request_id)
		@delivery_request = DeliveryRequest.find(delivery_request_id)
	end

	def pickup_reminder(pickup_request_id)
		@pickup_request = PickupRequest.find(pickup_request_id)
	end

end
