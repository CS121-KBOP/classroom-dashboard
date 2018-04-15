class OptionsController < ApplicationController
    include Hasher
    def new
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @poll = @course.polls.find(params[:poll_id])
        @option = @poll.options.new
    end

    def show
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @poll = @course.polls.find(params[:poll_id])
        @option = @poll.options.find(params[:id])
    end

    def create
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @poll = @course.polls.find(params[:poll_id])
        @option = @poll.options.create(option_params)
        if @option.save
            redirect_to user_course_poll_path(@user, @course, @poll)
        else
            render 'new'
        end
    end

    def destroy
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @poll = @course.polls.find(params[:poll_id])
        @option = @poll.options.find(params[:id])
        @option.destroy

        redirect_to user_course_poll_path(@user, @course, @poll)
    end

    def edit
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @poll = @course.polls.find(params[:poll_id])
        @option = @poll.options.find(params[:id])
    end

    def update
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @poll = @course.polls.find(params[:poll_id])
        @option = @poll.options.find(params[:id])
        if @option.update(option_params)
            redirect_to user_course_poll_path(@user, @course, @poll)
        else
            render 'edit'
        end
    end

    # Called when a student chooses the specific option from their screen
    def select
        @poll = Poll.find(unhashTagtoID(params[:access_tag]))
        @option = @poll.options.find(params[:option_id])
        @option.votes = @option.votes + 1
        @option.save

        render 'options/select'
    end

    private
        def option_params
            params.require(:option).permit(:label, :description, :votes)
        end
end
