class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
        t.string :title
        t.string :code
        t.integer :section
        t.text :semester
        t.integer :year, default: Date.today.year
        t.text :flashcard_order
        t.references :user, foreign_key: true

        t.timestamps
    end
  end
end
