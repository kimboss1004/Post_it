class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]
  def new
    
  end

  def create
    user = User.find_by(username: params[:username])
  
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] ||= "Welcome #{user.username}, you logged in."
      redirect_to root_path
    else
      flash[:error] = "There is something wrong with your username or password."
      render :new
    end
  end

  def destroy
    flash[:notice] = "#{current_user.username} logged out."
    session[:user_id] = nil
    redirect_to root_path
  end
end