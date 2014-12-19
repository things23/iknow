class CommentsController < ApplicationController
  before_action :load_question
  def create
    @comment = @question.comments.create(comments_params.merge(user: current_user))
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def comments_params
    params.require(:comment).permit(:body)
  end
end
