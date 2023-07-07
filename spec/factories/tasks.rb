FactoryBot.define do
  factory :task do
    name { "MyString" }
    complete { false }
    deadline { "2023-06-29 19:49:42" }
  end
end
