class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:edit, :update, :destroy]
  def index
      @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
    @answer = @question.answers.build
  end
  def new
    @question = current_user.questions.new
  end

  def edit
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

  def update
    if @question.update(questions_params)
      flash[:notice] = "Question was successfully updated"
      redirect_to @question
    else
      flash[:notice] = "Invalid title or body"
      render "edit"
    end
  end

  def destroy
    @question.destroy
    flash[:notice] = "Question was successfully deleted"
    redirect_to root_path
  end

  private

  def load_question
    @question = current_user.questions.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body)
  end
end
