class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        proper_user(@user)
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
        proper_user(@user)
    end

    def update
        @user = User.find(params[:id])
        proper_user(@user)

        if @user.update(user_params)
            redirect_to @user
        else
            render 'edit'
        end
    end

    def destroy
        @user = User.find(params[:id])
        proper_user(@user)
        @user.destroy
        redirect_to users_path
    end

    private
        def user_params
            params.require(:user).permit(:name, :email, :password)
        end
end