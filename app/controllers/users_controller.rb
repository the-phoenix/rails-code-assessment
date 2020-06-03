class UsersController < ApplicationController
  skip_before_action :authorized, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    payload_with_username = params
                                .permit(:email, :password, :password_confirmation)
                                .merge!(username: params[:email].split("@")[0])
    @user = User.create(payload_with_username)

    if @user.errors.blank? # If success
      session[:user_id] = @user.id
      redirect_to '/welcome'
    else # if failure
      render 'new'
    end
  end
end
