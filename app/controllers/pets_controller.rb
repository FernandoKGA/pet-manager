class PetsController < ApplicationController
  before_action :set_pet, only: [:show, :edit, :update, :destroy, :add_to_memorial]

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
      render :new, status: :unprocessable_content
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
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @pet.destroy
      redirect_to user_path(current_user), notice: "Pet excluído com sucesso!"
    else
      redirect_to user_path(current_user), alert: "Não foi possível excluir o Pet."
    end
  end

  def add_to_memorial
    if @pet.add_to_memorial!
      redirect_to pets_path, notice: "#{@pet.name} foi adicionado ao memorial com sucesso."
    else
      redirect_to pet_path(@pet), alert: "Erro ao adicionar o pet ao memorial."
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
