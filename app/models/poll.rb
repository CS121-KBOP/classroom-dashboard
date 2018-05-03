class Poll < ApplicationRecord
    belongs_to :course
    has_many :options, :dependent => :destroy
    validates :name, presence: true,
                     length: { minimum: 3, maximum: 20 }
    validates :description,
                length: {maximum: 100 }
end
