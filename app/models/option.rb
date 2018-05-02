class Option < ApplicationRecord
    belongs_to :poll
    validates :description,
                length: {maximum: 50 }
    validates :label, presence: true,
     			length: {maximum: 5 }
end
