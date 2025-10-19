FactoryBot.define do
  factory :medication do
    name { "Vermífugo X" }
    dosage { "5ml" }
    frequency { "Once a month" }
    start_date { Date.parse("2025-10-13") }
    association :pet
  end
end
