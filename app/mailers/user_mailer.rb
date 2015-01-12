class UserMailer < ActionMailer::Base
  default from: "team@quickbox.com"

	def welcome_email(user_id)
		@user = User.find(user_id)
		@url = "www.quickbox.com/"
		mail(to:@user.email, subject: "Welcome To QuickBox")
	end

	def reset_password_welcome_email(user_id)
		@user = User.find(user_id)
		@url = "www.quickbox.com/"
		mail(to:@user.email, subject: "Welcome To QuickBox")
	end

	def new_newsletter_subscriber_email(subscriber_id)
		@subscriber = Subscriber.find(subscriber_id)
		mail(to:@subscriber.email, subject: "Your Quickbox Discount Code!")
	end

	# def new_customer(email)
	# 	mail(to: email, subject: "You Have A New Customer")
	# end

	def confirm_pickup_email(pickup_request_id)
		@pickup_request = PickupRequest.find(pickup_request_id)
		@user = @pickup_request.user
		mail to: @user.email, subject: "Pickup Confirmation"
	end

	def confirm_delivery_email(delivery_request_id)
		@delivery_request = DeliveryRequest.find(delivery_request_id)
		@user = @delivery_request.user
		mail to: @user.email, subject: "Delivery Confirmation"
	end

	# def delivery_reminder(delivery_request_id)
	# 	@delivery_request = DeliveryRequest.find(delivery_request_id)
	# end

	# def pickup_reminder(pickup_request_id)
	# 	@pickup_request = PickupRequest.find(pickup_request_id)
	# end

	def delivery_receipt_email(delivery_request_id)
		@delivery_request = DeliveryRequest.find(delivery_request_id)
		@user = @delivery_request.user
		mail to: @user.email, subject: "QuickBox Delivery Receipt"
	end

	def pickup_receipt_email(pickup_request_id)
		@pickup_request = PickupRequest.find(pickup_request_id)
		@user = @pickup_request.user
		mail to: @user.email, subject: "Your Items Are In Storage!"
	end

end
