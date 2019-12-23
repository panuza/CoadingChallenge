Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      resources :users
      resources :answers
      resources :challenges
      scope :challenges, controller: "challenges" do
        get "/myChallenges/:user_id" => "challenges#my_challenges"
      end
      scope :answers, controller: "answers" do
        get "/challengeAnswers/:challenge_id" => "answers#challenge_answers"
      end
    end
  end
  root to: "home#index"
  post 'refresh', controller: :refresh, action: :create
  post 'signin', controller: :signin, action: :create
  post 'signup', controller: :signup, action: :create
  delete 'signin', controller: :signin, action: :destroy
end
