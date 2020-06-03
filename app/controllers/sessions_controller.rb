class SessionsController < ApplicationController
  skip_before_action :authorized, only: [:new, :create, :welcome]

  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to '/welcome'
    else
      redirect_to '/login'
    end
  end

  def logout
    session[:user_id] = nil

    redirect_to '/welcome'
  end

  def welcome
    puts session[:user_id]
  end

  def page_requires_login
  end
end
