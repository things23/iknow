class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:edit, :update, :destroy]

  def create
    @answer = @question.answers.build(answers_params.merge(user: current_user))
    #unless @answer.save
     # render json: @answer.errors.full_messages, status: :unprocessable_entity
   # end
      if @answer.save
        PrivatePub.publish_to "/questions/#{@question.id}/answers",
        answer: (render template: "answers/create.json.jbuilder")
      else
        respond_to do |format|
          format.js { render status: :unprocessable_entity }
        end
      end
  end

  def update
    @question = @answer.question
    unless @answer.update(answers_params)
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
    #if @answer.update(answers_params)
    #  PrivatePub.publish_to "/questions/#{@question.id}/answers",
    #  answer: (render template: "answers/update.json.jbuilder")
    #end
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
