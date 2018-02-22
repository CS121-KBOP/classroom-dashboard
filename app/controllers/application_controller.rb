class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  helper_method :logged_in?, :current_user

  def logged_in?
    session.has_key? :user
  end

  def current_user
    if logged_in?
        session[:user]
    end
  end
end
