Rails.application.routes.draw do
  root to: "application#redirect_to_quotes"

  namespace :api, defaults: { format: :json }  do
    namespace :v1 do
      resources :articles
      resources :users, only: %w[show]
    end
  end

 devise_for :users,
   defaults: { format: :json },
   path: '',
   path_names: {
     sign_in: 'api/v1/login',
     sign_out: 'api/v1/logout',
     registration: 'api/v1/signup'
   },
   controllers: {
     sessions: 'sessions',
     registrations: 'registrations'
   }
end
