FactoryBot.define do
  factory :user do
    email { "test@petmanager.com" }
    first_name { "MyString" }
    last_name { "MyString" }
    password { "teste001user" }
  end
end
