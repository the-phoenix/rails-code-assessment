class UsersController < ApplicationController
  skip_before_action :authorized, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.create(signup_params)

    if @user.errors.blank? # If success
      session[:user_id] = @user.id
      redirect_to '/welcome'
    else # if failure
      render 'new'
    end
  end

  def profile
    @user = User.find(session[:user_id])
  end

  def update_profile
    @user = User.find(session[:user_id])
    if profile_params[:username].length < 5
      flash[:notice] = "Username must be at least 5 characters."
    else
      @user.assign_attributes(profile_params)
      if @user.save(:validate => false) # avoid password validate
        flash[:notice] = "Successfully Updated!"
      end
    end

    render 'profile'
  end

  private
  def profile_params
    params.require(:user).permit(:username)
  end

  private
  def signup_params
    params
      .permit(:email, :password, :password_confirmation)
      .merge!(username: params[:email].split("@")[0])
  end
end
