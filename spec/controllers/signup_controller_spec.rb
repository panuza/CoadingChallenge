require 'rails_helper'

RSpec.describe SignupController, type: :controller do

  describe 'POST #create' do
    it 'returns http success' do
      post :create, params: {first_name: "test", last_name: "email", email: 'test@email.com', password: 'password', password_confirmation: 'password'}
      signup_response = JSON.parse(response.body)
      expect(response).to be_successful
      expect(signup_response['jwt']).to be_present
    end

    it 'creates a new user' do
      expect do
        post :create, params: {first_name: "test", last_name: "email", email: 'test@email.com', password: 'password', password_confirmation: 'password'}
      end.to change(User, :count).by(1)
    end
  end
end