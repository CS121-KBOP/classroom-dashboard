class AssignmentsController < ApplicationController
	def index
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @assignments = @course.assignments
    end

    def new
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @assignment = @course.assignments.new
    end

    def create
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @assignment = @course.assignments.create(assignment_params)
        if @assignment.save
            redirect_to user_course_assignment_path(@user, @course, @assignment)
        else
            render 'new'
      end
    end

    def show
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @assignment = @course.assignments.find(params[:id])
    end

    def destroy
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @assignment = @course.assignments.find(params[:id])
        @assignment.destroy
        redirect_to user_course_path(@user, @course)
    end

    def edit
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @assignment = @course.assignments.find(params[:id])
    end

    def update
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @assignment = @course.assignments.find(params[:id])
     
        if @assignment.update(assignment_params)
            redirect_to user_course_path(@user, @course)
        else
            render 'edit'
        end
    end
     
    private
        def assignment_params
            params.require(:assignment).permit(:name, :description)
        end
end
