class UsersController < ApplicationController
  def show
    @user = current_user
    @pets = @user.pets  # pega todos os pets do usuário logado
  end
end
