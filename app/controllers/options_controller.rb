class OptionsController < ApplicationController
    def new
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @poll = @course.polls.find(params[:poll_id])
        @option = @poll.options.new
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
        # TODO: This might need to take a select style path where students can access it
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
        @poll = Polls.find(helpers.unhashTag(params[:poll_id]))
        @option = @poll.options.find(params[:id])
        @option.votes = @option.votes + 1
        @option.save

        # TODO: Make this a "taken quiz path instead"
        redirect_to user_course_poll_path(@user, @course, @poll)
    end

    private
        def option_params
            params.require(:option).permit(:label, :description, :votes)
        end
end
