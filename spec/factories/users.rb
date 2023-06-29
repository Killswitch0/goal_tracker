FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    email { Faker::Internet.email }
    password { '111111' }
    email_confirmed { true }
    confirm_token { nil }
    old_password { '111111' }
  end
end