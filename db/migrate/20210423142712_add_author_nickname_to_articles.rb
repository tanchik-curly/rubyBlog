class AddAuthorNicknameToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :author_nickname, :string
  end
end
