class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:update, :destroy]
  #after_action :publish_answer, only: :create

  respond_to :json, only: :update
  respond_to :js, except: :create

  authorize_resource

  def create
    @answer = @question.answers.build(answers_params.merge(user: current_user))
    if @answer.save
      PrivatePub.publish_to("/questions/#{@question.id}/answers",
        answer: (render template: "answers/create.json.jbuilder"))
    else      respond_to do |format|
        format.js { render status: :unprocessable_entity }
      end
    end
    #почти решение, подумать по поводу статуса ошибки
    #respond_with(@answer = @question.answers.create(answers_params.merge(user: current_user)))
  end

  def update
    #unless @answer.update(answers_params)
    #  render json: @answer.errors.full_messages, status: :unprocessable_entity
    #end
    @answer.update(answers_params)
    respond_with @answer
    #if @answer.update(answers_params)
    #  PrivatePub.publish_to "/questions/#{@question.id}/answers",
    #  answer: (render template: "answers/update.json.jbuilder")
    #end
  end

  def destroy
    respond_with(@answer.destroy)
  end

  private
  def publish_answer
    pub_json = render_to_string(template: "answers/create.json.jbuilder", locals: {answer: @abswer})
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
