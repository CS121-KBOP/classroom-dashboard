class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
        t.string :name
        t.string :email
        t.string :password_digest
        t.string :oauth_token
        t.datetime :oauth_expires_at
        t.integer :oauth_id, :limit => 12

        t.timestamps
    end
  end
end
