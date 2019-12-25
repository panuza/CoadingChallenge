require 'rails_helper'

RSpec.describe SignupController, type: :controller do

  describe 'POST #create' do
    it 'returns http success' do
      post :create, params: {first_name: "test", last_name: "email", email: 'test@email.com', password: 'password', password_confirmation: 'password'}
      expect(response).to be_successful
      expect(response_json.keys).to eq ['csrf']
      expect(response.cookies[JWTSessions.access_cookie]).to be_present
    end

    it 'creates a new user' do
      expect do
        post :create, params: {first_name: "test", last_name: "email", email: 'test@email.com', password: 'password', password_confirmation: 'password'}
      end.to change(User, :count).by(1)
    end
  end
end