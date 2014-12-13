class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answers_params.merge(user: current_user))
    if @answer.save
      redirect_to @question
    else
      render "new"
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answers_params
    params.require(:answer).permit(:body)
  end
end
