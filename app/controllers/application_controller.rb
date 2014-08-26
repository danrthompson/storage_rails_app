class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def verify_user_is_ready!
  	redirect_to new_user_session_url and return unless current_user
  	redirect_to confirm_signup_pages_url(current_user.id) and return unless current_user.ready?
  end
end
