class BoxRequestsController < ApplicationController
	before_action :verify_user_is_ready!

	def new
		@box_request = BoxRequest.new
		@user = current_user
	end

	def create
		render text: params and return
		@user = current_user
		@box_request = BoxRequest.new(params.require(:box_request).permit(:box_quantity, :wardrobe_box_quantity, :bubble_quantity, :file_box_quantity, :poster_tube_quantity, :posted_delivery_date, :posted_delivery_time))
		@box_request.user = @user
		if @box_request.valid? then
			@user.update(params.require(:user))
		redirect_to @box_request and return if @box_request
		render action: :new
	end

	def show

	end
end