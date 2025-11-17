FactoryBot.define do
  factory :weight do
    association :pet
    weight { 9.99 }
  end
end
