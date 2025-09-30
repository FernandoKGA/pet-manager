class PetsController < ApplicationController


  def new
    @pet = current_user.pets.build
  end

  def create
    @pet = current_user.pets.build(pet_params)
    if @pet.save
      redirect_to user_path(current_user), notice: "Pet cadastrado com sucesso!"
    else
      flash.now[:alert] = "Não foi possível salvar o pet."
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @pet = current_user.pets.find(params[:id])
  end

  private

  def pet_params
    params.require(:pet).permit(:name, :species, :breed)
  end
end
