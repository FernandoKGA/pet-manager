class MedicalAppointmentsController < ApplicationController
  before_action :set_pet
  before_action :set_medical_appointment, only: %i[show edit update destroy]

  def index
    @medical_appointments = @pet.medical_appointments.order(appointment_date: :desc)
  end

  def show
  end

  def new
    @medical_appointment = @pet.medical_appointments.new
  end

  def create
    @medical_appointment = @pet.medical_appointments.new(medical_appointment_params)

    if @medical_appointment.save
      redirect_to pet_medical_appointment_path(@pet, @medical_appointment), notice: 'Consulta Veterinária cadastrada com sucesso!'
    else
      flash.now[:alert] = "Não foi possível salvar as informações da consulta veterinária do pet."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @medical_appointment.update(medical_appointment_params)
      redirect_to pet_medical_appointment_path(@pet, @medical_appointment), notice: 'Consulta Veterinária atualizada com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pet = Pet.find(params[:pet_id])
    @medical_appointment = @pet.medical_appointments.find(params[:id])
    @medical_appointment.destroy
    redirect_to pet_medical_appointments_path(@pet), notice: 'Consulta Veterinária excluída com sucesso!'
  end

  private

  def set_pet
    @pet = current_user.pets.find(params[:pet_id])
  end

  def set_medical_appointment
    @medical_appointment = @pet.medical_appointments.find_by(id: params[:id])
    unless @medical_appointment
      redirect_to pet_medical_appointments_path(@pet),
                  alert: "Consulta não encontrada para este pet."
    end
  end

  def medical_appointment_params
    params.require(:medical_appointment).permit(
      :veterinarian_name,
      :appointment_date,
      :appointment_time,
      :clinic_address,
      :notes
    )
  end
end