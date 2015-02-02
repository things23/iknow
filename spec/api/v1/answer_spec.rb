require 'rails_helper'

describe 'Answers API' do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answers) { create_list(:answer, 2, question: question, user: user) }
  let(:answer) { answers.first }
  let!(:comment) { create(:comment, commentable: answer, user: user) }
  let!(:attachment) { create :attachment, attachmentable: answer, user: user }

  describe 'GET /index' do
    let(:access_token) { create(:access_token) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'returns 200' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path("answers")
      end

      %w(id body created_at updated_at).each do |attr|
        it 'answer object contains #{attr}' do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json}.merge(options)
    end
  end

  describe 'Get /show' do
    let(:access_token) { create(:access_token) }

    it_behaves_like "API Authenticable"

    context 'authorized' do

      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'returns 200' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it 'answer object contains #{attr}' do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context "comments" do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it 'contains #{attr}' do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context "attachments" do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end

        %w(id file).each do |attr|
          it 'contains #{attr}' do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("answer/attachments/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe "POST /create" do

    let(:access_token) { create(:access_token) }

    it_behaves_like "API Authenticable"

    context 'authorized' do

      context "with valid attributes"
        it 'returns 201' do
          post "/api/v1/questions/#{question.id}/answers", question_id: question, answer: attributes_for(:answer), user: user, format: :json, access_token: access_token.token
          expect(response.status).to eq 201
        end

        it 'saves the new answer in the database' do
          expect {
            post "/api/v1/questions/#{question.id}/answers", question_id: question, answer: attributes_for(:answer), user: user, format: :json, access_token: access_token.token
          }.to change(Answer, :count).by(1)
      end

      context "with invalid attributes" do
        it 'returns 422' do
          post "/api/v1/questions/#{question.id}/answers", question_id: question, answer: attributes_for(:invalid_answer), user: user, format: :json, access_token: access_token.token
          expect(response.status).to eq 422
        end

        it 'does not save the new answer in the database' do
          expect {
            post "/api/v1/questions/#{question.id}/answers", question_id: question, answer: attributes_for(:invalid_answer), user: user, format: :json, access_token: access_token.token
          }.to_not change(Answer, :count)
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end
end