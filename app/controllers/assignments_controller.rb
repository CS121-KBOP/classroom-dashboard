class AssignmentsController < ApplicationController
    def index
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @assignments = @course.assignments
    end

    def new
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @assignment = @course.assignments.new
    end

    def create
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
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
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @assignment = @course.assignments.find(params[:id])
        @submissionTag = helpers.hashID(@assignment.id)
    end

    def destroy
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @assignment = @course.assignments.find(params[:id])
        @assignment.destroy

        redirect_to user_course_assignments_path(@user, @course)
    end

    def edit
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @assignment = @course.assignments.find(params[:id])
    end

    def update
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @assignment = @course.assignments.find(params[:id])

        if @assignment.update(assignment_params)
            redirect_to user_course_assignment_path(@user, @course, @assignment)
        else
            render 'edit'
        end
    end

    def submission_view
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @assignment = @course.assignments.find(params[:id])
        @sub_number = params[:submission].to_i
        @submission = @assignment.submissions[@sub_number]
    	if @submission != nil
            @submission_hash = {}
            @submission_hash[:picture_url] = @submission.answer.url()
            @submission_hash[:student_name] = Student.find(@submission.student_id).name
            @submission_hash[:created] = @submission.created_at.strftime("Submitted: %A, %B %-d, %Y at %I:%M %p")
            if @submission.created_at !=  @submission.updated_at
				@submission_hash[:edited] = @submission.updated_at.strftime("Edited at: %A, %B %-d, %Y at %I:%M %p")
			else
				@submission_hash[:edited] = "Not edited since submission"
			end
            @submission_hash[:url] = user_course_assignment_submission_path(@user, @course, @assignment, @submission)

        else
            @submission_hash = {};
        end
        # send the json back to the client
        render(json:  @submission_hash.to_json)
    end

    # Allow user to see who has and has not submitted something for this assignment
    def student_submission_lists
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @students = @course.students
        @assignment = @course.assignments.find(params[:id])
        @submissionTag = helpers.hashID(@assignment.id)
        @submissions = @assignment.submissions

        # Create an array that contains all students with a submission for the assignment
        @submitted_students = Array.new
        @submissions.each do |submission|
            student = submission.student
            @submitted_students = @submitted_students.push(student)
        end

        # Create an array that contains all students without a submission for the assignment
        @not_submitted_students = Array.new
        @students.each do |student|
            if !@submitted_students.include? student
                @not_submitted_students = @not_submitted_students.push(student)
            end
        end
    end

    private
        def assignment_params
            params.require(:assignment).permit(:name, :description, :active)
        end
end
