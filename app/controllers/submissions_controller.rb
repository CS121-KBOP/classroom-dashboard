class SubmissionsController < ApplicationController
    def new
        @assignment = Assignment.find(helpers.unhashTag(params[:assignment_id]))
        @submission = @assignment.submissions.new
    end

    def create
        @assignment = Assignment.find(helpers.unhashTag(params[:assignment_id]))
        @student = @assignment.course.students.find(params[:student_id])
        @submission = @assignment.submissions.create(:answer => params[:answer], :student_id => params[:student_id])
        logger.debug "New submission: #{@submission.attributes.inspect}"
        if @submission.save
            render(json:  {status: "ok"})
        else
            render(json:  {status: "failure"})
        end
    end

    def destroy
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @assignment = @course.assignments.find(params[:assignment_id])
        @submission = @assignment.submissions.find(params[:id])
        @submission.destroy
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
        @assignment = Assignment.find(params[:assignment_id])
     	@submission = @assignment.submissions.find(params[:id])
     	puts submission_params
        if @submission.update(submission_params)
            redirect_to user_course_assignment_path(@assignment.course.user, @assignment.course, @assignment)
        else
            render 'edit'
        end
    end

    def search
    	begin
        	@assignment = Assignment.find(params[:assignment_id])
        rescue
        	@assignment = Assignment.find(helpers.unhashTag(params[:assignment_id]))
		end
        @students = @assignment.course.students.where('name LIKE ?', "%#{params[:name]}%").order('name ASC').limit(5)
        render(json:  @students.to_json)
    end

     
    private
        def submission_params
            params.require(:submission).permit(:student_id, :answer)
        end
end
