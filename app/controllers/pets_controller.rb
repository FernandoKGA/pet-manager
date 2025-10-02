class PetsController < ApplicationController
  before_action :set_pet, only: [:show, :edit, :update]

  def new
    @pet = current_user.pets.build
  end

  def create
    @pet = current_user.pets.build(pet_params)
    if @pet.save
      redirect_to user_path(current_user), notice: "Pet cadastrado com sucesso!"
    else
      flash.now[:alert] = "Não foi possível guardar as informações do pet."
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @pet já está definido pelo before_action
  end

  def edit
    # @pet já está definido pelo before_action
  end

  def update
    if @pet.update(pet_params)
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
    params.require(:pet).permit(:name, :birthdate, :size, :species, :breed, :gender, :sinpatinhas_id)
  end
end