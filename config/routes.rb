Rails.application.routes.draw do
  get 'sessions/new'

  get '/signup', to: 'users#new'

  get '/about', to: 'static_pages#about'
  get '/help', to: 'static_pages#help'
  get '/contact', to: 'static_pages#contact'
  post '/signup', to: 'users#create'
  root 'static_pages#home'
  # root 'application#hello'
  resources :users
end
