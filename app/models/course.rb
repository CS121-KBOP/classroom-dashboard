class Course < ApplicationRecord
    belongs_to :user
    has_many :students, dependent: :destroy
    has_many :assignments, dependent: :destroy
    has_many :polls, dependent: :destroy
    validates :semester, presence: true,
                         inclusion: {in: ["SP", "FA", "SU"]}
    validates :year, presence: true,
                     format: {with: /\d\d\d\d/}
    validates :code, presence: true,
                     length: { minimum: 3, maximum: 10 }
    validates :section, presence: true
end
