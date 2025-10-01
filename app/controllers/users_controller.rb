class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authorize_user!, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(create_user_params)
    if @user.save
      redirect_to('/login')
    else
      # dica: :unprocessable_entity é o símbolo correto
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update(update_user_params)
      flash[:notice] = 'Profile updated successfully'
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def authorize_user!
      redirect_to('/login') unless current_user == @user
    end

    # criação exige senha
    def create_user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end

    # edição permite senha opcional (ignora se em branco)
    def update_user_params
      permitted = params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      if permitted[:password].blank?
        permitted.delete(:password)
        permitted.delete(:password_confirmation)
      end
      permitted
    end
end
