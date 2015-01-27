require 'rails_helper'

describe 'Users API' do
  describe 'GET /index' do
    context 'unauthorized' do

      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:users) { create_list(:user, 2) }
      let(:user) { users.first }

      #let!(:questions) { create_list(:question, 2) }
      #let(:question) { questions.first }
      #let!(:answer) { create(:answer, question: question, user: user) }

      before { get '/api/v1/users', format: :json, access_token: access_token.token }

      it 'returns 200' do
        expect(response).to be_success
      end

      it 'returns list of users except authenticated user' do
        expect(response.body).to have_json_size(2).at_path("users")
      end

      %w(id email created_at updated_at).each do |attr|
        it 'user object contains #{attr}' do
          expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("users/0/#{attr}")
        end
      end
    end
  end
end