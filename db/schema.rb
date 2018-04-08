# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180224101324) do

  create_table "assignments", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "active", default: true
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_assignments_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "title"
    t.string "code"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_courses_on_user_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "notes"
    t.boolean "in_flashcards", default: true
    t.boolean "in_quiz", default: true
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "portrait_file_name"
    t.string "portrait_content_type"
    t.integer "portrait_file_size"
    t.datetime "portrait_updated_at"
    t.index ["course_id"], name: "index_students_on_course_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.string "answer_file_name"
    t.string "answer_content_type"
    t.integer "answer_file_size"
    t.datetime "answer_updated_at"
    t.integer "assignment_id"
    t.integer "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignment_id"], name: "index_submissions_on_assignment_id"
    t.index ["student_id"], name: "index_submissions_on_student_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.string "name"
    t.string "email"
    t.string "oauth_token"
    t.datetime "oauth_expires_at"
    t.integer "oauth_id", limit: 12
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
