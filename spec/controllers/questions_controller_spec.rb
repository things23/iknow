require 'rails_helper'

describe QuestionsController do
  sign_in_user
  let(:question) { create(:question, user: @user) }

  describe "GET #index" do
    let(:questions) { create_list(:question, 2) }

    before { get :index}

    it "populates an array of all questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it "renders index view" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do

    before { get :show, id: question }

    it "assigns the requested question to @question" do
      expect(assigns(:question)).to eq question
    end

    it "assigns new answer for question" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it "renders show view" do
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    before { get :new }

    it "assigns a new Question to @question" do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it "renders new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new question in the database" do
        expect { post :create, user: @user, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it "redirects to show view" do
        post :create, user: @user, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context "with invalid attributes" do
      it "does not save the question" do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it "renders new view" do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "assigns requested question to @question" do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it "changes question attributes" do
        patch :update, id: question, question: {title: "new title", body: "new body" }, format: :js
        question.reload
        expect(question.title).to eq "new title"
        expect(question.body).to eq "new body"
      end
    end

    context "update another users question" do
      sign_in_another_user

      it "raises an error" do
        expect { patch :update, id: question, question: {title: "new title", body: "new body" }, format: :js }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "with invalid attributes" do
      before {  patch :update, id: question, question: { title: "new title", body: nil }, format: :js }
      it "does not change questions attributes" do
        question.reload
        expect(question.title).to eq "MyQuestion"
        expect(question.body).to eq "Body of my question"
      end
    end
  end

  describe "DELETE #destroy" do
    before { question }
    it "deletes question " do
      expect{ delete :destroy, user: @user, id: question }.to change(Question, :count).by(-1)
    end

    it "redirect to index view" do
      delete :destroy, user: @user, id: question
      expect(response).to redirect_to questions_path
    end

    context "delete another users question" do
      sign_in_another_user

      it "raises an error" do
        expect { delete :destroy, user: @user, id: question }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "PATCH #subscribe" do
  let(:user) { create(:user) }
    it "should call subscribe method on question with user" do
      expect(question).to receive(:subscribe).with(user)
      question.subscribe(user)
    end

    it "render subscribe template" do
      patch :subscribe, id: question, format: :js
      expect(response).to render_template :subscribe
    end
  end
end
