require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq-tasks'

  scope "/:locale", locale: /#{I18n.available_locales.join("|")}/ do
    resources :items, only: [:index, :show] do
      collection do
        get :fetch
      end
    end
  end

  root to: 'items#index'
end
