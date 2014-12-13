class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: :show
  def index
    if current_user
      @questions = Question.all
    else
      redirect_to new_user_session_path
    end
  end

  def show
  end

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new(questions_params)

    if @question.save
      flash[:notice] = "Question created"
      redirect_to @question
    else
      flash[:notice] = "Invalid title or body"
      render 'new'
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body)
  end
end
