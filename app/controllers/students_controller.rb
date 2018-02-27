class StudentsController < ApplicationController
    def index
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @students = @course.students
    end

    def new
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @student = @course.students.new
    end

    def create
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @student = @course.students.create(student_params)
        if @student.save
            redirect_to user_course_student_path(@user, @course, @student)
        else
            render 'new'
      end
    end

    def show
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @student = @course.students.find(params[:id])
    end

    def destroy
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @student = @course.students.find(params[:id])
        @student.destroy
        redirect_to user_course_path(@user, @course)
    end

    def edit
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @student = @course.students.find(params[:id])
    end

    def update
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @student = @course.students.find(params[:id])
     
        if @student.update(student_params)
            redirect_to user_course_path(@user, @course)
        else
            render 'edit'
        end
    end

    def import
        @user = User.find(params[:user_id])
        proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        Student.import(params[:file], @course)

        redirect_to user_course_path(@user, @course)
    end
     
    private
        def student_params
            params.require(:student).permit(:name, :email, :portrait, :notes)
        end
end
