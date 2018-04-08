class Submission < ApplicationRecord
  belongs_to :assignment
  has_one :student
  has_attached_file :answer
  validates_attachment_content_type :answer, content_type: /\Aimage\/.*\z/
  validates :answer, presence: true
end
