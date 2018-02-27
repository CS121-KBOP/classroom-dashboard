class AddAttachmentPortraitToStudents < ActiveRecord::Migration[5.1]
  def self.up
    change_table :students do |t|
      t.attachment :portrait
    end
  end

  def self.down
    remove_attachment :students, :portrait
  end
end
