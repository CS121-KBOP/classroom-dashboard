class SubmissionsController < ApplicationController
    def new
        @assignment = Assignment.find(unhashTag(params[:assignment_id]))
        @submission = @assignment.submissions.new
    end

    def create
        @assignment = Assignment.find(unhashTag(params[:assignment_id]))
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
        	@assignment = Assignment.find(unhashTag(params[:assignment_id]))
		end
        @students = @assignment.course.students.where('name LIKE ?', "%#{params[:name]}%").order('name ASC').limit(5)
        render(json:  @students.to_json)
    end

    # a helper function that unhashes an assignment tag
    def unhashTag(hash)
    	hash = (hash[1]+hash[3]+hash[0]+hash[2]).downcase;
    	max = 456976;
    	codestring = "ydlgknmzxjbctfiaqsrwoevuhp";
    	newnumber = 0;
    	for i in (3).downto(0)
    		newnumber *= 26;
    		newnumber += codestring.index(hash[i]);
    	end
    	if (newnumber <= max/4)
    		newnumber = (max/4 - newnumber)*4;
    	elsif (newnumber <= max/2)
    		newnumber = (max/2 - newnumber) * 4 + 2;
    	elsif (newnumber <= 3 * max / 4)
    		newnumber = (3*max/4 - newnumber) * 4 + 1;
    	else
    		newnumber = (max - newnumber) * 4 + 3;
    	end

    	return newnumber;
    end
     
    private
        def submission_params
            params.require(:submission).permit(:student_id, :answer)
        end
end
