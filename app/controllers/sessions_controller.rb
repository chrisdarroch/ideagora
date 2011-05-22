class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.authenticate(params[:details])
    if user
      session[:user_id] = user.id
      redirect_to root_url, :notice => 'Logged in!'
    else
      flash.now.alert = 'Invalid email or twitter username'
      render 'new'
    end
  end
end
