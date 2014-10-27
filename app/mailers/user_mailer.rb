class UserMailer < ActionMailer::Base
  default from: "danielrthompsonjr@gmail.com"

	def welcome_email(user)
	  	@user = user
	  	@url = "www.quickbox.com/"
	  	mail(to:@user.email, subject: "Welcome To QuickBox")
	end

	def new_customer(email)
		mail(to: email, subject: "You Have A New Customer")
	end

	def confirm_pickup_email(pickup_request)
		@pickup_request = pickup_request
	end

	def confirm_delivery_email(delivery_request)
		@delivery_request = delivery_request
	end

	def delivery_reminder(delivery_request)
		@delivery_request = delivery_request
	end

	def pickup_reminder(pickup_request)
		@pickup_request = pickup_request
	end

end
