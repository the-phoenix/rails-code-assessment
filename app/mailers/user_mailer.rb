class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to Incubit Assessment Site")
  end

  def resetpassword_email(user, reset_email_path)
    @user = user
    @link = root_url + reset_email_path
    mail(:to => user.email, :subject => "Instruction for reset password")
  end
end
