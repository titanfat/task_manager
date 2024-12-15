Rails.application.routes.draw do
  
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
