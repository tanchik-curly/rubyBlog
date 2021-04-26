class Article < ApplicationRecord
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy
    include Visible

    has_one_attached :article_picture, dependent: :destroy
    validates :article_picture, content_type: [:png, :jpg, :jpeg]

    validates :title, presence: true
    validates :body, presence: true, length: { minimum: 8 }
end
