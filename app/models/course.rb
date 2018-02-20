class Course < ApplicationRecord
    belongs_to :user
    has_many :students, dependent: :destroy
    has_many :assignments, dependent: :destroy
end
