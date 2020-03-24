require "sidekiq/web"

Rails.application.routes.draw do

  devise_for :users
  root to: 'pages#home', as: 'home'

  resources :itineraries, only: [:index, :show, :new, :create] do
    resources :favorites, only: [:create, :destroy]
  end
  resources :favorites, only: [:index]
  get '/concept', to: "pages#concept"

  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
