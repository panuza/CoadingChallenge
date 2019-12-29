require 'rails_helper'

describe Api::V1::AnswersController, type: :controller do
  render_views

  describe "answers controller" do 
    before do 
      @user = User.create!(first_name: "panuza", last_name: "parajuli", email: "panuza@test.com", password: "12345678", password_confirmation: "12345678")
      @challenge = Challenge.create!(user_id: @user.id, 
                                      name: "First challenge", 
                                      description: "My challenge description", 
                                      question: "What is your favourite game?",
                                      category: "Sports",
                                      difficulty_level: "1")
      @answer = Answer.create!(user_id: @user.id, 
                                challenge_id: @challenge.id,
                                answer: "Birat colie")
      token = JsonWebToken.encode(user_id: @user.id)
      @request.headers['Authorization'] = token
      @request.headers['CONTENT_TYPE'] = 'application/json'
    end 

    describe 'GET#index' do
      it 'returns JSON response' do
        get :index
        
        expect(response.status).to eq 200
        answers = JSON.parse(response.body)
        expect(answers.last["id"]).to eq @answer.id
      end
    end

    describe 'GET#challenge_answers' do
      it 'returns JSON response' do
        get :challenge_answers, params: { challenge_id: @challenge.id}
        
        expect(response.status).to eq 200
        answers = JSON.parse(response.body)
        expect(answers.last["id"]).to eq @answer.id
      end
    end

    describe 'POST #show' do
      it 'should show' do
        get :show, params: { :id => @answer.id }
        expect(response).to be_successful

      end
    end 

    describe 'POST #destroy' do
      it 'should destroy' do
        expect {
          delete :destroy, params: { id: @answer.id }
        }.to change(Answer, :count).by(-1)
      end
    end

    describe 'POST #create' do
      before do
        @new_challenge = Challenge.create!(user_id: @user.id, 
                                      name: "New challenge", 
                                      description: "My challenge description", 
                                      question: "What is your favourite game?",
                                      category: "Sports",
                                      difficulty_level: "1")
      token = JsonWebToken.encode(user_id: @user.id)
      @request.headers['Authorization'] = token
      @request.headers['CONTENT_TYPE'] = 'application/json'
      end

      context 'with valid params' do
        it 'creates a new answer' do
          expect {
            post :create, params: { answer: { user_id: @user.id, 
                                    challenge_id: @new_challenge.id, 
                                    answer: "My answer to challenge"}}
          }.to change(Answer, :count).by(1)
        end

        it 'renders a JSON response with the new answer' do
          post :create, params: { answer: { user_id: @user.id, 
                                    challenge_id: @new_challenge.id, 
                                    answer: "My answer to challenge"}}
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
        end

        it 'unauth without token' do
          @request.headers['Authorization'] = ''
          post :create, params: { answer: { user_id: @user.id, 
                                    challenge_id: @challenge.id, 
                                    answer: "My answer to challenge"}}
          expect(response).to have_http_status(401)
        end

        it 'should not create a new answer if already answered' do
          @answer = Answer.create!(user_id: @user.id, 
                                challenge_id: @new_challenge.id,
                                answer: "Birat colie")

          expect {
            post :create, params: { answer: { user_id: @user.id, 
                                    challenge_id: @new_challenge.id, 
                                    answer: "My answer to challenge"}}
          }.to change(Answer, :count).by(0)
        end
      end
    end

    describe 'GET#up_vote' do
      it 'should allow user to upvote successfully' do
        get :up_vote, params: { id: @answer.id}
        answers = JSON.parse(response.body)
        expect(answers["error"]).to eq("You have voted up successfully.") 
      end
    end

    describe 'GET#down_vote' do
      it 'should not allow user to downvote if skill level is less then 10' do
        @user.update_attribute(:skill_level, 0)
        get :down_vote, params: { id: @answer.id}
        answers = JSON.parse(response.body)
        expect(answers["error"]).to eq("You have no sufficient skill level to vote down this answer.") 
      end

      it 'should allow user to downvote' do
        @user.update_attribute(:skill_level, 10)
        get :down_vote, params: { id: @answer.id}
        answers = JSON.parse(response.body)
        expect(answers["error"]).to eq("You have voted down successfully.") 
      end
    end
  end 
end
