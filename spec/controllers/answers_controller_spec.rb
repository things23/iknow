require 'rails_helper'

describe AnswersController do
  sign_in_user

  let(:question) { create(:question, user: @user) }
  let(:answer) { create(:answer, user: @user, question: question) }

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new answer to the databse" do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :json}.to change(question.answers, :count).by(1)
      end

      it "renders status: 200 " do
        post :create, question_id: question, answer: attributes_for(:answer), format: :json
        expect(response.status).to eq(200)
      end
    end

    context "with invalid attributes" do
      it "does not save the answer" do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "assigns requested answer to @answer" do
        patch :update, id: answer, answer: attributes_for(:answer), format: :json
        expect(assigns(:answer)).to eq answer
      end

      it "assigns the question" do
        patch :update, id: answer, answer: attributes_for(:answer), format: :json
        expect(assigns(:question)).to eq question
      end

      it "changes answers attributes" do
        patch :update, id: answer, answer: { body: "new body" }, format: :json
        answer.reload
        expect(answer.body).to eq "new body"
      end

      it "render update template" do
        patch :update, id: answer, answer: attributes_for(:answer), format: :json
        expect(response.status).to eq(200)
      end
    end

    context "update another users answer" do
      sign_in_another_user

      it "raises an error" do
        expect { patch :update, id: answer, answer: { body: "new new body" }, format: :js }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes answer from related question" do
      answer
      expect{ delete :destroy, id: answer, format: :js }.to change(Answer, :count).by(-1)
    end
    it "redirects to root_path" do
      delete :destroy, id: answer, format: :js
      expect(response.status).to eq(200)
    end

    context "delete another users answer" do
      sign_in_another_user

      it "raises an error" do
        expect { delete :destroy, id: answer }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
