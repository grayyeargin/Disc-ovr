class SessionsController < ApplicationController

  def login
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to :root
    else
      session[:user_id] = nil
      @error = "Incorrect Login Information"
      render '/users/login'
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to :root
  end

end