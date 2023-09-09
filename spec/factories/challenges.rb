FactoryBot.define do
  factory :challenge do
    name { "MyString" }
    description { "MyText" }
    deadline { "2023-09-07 18:20:09" }
    user { nil }
  end
end
