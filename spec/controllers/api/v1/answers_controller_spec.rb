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
      # emulate_user_login(@user)
      payload = { user_id: @user.id }
      session = JWTSessions::Session.new(payload: payload)
      @tokens = session.login
    end 

    describe 'GET#index' do
      it 'returns JSON response' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        get :index
        
        expect(response.status).to eq 200
        answers = JSON.parse(response.body)
        expect(answers.last["id"]).to eq @answer.id
      end
    end

    describe 'GET#challenge_answers' do
      it 'returns JSON response' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        get :challenge_answers, params: { challenge_id: @challenge.id}
        
        expect(response.status).to eq 200
        answers = JSON.parse(response.body)
        expect(answers.last["id"]).to eq @answer.id
      end
    end

    describe 'POST #show' do
      it 'should show' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]

        get :show, params: { :id => @answer.id }
        expect(response).to be_successful

      end
    end 

    describe 'POST #destroy' do
      it 'should destroy' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
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
      payload = { user_id: @user.id }
      session = JWTSessions::Session.new(payload: payload)
      @tokens = session.login
      end

      context 'with valid params' do
        it 'creates a new answer' do
          request.cookies[JWTSessions.access_cookie] = @tokens[:access]
          request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
          expect {
            post :create, params: { answer: { user_id: @user.id, 
                                    challenge_id: @new_challenge.id, 
                                    answer: "My answer to challenge"}}
          }.to change(Answer, :count).by(1)
        end

        it 'renders a JSON response with the new answer' do
          request.cookies[JWTSessions.access_cookie] = @tokens[:access]
          request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
          post :create, params: { answer: { user_id: @user.id, 
                                    challenge_id: @new_challenge.id, 
                                    answer: "My answer to challenge"}}
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
        end

        it 'unauth without CSRF' do
          request.cookies[JWTSessions.access_cookie] = @tokens[:access]
          post :create, params: { answer: { user_id: @user.id, 
                                    challenge_id: @challenge.id, 
                                    answer: "My answer to challenge"}}
          expect(response).to have_http_status(401)
        end

        it 'should not create a new answer if already answered' do
          @answer = Answer.create!(user_id: @user.id, 
                                challenge_id: @new_challenge.id,
                                answer: "Birat colie")

          request.cookies[JWTSessions.access_cookie] = @tokens[:access]
          request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
          expect {
            post :create, params: { answer: { user_id: @user.id, 
                                    challenge_id: @new_challenge.id, 
                                    answer: "My answer to challenge"}}
          }.to change(Answer, :count).by(0)
        end
      end
    end
  end 
end
