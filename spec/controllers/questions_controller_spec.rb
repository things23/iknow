require 'rails_helper'

describe QuestionsController do
  let(:user) { create(:user) }
  before { sign_in user }

  describe "GET #index" do
    let(:questions) { create_list(:question, 2, user_id: user.id) }

    before { get :index, user_id: user }

    it "populates an array of all questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it "renders index view" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    let(:question) { create(:question, user_id: user.id) }

    before { get :show, user_id: user, id: question }

    it "assigns the requested question to @question" do
      expect(assigns(:question)).to eq question
    end

    it "renders show view" do
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    before { get :new, user_id: user.id }

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
        expect { post :create, user_id: user.id, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it "redirects to show view" do
        post :create, user_id: user.id, question: attributes_for(:question)
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
end
