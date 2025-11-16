class PasswordResetsController < ApplicationController
  skip_before_action :authenticate_user

  def new
    @password_reset = PasswordReset.new
  end

  def create
    @password_reset = PasswordReset.new(password_reset_params)
    @password_reset.save

    flash[:notice] = "Um link para trocar sua senha foi enviado ao seu email."
    redirect_to login_path
  end

  def edit
    @user = PasswordReset.find_by_valid_token(params[:id])
    if @user
    else
      flash[:alert] = "Seu link de trocar de senha não é válido."
      redirect_to new_password_reset_path
    end
  end

  def update
    @user = PasswordReset.find_by_valid_token(params[:id])
    if @user
      if @user.update(user_params)
        flash[:notice] = "Sua senha foi atualizada."
        redirect_to login_path
      else
        flash.now[:alert] = "Ocorreu um erro atualizando sua senha."
        render :edit, status: :unprocessable_content
      end
    else
      flash[:error] = "Seu link de trocar de senha não é válido."
      redirect_to new_password_reset_path
    end
  end

  private

  def password_reset_params
    params.require(:password_reset).permit(:email)
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
