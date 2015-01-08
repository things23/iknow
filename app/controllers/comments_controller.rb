class CommentsController < ApplicationController
  before_action :load_commentable


  def create
    @comment = @commentable.comments.build(comments_params.merge(user: current_user))
    if @comment.save
      render json: @comment
    end
  end

  private

  def load_commentable
    #resource, id = request.path.split('/')[1,2]
    #@commentable = resource.singularize.classify.constantize.find(id)
    if params[:question_id]
      @commentable = Question.find(params[:question_id])
    else
      @commentable = Answer.find(params[:answer_id])
    end
  end

  def comments_params
    params.require(:comment).permit(:body)
  end
end
