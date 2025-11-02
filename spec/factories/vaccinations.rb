FactoryBot.define do
  factory :vaccination do
    name { "V10" }
    applied_date { Date.today }
    applied_by { "Dr. House" }
    applied { true }

    association :pet

    trait :invalid do
      name { nil }
      applied_date { nil }
    end
  end
end