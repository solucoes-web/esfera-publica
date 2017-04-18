Rails.application.routes.draw do
  devise_for :users
  resources :items, only: [:show, :index]
  resources :feeds, except: :show
  root to: "feeds#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
