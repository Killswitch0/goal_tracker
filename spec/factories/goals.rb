FactoryBot.define do
  factory :goal do
    name { 'My goal is the best' }
    description { 'MyString' }
    deadline { Date.today + 3.days }
    color { 'Red' }
    user
    category
  end
end
