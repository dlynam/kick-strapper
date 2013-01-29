class UserMailer < ActionMailer::Base
  default :from => "WheresTheStyle@no-reply.com"

  def registration_confirmation(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to WheresTheStyle")
  end

  def password_reset(user)
    @user = user
    mail(:to => user.email, :subject => "Password Reset")
  end
  
end