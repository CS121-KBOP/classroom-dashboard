class CreateAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :assignments do |t|
      t.string :name
      t.text :description
      t.boolean :active, default: true
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
