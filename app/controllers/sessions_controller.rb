class SessionsController < ApplicationController
  def new
    redirect_to user_path(current_user) if logged_in?
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if !!user && user.authenticate(params[:session][:password])
      login(user)
      redirect_to user_path(user)
    else
      message = "Algo deu errado! Por favor, verifique suas credenciais."
      redirect_to login_path, alert: message
    end
  end
end
