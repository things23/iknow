class CommentsController < ApplicationController
  before_action :load_commentable


  def create
    @comment = @commentable.comments.new(comments_params.merge(user: current_user))

    if @comment.save
      if params[:question_id]
        redirect_to @commentable
      else
        redirect_to @commentable.question
      end
    else
      render :new
    end
  end

  private

  def load_commentable
    resource, id = request.path.split('/')[1,2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def comments_params
    params.require(:comment).permit(:body)
  end
end
