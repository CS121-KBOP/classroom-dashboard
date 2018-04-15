class Course < ApplicationRecord
    belongs_to :user
    has_many :students, dependent: :destroy
    has_many :assignments, dependent: :destroy
    has_many :polls, dependent: :destroy
    validates :semester, presence: true,
                         length: { minimum: 3, maximum: 10 }
    validates :code, presence: true,
                     length: { minimum: 3, maximum: 10 }
end
