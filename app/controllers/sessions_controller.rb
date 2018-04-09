class SessionsController < ApplicationController
    def new
    end

    def create
        user_info = request.env["omniauth.auth"]
        user           = User.new
        user.oauth_id  = user_info["uid"]
        user.name      = user_info["info"]["name"]
        user.provider  = user_info["provider"]
        if !User.where(oauth_id: user.oauth_id).exists?
            # If the User doesn't exist, create the User.
            user.save
        else
            # If the User already exists, then use the information from their
            # account, not from google oauth.
            user.name = User.find_by(oauth_id: user.oauth_id).name
        end
        user.id = User.find_by(oauth_id: user.oauth_id).id

        session[:user] = user

        redirect_to root_path
    end

    def destroy
        session.delete(:user)
        current_user = nil

        redirect_to root_path
    end
end
