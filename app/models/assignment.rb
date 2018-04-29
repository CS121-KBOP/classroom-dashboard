class Assignment < ApplicationRecord
  belongs_to :course
  has_many :submissions, :dependent => :destroy
  validates :name, presence: true,
                   length: { minimum: 3, maximum: 20 }
end
