require 'openssl'
require 'securerandom'

class SessionsController < ApplicationController
  skip_before_action :authorized,
                     only: [:new, :create, :welcome, :forgot_password, :reset_password]

  def new
    # flash[:notice] = nil
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password]) # Login success
      session[:user_id] = @user.id
      redirect_to welcome_path
    else # Or login failure
      redirect_to login_path, flash: { notice: "Invalid credentials" }
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
      flash.now[:notice] = "Please input your email."
    else
      @user = User.find_by(email: params[:email])
      if @user.nil?
        flash.now[:notice] = "Not existing user!"
      else
        raw, enc = helpers.generate(:reset_password_token)
        flash.now[:notice] = nil
        current_ts = Time.now.to_i.to_s

        @user[:reset_password_token] = enc
        @user[:reset_password_sent_at] = current_ts

        if @user.save
          flash.now[:notice] = "We'll send you an email for reset your password."
          link = "/reset_password/#{enc}/"
          UserMailer.resetpassword_email(@user, link).deliver
        end
      end
    end
  end

  def reset_password
    reset_pwd_token = params[:token]
    is_valid, error_description, user = check_token_valid(reset_pwd_token)
    flash[:error] = error_description

    if is_valid and params[:password].present?
      @user = user
      update_payload = params.permit(:password, :password_confirmation)
               .merge!(reset_password_token: nil, reset_password_sent_at: nil)

      if @user.update(update_payload)
        flash[:notice] = "Successfully Updated!"
        redirect_to root_path
      end
    end
  end

  private
  def check_token_valid(token)
    now = Time.now.to_i
    user = User.find_by(reset_password_token: token)

    if user.nil?
      [:false, "Sorry, this is invalid token!"]
    elsif (now - user[:reset_password_sent_at].to_i) >= 6 * 3600
      [:false, "Sorry, this link has expired!"]
    else
      [:true, nil, user]
    end
  end
end
