require 'rails_helper'

#RSpec.describe QuestionsController, :type => :controller do
describe QuestionsController do
  describe "GET #show" do
    let(:question) { create(:question) }
    before { get :show, id: question }
    it "assigns the requested question to @question" do
      expect(assigns(:question)).to eq question
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
  end
end
