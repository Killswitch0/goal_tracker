FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "My String #{n}".truncate(15) }
    complete { false }
    deadline { Date.today + 3.days }
  end
end
