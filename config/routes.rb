Rails.application.routes.draw do

  root to: "home#index"

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

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
        get "/upVote/:id" => "answers#up_vote"
        get "/downVote/:id" => "answers#down_vote"
      end
    end
  end

  post 'signin', controller: :signin, action: :create
  post 'signup', controller: :signup, action: :create
  delete 'signin', controller: :signin, action: :destroy
  post 'authenticate', to: 'authentication#authenticate'
end
