class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: [:new, :create]

  def new
    redirect_to user_path(current_user) if logged_in?
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if !!user && user.authenticate(params[:session][:password])
      login(user)
      redirect_to user_path(user)
    else
      flash[:danger] = "Algo deu errado! Por favor, verifique suas credenciais."
      redirect_to login_path
    end
  end

  def destroy
    logout
    flash[:success] = 'Logout com sucesso'
    redirect_to login_path
  end
end
