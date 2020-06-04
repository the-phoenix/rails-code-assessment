class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to Incubit Assessment Site")
  end

  def resetpassword_email(user, link)
    @user = user
    @link = link
    mail(:to => user.email, :subject => "Instruction for reset password")
  end
end
