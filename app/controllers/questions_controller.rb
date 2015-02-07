class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:update, :destroy]
  before_action :build_answer, only: :show

  respond_to :js, only: [:update, :subscribe]

  authorize_resource
  #load_and_authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = current_user.questions.new)
  end

  def create
    respond_with(@question = current_user.questions.create(questions_params))
  end

  def update
    @question.update(questions_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  def subscribe
    @question = Question.find(params[:id])
    @question.subscribe(current_user)
  end

  private

  def build_answer
    @question = Question.find(params[:id])
    @answer = @question.answers.build
  end

  def load_question
    @question = current_user.questions.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
