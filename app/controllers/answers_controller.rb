class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:update, :destroy]

  after_action :publish_answer, only: [:create, :update]

  respond_to :json, only: [:update, :create]
  respond_to :js, except: :mark_best_answer

  authorize_resource

  def create
    respond_with(@answer = @question.answers.create(answers_params.merge(user: current_user)))
  end

  def update
    @answer.update(answers_params)
    respond_with @answer
  end

  def destroy
    @answer.destroy
    respond_with @answer
  end

  def mark_best_answer
    @answer = current_user.question_answers.find(params[:id])
    @question = @answer.question
    @answer.set_best
  end

  private

  def publish_answer
    pub_json = render_to_string(template: "answers/create.json.jbuilder", locals: {answer: @answer})
    PrivatePub.publish_to("/questions/#{@question.id}/answers",
     answer: pub_json) if @answer.valid?
  end


  def load_answer
    @answer = current_user.answers.find(params[:id])
    @question = @answer.question
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answers_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
