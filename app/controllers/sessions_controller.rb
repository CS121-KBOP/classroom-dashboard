class SessionsController < ApplicationController
    def new
    end

    def create
        user_info = request.env["omniauth.auth"]

        user           = User.new
        user.oauth_id  = user_info["uid"]
        user.name      = user_info["info"]["name"]
        user.email     = user_info["info"]["email"]
        session[:user]  = user
        if !User.where(oauth_id: user.oauth_id).exists?
            user.save
        end

        redirect_to root_path
    end

    def destroy
        session.delete(:user)
        current_user = nil

        redirect_to root_path
    end
end
