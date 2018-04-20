require 'thread'

class StudentsController < ApplicationController
    def index
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @students = @course.students
    end

    def new
        semaphore = Mutex.new
        semaphore.lock
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:id])
        # Create a new student to be populated
        student = Student.new
        student.course_id = @course.id
        student.portrait = params[:file]
        # The name of the student is the name of the image
        student.name = student.portrait_file_name
        # Check that an image was actually grabbed by ensuring name is not empty or nil
        if student.name != "" and student.name != nil
            # Replace all underscores with spaces, as file names convert spaces to underscores
            if student.name.include? "_"
                student.name.gsub!("_", " ")
            end
            # Get rid of the file extension
            name_array = student.name.split(".")[0..-2]
            student.name = name_array.join(".")
            student.save
        end
        semaphore.unlock
        redirect_to user_course_students_path(@user, @course)
    end

    def create
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
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
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @student = @course.students.find(params[:id])
    end

    def destroy
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @student = @course.students.find(params[:id])
        @student.destroy
        redirect_to controller: 'courses', action: 'student_index', user_id: @user, id: @course
    end

    def edit
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @student = @course.students.find(params[:id])
    end

    def update
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        @student = @course.students.find(params[:id])

        if @student.update(student_params)
            redirect_to controller: 'courses', action: 'student_index', user_id: @user, id: @course
        else
            render 'edit'
        end
    end

    # Handles student upload from an image file. Called on a per file basis.
    # The name of the file (minus the file extension) will be the name of the student.
    def import
        semaphore = Mutex.new
        semaphore.lock
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:course_id])
        # Create a new student to be populated
        student = Student.new
        student.course_id = @course.id
        student.portrait = params[:file]
        # The name of the student is the name of the image
        student.name = student.portrait_file_name
        # Check that an image was actually grabbed by ensuring name is not empty or nil
        if student.name != "" and student.name != nil
            # Replace all underscores with spaces, as file names convert spaces to underscores
            if student.name.include? "_"
                student.name.gsub!("_", " ")
            end
            # Get rid of the file extension
            name_array = student.name.split(".")[0..-2]
            student.name = name_array.join(".")
            student.save
        end
        semaphore.unlock
        redirect_to user_course_students_path(@user, @course)
    end

    private
        def student_params
            params.require(:student).permit(:name, :email, :portrait, :notes,
                                            :in_flashcards, :in_quiz)
        end
end
