class Submission < ApplicationRecord
  belongs_to :assignment
  has_one :student
  validates :answer, presence: true
end
