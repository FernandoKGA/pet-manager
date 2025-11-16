FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@petmanager.com" }
    first_name { "MyString" }
    last_name { "MyString" }
    password { "teste001user" }
    role { :owner }

    trait :veterinarian do
      role { :veterinarian }
    end
  end
end
