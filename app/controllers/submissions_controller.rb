class SubmissionsController < ApplicationController
    def new
        @user = User.find(params[:user_id])
        @course = @user.courses.find(params[:course_id])
        @assignment = @course.assignments.find(params[:assignment_id])
        @submission = @assignment.submissions.new
    end

    def create
        @user = User.find(params[:user_id])
        @course = @user.courses.find(params[:course_id])
        @assignment = @course.assignments.find(params[:assignment_id])
        @submission = @assignment.submissions.create(submission_params)
        if @assignment.save
            render 'new'
        else
            render 'new'
      end
    end

    def destroy
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @assignment = @course.assignments.find(params[:id])
        @assignment.destroy
        redirect_to user_course_assignment_path(@user, @course, @assignment)
    end

    def edit
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @assignment = @course.assignments.find(params[:assignment_id])
        @submission = @assignment.submissions.find(params[:id])

    end

    def update
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @assignment = @course.assignments.find(params[:assignment_id])
     	@submission = @assignment.submissions.find(params[:id])
     	puts submission_params
        if @submission.update(submission_params)
            redirect_to user_course_assignment_path(@user, @course, @assignment)
        else
            render 'edit'
        end
    end

    def search
        @user = User.find(params[:user_id])
        @course = @user.courses.find(params[:course_id])
        @students = @course.students.where('email LIKE ?', "%#{params[:email]}%").order('email ASC').limit(5)
        render(json:  @students.to_json)
    end
     
    private
        def submission_params
            params.require(:submission).permit(:student_id, :answer)
        end
end
