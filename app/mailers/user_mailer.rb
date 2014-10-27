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
end
