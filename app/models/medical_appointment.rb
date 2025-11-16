class MedicalAppointment < ApplicationRecord
  belongs_to :pet

  # Adicionar validações
  validates :veterinarian_name, presence: { message: "Campo Veterinário obrigatório." }
  validates :appointment_date, presence: { message: "Campo data obrigatório." }
  validates :clinic_address, presence: { message: "Campo Endereço da Clínica obrigatório." }

end