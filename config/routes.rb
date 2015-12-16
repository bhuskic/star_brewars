Rails.application.routes.draw do
  scope '/api/', defaults: { format: 'json' } do
    namespace :v1 do
      resources :users, only: [:index, :create, :show, :update, :destroy]
      resources :recipes, only: [:index, :create, :show, :update, :destroy]
      resources :roles, only: [:index, :create, :show, :update, :destroy]
      resources :ingredients, only: [:index, :create, :show, :update, :destroy]
      resources :sessions, only: [:create]
    end
  end
end
