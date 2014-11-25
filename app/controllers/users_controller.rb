class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @likes = Like.where(user_id: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    user = User.create(user_params)
    if user.valid?
      redirect_to "/login"
    else
      @errors = user.errors.full_messages
      @user = User.new
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to user
  end

  def destroy
    user = User.find(params[:id])
    user.destroy!
    redirect_to :root
  end


  private
  def user_params
    params.require(:user).permit(:username, :password, :image_url, :first_name, :last_name, :avatar)
  end

end