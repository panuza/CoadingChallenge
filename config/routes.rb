Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      resources :answers
      resources :challenges
    end
  end
  # root to: "home#index"
end
