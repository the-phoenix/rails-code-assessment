class ApplicationController < ActionController::Base
  before_action :authorized
  add_flash_types :error, :notice

  helper_method :current_user
  helper_method :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !current_user.nil?
  end

  def authorized
    redirect_to '/welcome' unless logged_in?
  end
end
