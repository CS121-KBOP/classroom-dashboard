class CreateStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :students do |t|
      t.string :name
      t.string :email
      t.text :notes
      t.boolean :show, default: true
      t.references :course, foreign_key: true
      t.timestamps
    end
  end
end
