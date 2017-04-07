Rails.application.routes.draw do
  resources :items, only: [:show, :index]
  resources :feeds
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
