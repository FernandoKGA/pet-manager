require 'rails_helper'

RSpec.describe "MedicalAppointments", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:pet) { FactoryBot.create(:pet, user: user) }
  let!(:medical_appointment) { FactoryBot.create(:medical_appointment, pet: pet) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET /pets/:pet_id/medical_appointments/:id" do
    it "retorna status 200" do
      get pet_medical_appointment_path(pet, medical_appointment)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /pets/:pet_id/medical_appointments" do
    it "cria uma nova consulta" do
      expect {
        post pet_medical_appointments_path(pet), params: {
          medical_appointment: {
            veterinarian_name: "Dra. Marcia",
            appointment_date: Date.today,
            clinic_address: "Rua das Flores 123"
          }
        }
      }.to change(MedicalAppointment, :count).by(1)
    end
  end

  describe "DELETE /pets/:pet_id/medical_appointments/:id" do
    it "exclui a consulta" do
      expect {
        delete pet_medical_appointment_path(pet, medical_appointment)
      }.to change(MedicalAppointment, :count).by(-1)
    end
  end
end
