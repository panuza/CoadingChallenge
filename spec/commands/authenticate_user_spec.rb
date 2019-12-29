require 'rails_helper'

RSpec.describe AuthenticateUser do
  let(:user) { User.create(first_name: 'Test', last_name: 'Test', email: 'Test@user.com', password: 'test@123', password_confirmation: 'test@123') }
  subject(:valid_auth_obj) { described_class.new(user.email, user.password) }
  subject(:invalid_auth_obj) { described_class.new('foo', 'bar') }

  describe '#call' do
    context 'when valid credentials' do
      it 'returns an auth token' do
        token = valid_auth_obj.call
        expect(token).to_not be_nil
      end
    end

    context 'when invalid credentials' do
      it 'raises an authentication error' do
        expect(invalid_auth_obj.call.errors).to eq ({:user_authentication => ["invalid credentials"]})
      end
    end
  end
end
