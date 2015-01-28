class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, except: :show
  def index
    @answers = @question.answers
    respond_with @answers
  end

  def show
    respond_with @answer = Answer.find(params[:id])
  end

  def create
    respond_with(@answer = @question.answers.create(answers_params.merge(user: current_resource_owner)))
  end

  private

  def answers_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
