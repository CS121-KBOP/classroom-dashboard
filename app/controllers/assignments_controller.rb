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
        @submissionTag = hashID(@assignment.id)
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

    # a helper function that hashes an assignment number into a tag
    def hashID(number)
    	max = 456976;
    	codestring = "ydlgknmzxjbctfiaqsrwoevuhp";
    	newnumber = (number / 4).to_i;
    	if (number % 4 == 0)
    		newnumber = max/4 - newnumber;
    	elsif (number % 4 == 1)
    		newnumber = 3*max/4 - newnumber;
    	elsif (number % 4 == 2)
    		newnumber = max/2 -  newnumber;
    	else
    		newnumber = max - newnumber;
    	end
    	result = "";
    	puts newnumber;
    	for i in 1..4
    		result += codestring[newnumber % 26];
    		newnumber /= 26;
    	end
  		
  		return (result[2]+result[0]+result[3]+result[1]).upcase
    end

    def submission_view
    	@user = User.find(params[:user_id])
        proper_user(@user)
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
        else
            @submission_hash = {};
        end
        # send the json back to the client
        render(json:  @submission_hash.to_json)
    end
     
    private
        def assignment_params
            params.require(:assignment).permit(:name, :description)
        end
end
