class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :same_as_user, only: [:edit, :update]
  def show

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "You registered."
      redirect_to root_path
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your account has been updated."
      redirect_to root_path
    else
      render :edit
    end
  end


  private

  def same_as_user
    if current_user != @user
      flash[:error] = "You are not allowed to see that page."
      redirect_to root_path
    end
  end
  
  def set_user
    @user = User.find_by(slug: params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :password, :timezone)
  end
end