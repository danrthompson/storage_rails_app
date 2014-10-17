class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def after_sign_in_path_for(resource)
    if current_user.admin then
      admin_url
    else
      storage_items_url
    end
  end

  def verify_user_is_ready!
  	redirect_to new_user_session_url, alert: 'You need to be signed in to access this page.' and return unless current_user
  	redirect_to confirm_signup_pages_url(current_user.id) and return unless current_user.ready?
  end

  def no_user!
    redirect_to confirm_signup_pages_url(current_user.id) and return if current_user and not current_user.ready?
    redirect_to storage_items_url and return if current_user and current_user.ready?
  end
end
