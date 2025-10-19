class MedicationsController < ApplicationController
  before_action :set_pet, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :set_medication, only: [:edit, :update, :destroy]

  def index
    @medications = @pet.medications
  end

  def new
    @medication = @pet.medications.build
  end

  def create
    @medication = @pet.medications.build(medication_params)
    if @medication.save
      redirect_to root_path, notice: 'Medicamento adicionado com sucesso'
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @medication.update(medication_params)
      redirect_to root_path, notice: 'Medicamento atualizado com sucesso'
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @medication.destroy
    redirect_to root_path, notice: 'Medicamento removido com sucesso'
  end

  private

  def set_pet
    @pet = Pet.find(params[:pet_id])
  end

  def set_medication
    @medication = Medication.find(params[:id])
  end

  def medication_params
    params.require(:medication).permit(:name, :dosage, :frequency, :start_date)
  end
end