class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    helper_method :logged_in?, :current_user, :proper_user

    def logged_in?
        session.has_key? :user
    end

    def current_user
        session[:user] if logged_in?
    end

    def proper_user(user)
        if current_user["id"] != user.id
            render 'sessions/unauthorized'
        end
    end

end
