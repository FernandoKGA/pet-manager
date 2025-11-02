class VaccinationsController < ApplicationController
  before_action :set_pet
  before_action :set_vaccination, only: [:edit, :update, :destroy]

  def index
    @vaccinations = @pet.vaccinations.order(administered_on: :desc)
  end

  def new
    @vaccination = @pet.vaccinations.new
  end

  def create
    @vaccination = @pet.vaccinations.new(vaccination_params)
    if @vaccination.save
      redirect_to pet_vaccinations_path(@pet), notice: 'Vacina registrada com sucesso.'
    else
      flash.now[:alert] = @vaccination.errors.full_messages.first
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @vaccination.update(vaccination_params)
      redirect_to pet_vaccinations_path(@pet), notice: 'Vacina atualizada com sucesso.'
    else
      flash.now[:alert] = @vaccination.errors.full_messages.first
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @vaccination.destroy
    redirect_to pet_vaccinations_path(@pet), notice: 'Vacina removida com sucesso.'
  end

  private

  def set_pet
    @pet = current_user.pets.find(params[:pet_id])
  end

  def set_vaccination
    @vaccination = @pet.vaccinations.find(params[:id])
  end

  def vaccination_params
    params.require(:vaccination).permit(:vaccine_name, :administered_on, :next_due_on, :dose, :manufacturer, :batch_number, :notes)
  end
end
