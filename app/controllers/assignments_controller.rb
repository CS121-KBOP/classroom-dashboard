class AssignmentsController < ApplicationController
    include Hasher
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
        @submissionTag = hashIDtoTag(@assignment.id, false) # this is not a poll
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

    def get_submission_data
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @students = @course.students.order(:name)
        @assignment = @course.assignments.find(params[:id])

        # to hold the hashes
        @submissions = Array.new

        # for each student
        @students.each {|student| 
            @submission = @assignment.submissions.select { |submission| submission.student_id == student.id}
            @submission_hash = {}
            if @submission != []
                @submission = @submission[0]
                # this student has submitted
                @submission_hash[:submitted] = true
                @submission_hash[:picture_url] = @submission.answer.url()
                @submission_hash[:student_name] = student.name
                @submission_hash[:created] = @submission.created_at.strftime("Submitted: %A, %B %-d, %Y at %I:%M %p")
                if @submission.created_at !=  @submission.updated_at
                    @submission_hash[:edited] = @submission.updated_at.strftime("Edited at: %A, %B %-d, %Y at %I:%M %p")
                else
                    @submission_hash[:edited] = "Not edited since submission"
                end
                @submission_hash[:url] = user_course_assignment_submission_path(@user, @course, @assignment, @submission)

            else
                # this student has not submitted
                @submission_hash[:submitted] = false
                @submission_hash[:student_name] = student.name

            end

            # add this hash to the list
            @submissions.push(@submission_hash)
        }
        # send the json back to the client
        render(json:  @submissions.to_json)
    end

    private
        def assignment_params
            params.require(:assignment).permit(:name, :description, :active)
        end
end
