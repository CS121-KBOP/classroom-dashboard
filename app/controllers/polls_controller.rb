class PollsController < ApplicationController
    include Hasher

    def index
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @polls = @course.polls
    end

    def new
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @poll = @course.polls.new
    end

    def create
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @poll = @course.polls.create(poll_params)
        if @poll.save
            redirect_to user_course_poll_path(@user, @course, @poll)
        else
            render 'new'
      end
    end

    # For the user (professor)
    def show
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @poll = @course.polls.find(params[:id])
        @pollTag = hashIDtoTag(@poll.id, true) # this is a poll
        @options = @poll.options
        @data = Hash.new(0)
        @options.each do |option|
            @data[option.label] = option.votes
        end
    end

    # For the students on their phones
    def student_show
        @access_tag = params[:access_tag]
        @poll = Poll.find(unhashTagtoID(@access_tag))
        @options = @poll.options
    end

    def destroy
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @poll = @course.polls.find(params[:id])
        @poll.destroy

        redirect_to user_course_path(@user, @course)
    end

    def edit
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @poll = @course.polls.find(params[:id])
    end

    def update
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @poll = @course.polls.find(params[:id])

        if @poll.update(poll_params)
            redirect_to user_course_poll_path(@user, @course, @poll)
        else
            render 'edit'
        end
    end

    private
        def poll_params
            params.require(:poll).permit(:name, :description)
        end
end
