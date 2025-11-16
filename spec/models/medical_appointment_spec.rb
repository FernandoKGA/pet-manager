require 'rails_helper'

RSpec.describe MedicalAppointment, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:pet) { FactoryBot.create(:pet, user: user) }

  it "é válido com todos os atributos" do
    medical_appointment = build(:medical_appointment, pet: pet)
    expect(medical_appointment).to be_valid
  end

  it "é inválido sem nome do veterinário" do
    medical_appointment = build(:medical_appointment, veterinarian_name: nil, pet: pet)
    medical_appointment.valid?
    expect(medical_appointment.errors[:veterinarian_name]).to include("Campo Veterinário obrigatório.")
  end

  it "é inválido sem data da consulta" do
    medical_appointment = build(:medical_appointment, appointment_date: nil, pet: pet)
    medical_appointment.valid?
    expect(medical_appointment.errors[:appointment_date]).to include("Campo data obrigatório.")
  end

  it "é inválido sem endereço da clínica" do
    medical_appointment = build(:medical_appointment, clinic_address: nil, pet: pet)
    medical_appointment.valid?
    expect(medical_appointment.errors[:clinic_address]).to include("Campo Endereço da Clínica obrigatório.")
  end
end
