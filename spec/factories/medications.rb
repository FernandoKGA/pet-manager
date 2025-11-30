FactoryBot.define do
  factory :medication do
    name { 'Medicamento Teste' }
    dosage { '5ml' }
    frequency { 'Uma vez por dia' }
    start_date { Date.today }
    end_date { Date.today + 5.days }
    pet
  end
end