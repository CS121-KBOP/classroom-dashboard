class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        ensure_proper_user(@user)
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)

        if @user.save
            log_in @user
            flash[:success] = "Welcome to the Classroom Dashboard!"
            redirect_to @user
        else
            render 'new'
        end
    end

    def edit
        @user = User.find(params[:id])
        ensure_proper_user(@user)
    end

    def update
        @user = User.find(params[:id])
        ensure_proper_user(@user)

        if @user.update(user_params)
            # updates user's name and email for duration of their session
            # future sessions will be handled via database lookups
            current_user["name"] = user_params["name"]
            current_user["email"] = user_params["email"]
            redirect_to @user
        else
            render 'edit'
        end
    end

    def destroy
        @user = User.find(params[:id])
        ensure_proper_user(@user)
        @user.destroy
        redirect_to users_path
    end

    private
        def user_params
            params.require(:user).permit(:name, :email)
        end
end
