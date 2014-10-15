class UserMailer < ActionMailer::Base
  default from: "team@quickbox.com"

	def welcome_email(user)
	  	@user = user
	  	@url = "www.quickbox.com/"
	  	mail(to:@user.email, subject: "Welcome To QuickBox");
	end

	def new_customer()
		mail(to:"team@quickbox.com", subject: "You Have A New Customer");
	end
