FactoryBot.define do
  factory :expense do
    amount { "9.99" }
    category { "MyString" }
    description { "MyText" }
    date { "2025-10-05" }
    pet { nil }
    user { nil }
  end
end
