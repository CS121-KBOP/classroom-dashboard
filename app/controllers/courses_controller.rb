class CoursesController < ApplicationController
    def index
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        courses = @user.courses
        puts "\n\n\n\n\n=============\n\n\n\n\n"
        puts courses
        puts "\n\n\n\n\n=============\n\n\n\n\n"
        @ordered_courses = Array.new
        @ordered_courses = courses.sort_by {|course| [course.year, course.semester.downcase, course.code.downcase, course.section]}
        @ordered_courses = @ordered_courses.reverse
    end

    def student_index
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:id])
        @students = @course.students
    end

    def show
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:id])
    end

    def new
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.new
    end

    def create
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.create(course_params)

        if @course.save
            redirect_to user_course_path(@user, @course)
        else
            render 'new'
      end
    end

    def edit
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:id])
    end

    def update
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:id])

        if @course.update(course_params)
            redirect_to user_course_path(@user, @course)
        else
            render 'edit'
        end
    end

    def destroy
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:id])
        @course.destroy
        redirect_to user_courses_path(@user)
    end

    def quiz
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:id])
    end

    def edit_flashcard_order
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:id])
        @course.flashcard_order = params[:flashcard_order]["edit_flashcard_order"]
        @course.save

        redirect_to user_course_path(@user, @course)
    end

    def flashcard
        # get the user and course paramaters
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
        @course = @user.courses.find(params[:id])

        # Handles Equity Drawing of Flashcards

        # If the user has never ordered the flashcards, flashcard_order will be nil.
        if @course.flashcard_order != nil
            student_list = @course.flashcard_order.split("\n")
        else
            student_list = Array.new
        end

        # first see if there is a specified student to be selected
        # if there is, pick the first student from the list
        if student_list.length == 0
            # if the list to draw from is empty, just randomly select one student from the course roster
            @flashcard_student = @course.students.where(in_flashcards: true).sample
        else
            # Get the first name of the list, and remove any leading or trailing white space
            student_name = student_list[0].rstrip
            student_name = student_name.lstrip
            @flashcard_student = Student.find_by(name: student_name)
            # Remove this student from the ordering
            new_flashcard_order = student_list[1..-1].join("\n")
            @course.flashcard_order = new_flashcard_order
            @course.save
        end
        # if there is a student to show
        if @flashcard_student != nil
            # convert the student object to a hash
            @flashcard_student_hash = @flashcard_student.attributes
            # add the student's portrait url to the hash
            @flashcard_student_hash[:portrait_url] = @flashcard_student.portrait.url(:flashcard)
        else
            # otherwise send back an empty object
            @flashcard_student_hash = {};
        end

        # Handles Quiz Drawing of Flashcards

        @quiz_student = @course.students.where(in_quiz: true).sample
        # if there is a student to show
        if @quiz_student != nil
            # convert the student object to a hash
            @quiz_student_hash = @quiz_student.attributes
            # add the student's portrait url to the hash
            @quiz_student_hash[:portrait_url] = @quiz_student.portrait.url(:flashcard)
        else
            # otherwise send back an empty object
            @quiz_student_hash = {};
        end
        # send the json back to the client
        render(json:  {"equity": @flashcard_student_hash,  "quiz": @quiz_student_hash})
    end

    def updateNotes
        @user = User.find(params[:user_id])
        ensure_proper_user(@user)
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
            params.require(:course).permit(:title, :code, :semester, :section, :year)
        end

end
