class Article < ApplicationRecord
    has_many :comments
    include Visible

    validates :title, presence: true
    validates :body, presence: true, length: { minimum: 2 }
end
