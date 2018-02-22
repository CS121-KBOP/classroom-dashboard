class Student < ApplicationRecord
    belongs_to :course

    def self.import(file, course)
        spreadsheet = Roo::Spreadsheet.open(file.path)
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
            row = Hash[[header, spreadsheet.row(i)].transpose]
            student = find_by_id(row["id"]) || new
            student.attributes = row.to_hash
            student.course_id = course.id
            student.save!
        end
    end
end
