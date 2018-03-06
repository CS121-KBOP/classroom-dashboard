class CoursesController < ApplicationController    
    def index
        @user = User.find(params[:user_id])
        proper_user(@user)
        @courses = @user.courses
    end

    def show
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:id])
    end

    def new
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.new
    end

    def create
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.create(course_params)

        if @course.save
            redirect_to user_course_path(@user, @course)
        else
            render 'new'
      end
    end

    def edit
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:id])
    end

    def update
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:id])

        if @course.update(course_params)
            redirect_to user_course_path(@user, @course)
        else
            render 'edit'
        end
    end

    def destroy
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:id])
        @course.destroy
        redirect_to user_courses_path(@user)
    end

    def quiz
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:id])
    end

    def flashcard
        # get the user and course paramaters
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:id])
        # randomly select one student from the course roster
        @student = @course.students.sample
        # if there is a student to show
        if @student != nil
            # convert the student object to a hash
            @student_hash = @student.attributes
            # add the student's portrait url to the hash
            @student_hash[:portrait_url] = @student.portrait.url(:flashcard)
        else
            # otherwise send back an empty object
            @student_hash = {};
        end
        # send the json back to the client
        render(json:  @student_hash.to_json)
    end

    def updateNotes
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:id])
        @student = @course.students.find(params[:student_id])
        @student.notes = params[:notes]
        if @student.save
            render(json:  {status: "ok"})
        else
            render(json:  {status: "failure"})
        end
    end

    private
        def course_params
            params.require(:course).permit(:title, :code)
        end

end
