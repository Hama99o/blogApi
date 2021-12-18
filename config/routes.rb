Rails.application.routes.draw do
  devise_for :users
  root to: "application#redirect_to_quotes"
  
  namespace :api do
    namespace :v1 do
      resources :articles
    end
  end
end
