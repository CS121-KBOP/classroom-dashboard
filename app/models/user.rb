class User < ApplicationRecord
    has_many :courses, dependent: :destroy
end
