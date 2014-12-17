require 'rails_helper'

describe AnswersController do
  sign_in_user
  let(:question) { create(:question, user_id: @user.id) }
  let(:answer) { create(:answer, user_id: @user.id, question_id: question.id) }

  describe "GET #new" do
    before { get :new, user_id: @user.id, question_id: question }

    it "assigns a new Answer to @answer" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it "render new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new answer to the databse" do
        expect { post :create, user_id: @user.id, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it "redirects to related questions show view" do
        post :create, user_id: @user.id, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

    context "with invalid attributes" do
      it "does not save the answer" do
        expect { post :create, user_id: @user.id, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it "renders new view" do
        post :create, user_id: @user.id, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
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
        patch :update, id: answer, answer: attributes_for(:answer)
        expect(assigns(:answer)).to eq answer
      end

      it "changes answers attributes" do
        patch :update, id: answer, answer: { body: "new body" }
        answer.reload
        expect(answer.body).to eq "new body"
      end

      it "redirects to related question" do
        patch :update, id: answer, answer: attributes_for(:answer)
        expect(response).to redirect_to question
      end
    end

    context "with invalid attributes" do
      before { patch :update, id: answer, answer: { body: nil } }
      it "does not changes answers attributes" do
        answer.reload
        expect(answer.body).to eq "MyText"
      end

      it "re-enders edit view" do
        expect(response).to render_template :edit
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
