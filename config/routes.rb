Rails.application.routes.draw do
  scope '/api/', defaults: { format: 'json' } do
    namespace :v1 do
      resources :users, only: [:index, :create, :show, :update, :destroy]
      resources :recipes, only: [:index, :create, :show, :update, :destroy]
      resources :groceries, only: [:index, :create, :show, :update, :destroy]
      resources :roles, only: [:index, :create, :show, :update, :destroy]
    end
  end
end
