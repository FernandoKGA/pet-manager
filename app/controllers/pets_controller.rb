class PetsController < ApplicationController
  before_action :set_pet, only: [:show, :edit, :update]

  def new
    @pet = current_user.pets.build
  end

  def create
    @pet = current_user.pets.build(pet_params.except(:photo_file))

    if params.dig(:pet, :photo_file).present?
      @pet.attach_uploaded_file(params[:pet][:photo_file])
    end

    if @pet.save
      redirect_to user_path(current_user), notice: "Pet cadastrado com sucesso!"
    else
      flash.now[:alert] = "Não foi possível guardar as informações do pet."
      render :new, status: :unprocessable_entity
    end
  end

  def show

  end

  def edit

  end

  def update
    if params.dig(:pet, :photo_file).present?
      @pet.attach_uploaded_file(params[:pet][:photo_file])
    end

    if @pet.update(pet_params.except(:photo_file))
      redirect_to user_path(current_user), notice: "Pet atualizado com sucesso!"
    else
      flash.now[:alert] = "Não foi possível atualizar as informações do pet."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_pet
    @pet = current_user.pets.find(params[:id])
  end

  def pet_params
    params.require(:pet).permit(
      :name, :birthdate, :size, :species, :breed, :gender, :sinpatinhas_id,
      :photo_file
    )
  end
end
