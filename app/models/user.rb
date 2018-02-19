class User < ApplicationRecord
    has_many :courses, dependent: :destroy

    has_secure_password
    validates :password, presence: true, length: { minimum: 6, maximum: 256}
end
