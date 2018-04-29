class CreateOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :options do |t|
      t.string :label
      t.text :description
      t.integer :votes, :default => 0
      t.references :poll, foreign_key: true

      t.timestamps
    end
  end
end
