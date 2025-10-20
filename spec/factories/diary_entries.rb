FactoryBot.define do
  factory :diary_entry do
    content { "MyText" }
    entry_date { "2025-10-19 19:43:35" }
    pet { nil }
  end
end
