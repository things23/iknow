class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: :show

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    respond_with @question
  end

  def create
    respond_with(@question = current_resource_owner.questions.create(questions_params))
  end

  private

  def questions_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question = Question.find(params[:id])
  end
end