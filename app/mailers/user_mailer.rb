class UserMailer < ApplicationMailer
  default from: 'noreply@petmanager.herokuapp.com'

  def password_reset(user)
    @user = user
    mail(to: @user.email, subject: "Trocar sua senha")
  end
end
