FactoryBot.define do
  factory :vaccination do
    association :pet
    vaccine_name { "Vacina V10" }
    administered_on { Date.current }
    next_due_on { Date.current + 1.year }
    dose { "Reforço anual" }
    manufacturer { "PetPharma" }
    batch_number { "L12345" }
    notes { "Sem reações." }
  end
end
