Rails.application.routes.draw do

  devise_for :users
  root to: 'pages#home'

  resources :itineraries, only: [:index, :show, :new, :create]
  get '/mon-compte', to: "pages#my_account"
end
