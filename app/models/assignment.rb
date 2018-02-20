class Assignment < ApplicationRecord
  belongs_to :course
  has_many :submissions
  validates :name, presence: true,
                   length: { minimum: 3 }
end
