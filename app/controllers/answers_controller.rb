class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:new, :create]
  before_action :load_answer, only: [:edit, :update, :destroy]

  def new
    @answer = @question.answers.new
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answers_params.merge(user: current_user))
    if @answer.save
      flash[:notice] = "Answer was successfully created"
      redirect_to @question
    else
      render "new"
    end
  end

  def update
    if @answer.update(answers_params)
      flash[:notice] = "Answer was successfully updated"
      redirect_to @answer.question
    else
      render "edit"
    end
  end

  def destroy
    @answer.destroy
    flash[:notice] = "Answer was successfully deleted"
    redirect_to question_path(@answer.question)
  end

  private

  def load_answer
    @answer = current_user.answers.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answers_params
    params.require(:answer).permit(:body)
  end
end
