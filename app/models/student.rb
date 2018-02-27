class Student < ApplicationRecord
    belongs_to :course

    # credit to https://rubyplus.com/articles/4131-Import-Records-from-CSV-and-Excel-in-Rails-5 for this!
    def self.import(file, course)
        spreadsheet = Roo::Spreadsheet.open(file.path)
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |row_num|
            row = Hash[[header, spreadsheet.row(row_num)].transpose]
            student = Student.new
            student.attributes = row.to_hash
            student.course_id = course.id
            student.save
        end
    end
end
