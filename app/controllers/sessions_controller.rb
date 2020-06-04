require 'openssl'
require 'securerandom'

class SessionsController < ApplicationController
  skip_before_action :authorized, only: [:new, :create, :welcome, :forgot_password]

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
    if params[:email].nil?
      flash[:notice] = "Please input your email."
    else
      @user = User.find_by(email: params[:email])
      if @user.nil?
        flash[:notice] = "Not existing user!"
      else
        raw, enc = helpers.generate(:reset_password_token)
        flash[:notice] = nil
        current_ts = Time.now.to_i.to_s

        @user[:reset_password_token] = enc
        @user[:reset_password_sent_at] = current_ts

        if @user.save
          flash[:notice] = "We'll send you an email for reset your password."
          link = "http://localhost:3000/reset_password/" + enc + "/"
          UserMailer.resetpassword_email(@user, link).deliver
        end
      end
    end
  end


end
