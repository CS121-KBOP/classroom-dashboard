class Submission < ApplicationRecord
  belongs_to :assignment
  has_one :
  validates :answer, presence: true
end
