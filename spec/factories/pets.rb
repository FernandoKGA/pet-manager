FactoryBot.define do
  factory :pet do
    association :user
    name { "MyString" }
    birthdate { "2025-09-28" }
    size { 1 }
    species { "MyString" }
    breed { "MyString" }
    gender { "MyString" }
    sinpatinhas_id { "MyString" }
    active { true }
  end
end
