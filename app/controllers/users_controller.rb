
class UsersController < ApplicationController

  skip_before_action :authenticate_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if (@user.save)
      redirect_to('/login')
    else
      render :new, status: :unprocessable_content
    end
  end
  
  def index
    if current_user
      @pets = current_user.pets
    end
  end
  
  def show
    @user = current_user
    @pets = @user.pets  # pega todos os pets do usuário logado
  end
  
  private 
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
end
