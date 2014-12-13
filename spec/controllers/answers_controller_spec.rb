require 'rails_helper'

describe AnswersController do
  let(:question) { create(:question) }

  describe "GET #show" do
    let(:answer) { create(:answer, question_id: question.id) }

    before { get :show, question_id: question, id: answer }
    it "assigns the requested answer to @answer" do
      expect(assigns(:answer)).to eq answer
    end
  end

  describe "GET #new" do
    before { get :new, question_id: question }
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
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(Answer, :count).by(1)
      end
      it "redirects to related questions show view" do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(assigns(:answer).question)
      end
    end

    context "with invalid attributes" do
      it "does not save the answer" do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it "renders new view" do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end
end