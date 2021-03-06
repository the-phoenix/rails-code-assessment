class UsersController < ApplicationController
  skip_before_action :authorized, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.create(signup_params)

    if @user.errors.blank? # If success
      session[:user_id] = @user.id
      UserMailer.welcome_email(@user).deliver

      redirect_to profile_path
    else # if failure
      render 'new'
    end
  end

  def profile
    @user = current_user
  end

  def update_profile
    @user = current_user

    if profile_params[:username].length < 5
      flash[:notice] = "Username must be at least 5 characters."
    elsif @user.update_attributes(profile_params)
      flash[:notice] = "Successfully Updated!"
    end

    render 'profile'
  end

  private
    def profile_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end

    def signup_params
      params
        .permit(:email, :password, :password_confirmation)
        .merge!(username: params[:email].split("@")[0])
    end
end
