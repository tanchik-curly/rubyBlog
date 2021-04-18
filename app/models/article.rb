class Article < ApplicationRecord
    has_many :comments, dependent: :destroy
    include Visible

    validates :title, presence: true
    validates :body, presence: true, length: { minimum: 8 }
end
