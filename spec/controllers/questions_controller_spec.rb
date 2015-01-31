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

  describe "PATCH #mark_best_answer" do
    let(:answer) { create(:answer, question: question, user: @user) }
    let(:question_with_best_answer) { create(:question, user: @user) }
    let(:another_answer) { create(:answer, question: question_with_best_answer, user: @user) }

    context "with valid attributes" do
      context "if best answer dosen't mark yet" do
        before { patch :mark_best_answer, id: question, answer_id: answer.id, format: :js }

        it "assigns answer's id to question's best_answer" do
          question.reload
          expect(question.best_answer).to eq answer.id
        end

        it 'renders mark_best view' do
          expect(response).to render_template :mark_best_answer
        end
      end
      context "if best answer already mark" do
        it "does not assign answer's id to question's best_answer" do
          question_with_best_answer.best_answer = 1
          question_with_best_answer.reload
          @best_answer = question_with_best_answer.best_answer

          patch :mark_best_answer, id: question_with_best_answer, answer_id: answer.id, format: :js
          expect(question_with_best_answer.best_answer).to eq @best_answer
        end
      end
    end

    context "with invalid attributes" do
      it "assigns related Answer to @question" do
        patch :mark_best_answer, id: question, answer_id: nil, format: :js
        expect(question.best_answer).to be_nil
      end
    end
  end
  # describe 'PATCH #mark_best' do
   #context 'owner question' do
   # sign_in_user
   # before { patch :mark_best, id: answer, format: :js }

   # it 'assigns requested Answer to @answer' do
   #       expect(assigns(:answer)).to eq answer
   #     end

    #    it 'assigns requested answer for question current user' do
    #      expect(assigns(:answer).question.user).to eq user
    #    end#

    #    it 'change attributes' do
    #      answer.reload
    #      expect(answer.mark_best).to be true
    #    end

    #    it 'change question solution' do
    #      expect(answer.question.reload).to be_solution
     #   end

      #  it 'renders mark_best view' do
      #    expect(response).to render_template :mark_best
      #  end
    #  end
end
