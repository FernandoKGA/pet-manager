class UsersController < ApplicationController
  include NotificationCenterContext

  skip_before_action :authenticate_user, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :remove_photo]
  before_action :authorize_user!, only: [:edit, :update, :remove_photo]

  def new
    @user = User.new
  end

  def create
    @user = User.new(create_user_params)
    if @user.save
      redirect_to('/login')
    else
      render :new, status: :unprocessable_content
    end
  end
  
  def show
    @user = current_user
    @pets = @user.pets
    prepare_notification_center_context(user: @user)
  end

  def edit
  end

  def update
    if params[:user][:photo_upload].present?
      @user.attach_uploaded_file(params[:user][:photo_upload])
    end

    if @user.update(update_user_params)
      flash[:notice] = 'Profile updated successfully'
      redirect_to @user
    else
      render :edit, status: :unprocessable_content
    end
  end

  def remove_photo
    @user.remove_photo!
    redirect_to edit_user_path(@user), notice: "Foto removida!"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user!
    redirect_to('/login') unless current_user == @user
  end

  def create_user_params
    params.require(:user).permit(
      :first_name, :last_name, :email,
      :password, :password_confirmation
    )
  end

  def update_user_params
    permitted = params.require(:user).permit(
      :first_name, :last_name, :email,
      :password, :password_confirmation
    )

    if permitted[:password].blank?
      permitted.delete(:password)
      permitted.delete(:password_confirmation)
    end

    permitted
  end
end
