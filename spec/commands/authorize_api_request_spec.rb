require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
  let(:user) { User.create(first_name: 'Test', last_name: 'Test', email: 'Test@user.com', password: 'test@123', password_confirmation: 'test@123') }
  let(:header) { { 'Authorization' => token_generator(user.id) } }
  subject(:invalid_request_obj) { described_class.new({}) }
  subject(:request_obj) { described_class.new(header) }

  describe '#call' do
    context 'when valid request' do
      it 'returns user object' do
        result = request_obj.call.result
        expect(result.id).to eq(user.id)
      end
    end

    context 'when invalid request' do
      context 'when missing token' do
        it 'raises a MissingToken error' do
          expect(invalid_request_obj.call.errors).to eq({:token=>["Missing token", "Invalid token"]})
        end
      end

      context 'when token is expired' do
        let(:header) { { 'Authorization' => expired_token_generator(user.id) } }
        subject(:request_obj) { described_class.new(header) }

        it 'raises ExceptionHandler::ExpiredSignature error' do
          expect(request_obj.call.errors).to eq({:token=>["Invalid token"]})
        end
      end

      context 'fake token' do
        let(:header) { { 'Authorization' => 'foobar' } }
        subject(:invalid_request_obj) { described_class.new(header) }

        it 'handles JWT::DecodeError' do
          expect(invalid_request_obj.call.errors).to eq({:token=>["Invalid token"]})
        end
      end
    end
  end
end