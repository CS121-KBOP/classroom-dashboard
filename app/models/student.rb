class Student < ApplicationRecord
    belongs_to :course
    has_attached_file :portrait, styles: { flashcard: "300x300#", small: "100x100#" }, :default_url => "/images/defaults/:style/missing.png"
    validates_attachment_content_type :portrait, content_type: /\Aimage\/.*\z/
    validates :name,
            length: {maximum: 50 }
end
