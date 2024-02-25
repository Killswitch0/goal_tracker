FactoryBot.define do
  factory :completion_date do
    date { Time.now.utc }
  end
end
