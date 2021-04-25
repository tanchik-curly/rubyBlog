class HomeController < ApplicationController
  def index
    @articles = Article.all
    redirect_to articles_path(@articles)
  end
end
