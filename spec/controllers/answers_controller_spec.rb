require 'rails_helper'

describe AnswersController do
  sign_in_user
  let(:question) { create(:question, user_id: @user.id) }
  let(:answer) { create(:answer, user_id: @user.id, question_id: question.id) }

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new answer to the databse" do
        expect { post :create, user_id: @user.id, question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end

      it "render create template" do
        post :create, user_id: @user.id, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context "with invalid attributes" do
      it "does not save the answer" do
        expect { post :create, user_id: @user.id, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end

      it "renders new view" do
        post :create, user_id: @user.id, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe "GET #edit" do
    before { get :edit, id: answer }
    it "assigns requested answer to @answer" do
      expect(assigns(:answer)).to eq answer
    end
    it "renders edit view" do
      expect(response).to render_template :edit
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "assigns requested answer to @answer" do
        patch :update, id: answer, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it "assigns the question" do
        patch :update, id: answer, answer: attributes_for(:answer), format: :js
        expect(assigns(:question)).to eq question
      end

      it "changes answers attributes" do
        patch :update, id: answer, answer: { body: "new body" }, format: :js
        answer.reload
        expect(answer.body).to eq "new body"
      end

      it "render update template" do
        patch :update, id: answer, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes answer from related question" do
      answer
      expect{ delete :destroy, id: answer }.to change(Answer, :count).by(-1)
    end
    it "redirects to root_path" do
      delete :destroy, user_id: @user.id, id: answer
      expect(response).to redirect_to question_path(question)
    end
  end
end
