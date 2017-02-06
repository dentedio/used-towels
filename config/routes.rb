require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq-tasks'

  resources :items, only: [:index, :show] do
    collection do
      get :fetch
    end
  end

  root to: 'items#index'
end
