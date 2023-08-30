FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "My String #{n}".truncate(15) }
    complete { false }
    deadline { "2023-06-29 19:49:42" }
  end
end
