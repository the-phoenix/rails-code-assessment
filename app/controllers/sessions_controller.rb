require 'openssl'
require 'securerandom'

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

  def destroy
    session[:user_id] = nil

    redirect_to root_path
  end

  def welcome
  end

  def forgot_password
    raw, enc = helpers.generate(:reset_password_token)
    if params[:email].nil?
      flash[:notice] = "Please input your email."
    else
      @user = User.find_by(email: params[:email])
      if @user.nil?
        flash[:notice] = "Not existing user!"
      else
        flash[:notice] = nil
        token = Time.now.to_i.to_s

        @user[:reset_password_token] = token
        @user[:reset_password_sent_at] = token

        if @user.save
          # link = "http://localhost:3000/resetpassword/" + token + "/"
          # UserMailer.forgotpassword_email(@user, link).deliver
          redirect_to root_path
        end
      end
    end
  end


end
