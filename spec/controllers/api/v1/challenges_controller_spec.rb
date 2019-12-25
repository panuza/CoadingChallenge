require 'rails_helper'

describe Api::V1::ChallengesController, type: :controller do
  render_views

  describe "challenges controller" do 
    before do 
      @user = User.create!(first_name: "panuza", last_name: "parajuli", email: "panuza@test.com", password: "12345678", password_confirmation: "12345678")
      @challenge = Challenge.create!(user_id: @user.id, 
                                      name: "First challenge", 
                                      description: "My challenge description", 
                                      question: "What is your favourite game?",
                                      category: "Sports",
                                      difficulty_level: "1")
      payload = { user_id: @user.id }
      session = JWTSessions::Session.new(payload: payload)
      @tokens = session.login
    end 

    describe 'GET#index' do
      it 'returns JSON response' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        get :index
        
        expect(response.status).to eq 200
        challenges = JSON.parse(response.body)
        expect(challenges.last["id"]).to eq @challenge.id
      end
    end

    describe 'GET#my_challenges' do
      it 'returns JSON response' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        get :my_challenges, params: {user_id: @user.id}
        
        expect(response.status).to eq 200
        challenges = JSON.parse(response.body)
        expect(challenges.last["id"]).to eq @challenge.id
      end
    end


    describe 'POST #show' do
      it 'should show' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]

        get :show, params: { :id => @challenge.id }
        expect(response).to be_successful

      end
    end 

    describe 'POST #destroy' do
      it 'should destroy' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
        expect {
          delete :destroy, params: { id: @challenge.id }
        }.to change(Challenge, :count).by(-1)
      end
    end

    describe 'POST #create' do

      context 'with valid params' do
        it 'creates a new challenge' do
          request.cookies[JWTSessions.access_cookie] = @tokens[:access]
          request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
          expect {
            post :create, params: { challenge: { user_id: @user.id, 
                                    name: "Second challenge", 
                                    description: "My challenge description", 
                                    question: "Who is your favourite player?",
                                    category: "Sports",
                                    difficulty_level: "1"}}
          }.to change(Challenge, :count).by(1)
        end

        it 'renders a JSON response with the new challenge' do
          request.cookies[JWTSessions.access_cookie] = @tokens[:access]
          request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
          post :create, params: { challenge: { user_id: @user.id, 
                                    name: "Second challenge", 
                                    description: "My challenge description", 
                                    question: "Who is your favourite player?",
                                    category: "Sports",
                                    difficulty_level: "1"}}
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
        end

        it 'unauth without CSRF' do
          request.cookies[JWTSessions.access_cookie] = @tokens[:access]
          post :create, params: { challenge: { user_id: @user.id, 
                                    name: "Second challenge", 
                                    description: "My challenge description", 
                                    question: "Who is your favourite player?",
                                    category: "Sports",
                                    difficulty_level: "1"}}
          expect(response).to have_http_status(401)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        it 'updates the requested challenge' do
          request.cookies[JWTSessions.access_cookie] = @tokens[:access]
          request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
          put :update, params: { id: @challenge.id, challenge: { user_id: @user.id, 
                                    name: "updated challenge", 
                                    description: "My challenge description", 
                                    question: "Who is your favourite player?",
                                    category: "Sports",
                                    difficulty_level: "2"}}
          # put :update, params: { id: challenge.id, challenge: new_attributes }
          @challenge.reload
          expect(@challenge.name).to eq "updated challenge"
        end

        it 'renders a JSON response with the challenge' do
          request.cookies[JWTSessions.access_cookie] = @tokens[:access]
          request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
          put :update, params: { id: @challenge.id, challenge: { user_id: @user.id, 
                                    name: "updated challenge", 
                                    description: "My challenge description", 
                                    question: "Who is your favourite player?",
                                    category: "Sports",
                                    difficulty_level: "2"}}
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end
    end
  end 
end
