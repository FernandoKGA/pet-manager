FactoryBot.define do
  factory :vaccination do
    name { "MyString" }
    applied_date { "2025-11-02" }
    applied_by { "MyString" }
    applied { false }
    pet { nil }
  end
end
