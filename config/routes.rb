Rails.application.routes.draw do
  devise_for :users 
  root to: "home#index"

  get '/articles/my_articles', to: 'articles#my_articles'

  get '/search', to: 'articles#search'

  get '/category_filter', to: 'articles#category_filter'

  resources :articles do
    resources :comments
  end
  resources :articles do
    resources :likes
  end
end
