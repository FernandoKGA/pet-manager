class UsersController < ApplicationController
  
  def index
    if current_user
      @pets = current_user.pets
    end
  end
  
  
  def show
    @user = current_user
    @pets = @user.pets  # pega todos os pets do usuário logado
  end


end
