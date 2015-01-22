class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:new, :create]
  before_action :load_answer, only: [:edit, :update, :destroy]

  def create
    @answer = @question.answers.create(answers_params.merge(user: current_user))
    unless @answer.save
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
     # render json: @answer.to_json(include: :attachments, only: :body)
      # render json: @answer
    #end
  end

  def update
    #@answer.update(answers_params)
    @question = @answer.question
    unless @answer.update(answers_params)
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def load_answer
    @answer = current_user.answers.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answers_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
