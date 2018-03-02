class CreateSubmissions < ActiveRecord::Migration[5.1]
  def change
    create_table :submissions do |t|
      t.attachment :answer
      t.references :assignment, foreign_key: true
      t.references :student, foreign_key: true

      t.timestamps
    end
  end
end
