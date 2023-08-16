FactoryBot.define do
  factory :goal do
    name { "Exercise regularly" }
    description { "MyString" }
    deadline { "2023-06-29 18:02:50" }
    color { "Red" }
    user
    category
  end
end
