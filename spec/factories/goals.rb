FactoryBot.define do
  factory :goal do
    name { "Exercise regularly" }
    description { "MyString" }
    deadline { Date.today + 3.days }
    color { "Red" }
    user
    category
  end
end
