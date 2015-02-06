class UsersController < ApplicationController
  skip_authorization_check

  def index
    @users = User.order(id: :asc)
  end

  def show
    @user = User.find(params[:id])
  end

end