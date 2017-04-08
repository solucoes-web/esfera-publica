Rails.application.routes.draw do
  resources :items, only: [:show, :index]
  resources :feeds
  get 'tag/:tag/items', to: "items#index", as: 'tag-items'
  get 'tag/:tag/feeds', to: "feeds#index", as: 'tag-feeds'
  root to: "items#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
