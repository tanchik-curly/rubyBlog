class AddAuthorEmailToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :author_email, :string
  end
end
