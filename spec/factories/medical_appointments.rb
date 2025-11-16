FactoryBot.define do
  factory :medical_appointment do
    pet { nil }
    veterinarian_name { "Dra. Marcia" }
    appointment_date { "2025-11-03 21:10:27" }
    clinic_address { "Rua das Flores, 123" }
    notes { "Primeira consulta." }
  end
end
