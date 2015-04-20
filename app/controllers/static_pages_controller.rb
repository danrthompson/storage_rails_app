class StaticPagesController < ApplicationController
	def homepage
		@subscriber = Subscriber.new
	end

	def about
		@user = current_user
	end

	def contact
		@user = current_user
	end

	def faq
		@user = current_user
	end

	def feedback
		@user = current_user
	end

	def not_found
		render status: 404
	end

	def server_error
		render status: 500
	end

	def national
		@subscriber = Subscriber.new
	end

	def luxury
		@subscriber = Subscriber.new
	end

	def moving_and_storage
		@subscriber = Subscriber.new
	end

	def garage_organization
		@subscriber = Subscriber.new
	end

	def cu_student_storage
		@subscriber = Subscriber.new
	end

	def cheap_storage
		@subscriber = Subscriber.new
	end

	private

	def no_ready_users!
		redirect_to storage_items_url and return if current_user and current_user.ready?
	end
end
