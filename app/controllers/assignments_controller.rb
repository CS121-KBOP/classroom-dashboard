class AssignmentsController < ApplicationController
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
     
    private
        def assignment_params
            params.require(:assignment).permit(:name, :description)
        end
end
