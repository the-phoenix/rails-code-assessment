class SessionsController < ApplicationController
  skip_before_action :authorized,
                     only: [:new, :create, :forgot_password, :reset_password]

  def new
    # flash[:notice] = nil
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password]) # Login success
      session[:user_id] = @user.id
      redirect_to profile_path
    else # Or login failure
      redirect_to login_path, flash: { notice: "Invalid credentials" }
    end
  end

  def destroy
    session[:user_id] = nil

    redirect_to login_path
  end

  def forgot_password
    given_email = params[:email]
    flash.now[:notice] = "Please input your email." if given_email.nil?

    @user = User.find_by(email: given_email) unless given_email.nil?
    flash.now[:notice] = "Not existing user!" if @user.nil? and given_email

    if @user.present?
      current_ts = Time.now.to_i.to_s
      _, enc = helpers.generate(:reset_password_token)

      @user[:reset_password_token] = enc
      @user[:reset_password_sent_at] = current_ts

      if @user.save
        flash.now[:notice] = "We'll send you an email for reset your password."
        link = "#{root_url}/reset_password/#{enc}/"

        UserMailer.resetpassword_email(@user, link).deliver
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
