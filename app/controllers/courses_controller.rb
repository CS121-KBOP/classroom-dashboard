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

    def flashcard
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:id])
        @student = @course.students.sample
        @student_hash = @student.attributes
        @student_hash[:portrait_url] = @student.portrait.url(:flashcard)
        render(json:  @student_hash.to_json)
    end

    private
        def course_params
            params.require(:course).permit(:title, :code)
        end

end
