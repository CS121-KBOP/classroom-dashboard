class Student < ApplicationRecord
    belongs_to :course
    has_attached_file :portrait, styles: { flashcard: "600x600>", small: "100x100>" }
    validates_attachment_content_type :portrait, content_type: /\Aimage\/.*\z/
end
