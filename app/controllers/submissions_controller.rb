class SubmissionsController < ApplicationController
    include Hasher

    def new
        id = unhashTagtoID(params[:access_tag])
        if Assignment.exists?(id)
            @assignment = Assignment.find(id)
            @submission = @assignment.submissions.new
        else
            render "homepage/invalid_tag"
        end
        
    end

    def create
        @assignment = Assignment.find(unhashTagtoID(params[:access_tag]))
        @student = @assignment.course.students.find(params[:student_id])
        # if this student has already submitted for this assignment
        if @assignment.submissions.exists?(:student_id => params[:student_id].to_i)
            # find and update that record
            @submission = @assignment.submissions.where(:student_id => params[:student_id].to_i)
            if @submission.update(:answer => params[:answer])
                render(json:  {status: "ok"})
            else
                render(json:  {status: "failure"})
            end
        else
            # create a new assignment
            @submission = @assignment.submissions.create(:answer => params[:answer], :student_id => params[:student_id].to_i)
            if @submission.save
                render(json:  {status: "ok"})
            else
                render(json:  {status: "failure"})
            end
        end
        
    end

    def destroy
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @assignment = @course.assignments.find(params[:assignment_id])
        @submission = @assignment.submissions.find(params[:id])
        @submission.destroy
        redirect_to user_course_assignment_path(@user, @course, @assignment)
    end

    def edit
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
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
        @assignment = Assignment.find(unhashTagtoID(params[:access_tag]))
        @students = @assignment.course.students.where('name LIKE ?', "%#{params[:name]}%").order('name ASC').limit(5)
        render(json:  @students.to_json)
    end

     
    private
        def submission_params
            params.require(:submission).permit(:student_id, :answer)
        end
end
