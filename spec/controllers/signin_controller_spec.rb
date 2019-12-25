require 'rails_helper'

RSpec.describe SigninController, type: :controller do

  describe 'POST #create' do
    before do 
      @user = User.create!(first_name: "panuza", last_name: "parajuli", email: "panuza@test.com", password: "12345678", password_confirmation: "12345678")
    end
    it 'returns http success' do
      post :create, params: {first_name: @user.first_name, last_name: @user.last_name, email: @user.email, password: @user.password }
      expect(response).to be_successful
      expect(response_json.keys).to eq ['csrf']
      expect(response.cookies[JWTSessions.access_cookie]).to be_present
    end

    it 'returns unauthorized for invalid params' do
      post :create, params: { email: @user.email, password: 'incorrect' }
      expect(response).to have_http_status(401)
    end
  end
end